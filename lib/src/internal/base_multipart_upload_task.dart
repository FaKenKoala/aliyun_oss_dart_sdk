
 import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/callback/oss_completed_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/oss_ioexption.dart';
import 'package:aliyun_oss_dart_sdk/src/model/complete_multipart_upload_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/multipart_upload_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/part_e_tag.dart';
import 'package:aliyun_oss_dart_sdk/src/network/execution_context.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/task_cancel_exception.dart';

import 'http_message.dart';
import 'internal_request_operation.dart';

abstract class BaseMultipartUploadTask<Request extends MultipartUploadRequest,
        Result extends CompleteMultipartUploadResult> implements Callable<Result> {

     final int CPU_SIZE = Platform.numberOfProcessors * 2;
     final int MAX_CORE_POOL_SIZE = CPU_SIZE < 5 ? CPU_SIZE : 5;
     final int MAX_IMUM_POOL_SIZE = CPU_SIZE;
     final int KEEP_ALIVE_TIME = 3000;
     final int MAX_QUEUE_SIZE = 5000;
     final int PART_SIZE_ALIGN_NUM = 4 * 1024;
     ThreadPoolExecutor mPoolExecutor =
            ThreadPoolExecutor(MAX_CORE_POOL_SIZE, MAX_IMUM_POOL_SIZE, KEEP_ALIVE_TIME,
                    TimeUnit.MILLISECONDS, ArrayBlockingQueue<Runnable>(MAX_QUEUE_SIZE), new ThreadFactory() {
                @override
                 Thread newThread(Runnable runnable) {
                    return Thread(runnable, "oss-android-multipart-thread");
                }
            });
     List<PartETag> partETags = [];
     Object mLock = Object();
     InternalRequestOperation operation;
     ExecutionContext context;
     Exception uploadException;
     bool isCancel;
     File uploadFile;
     String uploadId;
     int fileLength;
     int partExceptionCount;
     int runPartTaskCount;
     int uploadedLength = 0;
     bool checkCRC64 = false;
     Request request;
     OSSCompletedCallback<Request, Result>? completedCallback;
     OSSProgressCallback<Request>? progressCallback;
     List<int> partAttr = [0,0];
     String uploadFilePath;
     int lastPartSize;//最后一个分片的大小
     Uri uploadUri;

     BaseMultipartUploadTask(this. operation, this.request,
                                   this.completedCallback,
                                   this.context) {
        progressCallback = request.progressCallback as OSSProgressCallback<Request>?;
        checkCRC64 = (request.crc64 == CRC64Config.yes);
    }

    /// abort upload
      void abortThisUpload();

    /// init multipart upload id
      void initMultipartUploadId() ;

    /// do multipart upload task
      Result doMultipartUpload() ;

    /// check is or not cancel
     void checkCancel()  {
        if (context.getCancellationHandler().isCancelled()) {
            TaskCancelException e = TaskCancelException("multipart cancel");
            throw OSSClientException( e, true);
        }
    }


     void preUploadPart(int readIndex, int byteCount, int partNumber)  {

    }

     void uploadPartFinish(PartETag partETag)  {
    }

    @override
     Result call()  {
        try {
            checkInitData();
            initMultipartUploadId();
            Result result = doMultipartUpload();

                completedCallback?.onSuccess(request, result);
            return result;
        } on OSSServiceException catch ( e) {
                completedCallback?.onFailure(request, null, e);
            rethrow;
        } catch ( e) {
            OSSClientException temp = OSSClientException(e);
            if (completedCallback != null) {
                completedCallback?.onFailure(request, temp, null);
            }
            throw temp;
        }
    }

     void checkInitData()  {
        if (request.uploadFilePath != null) {
            uploadFilePath = request.uploadFilePath!;
            uploadedLength = 0;
            uploadFile = File(uploadFilePath);
            fileLength = uploadFile.lengthSync();

        } else if (request.uploadUri != null) {
            uploadUri = request.uploadUri!;
            ParcelFileDescriptor? uploadFileDescriptor;
            try {
                uploadFileDescriptor = context.getApplicationContext().getContentResolver().openFileDescriptor(uploadUri, "r");
                fileLength = uploadFileDescriptor.getStatSize();
            } on OSSIOException catch ( e) {
                throw OSSClientException(e, true);
            } finally {
                try {
                    if (uploadFileDescriptor != null) {
                        uploadFileDescriptor.close();
                    }
                } on OSSIOException catch ( e) {
                    OSSLog.logThrowable2Local(e);
                }
            }
        }
        if (fileLength == 0) {
            throw OSSClientException("file length must not be 0");
        }

        checkPartSize(partAttr);

        final int partSize = request.partSize;
        final int partNumber = partAttr[1];

        OSSLog.logDebug("[checkInitData] - partNumber : $partNumber");
        OSSLog.logDebug("[checkInitData] - partSize : $partSize");


        if (partNumber > 1 && partSize < 102400) {
            throw OSSClientException("Part size must be greater than or equal to 100KB!");
        }
    }

     void uploadPart(int readIndex, int byteCount, int partNumber) {

        RandomAccessFile? raf;
        InputStream? inputStream;
        BufferedInputStream? bufferedInputStream;
        try {

            if (context.getCancellationHandler().isCancelled()) {
                mPoolExecutor.getQueue().clear();
                return;
            }

             (mLock) {
                mRunPartTaskCount++;
            }

            preUploadPart(readIndex, byteCount, partNumber);

            List<int> partContent = List.filled(byteCount, 0);
            int skip = readIndex * request.partSize;
            if (uploadUri != null) {
                inputStream = context.getApplicationContext().getContentResolver().openInputStream(uploadUri);
                bufferedInputStream = BufferedInputStream(inputStream);
                bufferedInputStream.skip(skip);
                bufferedInputStream.read(partContent, 0, byteCount);
            } else {
                raf = RandomAccessFile(mUploadFile, "r");

                raf.seek(skip);
                raf.readFully(partContent, 0, byteCount);
            }

            UploadPartRequest uploadPart = UploadPartRequest(
                    request.getBucketName(), request.getObjectKey(), mUploadId, readIndex + 1);
            uploadPart.setPartContent(partContent);
            uploadPart.setMd5Digest(BinaryUtil.calculateBase64Md5(partContent));
            uploadPart.setCRC64(request.getCRC64());
            UploadPartResult uploadPartResult = operation.syncUploadPart(uploadPart);
            //check isComplete
             (mLock) {
                PartETag partETag = PartETag(uploadPart.getPartNumber(), uploadPartResult.getETag());
                partETag.setPartSize(byteCount);
                if (mCheckCRC64) {
                    partETag.setCRC64(uploadPartResult.getClientCRC());
                }

                partETags.add(partETag);
                mUploadedLength += byteCount;

                uploadPartFinish(partETag);

                if (context.getCancellationHandler().isCancelled()) {
                    if (partETags.size() == (mRunPartTaskCount - mPartExceptionCount)) {
                        TaskCancelException e = TaskCancelException("multipart cancel");

                        throw OSSClientException(e.getMessage(), e, true);
                    }
                } else {
                    if (partETags.length == (partNumber - partExceptionCount)) {
                        notifyMultipartThread();
                    }
                    onProgressCallback(request, uploadedLength, fileLength);
                }

            }

        } catch ( e) {
            processException(e);
        } finally {
            try {
                if (raf != null)
                    raf.close();
                if (bufferedInputStream != null)
                    bufferedInputStream.close();
                if (inputStream != null)
                    inputStream.close();
            } catch (OSSIOException e) {
                OSSLog.logThrowable2Local(e);
            }
        }
    }

      void processException(Exception e);

    /// complete multipart upload
    ///
    /// @return
    /// @throws OSSClientException
    /// @throws OSSServiceException
     CompleteMultipartUploadResult completeMultipartUploadResult()  {
        //complete sort
        CompleteMultipartUploadResult? completeResult;
        if (partETags.isNotEmpty) {
            Collections.sort(partETags, Comparator<PartETag>() {
                @override
                 int compare(PartETag lhs, PartETag rhs) {
                    if (lhs.getPartNumber() < rhs.getPartNumber()) {
                        return -1;
                    } else if (lhs.getPartNumber() > rhs.getPartNumber()) {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            });

            CompleteMultipartUploadRequest complete = CompleteMultipartUploadRequest(
                    request.getBucketName(), request.getObjectKey(), mUploadId, partETags);
            if (request.getCallbackParam() != null) {
                complete.setCallbackParam(request.getCallbackParam());
            }
            if (request.getCallbackVars() != null) {
                complete.setCallbackVars(request.getCallbackVars());
            }
            if (request.getMetadata() != null) {
                ObjectMetadata metadata = ObjectMetadata();
                for (String key : request.getMetadata().getRawMetadata().keySet()) {
                    if (!key.equals(OSSHeaders.STORAGE_CLASS)) {
                        metadata.setHeader(key, request.getMetadata().getRawMetadata().get(key));
                    }
                }
                complete.setMetadata(metadata);
            }

            complete.setCRC64(request.getCRC64());
            completeResult = operation.syncCompleteMultipartUpload(complete);
        }
        mUploadedLength = 0;
        return completeResult;
    }

     void releasePool() {
        if (mPoolExecutor != null) {
            mPoolExecutor.getQueue().clear();
            mPoolExecutor.shutdown();
        }
    }

     void checkException()  {
        if (uploadException != null) {
            releasePool();
            if (uploadException instanceof OSSIOException) {
                throw (OSSIOException) uploadException;
            } else if (uploadException instanceof OSSServiceException) {
                throw (OSSServiceException) uploadException;
            } else if (uploadException instanceof OSSClientException) {
                throw (OSSClientException) uploadException;
            } else {
                OSSClientException clientException =
                        OSSClientException(uploadException.getMessage(), uploadException);
                throw clientException;
            }
        }
    }

     bool checkWaitCondition(int partNum) {
        if (partETags.size() == partNum) {
            return false;
        }
        return true;
    }

    /// notify wait thread
     void notifyMultipartThread() {
        mLock.notify();
        mPartExceptionCount = 0;
    }

    /// check part size
    ///
    /// @param partAttr
     void checkPartSize(int[] partAttr) {
        int partSize = request.getPartSize();
        OSSLog.logDebug("[checkPartSize] - mFileLength : " + mFileLength);
        OSSLog.logDebug("[checkPartSize] - partSize : " + partSize);
        int partNumber = mFileLength / partSize;
        if (mFileLength % partSize != 0) {
            partNumber = partNumber + 1;
        }
        int MAX_PART_NUM = 5000;
        if (partNumber == 1) {
            partSize = mFileLength;
        } else if (partNumber > MAX_PART_NUM) {
            partSize = mFileLength / (MAX_PART_NUM - 1);
            partSize = ceilPartSize(partSize);
            partNumber = mFileLength / partSize;
            partNumber += (mFileLength % partSize != 0) ? 1 : 0;
        }
        partAttr[0] = (int) partSize;
        partAttr[1] = (int) partNumber;
        request.setPartSize((int) partSize);

        OSSLog.logDebug("[checkPartSize] - partNumber : " + partNumber);
        OSSLog.logDebug("[checkPartSize] - partSize : " + (int) partSize);

        int lastPartSize = mFileLength % partSize;
        mLastPartSize = lastPartSize == 0 ? partSize : lastPartSize;
    }

     int ceilPartSize(int partSize) {
        partSize = (((partSize + (PART_SIZE_ALIGN_NUM - 1)) / PART_SIZE_ALIGN_NUM) * PART_SIZE_ALIGN_NUM);
        return partSize;
    }

    /// progress callback
    ///
    /// @param request
    /// @param currentSize
    /// @param totalSize
     void onProgressCallback(Request request, int currentSize, int totalSize) {
        if (progressCallback != null) {
            progressCallback.onProgress(request, currentSize, totalSize);
        }
    }

}
