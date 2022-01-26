 class MultipartUploadTask extends BaseMultipartUploadTask<MultipartUploadRequest,
        CompleteMultipartUploadResult> implements Callable<CompleteMultipartUploadResult> {

     MultipartUploadTask(InternalRequestOperation operation, MultipartUploadRequest request,
                               OSSCompletedCallback<MultipartUploadRequest, CompleteMultipartUploadResult> completedCallback,
                               ExecutionContext context) {
        super(operation, request, completedCallback, context);
    }

    @override
     void initMultipartUploadId()  {
        InitiateMultipartUploadRequest init = InitiateMultipartUploadRequest(
                request.getBucketName(), request.getObjectKey(), request.getMetadata());

        InitiateMultipartUploadResult initResult = operation.initMultipartUpload(init, null).getResult();

        mUploadId = initResult.getUploadId();
        request.setUploadId(mUploadId);
    }

    @override
     CompleteMultipartUploadResult doMultipartUpload()  {
        checkCancel();
        int readByte = partAttr[0];
        final int partNumber = partAttr[1];
        int currentLength = 0;
        for (int i = 0; i < partNumber; i++) {
            checkException();
            if (mPoolExecutor != null) {
                //need read byte
                if (i == partNumber - 1) {
                    readByte = (int) (mFileLength - currentLength);
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
             (mLock) {
                mLock.wait();
            }
        }
        if (uploadException != null) {
            abortThisUpload();
        }
        checkException();
        //complete sort
        CompleteMultipartUploadResult completeResult = completeMultipartUploadResult();

        releasePool();
        return completeResult;
    }

    @override
     void abortThisUpload() {
        if (mUploadId != null) {
            AbortMultipartUploadRequest abort = AbortMultipartUploadRequest(
                    request.getBucketName(), request.getObjectKey(), mUploadId);
            operation.abortMultipartUpload(abort, null).waitUntilFinished();
        }
    }

    @override
     void processException(Exception e) {
         (mLock) {
            mPartExceptionCount++;
            if (uploadException == null) {
                uploadException = e;
                mLock.notify();
            }
        }
    }

    @override
     void preUploadPart(int readIndex, int byteCount, int partNumber)  {
        checkException();
    }
}
