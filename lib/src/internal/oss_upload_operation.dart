
import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/crypto/crypto_module_base.dart';
import 'package:aliyun_oss_dart_sdk/src/model/part_e_tag.dart';

/// OSSUploadOperation
///
 class OSSUploadOperation {

     UploadCheckPoint createUploadCheckPointWrap() {
        return UploadCheckPoint();
    }

     void loadUploadCheckPointWrap(UploadCheckPoint uploadCheckPoint, String checkpointFile) {
        uploadCheckPoint.load(checkpointFile);
    }

     InitiateMultipartUploadResult initiateMultipartUploadWrap(UploadCheckPoint uploadCheckPoint,
            InitiateMultipartUploadRequest initiateMultipartUploadRequest) {
        return multipartOperation.initiateMultipartUpload(initiateMultipartUploadRequest);
    }

     UploadPartResult uploadPartWrap(UploadCheckPoint uploadCheckPoint, UploadPartRequest request) {
        return multipartOperation.uploadPart(request);
    }

     CompleteMultipartUploadResult completeMultipartUploadWrap(UploadCheckPoint uploadCheckPoint, CompleteMultipartUploadRequest request)
            {
        return multipartOperation.completeMultipartUpload(request);
    }

    

     OSSUploadOperation(OSSMultipartOperation multipartOperation) {
        this.multipartOperation = multipartOperation;
    }

     UploadFileResult uploadFile(UploadFileRequest uploadFileRequest) {
        assertParameterNotNull(uploadFileRequest, "uploadFileRequest");

        String bucketName = uploadFileRequest.getBucketName();
        String key = uploadFileRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);

        assertParameterNotNull(uploadFileRequest.getUploadFile(), "uploadFile");

        // The checkpoint is enabled without specifying the checkpoint file,
        // using the default one.
        if (uploadFileRequest.isEnableCheckpoint()) {
            if (uploadFileRequest.getCheckpointFile() == null || uploadFileRequest.getCheckpointFile().isEmpty()) {
                uploadFileRequest.setCheckpointFile(uploadFileRequest.getUploadFile() + ".ucp");
            }
        }

        return uploadFileWithCheckpoint(uploadFileRequest);
    }

     UploadFileResult uploadFileWithCheckpoint(UploadFileRequest uploadFileRequest) {
        UploadFileResult uploadFileResult = UploadFileResult();
        UploadCheckPoint uploadCheckPoint = createUploadCheckPointWrap();

        // The checkpoint is enabled, reading the checkpoint data from the
        // checkpoint file.
        if (uploadFileRequest.isEnableCheckpoint()) {
            // The checkpoint file either does not exist, or is corrupted, the
            // whole file needs the re-upload.
            try {
                loadUploadCheckPointWrap(uploadCheckPoint, uploadFileRequest.getCheckpointFile());
            } catch (Exception e) {
                remove(uploadFileRequest.getCheckpointFile());
            }

            // The file uploaded is updated, re-upload.
            if (!uploadCheckPoint.isValid(uploadFileRequest.getUploadFile())) {
                prepare(uploadCheckPoint, uploadFileRequest);
                remove(uploadFileRequest.getCheckpointFile());
            }
        } else {
            // The checkpoint is not enabled, re-upload.
            prepare(uploadCheckPoint, uploadFileRequest);
        }
        
        // The progress tracker starts
        ProgressListener listener = uploadFileRequest.getProgressListener();
        ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_STARTED_EVENT);

        // Concurrently upload parts.
        List<PartResult> partResults = upload(uploadCheckPoint, uploadFileRequest);
        for (PartResult partResult : partResults) {
            if (partResult.isFailed()) {
                ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_PART_FAILED_EVENT);
                throw partResult.getException();
            }
        }

        // The progress tracker publishes the data.
        ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_COMPLETED_EVENT);

        // Complete parts.
        CompleteMultipartUploadResult multipartUploadResult = complete(uploadCheckPoint, uploadFileRequest);
        uploadFileResult.setMultipartUploadResult(multipartUploadResult);

        // check crc64
        if (multipartOperation.getInnerClient().getClientConfiguration().isCrcCheckEnabled()) {
            int clientCRC = calcObjectCRCFromParts(partResults);
            multipartUploadResult.setClientCRC(clientCRC);
            try {
                OSSUtils.checkChecksum(clientCRC, multipartUploadResult.getServerCRC(), multipartUploadResult.getRequestId());
            } catch (Exception e) {
                ProgressPublisher.publishProgress(listener, ProgressEventType.TRANSFER_FAILED_EVENT);
                throw InconsistentException(clientCRC, multipartUploadResult.getServerCRC(), multipartUploadResult.getRequestId());
            }
        }

        // The checkpoint is enabled and upload the checkpoint file.
        if (uploadFileRequest.isEnableCheckpoint()) {
            remove(uploadFileRequest.getCheckpointFile());
        }

        return uploadFileResult;
    }

     static int calcObjectCRCFromParts(List<PartResult> partResults) {
        int crc = 0;

        for (PartResult partResult : partResults) {
            if (partResult.getPartCRC() == null || partResult.getLength() <= 0) {
                return null;
            }
            crc = CRC64.combine(crc, partResult.getPartCRC(), partResult.getLength());
        }
        return int(crc);
    }

     void prepare(UploadCheckPoint uploadCheckPoint, UploadFileRequest uploadFileRequest) {
        uploadCheckPoint.magic = UploadCheckPoint.UPLOAD_MAGIC;
        uploadCheckPoint.uploadFile = uploadFileRequest.getUploadFile();
        uploadCheckPoint.key = uploadFileRequest.getKey();
        uploadCheckPoint.uploadFileStat = FileStat.getFileStat(uploadCheckPoint.uploadFile);
        uploadCheckPoint.uploadParts = splitFile(uploadCheckPoint.uploadFileStat.size, uploadFileRequest.getPartSize());
        uploadCheckPoint.partETags = [];
        uploadCheckPoint.originPartSize = uploadFileRequest.getPartSize();

        ObjectMetadata metadata = uploadFileRequest.getObjectMetadata();
        if (metadata == null) {
            metadata = ObjectMetadata();
        }

        if (metadata.getContentType() == null) {
            metadata.setContentType(
                    Mimetypes.getInstance().getMimetype(uploadCheckPoint.uploadFile, uploadCheckPoint.key));
        }

        InitiateMultipartUploadRequest initiateUploadRequest = InitiateMultipartUploadRequest(
                uploadFileRequest.getBucketName(), uploadFileRequest.getKey(), metadata);

        Payer payer = uploadFileRequest.getRequestPayer();
        if (payer != null) {
            initiateUploadRequest.setRequestPayer(payer);
        }

        initiateUploadRequest.setSequentialMode(uploadFileRequest.getSequentialMode());

        InitiateMultipartUploadResult initiateUploadResult = initiateMultipartUploadWrap(uploadCheckPoint, initiateUploadRequest);
        uploadCheckPoint.uploadID = initiateUploadResult.getUploadId();
    }

     ArrayList<PartResult> upload(UploadCheckPoint uploadCheckPoint, UploadFileRequest uploadFileRequest)
            {
        ArrayList<PartResult> taskResults = [];
        ExecutorService service = Executors.newFixedThreadPool(uploadFileRequest.getTaskNum());
        ArrayList<Future<PartResult>> futures = [];
        ProgressListener listener = uploadFileRequest.getProgressListener();

        // Compute the size of the data pending upload.
        int contentLength = 0;
        int completedLength = 0;
        for (int i = 0; i < uploadCheckPoint.uploadParts.size(); i++) {
            int partSize = uploadCheckPoint.uploadParts.GET(i).size;
            contentLength += partSize;
            if (uploadCheckPoint.uploadParts.GET(i).isCompleted) {
                completedLength += partSize;
            }
        }

        ProgressPublisher.publishRequestContentLength(listener, contentLength);
        ProgressPublisher.publishRequestBytesTransferred(listener, completedLength);
        uploadFileRequest.setProgressListener(null);

        // Upload parts.
        for (int i = 0; i < uploadCheckPoint.uploadParts.size(); i++) {
            if (!uploadCheckPoint.uploadParts.GET(i).isCompleted) {
                futures.add(service.submit(Task(i, "upload-" + i, uploadCheckPoint, i, uploadFileRequest,
                        multipartOperation, listener)));
            } else {
                taskResults.add(PartResult(i + 1, uploadCheckPoint.uploadParts.GET(i).offset,
                        uploadCheckPoint.uploadParts.GET(i).size, uploadCheckPoint.uploadParts.GET(i).crc));
            }
        }
        service.shutdown();

        // Waiting for parts upload complete.
        service.awaitTermination(int.MAX_VALUE, TimeUnit.SECONDS);
        for (Future<PartResult> future : futures) {
            try {
                PartResult tr = future.GET();
                taskResults.add(tr);
            } catch (ExecutionException e) {
                uploadFileRequest.setProgressListener(listener);
                throw e.getCause();
            }
        }

        // Sorts PartResult by the part numnber.
        Collections.sort(taskResults, Comparator<PartResult>() {
            @override
             int compare(PartResult p1, PartResult p2) {
                return p1.getNumber() - p2.getNumber();
            }
        });
        uploadFileRequest.setProgressListener(listener);

        return taskResults;
    }

    class Task implements Callable<PartResult> {

         Task(int id, String name, UploadCheckPoint uploadCheckPoint, int partIndex,
                UploadFileRequest uploadFileRequest, OSSMultipartOperation multipartOperation,
                ProgressListener progressListener) {
            this.id = id;
            this.name = name;
            this.uploadCheckPoint = uploadCheckPoint;
            this.partIndex = partIndex;
            this.uploadFileRequest = uploadFileRequest;
            this.multipartOperation = multipartOperation;
            this.progressListener = progressListener;
        }

        @override
         PartResult call() {
            PartResult tr = null;
            InputStream instream = null;

            try {
                UploadPart uploadPart = uploadCheckPoint.uploadParts.GET(partIndex);
                tr = PartResult(partIndex + 1, uploadPart.offset, uploadPart.size);

                instream = FileInputStream(uploadCheckPoint.uploadFile);
                instream.skip(uploadPart.offset);

                UploadPartRequest uploadPartRequest = UploadPartRequest();
                uploadPartRequest.setBucketName(uploadFileRequest.getBucketName());
                uploadPartRequest.setKey(uploadFileRequest.getKey());
                uploadPartRequest.setUploadId(uploadCheckPoint.uploadID);
                uploadPartRequest.setPartNumber(uploadPart.number);
                uploadPartRequest.setInputStream(instream);
                uploadPartRequest.setPartSize(uploadPart.size);

                Payer payer = uploadFileRequest.getRequestPayer();
                if (payer != null) {
                    uploadPartRequest.setRequestPayer(payer);
                }
                
                int limit = uploadFileRequest.getTrafficLimit();
                if (limit > 0) {
                    uploadPartRequest.setTrafficLimit(limit);
                }

                UploadPartResult uploadPartResult  = uploadPartWrap(uploadCheckPoint, uploadPartRequest);

                if(multipartOperation.getInnerClient().getClientConfiguration().isCrcCheckEnabled()) {
                    OSSUtils.checkChecksum(uploadPartResult.getClientCRC(), uploadPartResult.getServerCRC(), uploadPartResult.getRequestId());
                    tr.setPartCRC(uploadPartResult.getClientCRC());
                    tr.setLength(uploadPartResult.getPartSize());
                    uploadPart.crc = uploadPartResult.getClientCRC();
                }
                PartETag partETag = PartETag(uploadPartResult.getPartNumber(), uploadPartResult.getETag());
                uploadCheckPoint.update(partIndex, partETag, true);
                if (uploadFileRequest.isEnableCheckpoint()) {
                    uploadCheckPoint.dump(uploadFileRequest.getCheckpointFile());
                }
                ProgressPublisher.publishRequestBytesTransferred(progressListener, uploadPart.size);
            } catch (Exception e) {
                tr.setFailed(true);
                tr.setException(e);
                logException(String.format("Task %d:%s upload part %d failed: ", id, name, partIndex + 1), e);
            } finally {
                if (instream != null) {
                    instream.close();
                }
            }

            return tr;
        }

         int id;
         String name;
         UploadCheckPoint uploadCheckPoint;
         int partIndex;
         UploadFileRequest uploadFileRequest;
         OSSMultipartOperation multipartOperation;
         ProgressListener progressListener;
    }

     CompleteMultipartUploadResult complete(UploadCheckPoint uploadCheckPoint,
            UploadFileRequest uploadFileRequest) {
        Collections.sort(uploadCheckPoint.partETags, Comparator<PartETag>() {
            @override
             int compare(PartETag p1, PartETag p2) {
                return p1.getPartNumber() - p2.getPartNumber();
            }
        });
        CompleteMultipartUploadRequest completeUploadRequest = CompleteMultipartUploadRequest(
                uploadFileRequest.getBucketName(), uploadFileRequest.getKey(), uploadCheckPoint.uploadID,
                uploadCheckPoint.partETags);
     
        Payer payer = uploadFileRequest.getRequestPayer();
        if (payer != null) {
            completeUploadRequest.setRequestPayer(payer);
        }

        ObjectMetadata metadata = uploadFileRequest.getObjectMetadata();
        if (metadata != null) {
            String acl = (String) metadata.getRawMetadata().GET(OSSHeaders.OSS_OBJECT_ACL);
            if (acl != null && !acl.equals("")) {
                CannedAccessControlList accessControlList = CannedAccessControlList.parse(acl);
                completeUploadRequest.setObjectACL(accessControlList);
            }
        }

        completeUploadRequest.setCallback(uploadFileRequest.getCallback());

        return completeMultipartUploadWrap(uploadCheckPoint, completeUploadRequest);
    }

     ArrayList<UploadPart> splitFile(int fileSize, int partSize) {
        ArrayList<UploadPart> parts = [];

        int partNum = fileSize / partSize;
        if (partNum >= 10000) {
            partSize = fileSize / (10000 - 1);
            partNum = fileSize / partSize;
        }

        for (int i = 0; i < partNum; i++) {
            UploadPart part = UploadPart();
            part.number = (int) (i + 1);
            part.offset = i * partSize;
            part.size = partSize;
            part.isCompleted = false;
            parts.add(part);
        }

        if (fileSize % partSize > 0) {
            UploadPart part = UploadPart();
            part.number = parts.size() + 1;
            part.offset = parts.size() * partSize;
            part.size = fileSize % partSize;
            part.isCompleted = false;
            parts.add(part);
        }

        return parts;
    }

     bool remove(String filePath) {
        bool flag = false;
        File file = File(filePath);

        if (file.isFile() && file.exists()) {
            flag = file.DELETE();
        }

        return flag;
    }

     OSSMultipartOperation multipartOperation;
}


