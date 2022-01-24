
/**
 * OSSDownloadOperation
 *
 */
 class OSSDownloadOperation {

     OSSObject getObjectWrap(GetObjectRequest getObjectRequest){
        return objectOperation.getObject(getObjectRequest);
    }

     Long getInputStreamCRCWrap(InputStream inputStream) {
        return IOUtils.getCRCValue(inputStream);
    }

    static class DownloadCheckPoint implements Serializable {

         static final long serialVersionUID = 4682293344365787077L;
         static final String DOWNLOAD_MAGIC = "92611BED-89E2-46B6-89E5-72F273D4B0A3";

        /**
         * Loads the checkpoint data from the checkpoint file.
         */
         synchronized void load(String cpFile) throws IOException, ClassNotFoundException {
            FileInputStream fileIn = new FileInputStream(cpFile);
            ObjectInputStream in = new ObjectInputStream(fileIn);
            DownloadCheckPoint dcp = (DownloadCheckPoint) in.readObject();
            assign(dcp);
            in.close();
            fileIn.close();
        }

        /**
         * Writes the checkpoint data to the checkpoint file.
         */
         synchronized void dump(String cpFile) throws IOException {
            this.md5 = hashCode();
            FileOutputStream fileOut = new FileOutputStream(cpFile);
            ObjectOutputStream outStream = new ObjectOutputStream(fileOut);
            outStream.writeObject(this);
            outStream.close();
            fileOut.close();
        }

        /**
         * Updates the part's download status.
         * 
         * @throws IOException
         */
         synchronized void update(int index, bool completed) throws IOException {
            downloadParts.GET(index).isCompleted = completed;
        }

        /**
         * Check if the object matches the checkpoint information.
         */
         synchronized bool isValid(OSSObjectOperation objectOperation, DownloadFileRequest downloadFileRequest) {
            // 比较checkpoint的magic和md5
            if (this.magic == null || !this.magic.equals(DOWNLOAD_MAGIC) || this.md5 != hashCode()) {
                return false;
            }

            GenericRequest genericRequest = new GenericRequest(bucketName, objectKey);

            Payer payer = downloadFileRequest.getRequestPayer();
            if (payer != null) {
                genericRequest.setRequestPayer(payer);
            }

            String versionId = downloadFileRequest.getVersionId();
            if (versionId != null) {
                genericRequest.setVersionId(versionId);
            }

            SimplifiedObjectMeta meta = objectOperation.getSimplifiedObjectMeta(genericRequest);

            // Object's size, last modified time or ETAG are not same as the one
            // in the checkpoint.
            if (this.objectStat.size != meta.getSize() || !this.objectStat.LAST_MODIFIED.equals(meta.getLastModified())
                    || !this.objectStat.digest.equals(meta.getETag())) {
                return false;
            }

            return true;
        }

        @override
         int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((bucketName == null) ? 0 : bucketName.hashCode());
            result = prime * result + ((downloadFile == null) ? 0 : downloadFile.hashCode());
            result = prime * result + ((magic == null) ? 0 : magic.hashCode());
            result = prime * result + ((objectKey == null) ? 0 : objectKey.hashCode());
            result = prime * result + ((objectStat == null) ? 0 : objectStat.hashCode());
            result = prime * result + ((downloadParts == null) ? 0 : downloadParts.hashCode());
            return result;
        }

         void assign(DownloadCheckPoint dcp) {
            this.magic = dcp.magic;
            this.md5 = dcp.md5;
            this.downloadFile = dcp.downloadFile;
            this.bucketName = dcp.bucketName;
            this.objectKey = dcp.objectKey;
            this.objectStat = dcp.objectStat;
            this.downloadParts = dcp.downloadParts;
        }

         String magic; // magic
         int md5; // the md5 of checkpoint data.
         String downloadFile; // local path for the download.
         String bucketName; // bucket name
         String objectKey; // object key
         ObjectStat objectStat; // object state
         ArrayList<DownloadPart> downloadParts; // download parts list.

    }

    static class ObjectStat implements Serializable {

         static final long serialVersionUID = -2883494783412999919L;

        @override
         int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((digest == null) ? 0 : digest.hashCode());
            result = prime * result + ((LAST_MODIFIED == null) ? 0 : LAST_MODIFIED.hashCode());
            result = prime * result + (int) (size ^ (size >>> 32));
            return result;
        }

         static ObjectStat getFileStat(OSSObjectOperation objectOperation, DownloadFileRequest downloadFileRequest) {
            String bucketName = downloadFileRequest.getBucketName();
            String key = downloadFileRequest.getKey();

            GenericRequest genericRequest = new GenericRequest(bucketName, key);

            Payer payer = downloadFileRequest.getRequestPayer();
            if (payer != null) {
                genericRequest.setRequestPayer(payer);
            }

            String versionId = downloadFileRequest.getVersionId();
            if (versionId != null) {
                genericRequest.setVersionId(versionId);
            }

            SimplifiedObjectMeta meta = objectOperation.getSimplifiedObjectMeta(genericRequest);

            ObjectStat objStat = new ObjectStat();
            objStat.size = meta.getSize();
            objStat.LAST_MODIFIED = meta.getLastModified();
            objStat.digest = meta.getETag();

            return objStat;
        }

         long size; // file size
         Date LAST_MODIFIED; // file's last modified time.
         String digest; // The file's ETag.
    }

    static class DownloadPart implements Serializable {

         static final long serialVersionUID = -3655925846487976207L;

        @override
         int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + index;
            result = prime * result + (isCompleted ? 1231 : 1237);
            result = prime * result + (int) (end ^ (end >>> 32));
            result = prime * result + (int) (start ^ (start >>> 32));
            result = prime * result + (int) (crc ^ (crc >>> 32));
            result = prime * result + (int) (fileStart ^ (fileStart >>> 32));
            return result;
        }

         int index; // part index (starting from 0).
         long start; // start index;
         long end; // end index;
         bool isCompleted; // flag of part download finished or not;
         long length; // length of part
         long crc; // part crc.
         long fileStart;  // start index in file, for range get
    }

    static class PartResult {

         PartResult(int number, long start, long end) {
            this.number = number;
            this.start = start;
            this.end = end;
        }

         PartResult(int number, long start, long end, long length, long clientCRC) {
            this.number = number;
            this.start = start;
            this.end = end;
            this.length = length;
            this.clientCRC = clientCRC;
        }

         long getStart() {
            return start;
        }

         void setStart(long start) {
            this.start = start;
        }

         long getEnd() {
            return end;
        }

         void setEnd(long end) {
            this.end = end;
        }

         int getNumber() {
            return number;
        }

         bool isFailed() {
            return failed;
        }

         void setFailed(bool failed) {
            this.failed = failed;
        }

         Exception getException() {
            return exception;
        }

         void setException(Exception exception) {
            this.exception = exception;
        }

         Long getClientCRC() { return clientCRC; }

         void setClientCRC(Long clientCRC) { this.clientCRC = clientCRC; }

         Long getServerCRC() {
            return serverCRC;
        }

         void setServerCRC(Long serverCRC) {
            this.serverCRC = serverCRC;
        }

         long getLength() {
            return length;
        }

         void setLength(long length) {
            this.length = length;
        }
         int number; // part number, starting from 1.
         long start; // start index in the part.
         long end; // end index in the part.
         bool failed; // flag of part upload failure.
         Exception exception; // Exception during part upload.
         Long clientCRC; // client crc of this part
         Long serverCRC; // server crc of this file

         long length;
    }

    static class DownloadResult {

         List<PartResult> getPartResults() {
            return partResults;
        }

         void setPartResults(List<PartResult> partResults) {
            this.partResults = partResults;
        }

         ObjectMetadata getObjectMetadata() {
            return objectMetadata;
        }

         void setObjectMetadata(ObjectMetadata objectMetadata) {
            this.objectMetadata = objectMetadata;
        }

         List<PartResult> partResults;
         ObjectMetadata objectMetadata;
    }

     OSSDownloadOperation(OSSObjectOperation objectOperation) {
        this.objectOperation = objectOperation;
    }

     DownloadFileResult downloadFile(DownloadFileRequest downloadFileRequest) throws Throwable {
        assertParameterNotNull(downloadFileRequest, "downloadFileRequest");

        String bucketName = downloadFileRequest.getBucketName();
        String key = downloadFileRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);

        // the download file name is not specified, using the key as the local
        // file name.
        if (downloadFileRequest.getDownloadFile() == null) {
            downloadFileRequest.setDownloadFile(downloadFileRequest.getKey());
        }

        // the checkpoint is enabled, but no checkpoint file, using the default
        // checkpoint file name.
        if (downloadFileRequest.isEnableCheckpoint()) {
            if (downloadFileRequest.getCheckpointFile() == null || downloadFileRequest.getCheckpointFile().isEmpty()) {
                String versionId = downloadFileRequest.getVersionId();
                if (versionId != null) {
                    downloadFileRequest.setCheckpointFile(downloadFileRequest.getDownloadFile() + "."
                            + BinaryUtil.encodeMD5(versionId.getBytes()) + ".dcp");
                } else {
                    downloadFileRequest.setCheckpointFile(downloadFileRequest.getDownloadFile() + ".dcp");
                }
            }
        }

        return downloadFileWithCheckpoint(downloadFileRequest);
    }

     DownloadFileResult downloadFileWithCheckpoint(DownloadFileRequest downloadFileRequest) throws Throwable {
        DownloadFileResult downloadFileResult = new DownloadFileResult();
        DownloadCheckPoint downloadCheckPoint = new DownloadCheckPoint();

        // The checkpoint is enabled, downloads the parts download results from
        // checkpoint file.
        if (downloadFileRequest.isEnableCheckpoint()) {
            // read the last download result. If checkpoint file dosx not exist,
            // or the file is updated/corrupted,
            // re-download again.
            try {
                downloadCheckPoint.load(downloadFileRequest.getCheckpointFile());
            } catch (Exception e) {
                remove(downloadFileRequest.getCheckpointFile());
            }

            // The download checkpoint is corrupted, download again.
            if (!downloadCheckPoint.isValid(objectOperation, downloadFileRequest)) {
                prepare(downloadCheckPoint, downloadFileRequest);
                remove(downloadFileRequest.getCheckpointFile());
            }
        } else {
            // The checkpoint is not enabled, download the file again.
            prepare(downloadCheckPoint, downloadFileRequest);
        }

        // Progress listen starts tracking the progress.
        ProgressListener listener = downloadFileRequest.getProgressListener();
        ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_STARTED_EVENT);

        // Concurrently download parts.
        DownloadResult downloadResult = download(downloadCheckPoint, downloadFileRequest);
        Long serverCRC = null;
        for (PartResult partResult : downloadResult.getPartResults()) {
            if (partResult.getServerCRC() != null) {
                serverCRC = partResult.getServerCRC();
            }
            if (partResult.isFailed()) {
                ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_PART_FAILED_EVENT);
                throw partResult.getException();
            }
        }

        // check crc64
        if(objectOperation.getInnerClient().getClientConfiguration().isCrcCheckEnabled() &&
           !hasRangeInRequest(downloadFileRequest)) {
            Long clientCRC = calcObjectCRCFromParts(downloadResult.getPartResults());
            try {
                OSSUtils.checkChecksum(clientCRC, serverCRC, downloadResult.getObjectMetadata().getRequestId());
            } catch (Exception e) {
                ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_FAILED_EVENT);
                throw new InconsistentException(clientCRC, serverCRC, downloadResult.getObjectMetadata().getRequestId());
            }
        }


        // Publish the complete status.
        ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_COMPLETED_EVENT);

        // rename the temp file.
        renameTo(downloadFileRequest.getTempDownloadFile(), downloadFileRequest.getDownloadFile());

        // The checkpoint is enabled, delete the checkpoint file after a
        // successful download.
        if (downloadFileRequest.isEnableCheckpoint()) {
            remove(downloadFileRequest.getCheckpointFile());
        }

        downloadFileResult.setObjectMetadata(downloadResult.getObjectMetadata());
        return downloadFileResult;
    }

     void prepare(DownloadCheckPoint downloadCheckPoint, DownloadFileRequest downloadFileRequest)
            throws IOException {
        downloadCheckPoint.magic = DownloadCheckPoint.DOWNLOAD_MAGIC;
        downloadCheckPoint.downloadFile = downloadFileRequest.getDownloadFile();
        downloadCheckPoint.bucketName = downloadFileRequest.getBucketName();
        downloadCheckPoint.objectKey = downloadFileRequest.getKey();
        downloadCheckPoint.objectStat = ObjectStat.getFileStat(objectOperation, downloadFileRequest);
        long downloadSize;
        if (downloadCheckPoint.objectStat.size > 0) {
            long[] slice = getSlice(downloadFileRequest.getRange(), downloadCheckPoint.objectStat.size);
            downloadCheckPoint.downloadParts = splitFile(slice[0], slice[1], downloadFileRequest.getPartSize());
            downloadSize = slice[1];
        } else {
            //download whole file
            downloadSize = 0;
            downloadCheckPoint.downloadParts = splitOneFile();
        }
        createFixedFile(downloadFileRequest.getTempDownloadFile(), downloadSize);
    }

     static void createFixedFile(String filePath, long length) throws IOException {
        File file = new File(filePath);
        RandomAccessFile rf = null;

        try {
            rf = new RandomAccessFile(file, "rw");
            rf.setLength(length);
        } finally {
            if (rf != null) {
                rf.close();
            }
        }
    }

     static Long calcObjectCRCFromParts(List<PartResult> partResults) {
        long crc = 0;

        for (PartResult partResult : partResults) {
            if (partResult.getClientCRC() == null || partResult.getLength() <= 0) {
                return null;
            }
            crc = CRC64.combine(crc, partResult.getClientCRC(), partResult.getLength());
        }
        return new Long(crc);
    }

     DownloadResult download(DownloadCheckPoint downloadCheckPoint, DownloadFileRequest downloadFileRequest)
            throws Throwable {
        DownloadResult downloadResult = new DownloadResult();
        ArrayList<PartResult> taskResults = [];
        ExecutorService service = Executors.newFixedThreadPool(downloadFileRequest.getTaskNum());
        ArrayList<Future<PartResult>> futures = [];
        List<Task> tasks = [];
        ProgressListener listener = downloadFileRequest.getProgressListener();

        // Compute the size of data pending download.
        long completedLength = 0;
        long contentLength = 0;
        for (int i = 0; i < downloadCheckPoint.downloadParts.size(); i++) {
            long partSize = downloadCheckPoint.downloadParts.GET(i).end -
                    downloadCheckPoint.downloadParts.GET(i).start + 1;
            contentLength += partSize;
            if (downloadCheckPoint.downloadParts.GET(i).isCompleted) {
                completedLength += partSize;
            }
        }

        ProgressPublisher.publishResponseContentLength(listener, contentLength);
        ProgressPublisher.publishResponseBytesTransferred(listener, completedLength);
        downloadFileRequest.setProgressListener(null);

        // Concurrently download parts.
        for (int i = 0; i < downloadCheckPoint.downloadParts.size(); i++) {
            if (!downloadCheckPoint.downloadParts.GET(i).isCompleted) {
                Task task = new Task(i, "download-" + i, downloadCheckPoint, i, downloadFileRequest, objectOperation,
                        listener);
                futures.add(service.submit(task));
                tasks.add(task);
            } else {
                taskResults.add(new PartResult(i + 1, downloadCheckPoint.downloadParts.GET(i).start,
                        downloadCheckPoint.downloadParts.GET(i).end, downloadCheckPoint.downloadParts.GET(i).length,
                        downloadCheckPoint.downloadParts.GET(i).crc));
            }
        }
        service.shutdown();

        // Waiting for all parts download,
        service.awaitTermination(Long.MAX_VALUE, TimeUnit.SECONDS);
        for (Future<PartResult> future : futures) {
            try {
                PartResult tr = future.GET();
                taskResults.add(tr);
            } catch (ExecutionException e) {
                downloadFileRequest.setProgressListener(listener);
                throw e.getCause();
            }
        }

        // Sorts the download result by the part number.
        Collections.sort(taskResults, new Comparator<PartResult>() {
            @override
             int compare(PartResult p1, PartResult p2) {
                return p1.getNumber() - p2.getNumber();
            }
        });

        // sets the return value.
        downloadResult.setPartResults(taskResults);
        if (tasks.size() > 0) {
            downloadResult.setObjectMetadata(tasks.GET(0).GetobjectMetadata());
        }
        downloadFileRequest.setProgressListener(listener);

        return downloadResult;
    }

     bool hasRangeInRequest(DownloadFileRequest downloadFileRequest) {
        return downloadFileRequest.getRange() != null;
    }

    class Task implements Callable<PartResult> {

         Task(int id, String name, DownloadCheckPoint downloadCheckPoint, int partIndex,
                DownloadFileRequest downloadFileRequest, OSSObjectOperation objectOperation,
                ProgressListener progressListener) {
            this.id = id;
            this.name = name;
            this.downloadCheckPoint = downloadCheckPoint;
            this.partIndex = partIndex;
            this.downloadFileRequest = downloadFileRequest;
            this.objectOperation = objectOperation;
            this.progressListener = progressListener;
        }

        @override
         PartResult call() throws Exception {
            PartResult tr = null;
            RandomAccessFile output = null;
            InputStream content = null;

            try {
                DownloadPart downloadPart = downloadCheckPoint.downloadParts.GET(partIndex);
                tr = new PartResult(partIndex + 1, downloadPart.start, downloadPart.end);

                output = new RandomAccessFile(downloadFileRequest.getTempDownloadFile(), "rw");
                output.seek(downloadPart.fileStart);

                GetObjectRequest getObjectRequest = new GetObjectRequest(downloadFileRequest.getBucketName(),
                        downloadFileRequest.getKey());
                getObjectRequest.setMatchingETagConstraints(downloadFileRequest.getMatchingETagConstraints());
                getObjectRequest.setNonmatchingETagConstraints(downloadFileRequest.getNonmatchingETagConstraints());
                getObjectRequest.setModifiedSinceConstraint(downloadFileRequest.getModifiedSinceConstraint());
                getObjectRequest.setUnmodifiedSinceConstraint(downloadFileRequest.getUnmodifiedSinceConstraint());
                getObjectRequest.setResponseHeaders(downloadFileRequest.getResponseHeaders());
                getObjectRequest.setRange(downloadPart.start, downloadPart.end);
 
                String versionId = downloadFileRequest.getVersionId();
                if (versionId != null) {
                    getObjectRequest.setVersionId(versionId);
                }

                Payer payer = downloadFileRequest.getRequestPayer();
                if (payer != null) {
                    getObjectRequest.setRequestPayer(payer);
                }

                int limit = downloadFileRequest.getTrafficLimit();
                if (limit > 0) {
                    getObjectRequest.setTrafficLimit(limit);
                }

                OSSObject ossObj = getObjectWrap(getObjectRequest);
                objectMetadata = ossObj.getObjectMetadata();
                content = ossObj.getObjectContent();

                byte[] buffer = new byte[DEFAULT_BUFFER_SIZE];
                int bytesRead = 0;
                while ((bytesRead = IOUtils.readNBytes(content, buffer, 0, buffer.length)) > 0) {
                    output.write(buffer, 0, bytesRead);
                }

                if (objectOperation.getInnerClient().getClientConfiguration().isCrcCheckEnabled()) {
                    Long clientCRC = getInputStreamCRCWrap(content);
                    tr.setClientCRC(clientCRC);
                    tr.setServerCRC(objectMetadata.getServerCRC());
                    tr.setLength(objectMetadata.getContentLength());
                    downloadPart.length = objectMetadata.getContentLength();
                    downloadPart.crc = clientCRC;
                }
                downloadCheckPoint.update(partIndex, true);
                if (downloadFileRequest.isEnableCheckpoint()) {
                    downloadCheckPoint.dump(downloadFileRequest.getCheckpointFile());
                }
                ProgressPublisher.publishResponseBytesTransferred(progressListener,
                        (downloadPart.end - downloadPart.start + 1));
            } catch (Exception e) {
                tr.setFailed(true);
                tr.setException(e);
                logException(String.format("Task %d:%s upload part %d failed: ", id, name, partIndex), e);
            } finally {
                if (output != null) {
                    output.close();
                }

                if (content != null) {
                    content.close();
                }
            }

            return tr;
        }

         ObjectMetadata GetobjectMetadata() {
            return objectMetadata;
        }

         int id;
         String name;
         DownloadCheckPoint downloadCheckPoint;
         int partIndex;
         DownloadFileRequest downloadFileRequest;
         OSSObjectOperation objectOperation;
         ObjectMetadata objectMetadata;
         ProgressListener progressListener;
    }

     ArrayList<DownloadPart> splitFile(long start, long objectSize, long partSize) {
        ArrayList<DownloadPart> parts = [];

        long partNum = objectSize / partSize;
        long alignSize = 4 * KB;
        if (partNum >= 10000) {
            partSize = objectSize / (10000 - 1);
            partSize = (((partSize + alignSize -1)/alignSize) * alignSize);
        }

        long offset = 0L;
        for (int i = 0; offset < objectSize; offset += partSize, i++) {
            DownloadPart part = new DownloadPart();
            part.index = i;
            part.start = offset + start;
            part.end = getPartEnd(offset, objectSize, partSize) + start;
            part.fileStart = offset;
            parts.add(part);
        }

        return parts;
    }

     long getPartEnd(long begin, long total, long per) {
        if (begin + per > total) {
            return total - 1;
        }
        return begin + per - 1;
    }

     ArrayList<DownloadPart> splitOneFile() {
        ArrayList<DownloadPart> parts = [];
        DownloadPart part = new DownloadPart();
        part.index = 0;
        part.start = 0;
        part.end = -1;
        part.fileStart = 0;
        parts.add(part);
        return parts;
    }

     long[] getSlice(long[] range, long totalSize) {
        long start = 0;
        long size = totalSize;

        if ((RANGE == null) ||
            (RANGE.length != 2) ||
            (totalSize < 1) ||
            (RANGE[0] < 0 && RANGE[1] < 0) ||
            (RANGE[0] > 0 && RANGE[1] > 0 && RANGE[0] > RANGE[1])||
            (RANGE[0] >= totalSize)) {
            //download all
        } else {
            //dwonload part by range & total size
            long begin = RANGE[0];
            long end = RANGE[1];
            if (RANGE[0] < 0) {
                begin = 0;
            }
            if (RANGE[1] < 0 || RANGE[1] >= totalSize) {
                end = totalSize -1;
            }
            start = begin;
            size = end - begin + 1;
        }

        return new long[]{start, size};
    }

     bool remove(String filePath) {
        bool flag = false;
        File file = new File(filePath);

        if (file.isFile() && file.exists()) {
            flag = file.DELETE();
        }

        return flag;
    }

     static void renameTo(String srcFilePath, String destFilePath) throws IOException {
        File srcfile = new File(srcFilePath);
        File destfile = new File(destFilePath);
        moveFile(srcfile, destfile);
    }

     static void moveFile(final File srcFile, final File destFile) throws IOException {
        if (srcFile == null) {
            throw new NullPointerException("Source must not be null");
        }
        if (destFile == null) {
            throw new NullPointerException("Destination must not be null");
        }
        if (!srcFile.exists()) {
            throw new FileNotFoundException("Source '" + srcFile + "' does not exist");
        }
        if (srcFile.isDirectory()) {
            throw new IOException("Source '" + srcFile + "' is a directory");
        }
        if (destFile.isDirectory()) {
            throw new IOException("Destination '" + destFile + "' is a directory");
        }
        if (destFile.exists()) {
            if (!destFile.DELETE()) {
                throw new IOException("Failed to delete original file '" + srcFile + "'");
            }
        }

        final bool rename = srcFile.renameTo(destFile);
        if (!rename) {
            copyFile(srcFile, destFile);
            if (!srcFile.DELETE()) {
                throw new IOException(
                        "Failed to delete original file '" + srcFile + "' after copy to '" + destFile + "'");
            }
        }
    }

     static void copyFile(File source, File dest) throws IOException {
        InputStream is = null;
        OutputStream os = null;
        try {
            is = new FileInputStream(source);
            os = new FileOutputStream(dest);
            byte[] buffer = new byte[4096];
            int length;
            while ((length = is.read(buffer)) > 0) {
                os.write(buffer, 0, length);
            }
        } finally {
            is.close();
            os.close();
        }
    }

     OSSObjectOperation objectOperation;
}
