 import 'package:aliyun_oss_dart_sdk/src/callback/lib_callback.dart';

import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';

class MultipartUploadTask extends BaseMultipartUploadTask<MultipartUploadRequest,
        CompleteMultipartUploadResult> implements Callable<CompleteMultipartUploadResult> {

     MultipartUploadTask(InternalRequestOperation operation, MultipartUploadRequest request,
                               OSSCompletedCallback<MultipartUploadRequest, CompleteMultipartUploadResult>? completedCallback,
                               ExecutionContext context) :
        super(operation, request, completedCallback, context);
    

    @override
     void initMultipartUploadId()  async{
        InitiateMultipartUploadRequest init = InitiateMultipartUploadRequest(
                request.bucketName, request.objectKey, request.metadata);

        InitiateMultipartUploadResult initResult = await operation.initMultipartUpload(init, null).getResult();

        uploadId = initResult.uploadId;
        request.uploadId = uploadId;
    }

    @override
     Future<CompleteMultipartUploadResult?> doMultipartUpload()  async{
        checkCancel();
        int readByte = partAttr[0];
        final int partNumber = partAttr[1];
        int currentLength = 0;
        for (int i = 0; i < partNumber; i++) {
            checkException();
            if (mPoolExecutor != null) {
                //need read byte
                if (i == partNumber - 1) {
                    readByte = fileLength - currentLength;
                }
                final int byteCount = readByte;
                final int readIndex = i;
                currentLength += byteCount;
                mPoolExecutor.execute(Runnable() {
                    @override
                     void run() {
                        uploadPart(readIndex, byteCount, partNumber);
                    }
                });
            }
        }

        if (checkWaitCondition(partNumber)) {
                mLock.wait();
        }
        if (uploadException != null) {
            abortThisUpload();
        }
        checkException();
        //complete sort
        CompleteMultipartUploadResult? completeResult = await completeMultipartUploadResult();

        releasePool();
        return completeResult;
    }

    @override
     void abortThisUpload() {
        if (uploadId != null) {
            AbortMultipartUploadRequest abort = AbortMultipartUploadRequest(
                    request.bucketName, request.objectKey, uploadId!);
            operation.abortMultipartUpload(abort, null).waitUntilFinished();
        }
    }

    @override
     void processException(Exception e) {
            partExceptionCount++;
            if (uploadException == null) {
                uploadException = e;
                mLock.notify();
            }
    }

    @override
     void preUploadPart(int readIndex, int byteCount, int partNumber)  {
        checkException();
    }
}
