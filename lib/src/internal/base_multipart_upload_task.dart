
 import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/callback/oss_completed_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/oss_ioexception.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/execution_context.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/task_cancel_exception.dart';
import 'lib_internal.dart';

abstract class BaseMultipartUploadTask<Request extends MultipartUploadRequest,
        Result extends CompleteMultipartUploadResult> implements Callable<Result> {

     final int CPU_SIZE = Platform.numberOfProcessors * 2;
     final int MAX_CORE_POOL_SIZE = Platform.numberOfProcessors * 2 < 5 ? Platform.numberOfProcessors * 2 : 5;
     final int MAX_IMUM_POOL_SIZE = Platform.numberOfProcessors * 2;
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
     Exception? uploadException;
     bool isCancel = false;
     File? uploadFile;
     String? uploadId;
     int fileLength = 0;
     int partExceptionCount = 0;
     int runPartTaskCount = 0;
     int uploadedLength = 0;
     bool isCheckCRC64 = false;
     Request request;
     OSSCompletedCallback<Request, Result>? completedCallback;
     OSSProgressCallback<Request>? progressCallback;
     List<int> partAttr = [0,0];
     String? uploadFilePath;
     int lastPartSize = 0;//最后一个分片的大小
     Uri? uploadUri;

     BaseMultipartUploadTask(this.operation, this.request,
                                   this.completedCallback,
                                   this.context) {
        progressCallback = request.progressCallback as OSSProgressCallback<Request>?;
        isCheckCRC64 = (request.crc64Config == CRC64Config.yes);
    }

    /// abort upload
      void abortThisUpload();

    /// init multipart upload id
      void initMultipartUploadId() ;

    /// do multipart upload task
      Future<Result?> doMultipartUpload() ;

    /// check is or not cancel
     void checkCancel()  {
        if (context.cancellationHandler.isCancelled) {
            TaskCancelException e = TaskCancelException("multipart cancel");
            throw OSSClientException( e, true);
        }
    }


     void preUploadPart(int readIndex, int byteCount, int partNumber)  {

    }

     void uploadPartFinish(PartETag partETag)  {
    }

    @override
     Result? call()  {
        try {
            checkInitData();
            initMultipartUploadId();
            Result? result = doMultipartUpload();

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
            uploadFile = File(uploadFilePath??'');
            fileLength = uploadFile?.lengthSync() ?? 0;

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

     void uploadPart(int readIndex, int byteCount, int partNumber) async{

        RandomAccessFile? raf;
        InputStream? inputStream;
        BufferedInputStream? bufferedInputStream;
        try {

            if (context.cancellationHandler.isCancelled) {
                mPoolExecutor.getQueue().clear();
                return;
            }

                runPartTaskCount++;

            preUploadPart(readIndex, byteCount, partNumber);

            List<int> partContent = List.filled(byteCount, 0);
            int skip = readIndex * request.partSize;
            if (uploadUri != null) {
                inputStream = context.getApplicationContext().getContentResolver().openInputStream(uploadUri);
                bufferedInputStream = BufferedInputStream(inputStream);
                bufferedInputStream.skip(skip);
                bufferedInputStream.read(partContent, 0, byteCount);
            } else {
                raf = uploadFile!.openSync();

                raf.seek(skip);
                raf.readFully(partContent, 0, byteCount);
            }

            UploadPartRequest uploadPart = UploadPartRequest(
                    request.bucketName, request.objectKey, uploadId, readIndex + 1);
            uploadPart.partContent = (partContent);
            uploadPart.md5Digest = (BinaryUtil.calculateBase64Md5(partContent));
            uploadPart.crc64Config = (request.crc64Config);
            UploadPartResult uploadPartResult = await operation.syncUploadPart(uploadPart);
            //check isComplete
                PartETag partETag = PartETag(uploadPart.partNumber, uploadPartResult.eTag);
                partETag.partSize = byteCount;
                if (isCheckCRC64) {
                    partETag.crc64 = uploadPartResult.clientCRC;
                }

                partETags.add(partETag);
                uploadedLength += byteCount;

                uploadPartFinish(partETag);

                if (context.cancellationHandler.isCancelled) {
                    if (partETags.length == (runPartTaskCount - partExceptionCount)) {
                        TaskCancelException e = TaskCancelException("multipart cancel");

                        throw OSSClientException(e, true);
                    }
                } else {
                    if (partETags.length == (partNumber - partExceptionCount)) {
                        notifyMultipartThread();
                    }
                    onProgressCallback(request, uploadedLength, fileLength);
                }


        } on Exception catch ( e) {
            processException(e);
        } finally {
            try {
                if (raf != null) {
                  raf.close();
                }
                if (bufferedInputStream != null) {
                  bufferedInputStream.close();
                }
                if (inputStream != null) {
                  inputStream.close();
                }
            } catch ( e) {
                OSSLog.logThrowable2Local(e);
            }
        }
    }

      void processException(Exception e);

    /// complete multipart upload
     Future<CompleteMultipartUploadResult?> completeMultipartUploadResult()  async{
        //complete sort
        CompleteMultipartUploadResult? completeResult;
        if (partETags.isNotEmpty) {
          partETags.sort((lhs, rhs){

          return lhs.partNumber.compareTo(rhs.partNumber);
                
            });

            CompleteMultipartUploadRequest complete = CompleteMultipartUploadRequest(
                    request.bucketName, request.objectKey, uploadId, partETags);
            if (request.callbackParam != null) {
                complete.callbackParam = request.callbackParam;
            }
            if (request.callbackVars != null) {
                complete.callbackVars = request.callbackVars;
            }
            if (request.metadata != null) {
                ObjectMetadata metadata = ObjectMetadata();
                request.metadata?.getRawMetadata().forEach((key, value) {
if (key !=(OSSHeaders.storageClass)) {
                        metadata.setHeader(key, value);
                    }
                 });
                complete.metadata = metadata;
            }

            complete.crc64Config = request.crc64Config;
            completeResult = await operation.syncCompleteMultipartUpload(complete);
        }
        uploadedLength = 0;
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

            if (uploadException is OSSIOException ||uploadException is OSSServiceException || uploadException is OSSClientException) {
                throw uploadException!;
            } else {
                OSSClientException clientException =
                        OSSClientException(uploadException);
                throw clientException;
            }
        }
    }

     bool checkWaitCondition(int partNum) {
        if (partETags.length == partNum) {
            return false;
        }
        return true;
    }

    /// notify wait thread
     void notifyMultipartThread() {
        mLock.notify();
        partExceptionCount = 0;
    }

    /// check part size
     void checkPartSize(List<int> partAttr) {
        int partSize = request.partSize;
        OSSLog.logDebug("[checkPartSize] - fileLength : $fileLength");
        OSSLog.logDebug("[checkPartSize] - partSize : $partSize");
        int partNumber = fileLength ~/ partSize;
        if (fileLength % partSize != 0) {
            partNumber = partNumber + 1;
        }
        int MAX_PART_NUM = 5000;
        if (partNumber == 1) {
            partSize = fileLength;
        } else if (partNumber > MAX_PART_NUM) {
            partSize = fileLength ~/ (MAX_PART_NUM - 1);
            partSize = ceilPartSize(partSize);
            partNumber = fileLength ~/ partSize;
            partNumber += (fileLength % partSize != 0) ? 1 : 0;
        }
        partAttr[0] =  partSize;
        partAttr[1] =  partNumber;
        request.partSize = partSize;

        OSSLog.logDebug("[checkPartSize] - partNumber : $partNumber");
        OSSLog.logDebug("[checkPartSize] - partSize : $partSize");

        int lastPartSize = fileLength % partSize;
        lastPartSize = lastPartSize == 0 ? partSize : lastPartSize;
    }

     int ceilPartSize(int partSize) {
        partSize = (((partSize + (PART_SIZE_ALIGN_NUM - 1)) ~/ PART_SIZE_ALIGN_NUM) * PART_SIZE_ALIGN_NUM);
        return partSize;
    }

    /// progress callback
    ///
    /// @param request
    /// @param currentSize
    /// @param totalSize
     void onProgressCallback(Request request, int currentSize, int totalSize) {
            progressCallback?.onProgress(request, currentSize, totalSize);
    }

}
