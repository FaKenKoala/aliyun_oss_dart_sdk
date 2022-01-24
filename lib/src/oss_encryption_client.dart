// ignore_for_file: avoid_renaming_method_parameters

import 'dart:io';

import 'client_configuration.dart';
import 'common/auth/credentials_provider.dart';
import 'crypto/crypto_configuration.dart';
import 'crypto/crypto_module.dart';
import 'crypto/encryption_materials.dart';
import 'crypto/multipart_upload_crypto_context.dart';
import 'crypto/oss_direct.dart';
import 'event/progress_input_stream.dart';
import 'internal/oss_download_operation_encrypted.dart';
import 'internal/oss_upload_operation_encrypted.dart';
import 'model/abort_multipart_upload_request.dart';
import 'model/append_object_request.dart';
import 'model/append_object_result.dart';
import 'model/complete_multipart_upload_request.dart';
import 'model/complete_multipart_upload_result.dart';
import 'model/download_file_request.dart';
import 'model/download_file_result.dart';
import 'model/generic_request.dart';
import 'model/get_object_request.dart';
import 'model/initiate_multipart_upload_request.dart';
import 'model/initiate_multipart_upload_result.dart';
import 'model/object_metadata.dart';
import 'model/oss_object.dart';
import 'model/payer.dart';
import 'model/pub_object_request.dart';
import 'model/put_object_result.dart';
import 'model/upload_file_request.dart';
import 'model/upload_file_result.dart';
import 'model/upload_part_copy_request.dart';
import 'model/upload_part_copy_result.dart';
import 'model/upload_part_request.dart';
import 'model/upload_part_result.dart';
import 'oss_client.dart';

