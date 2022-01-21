import 'client_configuration.dart';
import 'common/auth/credentials_provider.dart';
import 'common/comm/service_client.dart';
import 'common/comm/timeout_service_client.dart';
import 'event/progress_input_stream.dart';
import 'http_method.dart';
import 'internal/cors_operation.dart';
import 'internal/live_channel_operation.dart';
import 'internal/oss_bucket_operation.dart';
import 'internal/oss_download_operation.dart';
import 'internal/oss_multipart_operation.dart';
import 'internal/oss_object_operation.dart';
import 'internal/oss_upload_operation.dart';
import 'internal/sign_utils.dart';
import 'model/async_fetch_task_configuration.dart';
import 'model/bucket.dart';
import 'model/bucket_list.dart';
import 'model/bucket_qos_info.dart';
import 'model/create_bucket_request.dart';
import 'model/create_bucket_vpcip_request.dart';
import 'model/create_directory_request.dart';
import 'model/create_symlink_request.dart';
import 'model/create_udf_application_request.dart';
import 'model/create_udf_request.dart';
import 'model/delete_bucket_inventory_configuration_request.dart';
import 'model/delete_bucket_vpcip_request.dart';
import 'model/delete_directory_request.dart';
import 'model/delete_directory_result.dart';
import 'model/delete_vpcip_request.dart';
import 'model/generate_rtmp_uri_request.dart';
import 'model/generic_request.dart';
import 'model/generic_result.dart';
import 'model/get_async_fetch_task_request.dart';
import 'model/get_async_fetch_task_result.dart';
import 'model/get_bucket_inventory_configuration_request.dart';
import 'model/get_bucket_request_payment_result.dart';
import 'model/get_bucket_resource_group_result.dart';
import 'model/get_udf_application_log_request.dart';
import 'model/get_vod_playlist_request.dart';
import 'model/inventory_configuration.dart';
import 'model/list_bucket_inventory_configurations_request.dart';
import 'model/list_bucket_inventory_configurations_result.dart';
import 'model/list_buckets_request.dart';
import 'model/list_versions_request.dart';
import 'model/object_metadata.dart';
import 'model/oss_object.dart';
import 'model/oss_symlink.dart';
import 'model/payer.dart';
import 'model/process_object_request.dart';
import 'model/pub_object_request.dart';
import 'model/put_object_result.dart';
import 'model/rename_object_request.dart';
import 'model/resize_udf_application_request.dart';
import 'model/set_async_fetch_task_request.dart';
import 'model/set_async_fetch_task_result.dart';
import 'model/set_bucket_acl_request.dart';
import 'model/set_bucket_inventory_configuration_request.dart';
import 'model/set_bucket_qos_info_request.dart';
import 'model/set_bucket_request_payment_request.dart';
import 'model/set_bucket_resource_group_request.dart';
import 'model/transfer_acceleration.dart';
import 'model/udf_application_info.dart';
import 'model/udf_application_log.dart';
import 'model/udf_generic_request.dart';
import 'model/udf_info.dart';
import 'model/upgrade_udf_application_request.dart';
import 'model/upload_udf_image_request.dart';
import 'model/user_qos_info.dart';
import 'model/version_listing.dart';
import 'model/void_result.dart';
import 'model/vpc_policy.dart';
import 'oss.dart';

