 import 'package:aliyun_oss_dart_sdk/src/common/oss_constants.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/binary_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/oss_utils.dart';

class ExtensionRequestOperation {

     static ExecutorService executorService =
            Executors.newFixedThreadPool(OSSConstants.defaultBaseThreadPoolSize, ThreadFactory() {
                @override
                 Thread newThread(Runnable r) {
                    return Thread(r, "oss-android-extensionapi-thread");
                }
            });
     InternalRequestOperation apiOperation;

     ExtensionRequestOperation(InternalRequestOperation apiOperation) {
        this.apiOperation = apiOperation;
    }

     bool doesObjectExist(String bucketName, String objectKey)
             {

        try {
            HeadObjectRequest head = HeadObjectRequest(bucketName, objectKey);
            apiOperation.headObject(head, null).getResult();
            return true;
        } catch (OSSServiceException e) {
            if (e.getStatusCode() == 404) {
                return false;
            } else {
                throw e;
            }
        }
    }

     void abortResumableUpload(ResumableUploadRequest request)  {
        setCRC64(request);

        if (request.getRecordDirectory().notNullOrEmpty) {
            String? uploadFilePath = request.getUploadFilePath();
            String? fileMd5;
            if (uploadFilePath != null) {
                fileMd5 = BinaryUtil.calculateMd5Str(uploadFilePath);
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
            String recordFileName = BinaryUtil.calculateMd5Str((fileMd5 + request.getBucketName()
                    + request.getObjectKey() + String.valueOf(request.getPartSize())).getBytes());
            String recordPath = request.getRecordDirectory() + "/" + recordFileName;
            File recordFile = File(recordPath);

            if (recordFile.exists()) {
                BufferedReader br = BufferedReader(new FileReader(recordFile));
                String uploadId = br.readLine();
                br.close();

                OSSLog.logDebug("[initUploadId] - Found record file, uploadid: " + uploadId);

                if (request.getCRC64() == OSSRequest.CRC64Config.YES) {
                    String filePath = Environment.getExternalStorageDirectory().getPath() + File.separator + "oss" + File.separator + uploadId;
                    File file = File(filePath);
                    if (file.exists()) {
                        file.delete();
                    }
                }

                AbortMultipartUploadRequest abort = AbortMultipartUploadRequest(
                        request.getBucketName(), request.getObjectKey(), uploadId);
                apiOperation.abortMultipartUpload(abort, null);
            }

            if (recordFile != null) {
                recordFile.delete();
            }
        }
    }

     OSSAsyncTask<ResumableUploadResult> resumableUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest
            , ResumableUploadResult> completedCallback) {
        setCRC64(request);
        ExecutionContext<ResumableUploadRequest, ResumableUploadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());

        return OSSAsyncTask.wrapRequestTask(executorService.submit(ResumableUploadTask(request,
                completedCallback, executionContext, apiOperation)), executionContext);
    }

     OSSAsyncTask<ResumableUploadResult> sequenceUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest
            , ResumableUploadResult> completedCallback) {
        setCRC64(request);
        ExecutionContext<ResumableUploadRequest, ResumableUploadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());

        SequenceUploadTask task = SequenceUploadTask(request,
                completedCallback, executionContext, apiOperation);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(task), executionContext);
    }


     OSSAsyncTask<CompleteMultipartUploadResult> multipartUpload(MultipartUploadRequest request
            , OSSCompletedCallback<MultipartUploadRequest
            , CompleteMultipartUploadResult> completedCallback) {
        setCRC64(request);
        ExecutionContext<MultipartUploadRequest, CompleteMultipartUploadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());

        return OSSAsyncTask.wrapRequestTask(executorService.submit(MultipartUploadTask(apiOperation
                , request, completedCallback, executionContext)), executionContext);
    }

     OSSAsyncTask<ResumableDownloadResult> resumableDownload(ResumableDownloadRequest request,
                                                                   OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult> completedCallback) {
        ExecutionContext<ResumableDownloadRequest, ResumableDownloadResult> executionContext =
                ExecutionContext(apiOperation.getInnerClient(), request, apiOperation.getApplicationContext());
        return OSSAsyncTask.wrapRequestTask(executorService.submit(ResumableDownloadTask(apiOperation, request, completedCallback, executionContext)), executionContext);
    }

     void setCRC64(OSSRequest request) {
        Enum crc64 = request.getCRC64() != OSSRequest.CRC64Config.NULL ? request.getCRC64() :
                (apiOperation.getConf().isCheckCRC64() ? OSSRequest.CRC64Config.YES : OSSRequest.CRC64Config.NO);
        request.setCRC64(crc64);
    }
}