/// OSSEncryptionClient is used to do client-side encryption.
 class OSSEncryptionClient extends OSSClient {
     static final String USER_AGENT_SUFFIX = "/OSSEncryptionClient";
     final EncryptionMaterials encryptionMaterials;
     final CryptoConfiguration cryptoConfig;
     final OSSDirect ossDirect = OSSDirectImpl();

     OSSEncryptionClient(String endpoint, CredentialsProvider credsProvider, ClientConfiguration clientConfig,
            EncryptionMaterials encryptionMaterials, CryptoConfiguration cryptoConfig)
        :super(endpoint, credsProvider, clientConfig)
            
             {
        assertParameterNotNull(credsProvider, "CredentialsProvider");
        assertParameterNotNull(encryptionMaterials, "EncryptionMaterials");
        if(encryptionMaterials is KmsEncryptionMaterials) {
            ((KmsEncryptionMaterials)encryptionMaterials).setKmsCredentialsProvider(credsProvider);
        }
        this.cryptoConfig = cryptoConfig == null ? CryptoConfiguration.DEFAULT : cryptoConfig;
        this.encryptionMaterials = encryptionMaterials;
    }

    @override
     PutObjectResult putObject(PutObjectRequest req) {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.putObjectSecurely(req);
    }

    @override
     OSSObject getObject(GetObjectRequest req) {
        if(req.useUrlSignature) {
            throw ClientException("Encryption client error, get object with url opreation is disabled in encryption client." + 
                    "Please use normal oss client method {@OSSClient#getObject(GetObjectRequest req)}."); 
        }
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.getObjectSecurely(req);
    }

    @override
     ObjectMetadata getObject(GetObjectRequest req, File file) {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.getObjectSecurely(req, file);
    }

    @override
     UploadFileResult uploadFile(UploadFileRequest uploadFileRequest) {
        OSSUploadOperationEncrypted ossUploadOperationEncrypted = OSSUploadOperationEncrypted(this, encryptionMaterials);
        setUploadOperation(ossUploadOperationEncrypted);
        return super.uploadFile(uploadFileRequest);
    }

    @override
     DownloadFileResult downloadFile(DownloadFileRequest downloadFileRequest) {
        GenericRequest genericRequest = GenericRequest(downloadFileRequest.bucketName, downloadFileRequest.key);
        String? versionId = downloadFileRequest.versionId;
        if (versionId != null) {
            genericRequest.versionId = versionId;
        }
        Payer? payer = downloadFileRequest.payer;
        if (payer != null) {
            genericRequest.payer = payer;
        }
        ObjectMetadata objectMetadata = getObjectMetadata(genericRequest);

        int objectSize = objectMetadata.getContentLength();
        if (objectSize <= downloadFileRequest.partSize) {
            GetObjectRequest getObjectRequest = convertToGetObjectRequest(downloadFileRequest);
            objectMetadata = getObject(getObjectRequest, File(downloadFileRequest.downloadFile));
            DownloadFileResult downloadFileResult = DownloadFileResult();
            downloadFileResult.objectMetadata = objectMetadata;
            return downloadFileResult;
        } else {
            if (!hasEncryptionInfo(objectMetadata)) {
                return super.downloadFile(downloadFileRequest);
            } else {
                int partSize = downloadFileRequest.partSize;
                if (0 != (partSize % CryptoScheme.BLOCK_SIZE) || partSize <= 0) {
                    throw ArgumentError("download file part size is not 16 bytes alignment.");
                }
                OSSDownloadOperationEncrypted ossDownloadOperationEncrypted = OSSDownloadOperationEncrypted(this);
                setDownloadOperation(ossDownloadOperationEncrypted);
                return super.downloadFile(downloadFileRequest);
            }
        }
    }

     static GetObjectRequest convertToGetObjectRequest(DownloadFileRequest downloadFileRequest) {
        GetObjectRequest getObjectRequest = GetObjectRequest(downloadFileRequest.bucketName,
                downloadFileRequest.key);
        getObjectRequest.setMatchingETagConstraints(downloadFileRequest.getMatchingETagConstraints());
        getObjectRequest.setNonmatchingETagConstraints(downloadFileRequest.getNonmatchingETagConstraints());
        getObjectRequest.modifiedSinceConstraint = downloadFileRequest.modifiedSinceConstraint;
        getObjectRequest.unmodifiedSinceConstraint = downloadFileRequest.unmodifiedSinceConstraint;
        getObjectRequest.responseHeaders = downloadFileRequest.responseHeaders;

        List<int>? range = downloadFileRequest.getRange();
        if (range != null) {
            getObjectRequest.setRange(range[0], range[1]);
        }

        String? versionId = downloadFileRequest.versionId;
        if (versionId != null) {
            getObjectRequest.versionId = versionId;
        }

        Payer? payer = downloadFileRequest.payer;
        if (payer != null) {
            getObjectRequest.payer = payer;
        }

        int limit = downloadFileRequest.trafficLimit;
        if (limit > 0) {
            getObjectRequest.trafficLimit = limit;
        }

        return getObjectRequest;
    }

     InitiateMultipartUploadResult initiateMultipartUpload(InitiateMultipartUploadRequest request,
                                                                 MultipartUploadCryptoContext context)
                                                                 {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.initiateMultipartUploadSecurely(request, context);
    }

     UploadPartResult uploadPart(UploadPartRequest request, MultipartUploadCryptoContext context) {
        CryptoModule crypto = CryptoModuleDispatcher(ossDirect, encryptionMaterials, cryptoConfig);
        return crypto.uploadPartSecurely(request, context);
    }

     CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request, 
                                                                 MultipartUploadCryptoContext context) 
                                                                 {
        return super.completeMultipartUpload(request);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// Disabled api in encryption client///////////////////////////
    /// Note: This method is disabled in encryption client.
    ///  
    /// @deprecated please use encryption client method
    ///     {@link OSSEncryptionClient#initiateMultipartUpload(InitiateMultipartUploadRequest request, MultipartUploadCryptoContext context)}.             
    @override
    @Deprecated 
     InitiateMultipartUploadResult initiateMultipartUpload(InitiateMultipartUploadRequest request) {
        throw ClientException("Encryption client error, you should provide a multipart upload context to the encryption client. " + 
                 "Please use  encryption client method {@link OSSEncryptionClient#initiateMultipartUpload(InitiateMultipartUploadRequest request, " + 
                 "MultipartUploadCryptoContext context)}.");
    }

    /// Note: This method is disabled in encryption client.
    ///  
    /// @deprecated please use encryption client method
    ///     {@link OSSEncryptionClient#uploadPart(UploadPartRequest request, MultipartUploadCryptoContext context)}.             
    @override 
    @Deprecated
     UploadPartResult uploadPart(UploadPartRequest request)  {
        throw ClientException("Encryption client error, you should provide a multipart upload context to the encryption client. " + 
                "Please use  encryption client method {@link OSSEncryptionClient#uploadPart(UploadPartRequest request, MultipartUploadCryptoContext context)}.");
    }
    
    /// Note: This method is disabled in encryption client.
    ///  
    /// @deprecated please use normal oss client method
    ///     {@link OSSClient#appendObject(AppendObjectRequest appendObjectRequest)}.             
    @override
    @Deprecated
     AppendObjectResult appendObject(AppendObjectRequest appendObjectRequest)  {
        throw ClientException("Encryption client error, this method is disabled in encryption client." + 
            "Please use normal oss client method {@link OSSClient#appendObject(AppendObjectRequest appendObjectRequest)} method");
    } 
    
    /// Note: This method is disabled in encryption client.
    ///  
    /// @deprecated please use normal oss client method
    ///     {@link OSSClient#uploadPartCopy(UploadPartCopyRequest request)}.             
    @override
    @Deprecated
     UploadPartCopyResult uploadPartCopy(UploadPartCopyRequest request) {
        throw ClientException("Encryption client error, this method is disabled in encryption client." + 
                "Please use normal oss client method {@link OSSClient#uploadPartCopy(UploadPartCopyRequest request)}");
    }
    
    /// Note: This method is disabled in encryption client.
    ///  
    /// @deprecated please use normal oss client method
    ///     {@link OSSClient}#putObject(URL signedUrl, InputStream requestContent, int contentLength,
    ///           Map<String, String> requestHeaders, bool useChunkEncoding).
    @override
    @Deprecated
     PutObjectResult putObject(URL signedUrl, InputStream requestContent, int contentLength,
            Map<String, String> requestHeaders, bool useChunkEncoding) {
        throw ClientException("Encryption client error, this method is disabled in encryption client." + 
                "Please use normal oss client method {@link OSSClient#putObject(URL signedUrl, InputStream requestContent, "
                + "int contentLength, Map<String, String> requestHeaders, bool useChunkEncoding)");
    }


     

     void assertParameterNotNull(Object parameterValue,
            String errorMessage) {
        if (parameterValue == null)
            throw ArgumentError(errorMessage);
    }
}

 class OSSDirectImpl implements OSSDirect {
        @override
         ClientConfiguration getInnerClientConfiguration() {
            return OSSEncryptionClient.getClientConfiguration();
        }

        @override
         PutObjectResult putObject(PutObjectRequest putObjectRequest) {
            return OSSEncryptionClient.putObject(putObjectRequest);
        }

        @override
         OSSObject getObject(GetObjectRequest getObjectRequest) {
            return OSSEncryptionClient.getObject(getObjectRequest);
        }

        @override
         void abortMultipartUpload(AbortMultipartUploadRequest request) {
            OSSEncryptionClient.abortMultipartUpload(request);     
        }

        @override
         CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request) {
            return OSSEncryptionClient.completeMultipartUpload(request);
        }

        @override
         InitiateMultipartUploadResult initiateMultipartUpload(InitiateMultipartUploadRequest request) {
            return OSSEncryptionClient.initiateMultipartUpload(request);
        }

        @override
         UploadPartResult uploadPart(UploadPartRequest request) {
            return OSSEncryptionClient.uploadPart(request);
        }
    }