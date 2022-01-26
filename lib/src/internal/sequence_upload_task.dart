
 class SequenceUploadTask extends BaseMultipartUploadTask<ResumableUploadRequest,
        ResumableUploadResult> implements Callable<ResumableUploadResult> {

     File mRecordFile;
     List<Integer> mAlreadyUploadIndex = [];
     int mFirstPartSize;
     OSSSharedPreferences mSp;
     File mCRC64RecordFile;

     SequenceUploadTask(ResumableUploadRequest request,
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
                ParcelFileDescriptor parcelFileDescriptor = context.getApplicationContext().getContentResolver().openFileDescriptor(uploadUri, "r");
                try {
                    fileMd5 = BinaryUtil.calculateMd5Str(parcelFileDescriptor.getFileDescriptor());
                } finally {
                    if (parcelFileDescriptor != null) {
                        parcelFileDescriptor.close();
                    }
                }
            } else {
                fileMd5 = BinaryUtil.calculateMd5Str(uploadFilePath);
            }
            String recordFileName = BinaryUtil.calculateMd5Str((fileMd5 + request.getBucketName()
                    + request.getObjectKey() + String.valueOf(request.getPartSize()) + (mCheckCRC64 ? "-crc64" : "") + "-sequence").getBytes());
            String recordPath = request.getRecordDirectory() + File.separator + recordFileName;

            mRecordFile = File(recordPath);
            if (mRecordFile.exists()) {
                BufferedReader br = BufferedReader(new FileReader(mRecordFile));
                mUploadId = br.readLine();
                br.close();
                OSSLog.logDebug("sequence [initUploadId] - Found record file, uploadid: " + mUploadId);
            }

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

                do {
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

                        for (int i = 0; i < parts.size(); i++) {
                            PartSummary part = parts.get(i);
                            PartETag partETag = PartETag(part.getPartNumber(), part.getETag());
                            partETag.setPartSize(part.getSize());

                            if (recordCrc64 != null && recordCrc64.size() > 0) {
                                if (recordCrc64.containsKey(partETag.getPartNumber())) {
                                    partETag.setCRC64(recordCrc64.get(partETag.getPartNumber()));
                                }
                            }

                            partETags.add(partETag);
                            mUploadedLength += part.getSize();
                            mAlreadyUploadIndex.add(part.getPartNumber());
                            if (i == 0) {
                                mFirstPartSize = part.getSize();
                            }
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
            init.isSequential = true;
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

            if (mFirstPartSize != readByte) {
                throw OSSClientException("The part size setting is inconsistent with before");
            }

            int revertUploadedLength = mUploadedLength;

            if (mSp.getStringValue(mUploadId)).notNullOrEmpty {
                revertUploadedLength = int.valueOf(mSp.getStringValue(mUploadId));
            }

            if (progressCallback != null) {
                progressCallback.onProgress(request, revertUploadedLength, mFileLength);
            }

            mSp.removeKey(mUploadId);
        }

        for (int i = 0; i < partNumber; i++) {

            if (mAlreadyUploadIndex.size() != 0 && mAlreadyUploadIndex.contains(i + 1)) {
                continue;
            }

            //need read byte
            if (i == partNumber - 1) {
                readByte = (int) (mFileLength - tempUploadedLength);
            }
            OSSLog.logDebug("upload part readByte : " + readByte);
            int byteCount = readByte;
            int readIndex = i;
            tempUploadedLength += byteCount;
            uploadPart(readIndex, byteCount, partNumber);
            //break immediately for sequence upload
            if (uploadException != null){
                break;
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
        return result;
    }

     void uploadPart(int readIndex, int byteCount, int partNumber) {

        RandomAccessFile raf = null;
        InputStream inputStream = null;
        BufferedInputStream bufferedInputStream = null;
        UploadPartRequest uploadPartRequest = null;
        try {

            if (context.getCancellationHandler().isCancelled()) {
                return;
            }

            mRunPartTaskCount++;

            preUploadPart(readIndex, byteCount, partNumber);
            int skip = readIndex * request.getPartSize();
            List<int> partContent = byte[byteCount];

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

            uploadPartRequest = UploadPartRequest(
                    request.getBucketName(), request.getObjectKey(), mUploadId, readIndex + 1);
            uploadPartRequest.setPartContent(partContent);
            uploadPartRequest.setMd5Digest(BinaryUtil.calculateBase64Md5(partContent));
            uploadPartRequest.setCRC64(request.getCRC64());
            UploadPartResult uploadPartResult = operation.syncUploadPart(uploadPartRequest);
            //check isComplete，throw exception when error occur
            PartETag partETag = PartETag(uploadPartRequest.getPartNumber(), uploadPartResult.getETag());
            partETag.setPartSize(byteCount);
            if (mCheckCRC64) {
                partETag.setCRC64(uploadPartResult.getClientCRC());
            }

            partETags.add(partETag);
            mUploadedLength += byteCount;

            uploadPartFinish(partETag);

            if (context.getCancellationHandler().isCancelled()) {
                //cancel immediately for sequence upload
                TaskCancelException e = TaskCancelException("sequence upload task cancel");
                throw OSSClientException(e.getMessage(), e, true);
            } else {
                onProgressCallback(request, mUploadedLength, mFileLength);
            }
        } catch (OSSServiceException e) {
            // it is not necessary to throw 409 PartAlreadyExist exception out
            if (e.getStatusCode() != 409) {
                processException(e);
            } else {
                PartETag partETag = PartETag(uploadPartRequest.getPartNumber(), e.getPartEtag());
                partETag.setPartSize(uploadPartRequest.getPartContent().length);
                if (mCheckCRC64) {
                    List<int> partContent = uploadPartRequest.getPartContent();
                    ByteArrayInputStream byteArrayInputStream = ByteArrayInputStream(partContent);
                    CheckedInputStream checkedInputStream = CheckedInputStream(byteArrayInputStream, new CRC64());

                    partETag.setCRC64(checkedInputStream.getChecksum().getValue());
                }

                partETags.add(partETag);
                mUploadedLength += byteCount;
            }
        } catch ( e) {
            processException(e);
        } finally {
            try {
                if (raf != null)
                    raf.close();
                if (inputStream != null)
                    inputStream.close();
                if (bufferedInputStream != null)
                    bufferedInputStream.close();
            } catch (OSSIOException e) {
                OSSLog.logThrowable2Local(e);
            }
        }
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
//        mPartExceptionCount++;
        if (uploadException == null || !e.getMessage().equals(uploadException.getMessage())) {
            uploadException = e;
        }
        OSSLog.logThrowable2Local(e);
        if (context.getCancellationHandler().isCancelled()) {
            if (!mIsCancel) {
                mIsCancel = true;
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