/// The entry point class of OSS that implements the OSS interface.
 class OSSClient implements OSS {

    /* The default credentials provider */
     CredentialsProvider credsProvider;

    /* The valid endpoint for accessing to OSS services */
     Uri endpoint;

    /* The default service client */
     ServiceClient serviceClient;

    /* The miscellaneous OSS operations */
     OSSBucketOperation bucketOperation;
     OSSObjectOperation objectOperation;
     OSSMultipartOperation multipartOperation;
     CORSOperation corsOperation;
     OSSUploadOperation uploadOperation;
     OSSDownloadOperation downloadOperation;
     LiveChannelOperation liveChannelOperation;

    /// Gets the inner multipartOperation, used for subclass to do implement opreation.*/
     OSSMultipartOperation getMultipartOperation() {
        return multipartOperation;
    }

    /// Gets the inner objectOperation, used for subclass to do implement opreation.*/
     OSSObjectOperation getObjectOperation() {
        return objectOperation;
    }

    /// Sets the inner downloadOperation.*/
     void setDownloadOperation(OSSDownloadOperation downloadOperation) {
        this.downloadOperation = downloadOperation;
    }

    /// Sets the inner uploadOperation.*/
     void setUploadOperation(OSSUploadOperation uploadOperation) {
        this.uploadOperation = uploadOperation;
    }

    /// Uses the specified {@link CredentialsProvider}, client configuration and
    /// OSS endpoint to create a {@link OSSClient} instance.
    /// 
    /// @param endpoint
    ///            OSS services Endpoint.
    /// @param credsProvider
    ///            Credentials provider.
    /// @param config
    ///            client configuration.
     OSSClient(String endpoint, CredentialsProvider credsProvider, ClientConfiguration config) {
        this.credsProvider = credsProvider;
        config = config == null ? ClientConfiguration() : config;
        if (config.requestTimeoutEnabled) {
            serviceClient = TimeoutServiceClient(config);
        } else {
            serviceClient = DefaultServiceClient(config);
        }
        initOperations();
        setEndpoint(endpoint);
    }

    /// Gets OSS services Endpoint.
    /// 
    /// @return OSS services Endpoint.
      Uri getEndpoint() {
        return URI.create(endpoint.toString());
    }

    /// Sets OSS services endpoint.
    /// 
    /// @param endpoint
    ///            OSS services endpoint.
      void setEndpoint(String endpoint) {
        URI uri = toURI(endpoint);
        this.endpoint = uri;

        OSSUtils.ensureEndpointValid(uri.getHost());

        if (isIpOrLocalhost(uri)) {
            serviceClient.getClientConfiguration().setSLDEnabled(true);
        }

        bucketOperation.setEndpoint(uri);
        objectOperation.setEndpoint(uri);
        multipartOperation.setEndpoint(uri);
        corsOperation.setEndpoint(uri);
        liveChannelOperation.setEndpoint(uri);
    }

    /// Checks if the uri is an IP or domain. If it's IP or local host, then it
    /// will use secondary domain of Alibaba cloud. Otherwise, it will use domain
    /// directly to access the OSS.
    /// 
    /// @param uri
    ///            URI。
     bool isIpOrLocalhost(URI uri) {
        if (uri.getHost().equals("localhost")) {
            return true;
        }

        InetAddress ia;
        try {
            ia = InetAddress.getByName(uri.getHost());
        } catch (UnknownHostException e) {
            return false;
        }

        if (uri.getHost().equals(ia.getHostAddress())) {
            return true;
        }

        return false;
    }

     URI toURI(String endpoint) throws IllegalArgumentException {
        return OSSUtils.toEndpointURI(endpoint, serviceClient.getClientConfiguration().getProtocol().toString());
    }

     void initOperations() {
        bucketOperation = OSSBucketOperation(serviceClient, credsProvider);
        objectOperation = OSSObjectOperation(serviceClient, credsProvider);
        multipartOperation = OSSMultipartOperation(serviceClient, credsProvider);
        corsOperation = CORSOperation(serviceClient, credsProvider);
        uploadOperation = OSSUploadOperation(multipartOperation);
        downloadOperation = OSSDownloadOperation(objectOperation);
        liveChannelOperation = LiveChannelOperation(serviceClient, credsProvider);
    }

    @override
     void switchCredentials(Credentials creds) {
        if (creds == null) {
            throw ArgumentError("creds should not be null.");
        }

        credsProvider.setCredentials(creds);
    }

    @override
     void switchSignatureVersion(SignVersion signatureVersion) {
        if (signatureVersion == null) {
            throw ArgumentError("signatureVersion should not be null.");
        }

        getClientConfiguration().setSignatureVersion(signatureVersion);
    }

     CredentialsProvider getCredentialsProvider() {
        return credsProvider;
    }

     ClientConfiguration getClientConfiguration() {
        return serviceClient.getClientConfiguration();
    }

    @override
     Bucket createBucket(String bucketName)  {
        return createBucket(CreateBucketRequest(bucketName));
    }

    @override
     Bucket createBucket(CreateBucketRequest createBucketRequest)  {
        return bucketOperation.createBucket(createBucketRequest);
    }

    @override
     VoidResult deleteBucket(String bucketName)  {
        return deleteBucket(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucket(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucket(genericRequest);
    }

    @override
     List<Bucket> listBuckets()  {
        return bucketOperation.listBuckets();
    }

    @override
     BucketList listBuckets(ListBucketsRequest listBucketsRequest)  {
        return bucketOperation.listBuckets(listBucketsRequest);
    }

    @override
     BucketList listBuckets(String prefix, String marker, int maxKeys)  {
        return bucketOperation.listBuckets(ListBucketsRequest(prefix, marker, maxKeys));
    }

    @override
     VoidResult setBucketAcl(String bucketName, CannedAccessControlList cannedACL)
             {
        return setBucketAcl(SetBucketAclRequest(bucketName, cannedACL));
    }

    @override
     VoidResult setBucketAcl(SetBucketAclRequest setBucketAclRequest)  {
        return bucketOperation.setBucketAcl(setBucketAclRequest);
    }

    @override
     AccessControlList getBucketAcl(String bucketName)  {
        return getBucketAcl(GenericRequest(bucketName: bucketName));
    }

    @override
     AccessControlList getBucketAcl(GenericRequest genericRequest)  {
        return bucketOperation.getBucketAcl(genericRequest);
    }

    @override
     BucketMetadata getBucketMetadata(String bucketName)  {
        return getBucketMetadata(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketMetadata getBucketMetadata(GenericRequest genericRequest)  {
        return bucketOperation.getBucketMetadata(genericRequest);
    }

    @override
     VoidResult setBucketReferer(String bucketName, BucketReferer referer)  {
        return setBucketReferer(SetBucketRefererRequest(bucketName, referer));
    }

    @override
     VoidResult setBucketReferer(SetBucketRefererRequest setBucketRefererRequest)  {
        return bucketOperation.setBucketReferer(setBucketRefererRequest);
    }

    @override
     BucketReferer getBucketReferer(String bucketName)  {
        return getBucketReferer(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketReferer getBucketReferer(GenericRequest genericRequest)  {
        return bucketOperation.getBucketReferer(genericRequest);
    }

    @override
     String getBucketLocation(String bucketName)  {
        return getBucketLocation(GenericRequest(bucketName: bucketName));
    }

    @override
     String getBucketLocation(GenericRequest genericRequest)  {
        return bucketOperation.getBucketLocation(genericRequest);
    }

    @override
     bool doesBucketExist(String bucketName)  {
        return doesBucketExist(GenericRequest(bucketName: bucketName));
    }

    @override
     bool doesBucketExist(GenericRequest genericRequest)  {
        return bucketOperation.doesBucketExists(genericRequest);
    }

    /// Deprecated. Please use {@link OSSClient#doesBucketExist(String)} instead.
    @Deprecated
     bool isBucketExist(String bucketName)  {
        return doesBucketExist(bucketName);
    }

    @override
     ObjectListing listObjects(String bucketName)  {
        return listObjects(ListObjectsRequest(bucketName, null, null, null, null));
    }

    @override
     ObjectListing listObjects(String bucketName, String prefix)  {
        return listObjects(ListObjectsRequest(bucketName, prefix, null, null, null));
    }

    @override
     ObjectListing listObjects(ListObjectsRequest listObjectsRequest)  {
        return bucketOperation.listObjects(listObjectsRequest);
    }

    @override
     ListObjectsV2Result listObjectsV2(ListObjectsV2Request listObjectsV2Request)  {
        return bucketOperation.listObjectsV2(listObjectsV2Request);
    }

    @override
     ListObjectsV2Result listObjectsV2(String bucketName)  {
        return bucketOperation.listObjectsV2(ListObjectsV2Request(bucketName));
    }

    @override
     ListObjectsV2Result listObjectsV2(String bucketName, String prefix)  {
        return bucketOperation.listObjectsV2(ListObjectsV2Request(bucketName, prefix));
    }

    @override
     ListObjectsV2Result listObjectsV2(String bucketName, String prefix, String continuationToken,
                                String startAfter, String delimiter, Integer maxKeys,
                                String encodingType, bool fetchOwner)  {
        return bucketOperation.listObjectsV2(ListObjectsV2Request(bucketName, prefix, continuationToken, startAfter,
                delimiter, maxKeys, encodingType, fetchOwner));
    }

    @override
	 VersionListing listVersions(String bucketName, String prefix)  {
        return listVersions(ListVersionsRequest(bucketName, prefix, null, null, null, null));
	}

    @override
     VersionListing listVersions(String bucketName, String prefix, String keyMarker, String versionIdMarker,
        String delimiter, Integer maxResults)  {
        ListVersionsRequest request = ListVersionsRequest()
            .withBucketName(bucketName)
            .withPrefix(prefix)
            .withDelimiter(delimiter)
            .withKeyMarker(keyMarker)
            .withVersionIdMarker(versionIdMarker)
            .withMaxResults(maxResults);
        return listVersions(request);
    }

    @override
     VersionListing listVersions(ListVersionsRequest listVersionsRequest)  {
        return bucketOperation.listVersions(listVersionsRequest);
    }

    @override
     PutObjectResult putObject(String bucketName, String key, InputStream input)
             {
        return putObject(bucketName, key, input, null);
    }

    @override
     PutObjectResult putObject(String bucketName, String key, InputStream input, ObjectMetadata metadata)
             {
        return putObject(PutObjectRequest(bucketName, key, input, metadata));
    }

    @override
     PutObjectResult putObject(String bucketName, String key, File file, ObjectMetadata metadata)
             {
        return putObject(PutObjectRequest(bucketName, key, file, metadata));
    }

    @override
     PutObjectResult putObject(String bucketName, String key, File file)  {
        return putObject(bucketName, key, file, null);
    }

    @override
     PutObjectResult putObject(PutObjectRequest putObjectRequest)  {
        return objectOperation.putObject(putObjectRequest);
    }

    @override
     PutObjectResult putObject(URL signedUrl, String filePath, Map<String, String> requestHeaders)
             {
        return putObject(signedUrl, filePath, requestHeaders, false);
    }

    @override
     PutObjectResult putObject(URL signedUrl, String filePath, Map<String, String> requestHeaders,
            bool useChunkEncoding)  {

        FileInputStream requestContent = null;
        try {
            File toUpload = File(filePath);
            if (!checkFile(toUpload)) {
                throw ArgumentError("Illegal file path: " + filePath);
            }
            long fileSize = toUpload.length();
            requestContent = FileInputStream(toUpload);

            return putObject(signedUrl, requestContent, fileSize, requestHeaders, useChunkEncoding);
        } catch (FileNotFoundException e) {
            throw ClientException(e);
        } finally {
            if (requestContent != null) {
                try {
                    requestContent.close();
                } catch (IOException e) {
                }
            }
        }
    }

    @override
     PutObjectResult putObject(URL signedUrl, InputStream requestContent, long contentLength,
            Map<String, String> requestHeaders)  {
        return putObject(signedUrl, requestContent, contentLength, requestHeaders, false);
    }

    @override
     PutObjectResult putObject(URL signedUrl, InputStream requestContent, long contentLength,
            Map<String, String> requestHeaders, bool useChunkEncoding)  {
        return objectOperation.putObject(signedUrl, requestContent, contentLength, requestHeaders, useChunkEncoding);
    }

    @override
     CopyObjectResult copyObject(String sourceBucketName, String sourceKey, String destinationBucketName,
            String destinationKey)  {
        return copyObject(CopyObjectRequest(sourceBucketName, sourceKey, destinationBucketName, destinationKey));
    }

    @override
     CopyObjectResult copyObject(CopyObjectRequest copyObjectRequest)  {
        return objectOperation.copyObject(copyObjectRequest);
    }

    @override
     OSSObject getObject(String bucketName, String key)  {
        return getObject(GetObjectRequest(bucketName, key));
    }

    @override
     ObjectMetadata getObject(GetObjectRequest getObjectRequest, File file)  {
        return objectOperation.getObject(getObjectRequest, file);
    }

    @override
     OSSObject getObject(GetObjectRequest getObjectRequest)  {
        return objectOperation.getObject(getObjectRequest);
    }

    @override
     OSSObject getObject(URL signedUrl, Map<String, String> requestHeaders)  {
        GetObjectRequest getObjectRequest = GetObjectRequest(signedUrl, requestHeaders);
        return objectOperation.getObject(getObjectRequest);
    }

    @override
     OSSObject selectObject(SelectObjectRequest selectObjectRequest)  {
        return objectOperation.selectObject(selectObjectRequest);
    }

    @override
     SimplifiedObjectMeta getSimplifiedObjectMeta(String bucketName, String key)
             {
        return getSimplifiedObjectMeta(GenericRequest(bucketName, key));
    }

    @override
     SimplifiedObjectMeta getSimplifiedObjectMeta(GenericRequest genericRequest)
             {
        return objectOperation.getSimplifiedObjectMeta(genericRequest);
    }

    @override
     ObjectMetadata getObjectMetadata(String bucketName, String key)  {
        return getObjectMetadata(GenericRequest(bucketName, key));
    }

    @override
     SelectObjectMetadata createSelectObjectMetadata(CreateSelectObjectMetadataRequest createSelectObjectMetadataRequest)  {
        return objectOperation.createSelectObjectMetadata(createSelectObjectMetadataRequest);
    }
    
    @override
     ObjectMetadata getObjectMetadata(GenericRequest genericRequest)  {
        return objectOperation.getObjectMetadata(genericRequest);
    }

    @override
     ObjectMetadata headObject(String bucketName, String key)  {
        return headObject(HeadObjectRequest(bucketName, key));
    }

    @override
     ObjectMetadata headObject(HeadObjectRequest headObjectRequest)  {
        return objectOperation.headObject(headObjectRequest);
    }

    @override
     AppendObjectResult appendObject(AppendObjectRequest appendObjectRequest)
             {
        return objectOperation.appendObject(appendObjectRequest);
    }

    @override
     VoidResult deleteObject(String bucketName, String key)  {
        return deleteObject(GenericRequest(bucketName, key));
    }

    @override
     VoidResult deleteObject(GenericRequest genericRequest)  {
        return objectOperation.deleteObject(genericRequest);
    }
    
    @override
     VoidResult deleteVersion(String bucketName, String key, String versionId)  {
        return deleteVersion(DeleteVersionRequest(bucketName, key, versionId));
    }

    @override
     VoidResult deleteVersion(DeleteVersionRequest deleteVersionRequest)  {
        return objectOperation.deleteVersion(deleteVersionRequest);
    }

    @override
     DeleteObjectsResult deleteObjects(DeleteObjectsRequest deleteObjectsRequest)
             {
        return objectOperation.deleteObjects(deleteObjectsRequest);
    }
    
    @override
     DeleteVersionsResult deleteVersions(DeleteVersionsRequest deleteVersionsRequest)
         {
        return objectOperation.deleteVersions(deleteVersionsRequest);
    }

    @override
     bool doesObjectExist(String bucketName, String key)  {
        return doesObjectExist(GenericRequest(bucketName, key));
    }

    @override
     bool doesObjectExist(String bucketName, String key, bool isOnlyInOSS) {
        if (isOnlyInOSS) {
            return doesObjectExist(bucketName, key);
        } else {
            return objectOperation.doesObjectExistWithRedirect(GenericRequest(bucketName, key));
        }
    }

    @Deprecated
    @override
     bool doesObjectExist(HeadObjectRequest headObjectRequest)  {
        return doesObjectExist(GenericRequest(headObjectRequest.getBucketName(), headObjectRequest.getKey()));
    }

    @override
     bool doesObjectExist(GenericRequest genericRequest)  {
        return objectOperation.doesObjectExist(genericRequest);
    }

    @override
     bool doesObjectExist(GenericRequest genericRequest, bool isOnlyInOSS)  {
    	if (isOnlyInOSS) {
    	    return objectOperation.doesObjectExist(genericRequest);	
    	} else {
    	    return objectOperation.doesObjectExistWithRedirect(genericRequest);
    	}
    }

    @override
     VoidResult setObjectAcl(String bucketName, String key, CannedAccessControlList cannedACL)
             {
        return setObjectAcl(SetObjectAclRequest(bucketName, key, cannedACL));
    }

    @override
     VoidResult setObjectAcl(SetObjectAclRequest setObjectAclRequest)  {
        return objectOperation.setObjectAcl(setObjectAclRequest);
    }

    @override
     ObjectAcl getObjectAcl(String bucketName, String key)  {
        return getObjectAcl(GenericRequest(bucketName, key));
    }

    @override
     ObjectAcl getObjectAcl(GenericRequest genericRequest)  {
        return objectOperation.getObjectAcl(genericRequest);
    }

    @override
     RestoreObjectResult restoreObject(String bucketName, String key)  {
        return restoreObject(GenericRequest(bucketName, key));
    }

    @override
     RestoreObjectResult restoreObject(GenericRequest genericRequest)  {
        return objectOperation.restoreObject(genericRequest);
    }
    
    @override
     RestoreObjectResult restoreObject(String bucketName, String key, RestoreConfiguration restoreConfiguration)
             {
        return restoreObject(RestoreObjectRequest(bucketName, key, restoreConfiguration));
    }

    @override
     RestoreObjectResult restoreObject(RestoreObjectRequest restoreObjectRequest)
             {
        return objectOperation.restoreObject(restoreObjectRequest);
    }

    @override
     VoidResult setObjectTagging(String bucketName, String key, Map<String, String> tags)
         {
        return setObjectTagging(SetObjectTaggingRequest(bucketName, key, tags));
    }

    @override
     VoidResult setObjectTagging(String bucketName, String key, TagSet tagSet)  {
        return setObjectTagging(SetObjectTaggingRequest(bucketName, key, tagSet));
    }

    @override
     VoidResult setObjectTagging(SetObjectTaggingRequest setObjectTaggingRequest)  {
        return objectOperation.setObjectTagging(setObjectTaggingRequest);
    }

    @override
     TagSet getObjectTagging(String bucketName, String key)  {
        return getObjectTagging(GenericRequest(bucketName, key));
    }

    @override
     TagSet getObjectTagging(GenericRequest genericRequest)  {
        return objectOperation.getObjectTagging(genericRequest);
    }

    @override
     VoidResult deleteObjectTagging(String bucketName, String key)  {
        return deleteObjectTagging(GenericRequest(bucketName, key));
    }

    @override
     VoidResult deleteObjectTagging(GenericRequest genericRequest)  {
        return objectOperation.deleteObjectTagging(genericRequest);
    }

    @override
     URL generatePresignedUrl(String bucketName, String key, DateTime expiration)  {
        return generatePresignedUrl(bucketName, key, expiration, HttpMethod.get);
    }

    @override
     URL generatePresignedUrl(String bucketName, String key, Date expiration, HttpMethod method)
             {
        GeneratePresignedUrlRequest request = GeneratePresignedUrlRequest(bucketName, key);
        request.setExpiration(expiration);
        request.setMethod(method);

        return generatePresignedUrl(request);
    }

    @override
     URL generatePresignedUrl(GeneratePresignedUrlRequest request)  {

        assertParameterNotNull(request, "request");

        if (request.getBucketName() == null) {
            throw ArgumentError(OSS_RESOURCE_MANAGER.getString("MustSetBucketName"));
        }
        ensureBucketNameValid(request.getBucketName());

        if (request.getExpiration() == null) {
            throw ArgumentError(OSS_RESOURCE_MANAGER.getString("MustSetExpiration"));
        }
        String url;

        if (serviceClient.getClientConfiguration().getSignatureVersion() != null && serviceClient.getClientConfiguration().getSignatureVersion() == SignVersion.V2) {
            url = SignV2Utils.buildSignedURL(request, credsProvider.getCredentials(), serviceClient.getClientConfiguration(), endpoint);
        } else {
            url = SignUtils.buildSignedURL(request, credsProvider.getCredentials(), serviceClient.getClientConfiguration(), endpoint);
        }

        try {
            return URL(url);
        } catch (MalformedURLException e) {
            throw ClientException(e);
        }
    }

    @override
     VoidResult abortMultipartUpload(AbortMultipartUploadRequest request)  {
        return multipartOperation.abortMultipartUpload(request);
    }

    @override
     CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request)
             {
        return multipartOperation.completeMultipartUpload(request);
    }

    @override
     InitiateMultipartUploadResult initiateMultipartUpload(InitiateMultipartUploadRequest request)
             {
        return multipartOperation.initiateMultipartUpload(request);
    }

    @override
     MultipartUploadListing listMultipartUploads(ListMultipartUploadsRequest request)
             {
        return multipartOperation.listMultipartUploads(request);
    }

    @override
     PartListing listParts(ListPartsRequest request)  {
        return multipartOperation.listParts(request);
    }

    @override
     UploadPartResult uploadPart(UploadPartRequest request)  {
        return multipartOperation.uploadPart(request);
    }

    @override
     UploadPartCopyResult uploadPartCopy(UploadPartCopyRequest request)  {
        return multipartOperation.uploadPartCopy(request);
    }

    @override
     VoidResult setBucketCORS(SetBucketCORSRequest request)  {
        return corsOperation.setBucketCORS(request);
    }

    @override
     List<CORSRule> getBucketCORSRules(String bucketName)  {
        return getBucketCORSRules(GenericRequest(bucketName: bucketName));
    }

    @override
     List<CORSRule> getBucketCORSRules(GenericRequest genericRequest)  {
        return getBucketCORS(genericRequest).getCorsRules();
    }

    @override
     CORSConfiguration getBucketCORS(GenericRequest genericRequest)  {
        return corsOperation.getBucketCORS(genericRequest);
    }

    @override
     VoidResult deleteBucketCORSRules(String bucketName)  {
        return deleteBucketCORSRules(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketCORSRules(GenericRequest genericRequest)  {
        return corsOperation.deleteBucketCORS(genericRequest);
    }

    @override
     ResponseMessage optionsObject(OptionsRequest request)  {
        return corsOperation.optionsObject(request);
    }

    @override
     VoidResult setBucketLogging(SetBucketLoggingRequest request)  {
        return bucketOperation.setBucketLogging(request);
    }

    @override
     BucketLoggingResult getBucketLogging(String bucketName)  {
        return getBucketLogging(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketLoggingResult getBucketLogging(GenericRequest genericRequest)  {
        return bucketOperation.getBucketLogging(genericRequest);
    }

    @override
     VoidResult deleteBucketLogging(String bucketName)  {
        return deleteBucketLogging(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketLogging(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketLogging(genericRequest);
    }

    @override
     VoidResult putBucketImage(PutBucketImageRequest request)  {
        return bucketOperation.putBucketImage(request);
    }

    @override
     GetBucketImageResult getBucketImage(String bucketName)  {
        return bucketOperation.getBucketImage(bucketName, GenericRequest());
    }

    @override
     GetBucketImageResult getBucketImage(String bucketName, GenericRequest genericRequest)
             {
        return bucketOperation.getBucketImage(bucketName, genericRequest);
    }

    @override
     VoidResult deleteBucketImage(String bucketName)  {
        return bucketOperation.deleteBucketImage(bucketName, GenericRequest());
    }

    @override
     VoidResult deleteBucketImage(String bucketName, GenericRequest genericRequest)
             {
        return bucketOperation.deleteBucketImage(bucketName, genericRequest);
    }

    @override
     VoidResult putImageStyle(PutImageStyleRequest putImageStyleRequest)  {
        return bucketOperation.putImageStyle(putImageStyleRequest);
    }

    @override
     VoidResult deleteImageStyle(String bucketName, String styleName)  {
        return bucketOperation.deleteImageStyle(bucketName, styleName, GenericRequest());
    }

    @override
     VoidResult deleteImageStyle(String bucketName, String styleName, GenericRequest genericRequest)
             {
        return bucketOperation.deleteImageStyle(bucketName, styleName, genericRequest);
    }

    @override
     GetImageStyleResult getImageStyle(String bucketName, String styleName)  {
        return bucketOperation.getImageStyle(bucketName, styleName, GenericRequest());
    }

    @override
     GetImageStyleResult getImageStyle(String bucketName, String styleName, GenericRequest genericRequest)
             {
        return bucketOperation.getImageStyle(bucketName, styleName, genericRequest);
    }

    @override
     List<Style> listImageStyle(String bucketName)  {
        return bucketOperation.listImageStyle(bucketName, GenericRequest());
    }

    @override
     List<Style> listImageStyle(String bucketName, GenericRequest genericRequest)
             {
        return bucketOperation.listImageStyle(bucketName, genericRequest);
    }

    @override
     VoidResult setBucketProcess(SetBucketProcessRequest setBucketProcessRequest)  {
        return bucketOperation.setBucketProcess(setBucketProcessRequest);
    }

    @override
     BucketProcess getBucketProcess(String bucketName)  {
        return getBucketProcess(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketProcess getBucketProcess(GenericRequest genericRequest)  {
        return bucketOperation.getBucketProcess(genericRequest);
    }

    @override
     VoidResult setBucketWebsite(SetBucketWebsiteRequest setBucketWebSiteRequest)  {
        return bucketOperation.setBucketWebsite(setBucketWebSiteRequest);
    }

    @override
     BucketWebsiteResult getBucketWebsite(String bucketName)  {
        return getBucketWebsite(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketWebsiteResult getBucketWebsite(GenericRequest genericRequest)  {
        return bucketOperation.getBucketWebsite(genericRequest);
    }

    @override
     VoidResult deleteBucketWebsite(String bucketName)  {
        return deleteBucketWebsite(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketWebsite(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketWebsite(genericRequest);
    }
    
    @override
     BucketVersioningConfiguration getBucketVersioning(String bucketName)  {
        return getBucketVersioning(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketVersioningConfiguration getBucketVersioning(GenericRequest genericRequest)
         {
        return bucketOperation.getBucketVersioning(genericRequest);
    }

    @override
     VoidResult setBucketVersioning(SetBucketVersioningRequest setBucketVersioningRequest)
         {
        return bucketOperation.setBucketVersioning(setBucketVersioningRequest);
    }

    @override
     String generatePostPolicy(Date expiration, PolicyConditions conds) {
        String formatedExpiration = DateUtil.formatIso8601Date(expiration);
        String jsonizedExpiration = String.format("\"expiration\":\"%s\"", formatedExpiration);
        String jsonizedConds = conds.jsonize();

        StringBuilder postPolicy = StringBuilder();
        postPolicy.append(String.format("{%s,%s}", jsonizedExpiration, jsonizedConds));

        return postPolicy.toString();
    }

    @override
     String calculatePostSignature(String postPolicy)  {
        try {
            byte[] binaryData = postPolicy.getBytes(DEFAULT_CHARSET_NAME);
            String encPolicy = BinaryUtil.toBase64String(binaryData);
            return ServiceSignature.create().computeSignature(credsProvider.getCredentials().getSecretAccessKey(),
                    encPolicy);
        } catch (UnsupportedEncodingException ex) {
            throw ClientException("Unsupported charset: " + ex.getMessage());
        }
    }

    @override
     VoidResult setBucketLifecycle(SetBucketLifecycleRequest setBucketLifecycleRequest)
             {
        return bucketOperation.setBucketLifecycle(setBucketLifecycleRequest);
    }

    @override
     List<LifecycleRule> getBucketLifecycle(String bucketName)  {
        return getBucketLifecycle(GenericRequest(bucketName: bucketName));
    }

    @override
     List<LifecycleRule> getBucketLifecycle(GenericRequest genericRequest)  {
        return bucketOperation.getBucketLifecycle(genericRequest);
    }

    @override
     VoidResult deleteBucketLifecycle(String bucketName)  {
        return deleteBucketLifecycle(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketLifecycle(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketLifecycle(genericRequest);
    }

    @override
     VoidResult setBucketTagging(String bucketName, Map<String, String> tags)  {
        return setBucketTagging(SetBucketTaggingRequest(bucketName, tags));
    }

    @override
     VoidResult setBucketTagging(String bucketName, TagSet tagSet)  {
        return setBucketTagging(SetBucketTaggingRequest(bucketName, tagSet));
    }

    @override
     VoidResult setBucketTagging(SetBucketTaggingRequest setBucketTaggingRequest)  {
        return bucketOperation.setBucketTagging(setBucketTaggingRequest);
    }

    @override
     TagSet getBucketTagging(String bucketName)  {
        return getBucketTagging(GenericRequest(bucketName: bucketName));
    }

    @override
     TagSet getBucketTagging(GenericRequest genericRequest)  {
        return bucketOperation.getBucketTagging(genericRequest);
    }

    @override
     VoidResult deleteBucketTagging(String bucketName)  {
        return deleteBucketTagging(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketTagging(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketTagging(genericRequest);
    }

    @override
     VoidResult addBucketReplication(AddBucketReplicationRequest addBucketReplicationRequest)
             {
        return bucketOperation.addBucketReplication(addBucketReplicationRequest);
    }

    @override
     List<ReplicationRule> getBucketReplication(String bucketName)  {
        return getBucketReplication(GenericRequest(bucketName: bucketName));
    }

    @override
     List<ReplicationRule> getBucketReplication(GenericRequest genericRequest)
             {
        return bucketOperation.getBucketReplication(genericRequest);
    }

    @override
     VoidResult deleteBucketReplication(String bucketName, String replicationRuleID)
             {
        return deleteBucketReplication(DeleteBucketReplicationRequest(bucketName, replicationRuleID));
    }

    @override
     VoidResult deleteBucketReplication(DeleteBucketReplicationRequest deleteBucketReplicationRequest)
             {
        return bucketOperation.deleteBucketReplication(deleteBucketReplicationRequest);
    }

    @override
     BucketReplicationProgress getBucketReplicationProgress(String bucketName, String replicationRuleID)
             {
        return getBucketReplicationProgress(GetBucketReplicationProgressRequest(bucketName, replicationRuleID));
    }

    @override
     BucketReplicationProgress getBucketReplicationProgress(
            GetBucketReplicationProgressRequest getBucketReplicationProgressRequest)
             {
        return bucketOperation.getBucketReplicationProgress(getBucketReplicationProgressRequest);
    }

    @override
     List<String> getBucketReplicationLocation(String bucketName)  {
        return getBucketReplicationLocation(GenericRequest(bucketName: bucketName));
    }

    @override
     List<String> getBucketReplicationLocation(GenericRequest genericRequest)
             {
        return bucketOperation.getBucketReplicationLocation(genericRequest);
    }

    @override
     AddBucketCnameResult addBucketCname(AddBucketCnameRequest addBucketCnameRequest)  {
        return bucketOperation.addBucketCname(addBucketCnameRequest);
    }

    @override
     List<CnameConfiguration> getBucketCname(String bucketName)  {
        return getBucketCname(GenericRequest(bucketName: bucketName));
    }

    @override
     List<CnameConfiguration> getBucketCname(GenericRequest genericRequest)  {
        return bucketOperation.getBucketCname(genericRequest);
    }

    @override
     VoidResult deleteBucketCname(String bucketName, String domain)  {
        return deleteBucketCname(DeleteBucketCnameRequest(bucketName, domain));
    }

    @override
     VoidResult deleteBucketCname(DeleteBucketCnameRequest deleteBucketCnameRequest)
             {
        return bucketOperation.deleteBucketCname(deleteBucketCnameRequest);
    }

    @override
     BucketInfo getBucketInfo(String bucketName)  {
        return getBucketInfo(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketInfo getBucketInfo(GenericRequest genericRequest)  {
        return bucketOperation.getBucketInfo(genericRequest);
    }

    @override
     BucketStat getBucketStat(String bucketName)  {
        return getBucketStat(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketStat getBucketStat(GenericRequest genericRequest)  {
        return bucketOperation.getBucketStat(genericRequest);
    }

    @override
     VoidResult setBucketStorageCapacity(String bucketName, UserQos userQos)  {
        return setBucketStorageCapacity(SetBucketStorageCapacityRequest(bucketName).withUserQos(userQos));
    }

    @override
     VoidResult setBucketStorageCapacity(SetBucketStorageCapacityRequest setBucketStorageCapacityRequest)
             {
        return bucketOperation.setBucketStorageCapacity(setBucketStorageCapacityRequest);
    }

    @override
     UserQos getBucketStorageCapacity(String bucketName)  {
        return getBucketStorageCapacity(GenericRequest(bucketName: bucketName));
    }

    @override
     UserQos getBucketStorageCapacity(GenericRequest genericRequest)  {
        return bucketOperation.getBucketStorageCapacity(genericRequest);
    }

    @override
     VoidResult setBucketEncryption(SetBucketEncryptionRequest setBucketEncryptionRequest)
         {
        return bucketOperation.setBucketEncryption(setBucketEncryptionRequest);
    }

    @override
     ServerSideEncryptionConfiguration getBucketEncryption(String bucketName)
         {
        return getBucketEncryption(GenericRequest(bucketName: bucketName));
    }

    @override
     ServerSideEncryptionConfiguration getBucketEncryption(GenericRequest genericRequest)
         {
        return bucketOperation.getBucketEncryption(genericRequest);
    }

    @override
     VoidResult deleteBucketEncryption(String bucketName)  {
        return deleteBucketEncryption(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketEncryption(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketEncryption(genericRequest);
    }

    @override
     VoidResult setBucketPolicy(String bucketName,  String policyText)  {
        return setBucketPolicy(SetBucketPolicyRequest(bucketName, policyText));
    }

    @override
     VoidResult setBucketPolicy(SetBucketPolicyRequest setBucketPolicyRequest)  {
        return bucketOperation.setBucketPolicy(setBucketPolicyRequest);
    }

    @override
     GetBucketPolicyResult getBucketPolicy(GenericRequest genericRequest)  {
        return bucketOperation.getBucketPolicy(genericRequest);
    }

    @override
     GetBucketPolicyResult getBucketPolicy(String bucketName)  {
        return getBucketPolicy(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketPolicy(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketPolicy(genericRequest);
    }

    @override
     VoidResult deleteBucketPolicy(String bucketName)  {
        return deleteBucketPolicy(GenericRequest(bucketName: bucketName));
    }

    @override
     UploadFileResult uploadFile(UploadFileRequest uploadFileRequest) throws Throwable {
        return uploadOperation.uploadFile(uploadFileRequest);
    }

    @override
     DownloadFileResult downloadFile(DownloadFileRequest downloadFileRequest) throws Throwable {
        return downloadOperation.downloadFile(downloadFileRequest);
    }

    @override
     CreateLiveChannelResult createLiveChannel(CreateLiveChannelRequest createLiveChannelRequest)
             {
        return liveChannelOperation.createLiveChannel(createLiveChannelRequest);
    }

    @override
     VoidResult setLiveChannelStatus(String bucketName, String liveChannel, LiveChannelStatus status)
             {
        return setLiveChannelStatus(SetLiveChannelRequest(bucketName, liveChannel, status));
    }

    @override
     VoidResult setLiveChannelStatus(SetLiveChannelRequest setLiveChannelRequest)  {
        return liveChannelOperation.setLiveChannelStatus(setLiveChannelRequest);
    }

    @override
     LiveChannelInfo getLiveChannelInfo(String bucketName, String liveChannel)
             {
        return getLiveChannelInfo(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     LiveChannelInfo getLiveChannelInfo(LiveChannelGenericRequest liveChannelGenericRequest)
             {
        return liveChannelOperation.getLiveChannelInfo(liveChannelGenericRequest);
    }

    @override
     LiveChannelStat getLiveChannelStat(String bucketName, String liveChannel)
             {
        return getLiveChannelStat(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     LiveChannelStat getLiveChannelStat(LiveChannelGenericRequest liveChannelGenericRequest)
             {
        return liveChannelOperation.getLiveChannelStat(liveChannelGenericRequest);
    }

    @override
     VoidResult deleteLiveChannel(String bucketName, String liveChannel)  {
        return deleteLiveChannel(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     VoidResult deleteLiveChannel(LiveChannelGenericRequest liveChannelGenericRequest)
             {
        return liveChannelOperation.deleteLiveChannel(liveChannelGenericRequest);
    }

    @override
     List<LiveChannel> listLiveChannels(String bucketName)  {
        return liveChannelOperation.listLiveChannels(bucketName);
    }

    @override
     LiveChannelListing listLiveChannels(ListLiveChannelsRequest listLiveChannelRequest)
             {
        return liveChannelOperation.listLiveChannels(listLiveChannelRequest);
    }

    @override
     List<LiveRecord> getLiveChannelHistory(String bucketName, String liveChannel)
             {
        return getLiveChannelHistory(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     List<LiveRecord> getLiveChannelHistory(LiveChannelGenericRequest liveChannelGenericRequest)
             {
        return liveChannelOperation.getLiveChannelHistory(liveChannelGenericRequest);
    }

    @override
     VoidResult generateVodPlaylist(String bucketName, String liveChannelName, String PlaylistName, long startTime,
            long endTime)  {
        return generateVodPlaylist(
                GenerateVodPlaylistRequest(bucketName, liveChannelName, PlaylistName, startTime, endTime));
    }

    @override
     VoidResult generateVodPlaylist(GenerateVodPlaylistRequest generateVodPlaylistRequest)
             {
        return liveChannelOperation.generateVodPlaylist(generateVodPlaylistRequest);
    }

    @override
     OSSObject getVodPlaylist(String bucketName, String liveChannelName, int startTime,
                                    int endTime)  {
        return getVodPlaylist(
                GetVodPlaylistRequest(bucketName, liveChannelName, startTime, endTime));
    }

    @override
     OSSObject getVodPlaylist(GetVodPlaylistRequest getVodPlaylistRequest)
             {
        return liveChannelOperation.getVodPlaylist(getVodPlaylistRequest);
    }

    @override
     String generateRtmpUri(String bucketName, String liveChannelName, String PlaylistName, long expires)
             {
        return generateRtmpUri(GenerateRtmpUriRequest(bucketName, liveChannelName, PlaylistName, expires));
    }

    @override
     String generateRtmpUri(GenerateRtmpUriRequest generateRtmpUriRequest)  {
        return liveChannelOperation.generateRtmpUri(generateRtmpUriRequest);
    }

    @override
     VoidResult createSymlink(String bucketName, String symLink, String targetObject)
             {
        return createSymlink(CreateSymlinkRequest(bucketName, symLink, targetObject));
    }

    @override
     VoidResult createSymlink(CreateSymlinkRequest createSymlinkRequest)  {
        return objectOperation.createSymlink(createSymlinkRequest);
    }

    @override
     OSSSymlink getSymlink(String bucketName, String symLink)  {
        return getSymlink(GenericRequest(bucketName, symLink));
    }

    @override
     OSSSymlink getSymlink(GenericRequest genericRequest)  {
        return objectOperation.getSymlink(genericRequest);
    }

    @override
     GenericResult processObject(ProcessObjectRequest processObjectRequest)  {
        return objectOperation.processObject(processObjectRequest);
    }

    @override
     VoidResult setBucketRequestPayment(String bucketName, Payer payer)  {
        return setBucketRequestPayment(SetBucketRequestPaymentRequest(bucketName, payer));
    }

    @override
     VoidResult setBucketRequestPayment(SetBucketRequestPaymentRequest setBucketRequestPaymentRequest)  {
        return bucketOperation.setBucketRequestPayment(setBucketRequestPaymentRequest);
    }

    @override
     GetBucketRequestPaymentResult getBucketRequestPayment(String bucketName)  {
        return getBucketRequestPayment(GenericRequest(bucketName: bucketName));
    }

    @override
     GetBucketRequestPaymentResult getBucketRequestPayment(GenericRequest genericRequest)  {
        return bucketOperation.getBucketRequestPayment(genericRequest);
    }

    @override
     VoidResult setBucketQosInfo(String bucketName, BucketQosInfo bucketQosInfo)  {
        return setBucketQosInfo(SetBucketQosInfoRequest(bucketName, bucketQosInfo));
    }

    @override
     VoidResult setBucketQosInfo(SetBucketQosInfoRequest setBucketQosInfoRequest)  {
        return bucketOperation.setBucketQosInfo(setBucketQosInfoRequest);
    }

    @override
     BucketQosInfo getBucketQosInfo(String bucketName)  {
        return getBucketQosInfo(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketQosInfo getBucketQosInfo(GenericRequest genericRequest)  {
        return bucketOperation.getBucketQosInfo(genericRequest);
    }

    @override
     VoidResult deleteBucketQosInfo(String bucketName)  {
        return deleteBucketQosInfo(GenericRequest(bucketName: bucketName));
    }
 
    @override
     VoidResult deleteBucketQosInfo(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketQosInfo(genericRequest);
    }

    @override
     UserQosInfo getUserQosInfo()  {
        return bucketOperation.getUserQosInfo();
    }

    @override
     SetAsyncFetchTaskResult setAsyncFetchTask(String bucketName,
        AsyncFetchTaskConfiguration asyncFetchTaskConfiguration)  {
        return setAsyncFetchTask(SetAsyncFetchTaskRequest(bucketName,asyncFetchTaskConfiguration));
    }

    @override
     SetAsyncFetchTaskResult setAsyncFetchTask(SetAsyncFetchTaskRequest setAsyncFetchTaskRequest)
             {
        return bucketOperation.setAsyncFetchTask(setAsyncFetchTaskRequest);
    }

    @override
     GetAsyncFetchTaskResult getAsyncFetchTask(String bucketName, String taskId)
             {
        return getAsyncFetchTask(GetAsyncFetchTaskRequest(bucketName, taskId));
    }

    @override
     GetAsyncFetchTaskResult getAsyncFetchTask(GetAsyncFetchTaskRequest getAsyncFetchTaskRequest)
             {
        return bucketOperation.getAsyncFetchTask(getAsyncFetchTaskRequest);
    }

    @override
     CreateVpcipResult createVpcip(CreateVpcipRequest createVpcipRequest)  {
        return bucketOperation.createVpcip(createVpcipRequest);
    }

    @override
     List<Vpcip> listVpcip()  {
        return bucketOperation.listVpcip();
    }

    @override
     VoidResult deleteVpcip(DeleteVpcipRequest deleteVpcipRequest)  {
        return bucketOperation.deleteVpcip(deleteVpcipRequest);
    }

    @override
     VoidResult createBucketVpcip(CreateBucketVpcipRequest createBucketVpcipRequest)  {
        return bucketOperation.createBucketVpcip(createBucketVpcipRequest);
    }

    @override
     VoidResult deleteBucketVpcip(DeleteBucketVpcipRequest deleteBucketVpcipRequest)  {
        return bucketOperation.deleteBucketVpcip(deleteBucketVpcipRequest);
    }

    @override
     List<VpcPolicy> getBucketVpcip(GenericRequest genericRequest)  {
        return bucketOperation.getBucketVpcip(genericRequest);
    }

    @override
     VoidResult setBucketInventoryConfiguration(String bucketName, InventoryConfiguration inventoryConfiguration)
             {
        return setBucketInventoryConfiguration(SetBucketInventoryConfigurationRequest(bucketName, inventoryConfiguration));
    }

    @override
     VoidResult setBucketInventoryConfiguration(SetBucketInventoryConfigurationRequest
            setBucketInventoryConfigurationRequest)  {
        return bucketOperation.setBucketInventoryConfiguration(setBucketInventoryConfigurationRequest);
    }

    @override
     GetBucketInventoryConfigurationResult getBucketInventoryConfiguration(String bucketName, String inventoryId)
             {
        return getBucketInventoryConfiguration(GetBucketInventoryConfigurationRequest(bucketName, inventoryId));
    }

    @override
     GetBucketInventoryConfigurationResult getBucketInventoryConfiguration(GetBucketInventoryConfigurationRequest
            getBucketInventoryConfigurationRequest)  {
        return bucketOperation.getBucketInventoryConfiguration(getBucketInventoryConfigurationRequest);
    }

    @override
     ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(String bucketName)
            {
        return listBucketInventoryConfigurations(ListBucketInventoryConfigurationsRequest(bucketName));
    }

    @override
     ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(
            String bucketName, String continuationToken)  {
        return listBucketInventoryConfigurations(ListBucketInventoryConfigurationsRequest(
                bucketName, continuationToken));
    }

    @override
     ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(ListBucketInventoryConfigurationsRequest
            listBucketInventoryConfigurationsRequest)  {
        return bucketOperation.listBucketInventoryConfigurations(listBucketInventoryConfigurationsRequest);
    }

    @override
     VoidResult deleteBucketInventoryConfiguration(String bucketName, String inventoryId)  {
        return deleteBucketInventoryConfiguration(DeleteBucketInventoryConfigurationRequest(bucketName, inventoryId));
    }

    @override
     VoidResult deleteBucketInventoryConfiguration(
            DeleteBucketInventoryConfigurationRequest deleteBucketInventoryConfigurationRequest)
             {
        return bucketOperation.deleteBucketInventoryConfiguration(deleteBucketInventoryConfigurationRequest);
    }

    @override
     InitiateBucketWormResult initiateBucketWorm(InitiateBucketWormRequest initiateBucketWormRequest)  {
        return bucketOperation.initiateBucketWorm(initiateBucketWormRequest);
    }

    @override
     InitiateBucketWormResult initiateBucketWorm(String bucketName, int retentionPeriodInDays)  {
        return initiateBucketWorm(InitiateBucketWormRequest(bucketName, retentionPeriodInDays));
    }

    @override
     VoidResult abortBucketWorm(GenericRequest genericRequest)  {
        return bucketOperation.abortBucketWorm(genericRequest);
    }

    @override
     VoidResult abortBucketWorm(String bucketName)  {
        return abortBucketWorm(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult completeBucketWorm(CompleteBucketWormRequest completeBucketWormRequest)  {
        return bucketOperation.completeBucketWorm(completeBucketWormRequest);
    }

    @override
     VoidResult completeBucketWorm(String bucketName, String wormId)  {
        return completeBucketWorm(CompleteBucketWormRequest(bucketName, wormId));
    }

    @override
     VoidResult extendBucketWorm(ExtendBucketWormRequest extendBucketWormRequest)  {
        return bucketOperation.extendBucketWorm(extendBucketWormRequest);
    }

    @override
     VoidResult extendBucketWorm(String bucketName, String wormId, int retentionPeriodInDays)  {
        return extendBucketWorm(ExtendBucketWormRequest(bucketName, wormId, retentionPeriodInDays));
    }

    @override
     GetBucketWormResult getBucketWorm(GenericRequest genericRequest)  {
        return bucketOperation.getBucketWorm(genericRequest);
    }

    @override
     GetBucketWormResult getBucketWorm(String bucketName)  {
        return getBucketWorm(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult createDirectory(String bucketName, String dirName)  {
        return createDirectory(CreateDirectoryRequest(bucketName, dirName));
    }

    @override
     VoidResult createDirectory(CreateDirectoryRequest createDirectoryRequest)  {
        return objectOperation.createDirectory(createDirectoryRequest);
    }

    @override
     DeleteDirectoryResult deleteDirectory(String bucketName, String dirName)  {
        return deleteDirectory(bucketName, dirName, false, null);
    }

    @override
     DeleteDirectoryResult deleteDirectory(String bucketName, String dirName,
                        bool deleteRecursive, String nextDeleteToken)  {
        return deleteDirectory(DeleteDirectoryRequest(bucketName, dirName, deleteRecursive, nextDeleteToken));
    }

    @override
     DeleteDirectoryResult deleteDirectory(DeleteDirectoryRequest deleteDirectoryRequest)  {
        return objectOperation.deleteDirectory(deleteDirectoryRequest);
    }

    @override
     VoidResult renameObject(String bucketName, String sourceObjectName, String destinationObject)  {
        return renameObject(RenameObjectRequest(bucketName, sourceObjectName, destinationObject));
    }
	
	@override
     VoidResult renameObject(RenameObjectRequest renameObjectRequest)  {
        return objectOperation.renameObject(renameObjectRequest);
    }

	@override
	 VoidResult setBucketResourceGroup(SetBucketResourceGroupRequest setBucketResourceGroupRequest)  {
		return bucketOperation.setBucketResourceGroup(setBucketResourceGroupRequest);
	}

	@override
	 GetBucketResourceGroupResult getBucketResourceGroup(String bucketName)  {
		return bucketOperation.getBucketResourceGroup(GenericRequest(bucketName: bucketName));
	}

    @override
     VoidResult createUdf(CreateUdfRequest createUdfRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     UdfInfo getUdfInfo(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     List<UdfInfo> listUdfs()  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult deleteUdf(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult uploadUdfImage(UploadUdfImageRequest uploadUdfImageRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     List<UdfImageInfo> getUdfImageInfo(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult deleteUdfImage(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult createUdfApplication(CreateUdfApplicationRequest createUdfApplicationRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     UdfApplicationInfo getUdfApplicationInfo(UdfGenericRequest genericRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     List<UdfApplicationInfo> listUdfApplications()  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult deleteUdfApplication(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult upgradeUdfApplication(UpgradeUdfApplicationRequest upgradeUdfApplicationRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult resizeUdfApplication(ResizeUdfApplicationRequest resizeUdfApplicationRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     UdfApplicationLog getUdfApplicationLog(GetUdfApplicationLogRequest getUdfApplicationLogRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult setBucketTransferAcceleration(String bucketName, bool enable)  {
        return bucketOperation.setBucketTransferAcceleration(SetBucketTransferAccelerationRequest(bucketName, enable));
    }

    @override
     TransferAcceleration getBucketTransferAcceleration(String bucketName)  {
        return bucketOperation.getBucketTransferAcceleration(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketTransferAcceleration(String bucketName)  {
        return bucketOperation.deleteBucketTransferAcceleration(GenericRequest(bucketName: bucketName));
    }

    @override
     void shutdown() {
        try {
            serviceClient.shutdown();
        } catch ( e) {
            LogUtils.logException("shutdown throw exception: ", e);
        }
    }

    @override
     String getConnectionPoolStats() {
        try {
            return serviceClient.getConnectionPoolStats();
        } catch ( e) {
        }
        return "";
    }
}