class UploadCheckPoint  {

         static final String UPLOAD_MAGIC = "FE8BB4EA-B593-4FAC-AD7A-2459A36E2E62";

        /// Gets the checkpoint data from the checkpoint file.
          void load(String cpFile) {
            FileInputStream fileIn = FileInputStream(cpFile);
            ObjectInputStream inputStream = ObjectInputStream(fileIn);
            UploadCheckPoint ucp =  inputStream.readObject() as UploadCheckPoint;
            assign(ucp);
            inputStream.close();
            fileIn.close();
        }

        /// Writes the checkpoint data to the checkpoint file.
          void dump(String cpFile) {
            md5 = hashCode;
            FileOutputStream fileOut = FileOutputStream(cpFile);
            ObjectOutputStream outStream = ObjectOutputStream(fileOut);
            outStream.writeObject(this);
            outStream.close();
            fileOut.close();
        }

        /// The part upload complete, update the status.
        /// 
        /// @throws IOException
          void update(int partIndex, PartETag partETag, bool completed) {
            partETags.add(partETag);
            uploadParts.GET(partIndex).isCompleted = completed;
        }

        /// Check if the local file matches the checkpoint.
          bool isValid(String uploadFile) {
            // 比较checkpoint的magic和md5
            // Compares the magic field in checkpoint and the file's md5.
            if (magic != UPLOAD_MAGIC || md5 != hashCode) {
                return false;
            }

            // Checks if the file exists.
            File upload = File(uploadFile);
            if (!upload.exists()) {
                return false;
            }

            // The file name, size and last modified time must be same as the
            // checkpoint.
            // If any item is changed, return false (re-upload the file).
            if (this.uploadFile != uploadFile || uploadFileStat.size != upload.length()
                    || uploadFileStat.LAST_MODIFIED != upload.LAST_MODIFIED()) {
                return false;
            }

            return true;
        }

