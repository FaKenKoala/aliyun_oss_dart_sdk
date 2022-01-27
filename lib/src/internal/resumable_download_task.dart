

import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/callback/lib_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/lib_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/task_cancel_exception.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
class ResumableDownloadTask<Requst extends ResumableDownloadRequest,
        Result extends ResumableDownloadResult> implements Callable<Result> {
     final int CPU_SIZE = Platform.numberOfProcessors *  2;
     final int MAX_CORE_POOL_SIZE = Platform.numberOfProcessors * 2 < 5 ? Platform.numberOfProcessors * 2 : 5;
     final int MAX_IMUM_POOL_SIZE = Platform.numberOfProcessors * 2;
     final int KEEP_ALIVE_TIME = 3000;
     final int MAX_QUEUE_SIZE = 5000;
    //  ThreadPoolExecutor mPoolExecutor =
    //         ThreadPoolExecutor(MAX_CORE_POOL_SIZE, MAX_IMUM_POOL_SIZE, KEEP_ALIVE_TIME,
    //                 TimeUnit.MILLISECONDS, ArrayBlockingQueue<Runnable>(MAX_QUEUE_SIZE), ThreadFactory() {
    //             @override
    //              Thread newThread(Runnable runnable) {
    //                 return Thread(runnable, "oss-android-multipart-thread");
    //             }
    //         });
     ResumableDownloadRequest mRequest;
     InternalRequestOperation mOperation;
     OSSCompletedCallback? completedCallback;
     ExecutionContext context;
     OSSProgressCallback? progressCallback;
     late CheckPoint checkPoint;
     Object lock = Object();
     Exception? downloadException;
     int completedPartSize = 0;
     int downloadPartSize = 0;
     int partExceptionCount = 0;
     String? checkpointPath;

    ResumableDownloadTask(this.mOperation,
                          this.mRequest,
                          this.completedCallback,
                          this.context) {
        progressCallback = mRequest.progressListener;
    }


    @override
     Result call()  {
        try {
            checkInitData();
            ResumableDownloadResult result = doMultipartDownload();
                completedCallback?.onSuccess(mRequest, result);
            return result as Result;
        } on OSSServiceException catch ( e) {
                completedCallback?.onFailure(mRequest, null, e);
            rethrow;
        } catch ( e) {
            OSSClientException temp;
            if (e is OSSClientException) {
                temp =  e;
            } else {
                temp = OSSClientException(e);
            }
                completedCallback?.onFailure(mRequest, temp, null);
            throw temp;
        }
    }

     void checkInitData()  async{

        if (mRequest.range != null && !mRequest.range!.checkIsValid()) {
            throw OSSClientException("Range is invalid");
        }
        String recordFileName = BinaryUtil.calculateMd5StrFromStr((mRequest.bucketName + mRequest.objectKey
                + '${mRequest.partSize}' + (mRequest.crc64Config == CRC64Config.yes ? "-crc64" : "")));
        checkpointPath = '${mRequest.checkPointFilePath}' + path.separator + recordFileName;

        checkPoint = CheckPoint();

        if (mRequest.enableCheckPoint) {
            try {
                checkPoint.load(checkpointPath!);
            } catch ( e) {
                removeFile(checkpointPath!);
                removeFile(mRequest.getTempFilePath());
            }
            if (!(await checkPoint.isValid(mOperation))) {
                removeFile(checkpointPath!);
                removeFile(mRequest.getTempFilePath());

                initCheckPoint();
            }
        } else {
            initCheckPoint();
        }
    }

     bool removeFile(String filePath) {
        bool flag = false;
        File file = File(filePath);

        if (file.existsSync()) {
          try{
             file.deleteSync();
             flag=true;
          }catch(e){
            flag = false;
          }
        }

        return flag;
    }

     void initCheckPoint()  async{
        FileStat fileStat = await FileStat.getFileStat(mOperation, mRequest.bucketName, mRequest.objectKey);
        Range range = correctRange(mRequest.range, fileStat.fileLength);
        int downloadSize = range.end - range.begin;
        createFile(mRequest.getTempFilePath(), downloadSize);

        checkPoint..bucketName = mRequest.bucketName
        ..objectKey = mRequest.objectKey
        ..fileStat = fileStat
        ..parts = splitFile(range, checkPoint.fileStat.fileLength, mRequest.partSize);
    }

     ResumableDownloadResult doMultipartDownload()  {
        checkCancel();
        ResumableDownloadResult resumableDownloadResult = ResumableDownloadResult();

        final DownloadFileResult result = DownloadFileResult();
        result.partResults = [];

        for (final DownloadPart part in checkPoint.parts) {
            checkException();
            if (mPoolExecutor != null && !part.isCompleted) {
                mPoolExecutor.execute(Runnable() {
                    @override
                     void run() {
                        downloadPart(result, part);
                        Log.i("partResults", "start: ${part.start}, end: ${part.end}");
                    }
                });
            } else {
                DownloadPartResult partResult = DownloadPartResult();
                partResult.partNumber = part.partNumber;
                partResult.requestId = checkPoint.fileStat?.requestId;
                partResult.length = part.length;
                if (mRequest.crc64Config == CRC64Config.yes) {
                    partResult.clientCRC = part?.crc64;
                }
                result.partResults.add(partResult);
                downloadPartSize += 1;
                completedPartSize += 1;
            }
        }
        // Wait for all tasks to be completed
        if (checkWaitCondition(checkPoint.parts.length)) {
            //  (mLock) {
            //     mLock.wait();
            // }
        }
        checkException();
        result.partResults.sort((p0, p1) => p0.partNumber.compareTo(p1.partNumber));

        if (mRequest.crc64Config == CRC64Config.yes && mRequest.range == null) {
            String? clientCRC = calcObjectCRCFromParts(result.partResults);
            resumableDownloadResult.clientCRC = clientCRC;
            try {
                OSSUtils.checkChecksum(clientCRC, checkPoint.fileStat.serverCRC, result.partResults[0].requestId);
            } on InconsistentException catch ( e) {
                removeFile(checkpointPath!);
                removeFile(mRequest.getTempFilePath());
                rethrow;
            }
        }
        removeFile(checkpointPath!);

        File fromFile = File(mRequest.getTempFilePath());
        File toFile = File(mRequest.downloadToFilePath);
        moveFile(fromFile, toFile);

        resumableDownloadResult..serverCRC = checkPoint.fileStat.serverCRC
        ..metadata = result.metadata
        ..requestId = result.partResults[0].requestId
        ..statusCode = HttpStatus.ok;

        return resumableDownloadResult;
    }

     static String? calcObjectCRCFromParts(List<DownloadPartResult> partResults) {
        String? crc;

        for (DownloadPartResult partResult in partResults) {
            if (partResult.clientCRC == null || partResult.length <= 0) {
                return null;
            }
            crc = CRC64.combine(crc, partResult.clientCRC, partResult.length);
        }
        return crc;
    }

     List<DownloadPart> splitFile(Range range, int fileSize, int partSize) {

        if (fileSize <= 0) {
            DownloadPart part = DownloadPart();
            part.start = 0;
            part.end = -1;
            part.length = 0;
            part.partNumber = 0;

            List<DownloadPart> parts = [];
            parts.add(part);
            return parts;
        }
        int start = range.begin;
        int size = range.end - range.begin;

        int count = size ~/ partSize;
        if (size % partSize > 0) {
            count += 1;
        }

        List<DownloadPart> parts = [];
        for (int i = 0; i < count; i++) {
            DownloadPart part = DownloadPart();
            part.start = start + partSize * i;
            part.end = start + partSize * (i + 1) - 1;
            part.length = part.end - part.start + 1;
            if (part.end >= start + size) {
                part.end = -1;
                part.length = start + size - part.start;
            }
            part.partNumber = i;
            part.fileStart = i * partSize;
            parts.add(part);
        }
        return parts;
    }

     Range correctRange(Range? range, int totalSize) {
        int start = 0;
        int size = totalSize;
        if (range != null) {
            start = range.begin;
            if (range.begin == -1) {
                start = 0;
            }
            size = range.end - range.begin;
            if (range.end == -1) {
                size = totalSize - start;
            }
        }
        return Range(start, start + size);
    }

     void downloadPart(DownloadFileResult downloadResult, DownloadPart part) async{

        RandomAccessFile? output;
        InputStream? content;
        try {

            if (context.cancellationHandler.isCancelled) {
                mPoolExecutor.getQueue().clear();
            }

            downloadPartSize += 1;

            output = File(mRequest.getTempFilePath()).openSync();
            output.seek(part.fileStart);

            Map<String, String> requestHeader = mRequest.requestHeader;

            GetObjectRequest request = GetObjectRequest(mRequest.bucketName, mRequest.objectKey);
            request.range = Range(part.start, part.end);
            request.requestHeaders = requestHeader;
            GetObjectResult result =  await mOperation.getObject(request, null).getResult();

            content = result.objectContent;

            List<int> buffer = List.filled(part.length, 0);
            int readLength = 0;
            if (mRequest.crc64Config == CRC64Config.yes) {
                content = CheckedInputStream(content, OSSCRC64());
            }

            while ((readLength = content.read(buffer)) != -1) {
                output.write(buffer, 0, (int) readLength);
            }


                DownloadPartResult partResult = DownloadPartResult();
                partResult.partNumber = part.partNumber;
                partResult.requestId = result.requestId;
                partResult.length = result.contentLength;
                if (mRequest.crc64Config == CRC64Config.yes) {
                    String clientCRC = (content as CheckedInputStream).checksum.value;
                    partResult.clientCRC = clientCRC;

                    part.crc64 = clientCRC;
                }
                downloadResult.partResults.add(partResult);
                downloadResult.metadata ??= result.metadata;

                completedPartSize += 1;

                if (context.cancellationHandler.isCancelled) {
                    // Cancel after the last task is completed
                    if (downloadPartSize == completedPartSize - partExceptionCount) {
                        checkCancel();
                    }
                } else {
                    // After all tasks are completed, wake up the thread where the doMultipartDownload method is located
                    if (checkPoint.parts.length == (completedPartSize - partExceptionCount)) {
                        notifyMultipartThread();
                    }
                    checkPoint.update(part.partNumber, true);
                    if (mRequest.enableCheckPoint) {
                        checkPoint.dump(checkpointPath!);
                    }
                    Range range = correctRange(mRequest.range, checkPoint.fileStat!.fileLength);
                        progressCallback?.onProgress(mRequest, checkPoint.downloadLength, range.end - range.begin);
                }
        } catch ( e) {
            processException(e as Exception);
        } finally {
            try {
                if (output != null) {
                    output.close();
                }
                if (content != null) {
                    content.close();
                }
            } catch ( e) {
                OSSLog.logThrowable2Local(e);
            }
        }
    }

     void createFile(String filePath, int length)  {
        File file = File(filePath);
        RandomAccessFile? accessFile;

        try {
            accessFile = file.openSync(mode: FileMode.write);
            accessFile.setLength(length);
        } finally {
            if (accessFile != null) {
                accessFile.close();
            }
        }
    }

     void moveFile(File fromFile, File toFile)  {

        try{
        fromFile.renameSync(toFile.path);
        }catch(e){
            Log.i("moveFile", "rename");
            InputStream? ist ;
            OutputStream? ost ;
            try {
                ist = FileInputStream(fromFile);
                ost = FileOutputStream(toFile);
                copyFile(ist, ost);
                fromFile.deleteSync();
                // if (!fromFile.delete()) {
                //     throw OSSIOException("Failed to delete original file '" + fromFile + "'");
                // }
            } catch ( e) {
                rethrow;
            } finally {
                if (ist != null) {
                    ist.close();
                }
                if (ost != null) {
                    ost.close();
                }
            }
        }
    }

     void copyFile(InputStream ist, OutputStream ost)  {
        List<int> buffer = List.filled(4096, 0);
        int byteCount;
        while ((byteCount = ist.read(buffer)) != -1) {
            ost.write(buffer, 0, byteCount);
        }
    }

     void notifyMultipartThread() {
        // lock.notify();
        partExceptionCount = 0;
    }

     void processException(Exception e) {
            partExceptionCount++;
            if (downloadException == null) {
                downloadException = e;
                // mLock.notify();
            }
    }

     void releasePool() {
        if (mPoolExecutor != null) {
            mPoolExecutor.getQueue().clear();
            mPoolExecutor.shutdown();
        }
    }

     void checkException()  {
        if (downloadException != null) {
            releasePool();
            if (downloadException is OSSIOException || downloadException is OSSServiceException || 
            downloadException is OSSClientException) {
                throw downloadException!;
            } else {
                OSSClientException clientException =
                        OSSClientException(downloadException);
                throw clientException;
            }
        }
    }

     bool checkWaitCondition(int partNum) {
        if (completedPartSize == partNum) {
            return false;
        }
        return true;
    }

     void checkCancel()  {
        if (context.cancellationHandler.isCancelled) {
            TaskCancelException e = TaskCancelException("Resumable download cancel");
            throw OSSClientException(e);
        }
    }
        }

    class DownloadPart  {

         int partNumber = 0;
         int start = -1; // start index;
         int end = -1; // end index;
         bool isCompleted = false; // flag of part download finished or not;
         int length = 0; // length of part
         int fileStart = 0; // start index of file
         String? crc64; // part crc.

        @override
        bool operator ==(Object other) {
          return identical(this, other) || other is DownloadPart && other.partNumber == partNumber && other.isCompleted == isCompleted && other.end == end && other.start == start 
          && other.crc64 == crc64;
        }
        @override
         int get hashCode {
            final int prime = 31;
            int result = 1;
            result = prime * result + partNumber;
            result = prime * result + (isCompleted ? 1231 : 1237);
            result = prime * result +  (end ^ (end >>> 32));
            result = prime * result + (start ^ (start >>> 32));
            // result = prime * result +  (crc64 ^ (crc64 >>> 32));
            result = prime * result + (crc64?.hashCode ?? 0);
            return result;
        }
    }

    class CheckPoint {


         int md5 = 0;
         String? downloadFile;
         String? bucketName;
         String? objectKey;
         late FileStat fileStat;
         List<DownloadPart> parts = [];
         int downloadLength = 0;

        /// Loads the checkpoint data from the checkpoint file.
          void load(String cpFile)  {
            FileInputStream? fileIn = null;
            ObjectInputStream? objIn = null;
            try {
                fileIn = FileInputStream(cpFile);
                objIn = ObjectInputStream(fileIn);
                CheckPoint dcp =  objIn.readObject() as CheckPoint;
                assign(dcp);
            } finally {
                    objIn?.close();
                    fileIn?.close();
            }
        }

        /// Writes the checkpoint data to the checkpoint file.
          void dump(String cpFile)  {
            md5 = hashCode;
            FileOutputStream fileOut = null;
            ObjectOutputStream outStream = null;
            try {
                fileOut = FileOutputStream(cpFile);
                outStream = ObjectOutputStream(fileOut);
                outStream.writeObject(this);
            } finally {
                if (outStream != null) {
                    outStream.close();
                }
                if (fileOut != null) {
                    fileOut.close();
                }
            }
        }

        /// Updates the part's download status.
        ///
        /// @throws OSSIOException
          void update(int index, bool completed)  {
            parts[index].isCompleted = completed;
            downloadLength += parts[index].length;
        }

        /// Check if the object matches the checkpoint information.
          Future<bool> isValid(InternalRequestOperation operation)  async{
            // Compare magic and md5 of checkpoint
            if (md5 != hashCode) {
                return false;
            }

            FileStat fStat = await FileStat.getFileStat(operation, bucketName, objectKey);

            // Object's size, last modified time or ETAG are not same as the one
            // in the checkpoint.
            if (fileStat.lastModified == null) {
                if (fileStat.fileLength != fStat.fileLength || fileStat.eTag!=fStat.eTag) {
                    return false;
                }
            } else {
                if (fileStat.fileLength != fStat.fileLength || fileStat.lastModified!=fStat.lastModified
                        || fileStat.eTag!=fStat.eTag) {
                    return false;
                }
            }
            return true;
        }

        @override
        bool operator ==(Object other) {
          return identical(this, other) || other is CheckPoint && other.bucketName == bucketName && other.downloadFile == downloadFile && other.objectKey == objectKey && other.fileStat == fileStat && DeepCollectionEquality().equals(other.parts, parts) && other.downloadLength == downloadLength;
        }
        @override
         int get hashCode {
            final int prime = 31;
            int result = 1;
            result = prime * result + (bucketName?.hashCode ?? 0);
            result = prime * result + (downloadFile?.hashCode ?? 0);
            result = prime * result + (objectKey?.hashCode ?? 0);
            result = prime * result + (fileStat?.hashCode ?? 0);
            result = prime * result + (parts.hashCode);
            result = prime * result + (downloadLength ^ (downloadLength >>> 32));
            return result;
        }

         void assign(CheckPoint dcp) {
            md5 = dcp.md5;
            downloadFile = dcp.downloadFile;
            bucketName = dcp.bucketName;
            objectKey = dcp.objectKey;
            fileStat = dcp.fileStat;
            parts = dcp.parts;
            downloadLength = dcp.downloadLength;
        }
    }

    class FileStat  {

         int fileLength = 0;
         String? md5;
         DateTime? lastModified;
         String? eTag;
         String? serverCRC;
         String? requestId;

         static Future<FileStat> getFileStat(InternalRequestOperation operation, String? bucketName, String? objectKey)  async {
            HeadObjectRequest request = HeadObjectRequest(bucketName, objectKey);
            HeadObjectResult result = await operation.headObject(request, null).getResult();

            FileStat fileStat = FileStat()
            ..fileLength = result.metadata.getContentLength()
            ..eTag = result.metadata.getETag()
            ..lastModified = result.metadata.getLastModified()
            ..serverCRC = result.serverCRC
            ..requestId = result.requestId;

            return fileStat;
        }

        @override
        bool operator ==(Object other) {
          return identical(this, other) || other is FileStat && other.eTag == eTag && other.lastModified == lastModified && other.fileLength == fileLength;
        }

        @override
         int get hashCode {
            final int prime = 31;
            int result = 1;
            result = prime * result + (eTag?.hashCode ?? 0 );
            result = prime * result + (lastModified?.hashCode ?? 0 );
            result = prime * result + (fileLength ^ (fileLength >>> 32));
            return result;
        }
    }

    class DownloadPartResult {

         int partNumber = 0;
         String? requestId;
         String? clientCRC;
         int length = 0;
    }

    class DownloadFileResult extends OSSResult {

         List<DownloadPartResult> partResults = [];
         ObjectMetadata? metadata;
    }
