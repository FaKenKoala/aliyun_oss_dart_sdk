import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:aliyun_oss_dart_sdk/src/callback/lib_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

class ExtensionRequestOperation {

     static ExecutorService executorService =
            Executors.newFixedThreadPool(OSSConstants.defaultBaseThreadPoolSize, ThreadFactory() {
                @override
                 Thread newThread(Runnable r) {
                    return Thread(r, "oss-android-extensionapi-thread");
                }
            });
     InternalRequestOperation apiOperation;

     ExtensionRequestOperation(this. apiOperation);

     bool doesObjectExist(String bucketName, String objectKey)
             {

        try {
            HeadObjectRequest head = HeadObjectRequest(bucketName, objectKey);
            apiOperation.headObject(head, null).getResult();
            return true;
        } on OSSServiceException catch ( e) {
            if (e.statusCode == HttpStatus.notFound) {
                return false;
            } else {
                rethrow;
            }
        }
    }

     void abortResumableUpload(ResumableUploadRequest request)  {
        setCRC64(request);

        if (request.recordDirectory.notNullOrEmpty) {
            String? uploadFilePath = request.uploadFilePath;
            String? fileMd5;
            if (uploadFilePath != null) {
                fileMd5 = BinaryUtil.calculateMd5StrFromPath(uploadFilePath);
            } else {
                ParcelFileDescriptor parcelFileDescriptor = apiOperation.getApplicationContext().getContentResolver().openFileDescriptor(request.getUploadUri(), "r");
                try {
                    fileMd5 = BinaryUtil.calculateMd5Str(parcelFileDescriptor.getFileDescriptor());
                } finally {
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                    }
                }
            }
            String recordFileName = BinaryUtil.calculateMd5Str(utf8.encode(fileMd5 + request.bucketName
                    + request.objectKey + "${request.partSize}"));
            String recordPath = "${request.recordDirectory}/$recordFileName";
            File recordFile = File(recordPath);

            if (recordFile.existsSync()) {
                BufferedReader br = BufferedReader(FileReader(recordFile));
                String uploadId = br.readLine();
                br.close();

                OSSLog.logDebug("[initUploadId] - Found record file, uploadid: " + uploadId);

                if (request.crc64Config == CRC64Config.yes) {
                    String filePath = Environment.getExternalStorageDirectory().getPath() + path.separator + "oss" + path.separator + uploadId;
                    File file = File(filePath);
                    if (file.existsSync()) {
                        file.delete();
                    }
                }

                AbortMultipartUploadRequest abort = AbortMultipartUploadRequest(
                        request.bucketName, request.objectKey, uploadId);
                apiOperation.abortMultipartUpload(abort, null);
            }

                recordFile.deleteSync();
        }
    }

     OSSAsyncTask<ResumableUploadResult> resumableUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest
            , ResumableUploadResult>? completedCallback) {
        setCRC64(request);
        ExecutionContext<ResumableUploadRequest, ResumableUploadResult> executionContext =
                ExecutionContext(request);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(ResumableUploadTask(request,
                completedCallback, executionContext, apiOperation)), executionContext);
    }

     OSSAsyncTask<ResumableUploadResult> sequenceUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest
            , ResumableUploadResult>? completedCallback) {
        setCRC64(request);
        ExecutionContext<ResumableUploadRequest, ResumableUploadResult> executionContext =
                ExecutionContext( request);

        SequenceUploadTask task = SequenceUploadTask(request,
                completedCallback, executionContext, apiOperation);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(task), executionContext);
    }


     OSSAsyncTask<CompleteMultipartUploadResult> multipartUpload(MultipartUploadRequest request
            , OSSCompletedCallback<MultipartUploadRequest
            , CompleteMultipartUploadResult>? completedCallback) {
        setCRC64(request);
        ExecutionContext<MultipartUploadRequest, CompleteMultipartUploadResult> executionContext =
                ExecutionContext( request);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(MultipartUploadTask(apiOperation
                , request, completedCallback, executionContext)), executionContext);
    }

     OSSAsyncTask<ResumableDownloadResult> resumableDownload(ResumableDownloadRequest request,
                                                                   OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult>? completedCallback) {
        ExecutionContext<ResumableDownloadRequest, ResumableDownloadResult> executionContext =
                ExecutionContext( request);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(ResumableDownloadTask(apiOperation, request, completedCallback, executionContext)), executionContext);
    }

     void setCRC64(OSSRequest request) {
        CRC64Config crc64 = request.crc64Config != CRC64Config.$null ? request.crc64Config :
                (apiOperation.conf.checkCRC64 ? CRC64Config.yes : CRC64Config.no);
        request.crc64Config = crc64;
    }
}