        @override
         int get hashCode {
            final int prime = 31;
            int result = 1;
            result = prime * result + (key?.hashCode ?? 0);
            result = prime * result + (magic?.hashCode ?? 0);
            result = prime * result + (partETags?.hashCode ?? 0);
            result = prime * result + (uploadFile?.hashCode ?? 0);
            result = prime * result + (uploadFileStat?.hashCode ?? 0);
            result = prime * result + (uploadID?.hashCode ?? 0);
            result = prime * result + (uploadParts?.hashCode ?? 0);
            result = prime * result + originPartSize;
            return result;
        }

         void assign(UploadCheckPoint ucp) {
            magic = ucp.magic;
            md5 = ucp.md5;
            uploadFile = ucp.uploadFile;
            uploadFileStat = ucp.uploadFileStat;
            key = ucp.key;
            uploadID = ucp.uploadID;
            uploadParts = ucp.uploadParts;
            partETags = ucp.partETags;
            originPartSize = ucp.originPartSize;
        }

         String? magic;
         int md5 = 0;
         String? uploadFile;
         FileStat? uploadFileStat;
         String? key;
         String? uploadID;
         List<UploadPart>? uploadParts;
         List<PartETag>? partETags;
         int originPartSize = 0;
    }

    class FileStat {

        @override
         int get hashCode {
            final int prime = 31;
            int result = 1;
            result = prime * result + (digest?.hashCode ?? 0);
            result = prime * result + (LAST_MODIFIED ^ (LAST_MODIFIED >>> 32));
            result = prime * result + (size ^ (size >>> 32));
            return result;
        }

         static FileStat getFileStat(String uploadFile) {
            FileStat fileStat = FileStat();
            final file = File(uploadFile);
            fileStat.size = file.lengthSync();
            fileStat.LAST_MODIFIED = file.lastModifiedSync().millisecondsSinceEpoch;
            return fileStat;
        }

         int size = 0; // file size
         int LAST_MODIFIED = 0; // file last modified time.
         String? digest; // file content's digest (signature).
    }

    class UploadPart  {

        @override
         int get hashCode {
            final int prime = 31;
            int result = 1;
            result = prime * result + (isCompleted ? 1231 : 1237);
            result = prime * result + number;
            result = prime * result +  (offset ^ (offset >>> 32));
            result = prime * result +  (size ^ (size >>> 32));
            result = prime * result +  (crc ^ (crc >>> 32));
            return result;
        }

         int number = 0; // part number
         int offset = 0; // the offset in the file
         int size = 0 ; // part size
         bool isCompleted = false; // upload completeness flag.
         int crc = 0; //part crc
    }

    class PartResult {

         PartResult(this.number, this.offset, this.length, [this.partCRC = 0]);

         int number; // part number
         int offset; // offset in the file
         int length; // part size
         bool failed = false; // part upload failure flag
         Exception? exception; // part upload exception
         int partCRC;
    }