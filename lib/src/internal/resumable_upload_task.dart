
 class ResumableUploadTask extends BaseMultipartUploadTask<ResumableUploadRequest,
        ResumableUploadResult> implements Callable<ResumableUploadResult> {

     File mRecordFile;
     List<Integer> mAlreadyUploadIndex = [];
     OSSSharedPreferences mSp;
     File mCRC64RecordFile;


     ResumableUploadTask(ResumableUploadRequest request,
                               OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback,
                               ExecutionContext context, InternalRequestOperation apiOperation) {
        super(apiOperation, request, completedCallback, context);
        mSp = OSSSharedPreferences.instance(context.getApplicationContext());
    }

    @override
     void initMultipartUploadId()  {

        Map<Integer, int> recordCrc64 = null;

        if (!OSSUtils.isEmptyString(request.getRecordDirectory())) {
            String fileMd5 = null;
            if (uploadUri != null) {
                OSSLog.logDebug("[initUploadId] - mUploadFilePath : " + uploadUri.getPath());
                ParcelFileDescriptor parcelFileDescriptor = context.getApplicationContext().getContentResolver().openFileDescriptor(uploadUri, "r");
                try {
                    fileMd5 = BinaryUtil.calculateMd5Str(parcelFileDescriptor.getFileDescriptor());
                } finally {
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                    }
                }
            } else {
                OSSLog.logDebug("[initUploadId] - mUploadFilePath : " + uploadFilePath);
                fileMd5 = BinaryUtil.calculateMd5Str(uploadFilePath);
            }
            OSSLog.logDebug("[initUploadId] - mRequest.getPartSize() : " + request.getPartSize());
            String recordFileName = BinaryUtil.calculateMd5Str((fileMd5 + request.getBucketName()
                    + request.getObjectKey() + String.valueOf(request.getPartSize()) + (mCheckCRC64 ? "-crc64" : "")).getBytes());
            String recordPath = request.getRecordDirectory() + File.separator + recordFileName;


            mRecordFile = File(recordPath);
            if (mRecordFile.exists()) {
                BufferedReader br = BufferedReader(new FileReader(mRecordFile));
                mUploadId = br.readLine();
                br.close();
            }

            OSSLog.logDebug("[initUploadId] - mUploadId : " + mUploadId);

            if (!OSSUtils.isEmptyString(mUploadId)) {
                if (mCheckCRC64) {
                    String filePath = request.getRecordDirectory() + File.separator + mUploadId;
                    File crc64Record = File(filePath);
                    if (crc64Record.exists()) {
                        FileInputStream fs = FileInputStream(crc64Record);//创建文件字节输出流对象
                        ObjectInputStream ois = ObjectInputStream(fs);

                        try {
                            recordCrc64 = (Map<Integer, int>) ois.readObject();
                            crc64Record.delete();
                        } catch (ClassNotFoundException e) {
                            OSSLog.logThrowable2Local(e);
                        } finally {
                            if (ois != null)
                                ois.close();
                            crc64Record.delete();
                        }
                    }
                }

                bool isTruncated = false;
                int nextPartNumberMarker = 0;


                do{
                    ListPartsRequest listParts = ListPartsRequest(request.getBucketName(), request.getObjectKey(), mUploadId);
                    if (nextPartNumberMarker > 0){
                        listParts.setPartNumberMarker(nextPartNumberMarker);
                    }

                    OSSAsyncTask<ListPartsResult> task = operation.listParts(listParts, null);
                    try {
                        ListPartsResult result = task.getResult();
                        isTruncated = result.isTruncated();
                        nextPartNumberMarker = result.getNextPartNumberMarker();
                        List<PartSummary> parts = result.getParts();
                        int partSize = partAttr[0];
                        int partTotalNumber = partAttr[1];
                        for (int i = 0; i < parts.size(); i++) {
                            PartSummary part = parts.get(i);
                            PartETag partETag = PartETag(part.getPartNumber(), part.getETag());
                            partETag.setPartSize(part.getSize());

                            if (recordCrc64 != null && recordCrc64.size() > 0) {
                                if (recordCrc64.containsKey(partETag.getPartNumber())) {
                                    partETag.setCRC64(recordCrc64.get(partETag.getPartNumber()));
                                }
                            }
                            OSSLog.logDebug("[initUploadId] -  " + i + " part.getPartNumber() : " + part.getPartNumber());
                            OSSLog.logDebug("[initUploadId] -  " + i + " part.getSize() : " + part.getSize());


                            bool isTotal = part.getPartNumber() == partTotalNumber;

                            if (isTotal && part.getSize() != mLastPartSize){
                                throw OSSClientException("current part size " + part.getSize() + " setting is inconsistent with PartSize : " + partSize + " or lastPartSize : " + mLastPartSize);
                            }

                            if (!isTotal && part.getSize() != partSize){
                                throw OSSClientException("current part size " + part.getSize() + " setting is inconsistent with PartSize : " + partSize + " or lastPartSize : " + mLastPartSize);
                            }

//                            if (part.getPartNumber() == partTotalNumber){
//                                if (part.getSize() != mLastPartSize){
//                                    throw OSSClientException("current part size " + partSize + " setting is inconsistent with PartSize : " + mPartAttr[0] + " or lastPartSize : " + mLastPartSize);
//                                }
//                            }else{
//                                if (part.getSize() != partSize){
//                                    throw OSSClientException("current part size " + partSize + " setting is inconsistent with PartSize : " + mPartAttr[0] + " or lastPartSize : " + mLastPartSize);
//                                }
//                            }

                            partETags.add(partETag);
                            mUploadedLength += part.getSize();
                            mAlreadyUploadIndex.add(part.getPartNumber());
                        }
                    } catch (OSSServiceException e) {
                        isTruncated = false;
                        if (e.getStatusCode() == 404) {
                            mUploadId = null;
                        } else {
                            throw e;
                        }
                    } catch (OSSClientException e) {
                        isTruncated = false;
                        throw e;
                    }
                    task.waitUntilFinished();
                }while (isTruncated);

            }

            if (!mRecordFile.exists() && !mRecordFile.createNewFile()) {
                throw OSSClientException("Can't create file at path: " + mRecordFile.getAbsolutePath()
                        + "\nPlease make sure the directory exist!");
            }
        }

        if (OSSUtils.isEmptyString(mUploadId)) {
            InitiateMultipartUploadRequest init = InitiateMultipartUploadRequest(
                    request.getBucketName(), request.getObjectKey(), request.getMetadata());

            InitiateMultipartUploadResult initResult = operation.initMultipartUpload(init, null).getResult();

            mUploadId = initResult.getUploadId();

            if (mRecordFile != null) {
                BufferedWriter bw = BufferedWriter(new FileWriter(mRecordFile));
                bw.write(mUploadId);
                bw.close();
            }
        }

        request.setUploadId(mUploadId);
    }

    @override
     ResumableUploadResult doMultipartUpload()  {

        int tempUploadedLength = mUploadedLength;
        checkCancel();
//        int[] mPartAttr = int[2];
//        checkPartSize(mPartAttr);
        int readByte = partAttr[0];
        final int partNumber = partAttr[1];

        if (partETags.size() > 0 && mAlreadyUploadIndex.size() > 0) { //revert progress
            if (mUploadedLength > mFileLength) {
                throw OSSClientException("The uploading file is inconsistent with before");
            }

//            int firstPartSize = mPartETags.get(0).getPartSize();
//            OSSLog.logDebug("[initUploadId] - firstPartSize : " + firstPartSize);
//            if (firstPartSize > 0 && firstPartSize != readByte && firstPartSize < mFileLength) {
//                throw OSSClientException("current part size " + readByte + " setting is inconsistent with before " + firstPartSize);
//            }

            int revertUploadedLength = mUploadedLength;

            if (mSp.getStringValue(mUploadId)).notNullOrEmpty {
                revertUploadedLength = int.valueOf(mSp.getStringValue(mUploadId));
            }

            if (progressCallback != null) {
                progressCallback.onProgress(request, revertUploadedLength, mFileLength);
            }

            mSp.removeKey(mUploadId);
        }
        //已经运行的任务需要添加已经上传的任务数量
        mRunPartTaskCount = partETags.size();

        for (int i = 0; i < partNumber; i++) {

            if (mAlreadyUploadIndex.size() != 0 && mAlreadyUploadIndex.contains(i + 1)) {
                continue;
            }

            if (mPoolExecutor != null) {
                //need read byte
                if (i == partNumber - 1) {
                    readByte = (int) (mFileLength - tempUploadedLength);
                }
                final int byteCount = readByte;
                final int readIndex = i;
                tempUploadedLength += byteCount;
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

        checkException();
        //complete sort
        CompleteMultipartUploadResult completeResult = completeMultipartUploadResult();
        ResumableUploadResult result = null;
        if (completeResult != null) {
            result = ResumableUploadResult(completeResult);
        }
        if (mRecordFile != null) {
            mRecordFile.delete();
        }
        if (mCRC64RecordFile != null) {
            mCRC64RecordFile.delete();
        }

        releasePool();
        return result;
    }

    @override
     void checkException()  {
        if (context.getCancellationHandler().isCancelled()) {
            if (request.deleteUploadOnCancelling()) {
                abortThisUpload();
                if (mRecordFile != null) {
                    mRecordFile.delete();
                }
            } else {
                if (partETags != null && partETags.size() > 0 && mCheckCRC64 && request.getRecordDirectory() != null) {
                    Map<Integer, int> maps = HashMap<Integer, int>();
                    for (PartETag eTag : partETags) {
                        maps[eTag.getPartNumber()] = eTag.getCRC64();
                    }
                    ObjectOutputStream oot = null;
                    try {
                        String filePath = request.getRecordDirectory() + File.separator + mUploadId;
                        mCRC64RecordFile = File(filePath);
                        if (!mCRC64RecordFile.exists()) {
                            mCRC64RecordFile.createNewFile();
                        }
                        oot = ObjectOutputStream(new FileOutputStream(mCRC64RecordFile));
                        oot.writeObject(maps);
                    } catch (OSSIOException e) {
                        OSSLog.logThrowable2Local(e);
                    } finally {
                        if (oot != null) {
                            oot.close();
                        }
                    }
                }
            }
        }
        super.checkException();
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
            uploadException = e;
            OSSLog.logThrowable2Local(e);
            if (context.getCancellationHandler().isCancelled()) {
                if (!mIsCancel) {
                    mIsCancel = true;
                    mLock.notify();
                }
            }
            if (partETags.size() == (mRunPartTaskCount - mPartExceptionCount)) {
                notifyMultipartThread();
            }
        }
    }

    @override
     void uploadPartFinish(PartETag partETag)  {
        if (context.getCancellationHandler().isCancelled()) {
            if (!mSp.contains(mUploadId)) {
                mSp.setStringValue(mUploadId, String.valueOf(mUploadedLength));
                onProgressCallback(request, mUploadedLength, mFileLength);
            }
        }
    }
}
