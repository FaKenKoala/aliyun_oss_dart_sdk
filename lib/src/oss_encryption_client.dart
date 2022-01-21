import 'client_configuration.dart';
import 'common/auth/credentials_provider.dart';
import 'crypto/encryption_materials.dart';
import 'oss_client.dart';

/// OSSEncryptionClient is used to do client-side encryption.
 class OSSEncryptionClient extends OSSClient {
     static final String USER_AGENT_SUFFIX = "/OSSEncryptionClient";
     final EncryptionMaterials encryptionMaterials;
     final CryptoConfiguration cryptoConfig;
     final OSSDirect ossDirect = OSSDirectImpl();

     OSSEncryptionClient(String endpoint, CredentialsProvider credsProvider, ClientConfiguration clientConfig,
            EncryptionMaterials encryptionMaterials, CryptoConfiguration cryptoConfig) {
        super(endpoint, credsProvider, clientConfig);
        assertParameterNotNull(credsProvider, "CredentialsProvider");
        assertParameterNotNull(encryptionMaterials, "EncryptionMaterials");
        if(encryptionMaterials is KmsEncryptionMaterials) {
            ((KmsEncryptionMaterials)encryptionMaterials).setKmsCredentialsProvider(credsProvider);
        }
        this.cryptoConfig = cryptoConfig == null ? CryptoConfiguration.DEFAULT : cryptoConfig;
        this.encryptionMaterials = encryptionMaterials;
    }

    @override
     PutObjectResult putObject(PutObjectRequest req) throws OSSException, ClientException {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.putObjectSecurely(req);
    }

    @override
     OSSObject getObject(GetObjectRequest req) throws OSSException, ClientException {
        if(req.isUseUrlSignature()) {
            throw ClientException("Encryption client error, get object with url opreation is disabled in encryption client." + 
                    "Please use normal oss client method {@OSSClient#getObject(GetObjectRequest req)}."); 
        }
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.getObjectSecurely(req);
    }

    @override
     ObjectMetadata getObject(GetObjectRequest req, File file) throws OSSException, ClientException {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.getObjectSecurely(req, file);
    }

    @override
     UploadFileResult uploadFile(UploadFileRequest uploadFileRequest) throws Throwable {
        OSSUploadOperationEncrypted ossUploadOperationEncrypted = OSSUploadOperationEncrypted(this, encryptionMaterials);
        this.setUploadOperation(ossUploadOperationEncrypted);
        return super.uploadFile(uploadFileRequest);
    }

    @override
     DownloadFileResult downloadFile(DownloadFileRequest downloadFileRequest) throws Throwable {
        GenericRequest genericRequest = GenericRequest(downloadFileRequest.getBucketName(), downloadFileRequest.getKey());
        String versionId = downloadFileRequest.getVersionId();
        if (versionId != null) {
            genericRequest.setVersionId(versionId);
        }
        Payer payer = downloadFileRequest.getRequestPayer();
        if (payer != null) {
            genericRequest.setRequestPayer(payer);
        }
        ObjectMetadata objectMetadata = getObjectMetadata(genericRequest);

        long objectSize = objectMetadata.getContentLength();
        if (objectSize <= downloadFileRequest.getPartSize()) {
            GetObjectRequest getObjectRequest = convertToGetObjectRequest(downloadFileRequest);
            objectMetadata = this.getObject(getObjectRequest, File(downloadFileRequest.getDownloadFile()));
            DownloadFileResult downloadFileResult = DownloadFileResult();
            downloadFileResult.setObjectMetadata(objectMetadata);
            return downloadFileResult;
        } else {
            if (!hasEncryptionInfo(objectMetadata)) {
                return super.downloadFile(downloadFileRequest);
            } else {
                long partSize = downloadFileRequest.getPartSize();
                if (0 != (partSize % CryptoScheme.BLOCK_SIZE) || partSize <= 0) {
                    throw ArgumentError("download file part size is not 16 bytes alignment.");
                }
                OSSDownloadOperationEncrypted ossDownloadOperationEncrypted = OSSDownloadOperationEncrypted(this);
                this.setDownloadOperation(ossDownloadOperationEncrypted);
                return super.downloadFile(downloadFileRequest);
            }
        }
    }

     static GetObjectRequest convertToGetObjectRequest(DownloadFileRequest downloadFileRequest) {
        GetObjectRequest getObjectRequest = GetObjectRequest(downloadFileRequest.getBucketName(),
                downloadFileRequest.getKey());
        getObjectRequest.setMatchingETagConstraints(downloadFileRequest.getMatchingETagConstraints());
        getObjectRequest.setNonmatchingETagConstraints(downloadFileRequest.getNonmatchingETagConstraints());
        getObjectRequest.setModifiedSinceConstraint(downloadFileRequest.getModifiedSinceConstraint());
        getObjectRequest.setUnmodifiedSinceConstraint(downloadFileRequest.getUnmodifiedSinceConstraint());
        getObjectRequest.setResponseHeaders(downloadFileRequest.getResponseHeaders());

        long[] range = downloadFileRequest.getRange();
        if (range != null) {
            getObjectRequest.setRange(range[0], range[1]);
        }

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

        return getObjectRequest;
    }

     InitiateMultipartUploadResult initiateMultipartUpload(InitiateMultipartUploadRequest request,
                                                                 MultipartUploadCryptoContext context)
                                                                 throws OSSException, ClientException {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.initiateMultipartUploadSecurely(request, context);
    }

     UploadPartResult uploadPart(UploadPartRequest request, MultipartUploadCryptoContext context) {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.uploadPartSecurely(request, context);
    }

     CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request, 
                                                                 MultipartUploadCryptoContext context) 
                                                                 throws OSSException, ClientException {
        return super.completeMultipartUpload(request);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// Disabled api in encryption client///////////////////////////
    /**
     * Note: This method is disabled in encryption client.
     *  
     * @deprecated please use encryption client method
     *     {@link OSSEncryptionClient#initiateMultipartUpload(InitiateMultipartUploadRequest request, MultipartUploadCryptoContext context)}.             
     */
    @override
    @Deprecated 
     InitiateMultipartUploadResult initiateMultipartUpload(InitiateMultipartUploadRequest request) throws ClientException {
        throw ClientException("Encryption client error, you should provide a multipart upload context to the encryption client. " + 
                 "Please use  encryption client method {@link OSSEncryptionClient#initiateMultipartUpload(InitiateMultipartUploadRequest request, " + 
                 "MultipartUploadCryptoContext context)}.");
    }

    /**
     * Note: This method is disabled in encryption client.
     *  
     * @deprecated please use encryption client method
     *     {@link OSSEncryptionClient#uploadPart(UploadPartRequest request, MultipartUploadCryptoContext context)}.             
     */
    @override 
    @Deprecated
     UploadPartResult uploadPart(UploadPartRequest request) throws ClientException {
        throw ClientException("Encryption client error, you should provide a multipart upload context to the encryption client. " + 
                "Please use  encryption client method {@link OSSEncryptionClient#uploadPart(UploadPartRequest request, MultipartUploadCryptoContext context)}.");
    }
    
    /**
     * Note: This method is disabled in encryption client.
     *  
     * @deprecated please use normal oss client method
     *     {@link OSSClient#appendObject(AppendObjectRequest appendObjectRequest)}.             
     */
    @override
    @Deprecated
     AppendObjectResult appendObject(AppendObjectRequest appendObjectRequest) throws ClientException {
        throw ClientException("Encryption client error, this method is disabled in encryption client." + 
            "Please use normal oss client method {@link OSSClient#appendObject(AppendObjectRequest appendObjectRequest)} method");
    } 
    
    /**
     * Note: This method is disabled in encryption client.
     *  
     * @deprecated please use normal oss client method
     *     {@link OSSClient#uploadPartCopy(UploadPartCopyRequest request)}.             
     */
    @override
    @Deprecated
     UploadPartCopyResult uploadPartCopy(UploadPartCopyRequest request) throws ClientException {
        throw ClientException("Encryption client error, this method is disabled in encryption client." + 
                "Please use normal oss client method {@link OSSClient#uploadPartCopy(UploadPartCopyRequest request)}");
    }
    
    /**
     * Note: This method is disabled in encryption client.
     *  
     * @deprecated please use normal oss client method
     *     {@link OSSClient}#putObject(URL signedUrl, InputStream requestContent, long contentLength,
     *           Map<String, String> requestHeaders, bool useChunkEncoding).
     */
    @override
    @Deprecated
     PutObjectResult putObject(URL signedUrl, InputStream requestContent, long contentLength,
            Map<String, String> requestHeaders, bool useChunkEncoding) throws ClientException {
        throw ClientException("Encryption client error, this method is disabled in encryption client." + 
                "Please use normal oss client method {@link OSSClient#putObject(URL signedUrl, InputStream requestContent, "
                + "long contentLength, Map<String, String> requestHeaders, bool useChunkEncoding)");
    }


     final class OSSDirectImpl implements OSSDirect {
        @override
         ClientConfiguration getInnerClientConfiguration() {
            return OSSEncryptionClient.this.getClientConfiguration();
        }

        @override
         PutObjectResult putObject(PutObjectRequest putObjectRequest) {
            return OSSEncryptionClient.super.putObject(putObjectRequest);
        }

        @override
         OSSObject getObject(GetObjectRequest getObjectRequest) {
            return OSSEncryptionClient.super.getObject(getObjectRequest);
        }

        @override
         void abortMultipartUpload(AbortMultipartUploadRequest request) {
            OSSEncryptionClient.super.abortMultipartUpload(request);     
        }

        @override
         CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request) {
            return OSSEncryptionClient.super.completeMultipartUpload(request);
        }

        @override
         InitiateMultipartUploadResult initiateMultipartUpload(InitiateMultipartUploadRequest request) {
            return OSSEncryptionClient.super.initiateMultipartUpload(request);
        }

        @override
         UploadPartResult uploadPart(UploadPartRequest request) {
            return OSSEncryptionClient.super.uploadPart(request);
        }
    }

     void assertParameterNotNull(Object parameterValue,
            String errorMessage) {
        if (parameterValue == null)
            throw ArgumentError(errorMessage);
    }
}
