import 'client_configuration.dart';
import 'common/auth/credentials_provider.dart';
import 'common/auth/custom_session_credentials_provider.dart';
import 'common/comm/service_client.dart';
import 'common/comm/sign_version.dart';
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
import 'model/access_control_list.dart';
import 'model/async_fetch_task_configuration.dart';
import 'model/bucket.dart';
import 'model/bucket_list.dart';
import 'model/bucket_metadata.dart';
import 'model/bucket_qos_info.dart';
import 'model/bucket_referer.dart';
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
import 'model/list_objects_request.dart';
import 'model/list_objects_v2_request.dart';
import 'model/list_objects_v2_result.dart';
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

import 'dart:io';

import 'common/auth/credentials.dart';
import 'model/abort_multipart_upload_request.dart';
import 'model/add_bucket_cname_request.dart';
import 'model/add_bucket_cname_result.dart';
import 'model/add_bucket_replication_request.dart';
import 'model/append_object_request.dart';
import 'model/append_object_result.dart';
import 'model/bucket_info.dart';
import 'model/bucket_logging_result.dart';
import 'model/bucket_process.dart';
import 'model/bucket_replication_progress.dart';
import 'model/bucket_stat.dart';
import 'model/bucket_versioning_configuration.dart';
import 'model/bucket_website_result.dart';
import 'model/canned_access_control_list.dart';
import 'model/cname_configuration.dart';
import 'model/complete_bucket_worm_request.dart';
import 'model/complete_multipart_upload_request.dart';
import 'model/complete_multipart_upload_result.dart';
import 'model/copy_object_request.dart';
import 'model/copy_object_result.dart';
import 'model/cors_configuration.dart';
import 'model/create_live_channel_request.dart';
import 'model/create_live_channel_result.dart';
import 'model/create_select_object_metadata_request.dart';
import 'model/create_vpcip_request.dart';
import 'model/create_vpcip_result.dart';
import 'model/delete_bucket_cname_request.dart';
import 'model/delete_bucket_replication_request.dart';
import 'model/delete_objects_request.dart';
import 'model/delete_objects_result.dart';
import 'model/delete_version_request.dart';
import 'model/delete_versions_request.dart';
import 'model/delete_versions_result.dart';
import 'model/download_file_request.dart';
import 'model/download_file_result.dart';
import 'model/extend_bucket_worm_request.dart';
import 'model/generate_presigned_url_request.dart';
import 'model/generate_vod_playlist_request.dart';
import 'model/get_bucket_image_result.dart';
import 'model/get_bucket_inventory_configuration_result.dart';
import 'model/get_bucket_policy_result.dart';
import 'model/get_bucket_replication_progress_request.dart';
import 'model/get_bucket_worm_result.dart';
import 'model/get_image_style_result.dart';
import 'model/get_object_request.dart';
import 'model/head_object_request.dart';
import 'model/initiate_bucket_worm_request.dart';
import 'model/initiate_bucket_worm_result.dart';
import 'model/initiate_multipart_upload_request.dart';
import 'model/initiate_multipart_upload_result.dart';
import 'model/lifecycle_rule.dart';
import 'model/list_live_channels_request.dart';
import 'model/list_multipart_uploads_request.dart';
import 'model/list_parts_request.dart';
import 'model/live_channel.dart';
import 'model/live_channel_generic_request.dart';
import 'model/live_channel_info.dart';
import 'model/live_channel_listing.dart';
import 'model/live_channel_stat.dart';
import 'model/live_channel_status.dart';
import 'model/live_record.dart';
import 'model/multipart_upload_listing.dart';
import 'model/object_acl.dart';
import 'model/object_listing.dart';
import 'model/part_listing.dart';
import 'model/policy_conditions.dart';
import 'model/pub_bucket_image_request.dart';
import 'model/put_image_style_request.dart';
import 'model/replication_rule.dart';
import 'model/restore_configuration.dart';
import 'model/restore_object_request.dart';
import 'model/restore_object_result.dart';
import 'model/select_object_metadata.dart';
import 'model/select_object_request.dart';
import 'model/server_side_encryption_configuration.dart';
import 'model/set_bucket_cors_request.dart';
import 'model/set_bucket_encryption_request.dart';
import 'model/set_bucket_lifecycle_request.dart';
import 'model/set_bucket_logging_request.dart';
import 'model/set_bucket_policy_request.dart';
import 'model/set_bucket_process_request.dart';
import 'model/set_bucket_referer_request.dart';
import 'model/set_bucket_storage_capacity_request.dart';
import 'model/set_bucket_tagging_request.dart';
import 'model/set_bucket_versioning_request.dart';
import 'model/set_bucket_website_request.dart';
import 'model/set_live_channel_request.dart';
import 'model/set_object_acl_request.dart';
import 'model/set_object_tagging_request.dart';
import 'model/simplified_object_meta.dart';
import 'model/style.dart';
import 'model/tag_set.dart';
import 'model/udf_image_info.dart';
import 'model/upload_file_request.dart';
import 'model/upload_file_result.dart';
import 'model/upload_part_copy_request.dart';
import 'model/upload_part_copy_result.dart';
import 'model/upload_part_request.dart';
import 'model/upload_part_result.dart';
import 'model/user_qos.dart';
import 'model/vpc_ip.dart';


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
     OSSClient(String endpoint, this.credsProvider, ClientConfiguration config) {
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

     Uri toURI(String endpoint) {
        return OSSUtils.toEndpointURI(endpoint, serviceClient.config.protocol.toString());
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
     void switchSignatureVersion(SignVersion? signatureVersion) {
        if (signatureVersion == null) {
            throw ArgumentError("signatureVersion should not be null.");
        }

        getClientConfiguration().signatureVersion = signatureVersion;
    }

     CredentialsProvider getCredentialsProvider() {
        return credsProvider;
    }

     ClientConfiguration getClientConfiguration() {
        return serviceClient.config;
    }

    @override
     Bucket createBucket(String bucketName)  {
        return createBucketWithRequest(CreateBucketRequest(bucketName));
    }

    @override
     Bucket createBucketWithRequest(CreateBucketRequest createBucketRequest)  {
        return bucketOperation.createBucket(createBucketRequest);
    }

    @override
     VoidResult deleteBucket(String bucketName)  {
        return deleteBucketWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucket(genericRequest);
    }

    @override
     List<Bucket> listBuckets()  {
        return bucketOperation.listBuckets();
    }

    @override
     BucketList listBucketsWithRequest(ListBucketsRequest listBucketsRequest)  {
        return bucketOperation.listBucketsWithRequest(listBucketsRequest);
    }

    @override
     BucketList listBuckets(String prefix, String marker, int maxKeys)  {
        return bucketOperation.listBucketsWithRequest(ListBucketsRequest(prefix, marker, maxKeys));
    }

    @override
     VoidResult setBucketAcl(String bucketName, CannedAccessControlList cannedACL)
             {
        return setBucketAclWithRequest(SetBucketAclRequest(bucketName, cannedACL));
    }

    @override
     VoidResult setBucketAclWithRequest(SetBucketAclRequest setBucketAclRequest)  {
        return bucketOperation.setBucketAcl(setBucketAclRequest);
    }

    @override
     AccessControlList getBucketAcl(String bucketName)  {
        return getBucketAclWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     AccessControlList getBucketAclWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketAcl(genericRequest);
    }

    @override
     BucketMetadata getBucketMetadata(String bucketName)  {
        return getBucketMetadataWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketMetadata getBucketMetadataWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketMetadata(genericRequest);
    }

    @override
     VoidResult setBucketReferer(String bucketName, BucketReferer referer)  {
        return setBucketRefererWithRequest(SetBucketRefererRequest(bucketName, referer));
    }

    @override
     VoidResult setBucketRefererWithRequest(SetBucketRefererRequest setBucketRefererRequest)  {
        return bucketOperation.setBucketReferer(setBucketRefererRequest);
    }

    @override
     BucketReferer getBucketReferer(String bucketName)  {
        return getBucketRefererWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketReferer getBucketRefererWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketReferer(genericRequest);
    }

    @override
     String getBucketLocation(String bucketName)  {
        return getBucketLocationWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     String getBucketLocationWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketLocation(genericRequest);
    }

    @override
     bool doesBucketExist(String bucketName)  {
        return doesBucketExistWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     bool doesBucketExistWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.doesBucketExists(genericRequest);
    }

    /// Deprecated. Please use {@link OSSClient#doesBucketExist(String)} instead.
    @Deprecated
     bool isBucketExist(String bucketName)  {
        return doesBucketExist(bucketName);
    }

    @override
     ObjectListing listObjects(String bucketName)  {
        return listObjectsWithRequest(ListObjectsRequest(bucketName, null, null, null, null));
    }

    @override
     ObjectListing listObjects(String bucketName, String prefix)  {
        return listObjectsWithRequest(ListObjectsRequest(bucketName, prefix, null, null, null));
    }

    @override
     ObjectListing listObjectsWithRequest(ListObjectsRequest listObjectsRequest)  {
        return bucketOperation.listObjects(listObjectsRequest);
    }

    @override
     ListObjectsV2Result listObjectsV2WithRequest(ListObjectsV2Request listObjectsV2Request)  {
        return bucketOperation.listObjectsV2(listObjectsV2Request);
    }

    @override
     ListObjectsV2Result listObjectsV2(String bucketName)  {
        return bucketOperation.listObjectsV2WithRequest(ListObjectsV2Request(bucketName));
    }

    @override
     ListObjectsV2Result listObjectsV2(String bucketName, String prefix)  {
        return bucketOperation.listObjectsV2WithRequest(ListObjectsV2Request(bucketName, prefix));
    }

    @override
     ListObjectsV2Result listObjectsV2(String bucketName, String prefix, String continuationToken,
                                String startAfter, String delimiter, Integer maxKeys,
                                String encodingType, bool fetchOwner)  {
        return bucketOperation.listObjectsV2WithRequest(ListObjectsV2Request(bucketName, prefix, continuationToken, startAfter,
                delimiter, maxKeys, encodingType, fetchOwner));
    }

    @override
	 VersionListing listVersions(String bucketName, String prefix)  {
        return listVersionsWithRequest(ListVersionsRequest(bucketName, prefix, null, null, null, null));
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
     VersionListing listVersionsWithRequest(ListVersionsRequest listVersionsRequest)  {
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
        return putObjectWithRequest(PutObjectRequest(bucketName, key, input, metadata));
    }

    @override
     PutObjectResult putObject(String bucketName, String key, File file, ObjectMetadata metadata)
             {
        return putObjectWithRequest(PutObjectRequest(bucketName, key, file, metadata));
    }

    @override
     PutObjectResult putObject(String bucketName, String key, File file)  {
        return putObject(bucketName, key, file, null);
    }

    @override
     PutObjectResult putObjectWithRequest(PutObjectRequest putObjectRequest)  {
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
                } catch ( e) {
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
        return copyObjectWithRequest(CopyObjectRequest(sourceBucketName, sourceKey, destinationBucketName, destinationKey));
    }

    @override
     CopyObjectResult copyObjectWithRequest(CopyObjectRequest copyObjectRequest)  {
        return objectOperation.copyObject(copyObjectRequest);
    }

    @override
     OSSObject getObject(String bucketName, String key)  {
        return getObjectWithRequest(GetObjectRequest(bucketName, key));
    }

    @override
     ObjectMetadata getObjectWithRequestFile(GetObjectRequest getObjectRequest, File file)  {
        return objectOperation.getObject(getObjectRequest, file);
    }

    @override
     OSSObject getObjectWithRequest(GetObjectRequest getObjectRequest)  {
        return objectOperation.getObject(getObjectRequest);
    }

    @override
     OSSObject getObjectWithHeader(Uri signedUrl, Map<String, String> requestHeaders)  {
        GetObjectRequest getObjectRequest = GetObjectRequest(signedUrl, requestHeaders);
        return objectOperation.getObject(getObjectRequest);
    }

    @override
     OSSObject selectObjectWithRequest(SelectObjectRequest selectObjectRequest)  {
        return objectOperation.selectObject(selectObjectRequest);
    }

    @override
     SimplifiedObjectMeta getSimplifiedObjectMeta(String bucketName, String key)
             {
        return getSimplifiedObjectMetaWithRequest(GenericRequest(bucketName, key));
    }

    @override
     SimplifiedObjectMeta getSimplifiedObjectMetaWithRequest(GenericRequest genericRequest)
             {
        return objectOperation.getSimplifiedObjectMeta(genericRequest);
    }

    @override
     ObjectMetadata getObjectMetadata(String bucketName, String key)  {
        return getObjectMetadataWithRequest(GenericRequest(bucketName, key));
    }

    @override
     SelectObjectMetadata createSelectObjectMetadataWithRequest(CreateSelectObjectMetadataRequest createSelectObjectMetadataRequest)  {
        return objectOperation.createSelectObjectMetadata(createSelectObjectMetadataRequest);
    }
    
    @override
     ObjectMetadata getObjectMetadataWithRequest(GenericRequest genericRequest)  {
        return objectOperation.getObjectMetadata(genericRequest);
    }

    @override
     ObjectMetadata headObject(String bucketName, String key)  {
        return headObjectWithRequest(HeadObjectRequest(bucketName, key));
    }

    @override
     ObjectMetadata headObjectWithRequest(HeadObjectRequest headObjectRequest)  {
        return objectOperation.headObject(headObjectRequest);
    }

    @override
     AppendObjectResult appendObjectWithRequest(AppendObjectRequest appendObjectRequest)
             {
        return objectOperation.appendObject(appendObjectRequest);
    }

    @override
     VoidResult deleteObject(String bucketName, String key)  {
        return deleteObjectWithRequest(GenericRequest(bucketName, key));
    }

    @override
     VoidResult deleteObjectWithRequest(GenericRequest genericRequest)  {
        return objectOperation.deleteObject(genericRequest);
    }
    
    @override
     VoidResult deleteVersion(String bucketName, String key, String versionId)  {
        return deleteVersionWithRequest(DeleteVersionRequest(bucketName, key, versionId));
    }

    @override
     VoidResult deleteVersionWithRequest(DeleteVersionRequest deleteVersionRequest)  {
        return objectOperation.deleteVersion(deleteVersionRequest);
    }

    @override
     DeleteObjectsResult deleteObjectsWithRequest(DeleteObjectsRequest deleteObjectsRequest)
             {
        return objectOperation.deleteObjects(deleteObjectsRequest);
    }
    
    @override
     DeleteVersionsResult deleteVersionsWithRequest(DeleteVersionsRequest deleteVersionsRequest)
         {
        return objectOperation.deleteVersions(deleteVersionsRequest);
    }

    @override
     bool doesObjectExist(String bucketName, String key)  {
        return doesObjectExistWithRequest(GenericRequest(bucketName, key));
    }

    @override
     bool doesObjectExist(String bucketName, String key, bool isOnlyInOSS) {
        if (isOnlyInOSS) {
            return doesObjectExist(bucketName, key);
        } else {
            return objectOperation.doesObjectExistWithRedirectWithRequest(GenericRequest(bucketName, key));
        }
    }

    @Deprecated
    @override
     bool doesObjectExistWithRequest(HeadObjectRequest headObjectRequest)  {
        return doesObjectExistWithRequest(GenericRequest(headObjectRequest.getBucketName(), headObjectRequest.getKey()));
    }

    @override
     bool doesObjectExistWithRequest(GenericRequest genericRequest)  {
        return objectOperation.doesObjectExist(genericRequest);
    }

    @override
     bool doesObjectExistWithRequest(GenericRequest genericRequest, bool isOnlyInOSS)  {
    	if (isOnlyInOSS) {
    	    return objectOperation.doesObjectExist(genericRequest);	
    	} else {
    	    return objectOperation.doesObjectExistWithRedirect(genericRequest);
    	}
    }

    @override
     VoidResult setObjectAcl(String bucketName, String key, CannedAccessControlList cannedACL)
             {
        return setObjectAclWithRequest(SetObjectAclRequest(bucketName, key, cannedACL));
    }

    @override
     VoidResult setObjectAclWithRequest(SetObjectAclRequest setObjectAclRequest)  {
        return objectOperation.setObjectAcl(setObjectAclRequest);
    }

    @override
     ObjectAcl getObjectAcl(String bucketName, String key)  {
        return getObjectAclWithRequest(GenericRequest(bucketName, key));
    }

    @override
     ObjectAcl getObjectAclWithRequest(GenericRequest genericRequest)  {
        return objectOperation.getObjectAcl(genericRequest);
    }

    @override
     RestoreObjectResult restoreObject(String bucketName, String key)  {
        return restoreObjectWithRequest(GenericRequest(bucketName, key));
    }

    @override
     RestoreObjectResult restoreObjectWithRequest(GenericRequest genericRequest)  {
        return objectOperation.restoreObject(genericRequest);
    }
    
    @override
     RestoreObjectResult restoreObject(String bucketName, String key, RestoreConfiguration restoreConfiguration)
             {
        return restoreObjectWithRequest(RestoreObjectRequest(bucketName, key, restoreConfiguration));
    }

    @override
     RestoreObjectResult restoreObjectWithRequest(RestoreObjectRequest restoreObjectRequest)
             {
        return objectOperation.restoreObject(restoreObjectRequest);
    }

    @override
     VoidResult setObjectTagging(String bucketName, String key, Map<String, String> tags)
         {
        return setObjectTaggingWithRequest(SetObjectTaggingRequest(bucketName, key, tags));
    }

    @override
     VoidResult setObjectTagging(String bucketName, String key, TagSet tagSet)  {
        return setObjectTaggingWithRequest(SetObjectTaggingRequest(bucketName, key, tagSet));
    }

    @override
     VoidResult setObjectTaggingWithRequest(SetObjectTaggingRequest setObjectTaggingRequest)  {
        return objectOperation.setObjectTagging(setObjectTaggingRequest);
    }

    @override
     TagSet getObjectTagging(String bucketName, String key)  {
        return getObjectTaggingWithRequest(GenericRequest(bucketName, key));
    }

    @override
     TagSet getObjectTaggingWithRequest(GenericRequest genericRequest)  {
        return objectOperation.getObjectTagging(genericRequest);
    }

    @override
     VoidResult deleteObjectTagging(String bucketName, String key)  {
        return deleteObjectTaggingWithRequest(GenericRequest(bucketName, key));
    }

    @override
     VoidResult deleteObjectTaggingWithRequest(GenericRequest genericRequest)  {
        return objectOperation.deleteObjectTagging(genericRequest);
    }

    @override
     URL generatePresignedUrl(String bucketName, String key, DateTime expiration)  {
        return generatePresignedUrl(bucketName, key, expiration, HttpMethod.GET);
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
     URL generatePresignedUrlWithRequest(GeneratePresignedUrlRequest request)  {

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
     VoidResult abortMultipartUploadWithRequest(AbortMultipartUploadRequest request)  {
        return multipartOperation.abortMultipartUpload(request);
    }

    @override
     CompleteMultipartUploadResult completeMultipartUploadWithRequest(CompleteMultipartUploadRequest request)
             {
        return multipartOperation.completeMultipartUpload(request);
    }

    @override
     InitiateMultipartUploadResult initiateMultipartUploadWithRequest(InitiateMultipartUploadRequest request)
             {
        return multipartOperation.initiateMultipartUpload(request);
    }

    @override
     MultipartUploadListing listMultipartUploadsWithRequest(ListMultipartUploadsRequest request)
             {
        return multipartOperation.listMultipartUploads(request);
    }

    @override
     PartListing listPartsWithRequest(ListPartsRequest request)  {
        return multipartOperation.listParts(request);
    }

    @override
     UploadPartResult uploadPartWithRequest(UploadPartRequest request)  {
        return multipartOperation.uploadPart(request);
    }

    @override
     UploadPartCopyResult uploadPartCopyWithRequest(UploadPartCopyRequest request)  {
        return multipartOperation.uploadPartCopy(request);
    }

    @override
     VoidResult setBucketCORSWithRequest(SetBucketCORSRequest request)  {
        return corsOperation.setBucketCORS(request);
    }

    @override
     List<CORSRule> getBucketCORSRules(String bucketName)  {
        return getBucketCORSRulesWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     List<CORSRule> getBucketCORSRulesWithRequest(GenericRequest genericRequest)  {
        return getBucketCORS(genericRequest).getCorsRules();
    }

    @override
     CORSConfiguration getBucketCORSWithRequest(GenericRequest genericRequest)  {
        return corsOperation.getBucketCORS(genericRequest);
    }

    @override
     VoidResult deleteBucketCORSRules(String bucketName)  {
        return deleteBucketCORSRulesWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketCORSRulesWithRequest(GenericRequest genericRequest)  {
        return corsOperation.deleteBucketCORS(genericRequest);
    }

    @override
     ResponseMessage optionsObjectWithRequest(OptionsRequest request)  {
        return corsOperation.optionsObject(request);
    }

    @override
     VoidResult setBucketLoggingWithRequest(SetBucketLoggingRequest request)  {
        return bucketOperation.setBucketLogging(request);
    }

    @override
     BucketLoggingResult getBucketLogging(String bucketName)  {
        return getBucketLoggingWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketLoggingResult getBucketLoggingWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketLogging(genericRequest);
    }

    @override
     VoidResult deleteBucketLogging(String bucketName)  {
        return deleteBucketLoggingWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketLoggingWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketLogging(genericRequest);
    }

    @override
     VoidResult putBucketImageWithRequest(PutBucketImageRequest request)  {
        return bucketOperation.putBucketImage(request);
    }

    @override
     GetBucketImageResult getBucketImage(String bucketName)  {
        return bucketOperation.getBucketImageWithRequest(bucketName, GenericRequest());
    }

    @override
     GetBucketImageResult getBucketImageWithRequest(String bucketName, GenericRequest genericRequest)
             {
        return bucketOperation.getBucketImage(bucketName, genericRequest);
    }

    @override
     VoidResult deleteBucketImage(String bucketName)  {
        return bucketOperation.deleteBucketImageWithRequest(bucketName, GenericRequest());
    }

    @override
     VoidResult deleteBucketImageWithRequest(String bucketName, GenericRequest genericRequest)
             {
        return bucketOperation.deleteBucketImage(bucketName, genericRequest);
    }

    @override
     VoidResult putImageStyleWithRequest(PutImageStyleRequest putImageStyleRequest)  {
        return bucketOperation.putImageStyle(putImageStyleRequest);
    }

    @override
     VoidResult deleteImageStyle(String bucketName, String styleName)  {
        return bucketOperation.deleteImageStyleWithRequest(bucketName, styleName, GenericRequest());
    }

    @override
     VoidResult deleteImageStyleWithRequest(String bucketName, String styleName, GenericRequest genericRequest)
             {
        return bucketOperation.deleteImageStyle(bucketName, styleName, genericRequest);
    }

    @override
     GetImageStyleResult getImageStyle(String bucketName, String styleName)  {
        return bucketOperation.getImageStyleWithRequest(bucketName, styleName, GenericRequest());
    }

    @override
     GetImageStyleResult getImageStyleWithRequest(String bucketName, String styleName, GenericRequest genericRequest)
             {
        return bucketOperation.getImageStyle(bucketName, styleName, genericRequest);
    }

    @override
     List<Style> listImageStyle(String bucketName)  {
        return bucketOperation.listImageStyleWithRequest(bucketName, GenericRequest());
    }

    @override
     List<Style> listImageStyleWithRequest(String bucketName, GenericRequest genericRequest)
             {
        return bucketOperation.listImageStyle(bucketName, genericRequest);
    }

    @override
     VoidResult setBucketProcessWithRequest(SetBucketProcessRequest setBucketProcessRequest)  {
        return bucketOperation.setBucketProcess(setBucketProcessRequest);
    }

    @override
     BucketProcess getBucketProcess(String bucketName)  {
        return getBucketProcessWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketProcess getBucketProcessWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketProcess(genericRequest);
    }

    @override
     VoidResult setBucketWebsiteWithRequest(SetBucketWebsiteRequest setBucketWebSiteRequest)  {
        return bucketOperation.setBucketWebsite(setBucketWebSiteRequest);
    }

    @override
     BucketWebsiteResult getBucketWebsite(String bucketName)  {
        return getBucketWebsiteWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketWebsiteResult getBucketWebsiteWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketWebsite(genericRequest);
    }

    @override
     VoidResult deleteBucketWebsite(String bucketName)  {
        return deleteBucketWebsiteWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketWebsiteWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketWebsite(genericRequest);
    }
    
    @override
     BucketVersioningConfiguration getBucketVersioning(String bucketName)  {
        return getBucketVersioningWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketVersioningConfiguration getBucketVersioningWithRequest(GenericRequest genericRequest)
         {
        return bucketOperation.getBucketVersioning(genericRequest);
    }

    @override
     VoidResult setBucketVersioningWithRequest(SetBucketVersioningRequest setBucketVersioningRequest)
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
     VoidResult setBucketLifecycleWithRequest(SetBucketLifecycleRequest setBucketLifecycleRequest)
             {
        return bucketOperation.setBucketLifecycle(setBucketLifecycleRequest);
    }

    @override
     List<LifecycleRule> getBucketLifecycle(String bucketName)  {
        return getBucketLifecycleWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     List<LifecycleRule> getBucketLifecycleWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketLifecycle(genericRequest);
    }

    @override
     VoidResult deleteBucketLifecycle(String bucketName)  {
        return deleteBucketLifecycleWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketLifecycleWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketLifecycle(genericRequest);
    }

    @override
     VoidResult setBucketTagging(String bucketName, Map<String, String> tags)  {
        return setBucketTaggingWithRequest(SetBucketTaggingRequest(bucketName, tags));
    }

    @override
     VoidResult setBucketTagging(String bucketName, TagSet tagSet)  {
        return setBucketTaggingWithRequest(SetBucketTaggingRequest(bucketName, tagSet));
    }

    @override
     VoidResult setBucketTaggingWithRequest(SetBucketTaggingRequest setBucketTaggingRequest)  {
        return bucketOperation.setBucketTagging(setBucketTaggingRequest);
    }

    @override
     TagSet getBucketTagging(String bucketName)  {
        return getBucketTaggingWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     TagSet getBucketTaggingWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketTagging(genericRequest);
    }

    @override
     VoidResult deleteBucketTagging(String bucketName)  {
        return deleteBucketTaggingWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketTaggingWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketTagging(genericRequest);
    }

    @override
     VoidResult addBucketReplicationWithRequest(AddBucketReplicationRequest addBucketReplicationRequest)
             {
        return bucketOperation.addBucketReplication(addBucketReplicationRequest);
    }

    @override
     List<ReplicationRule> getBucketReplication(String bucketName)  {
        return getBucketReplicationWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     List<ReplicationRule> getBucketReplicationWithRequest(GenericRequest genericRequest)
             {
        return bucketOperation.getBucketReplication(genericRequest);
    }

    @override
     VoidResult deleteBucketReplication(String bucketName, String replicationRuleID)
             {
        return deleteBucketReplicationWithRequest(DeleteBucketReplicationRequest(bucketName, replicationRuleID));
    }

    @override
     VoidResult deleteBucketReplicationWithRequest(DeleteBucketReplicationRequest deleteBucketReplicationRequest)
             {
        return bucketOperation.deleteBucketReplication(deleteBucketReplicationRequest);
    }

    @override
     BucketReplicationProgress getBucketReplicationProgress(String bucketName, String replicationRuleID)
             {
        return getBucketReplicationProgressWithRequest(GetBucketReplicationProgressRequest(bucketName, replicationRuleID));
    }

    @override
     BucketReplicationProgress getBucketReplicationProgress(
            GetBucketReplicationProgressRequest getBucketReplicationProgressRequest)
             {
        return bucketOperation.getBucketReplicationProgress(getBucketReplicationProgressRequest);
    }

    @override
     List<String> getBucketReplicationLocation(String bucketName)  {
        return getBucketReplicationLocationWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     List<String> getBucketReplicationLocationWithRequest(GenericRequest genericRequest)
             {
        return bucketOperation.getBucketReplicationLocation(genericRequest);
    }

    @override
     AddBucketCnameResult addBucketCnameWithRequest(AddBucketCnameRequest addBucketCnameRequest)  {
        return bucketOperation.addBucketCname(addBucketCnameRequest);
    }

    @override
     List<CnameConfiguration> getBucketCname(String bucketName)  {
        return getBucketCnameWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     List<CnameConfiguration> getBucketCnameWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketCname(genericRequest);
    }

    @override
     VoidResult deleteBucketCname(String bucketName, String domain)  {
        return deleteBucketCnameWithRequest(DeleteBucketCnameRequest(bucketName, domain));
    }

    @override
     VoidResult deleteBucketCnameWithRequest(DeleteBucketCnameRequest deleteBucketCnameRequest)
             {
        return bucketOperation.deleteBucketCname(deleteBucketCnameRequest);
    }

    @override
     BucketInfo getBucketInfo(String bucketName)  {
        return getBucketInfoWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketInfo getBucketInfoWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketInfo(genericRequest);
    }

    @override
     BucketStat getBucketStat(String bucketName)  {
        return getBucketStatWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketStat getBucketStatWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketStat(genericRequest);
    }

    @override
     VoidResult setBucketStorageCapacity(String bucketName, UserQos userQos)  {
        return setBucketStorageCapacityWithRequest(SetBucketStorageCapacityRequest(bucketName).withUserQos(userQos));
    }

    @override
     VoidResult setBucketStorageCapacityWithRequest(SetBucketStorageCapacityRequest setBucketStorageCapacityRequest)
             {
        return bucketOperation.setBucketStorageCapacity(setBucketStorageCapacityRequest);
    }

    @override
     UserQos getBucketStorageCapacity(String bucketName)  {
        return getBucketStorageCapacityWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     UserQos getBucketStorageCapacityWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketStorageCapacity(genericRequest);
    }

    @override
     VoidResult setBucketEncryptionWithRequest(SetBucketEncryptionRequest setBucketEncryptionRequest)
         {
        return bucketOperation.setBucketEncryption(setBucketEncryptionRequest);
    }

    @override
     ServerSideEncryptionConfiguration getBucketEncryption(String bucketName)
         {
        return getBucketEncryptionWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     ServerSideEncryptionConfiguration getBucketEncryptionWithRequest(GenericRequest genericRequest)
         {
        return bucketOperation.getBucketEncryption(genericRequest);
    }

    @override
     VoidResult deleteBucketEncryption(String bucketName)  {
        return deleteBucketEncryptionWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketEncryptionWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketEncryption(genericRequest);
    }

    @override
     VoidResult setBucketPolicy(String bucketName,  String policyText)  {
        return setBucketPolicyWithRequest(SetBucketPolicyRequest(bucketName, policyText));
    }

    @override
     VoidResult setBucketPolicyWithRequest(SetBucketPolicyRequest setBucketPolicyRequest)  {
        return bucketOperation.setBucketPolicy(setBucketPolicyRequest);
    }

    @override
     GetBucketPolicyResult getBucketPolicyWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketPolicy(genericRequest);
    }

    @override
     GetBucketPolicyResult getBucketPolicy(String bucketName)  {
        return getBucketPolicyWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketPolicyWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketPolicy(genericRequest);
    }

    @override
     VoidResult deleteBucketPolicy(String bucketName)  {
        return deleteBucketPolicyWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     UploadFileResult uploadFileWithRequest(UploadFileRequest uploadFileRequest) throws Throwable {
        return uploadOperation.uploadFile(uploadFileRequest);
    }

    @override
     DownloadFileResult downloadFileWithRequest(DownloadFileRequest downloadFileRequest) throws Throwable {
        return downloadOperation.downloadFile(downloadFileRequest);
    }

    @override
     CreateLiveChannelResult createLiveChannelWithRequest(CreateLiveChannelRequest createLiveChannelRequest)
             {
        return liveChannelOperation.createLiveChannel(createLiveChannelRequest);
    }

    @override
     VoidResult setLiveChannelStatus(String bucketName, String liveChannel, LiveChannelStatus status)
             {
        return setLiveChannelStatusWithRequest(SetLiveChannelRequest(bucketName, liveChannel, status));
    }

    @override
     VoidResult setLiveChannelStatusWithRequest(SetLiveChannelRequest setLiveChannelRequest)  {
        return liveChannelOperation.setLiveChannelStatus(setLiveChannelRequest);
    }

    @override
     LiveChannelInfo getLiveChannelInfo(String bucketName, String liveChannel)
             {
        return getLiveChannelInfoWithRequest(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     LiveChannelInfo getLiveChannelInfoWithRequest(LiveChannelGenericRequest liveChannelGenericRequest)
             {
        return liveChannelOperation.getLiveChannelInfo(liveChannelGenericRequest);
    }

    @override
     LiveChannelStat getLiveChannelStat(String bucketName, String liveChannel)
             {
        return getLiveChannelStatWithRequest(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     LiveChannelStat getLiveChannelStatWithRequest(LiveChannelGenericRequest liveChannelGenericRequest)
             {
        return liveChannelOperation.getLiveChannelStat(liveChannelGenericRequest);
    }

    @override
     VoidResult deleteLiveChannel(String bucketName, String liveChannel)  {
        return deleteLiveChannelWithRequest(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     VoidResult deleteLiveChannelWithRequest(LiveChannelGenericRequest liveChannelGenericRequest)
             {
        return liveChannelOperation.deleteLiveChannel(liveChannelGenericRequest);
    }

    @override
     List<LiveChannel> listLiveChannels(String bucketName)  {
        return liveChannelOperation.listLiveChannels(bucketName);
    }

    @override
     LiveChannelListing listLiveChannelsWithRequest(ListLiveChannelsRequest listLiveChannelRequest)
             {
        return liveChannelOperation.listLiveChannels(listLiveChannelRequest);
    }

    @override
     List<LiveRecord> getLiveChannelHistory(String bucketName, String liveChannel)
             {
        return getLiveChannelHistoryWithRequest(LiveChannelGenericRequest(bucketName, liveChannel));
    }

    @override
     List<LiveRecord> getLiveChannelHistoryWithRequest(LiveChannelGenericRequest liveChannelGenericRequest)
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
     VoidResult generateVodPlaylistWithRequest(GenerateVodPlaylistRequest generateVodPlaylistRequest)
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
     OSSObject getVodPlaylistWithRequest(GetVodPlaylistRequest getVodPlaylistRequest)
             {
        return liveChannelOperation.getVodPlaylist(getVodPlaylistRequest);
    }

    @override
     String generateRtmpUri(String bucketName, String liveChannelName, String PlaylistName, long expires)
             {
        return generateRtmpUriWithRequest(GenerateRtmpUriRequest(bucketName, liveChannelName, PlaylistName, expires));
    }

    @override
     String generateRtmpUriWithRequest(GenerateRtmpUriRequest generateRtmpUriRequest)  {
        return liveChannelOperation.generateRtmpUri(generateRtmpUriRequest);
    }

    @override
     VoidResult createSymlink(String bucketName, String symLink, String targetObject)
             {
        return createSymlinkWithRequest(CreateSymlinkRequest(bucketName, symLink, targetObject));
    }

    @override
     VoidResult createSymlinkWithRequest(CreateSymlinkRequest createSymlinkRequest)  {
        return objectOperation.createSymlink(createSymlinkRequest);
    }

    @override
     OSSSymlink getSymlink(String bucketName, String symLink)  {
        return getSymlinkWithRequest(GenericRequest(bucketName, symLink));
    }

    @override
     OSSSymlink getSymlinkWithRequest(GenericRequest genericRequest)  {
        return objectOperation.getSymlink(genericRequest);
    }

    @override
     GenericResult processObjectWithRequest(ProcessObjectRequest processObjectRequest)  {
        return objectOperation.processObject(processObjectRequest);
    }

    @override
     VoidResult setBucketRequestPayment(String bucketName, Payer payer)  {
        return setBucketRequestPaymentWithRequest(SetBucketRequestPaymentRequest(bucketName, payer));
    }

    @override
     VoidResult setBucketRequestPaymentWithRequest(SetBucketRequestPaymentRequest setBucketRequestPaymentRequest)  {
        return bucketOperation.setBucketRequestPayment(setBucketRequestPaymentRequest);
    }

    @override
     GetBucketRequestPaymentResult getBucketRequestPayment(String bucketName)  {
        return getBucketRequestPaymentWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     GetBucketRequestPaymentResult getBucketRequestPaymentWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketRequestPayment(genericRequest);
    }

    @override
     VoidResult setBucketQosInfo(String bucketName, BucketQosInfo bucketQosInfo)  {
        return setBucketQosInfoWithRequest(SetBucketQosInfoRequest(bucketName, bucketQosInfo));
    }

    @override
     VoidResult setBucketQosInfoWithRequest(SetBucketQosInfoRequest setBucketQosInfoRequest)  {
        return bucketOperation.setBucketQosInfo(setBucketQosInfoRequest);
    }

    @override
     BucketQosInfo getBucketQosInfo(String bucketName)  {
        return getBucketQosInfoWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     BucketQosInfo getBucketQosInfoWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketQosInfo(genericRequest);
    }

    @override
     VoidResult deleteBucketQosInfo(String bucketName)  {
        return deleteBucketQosInfoWithRequest(GenericRequest(bucketName: bucketName));
    }
 
    @override
     VoidResult deleteBucketQosInfoWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.deleteBucketQosInfo(genericRequest);
    }

    @override
     UserQosInfo getUserQosInfo()  {
        return bucketOperation.getUserQosInfo();
    }

    @override
     SetAsyncFetchTaskResult setAsyncFetchTask(String bucketName,
        AsyncFetchTaskConfiguration asyncFetchTaskConfiguration)  {
        return setAsyncFetchTaskWithRequest(SetAsyncFetchTaskRequest(bucketName,asyncFetchTaskConfiguration));
    }

    @override
     SetAsyncFetchTaskResult setAsyncFetchTaskWithRequest(SetAsyncFetchTaskRequest setAsyncFetchTaskRequest)
             {
        return bucketOperation.setAsyncFetchTask(setAsyncFetchTaskRequest);
    }

    @override
     GetAsyncFetchTaskResult getAsyncFetchTask(String bucketName, String taskId)
             {
        return getAsyncFetchTaskWithRequest(GetAsyncFetchTaskRequest(bucketName, taskId));
    }

    @override
     GetAsyncFetchTaskResult getAsyncFetchTaskWithRequest(GetAsyncFetchTaskRequest getAsyncFetchTaskRequest)
             {
        return bucketOperation.getAsyncFetchTask(getAsyncFetchTaskRequest);
    }

    @override
     CreateVpcipResult createVpcipWithRequest(CreateVpcipRequest createVpcipRequest)  {
        return bucketOperation.createVpcip(createVpcipRequest);
    }

    @override
     List<Vpcip> listVpcip()  {
        return bucketOperation.listVpcip();
    }

    @override
     VoidResult deleteVpcipWithRequest(DeleteVpcipRequest deleteVpcipRequest)  {
        return bucketOperation.deleteVpcip(deleteVpcipRequest);
    }

    @override
     VoidResult createBucketVpcipWithRequest(CreateBucketVpcipRequest createBucketVpcipRequest)  {
        return bucketOperation.createBucketVpcip(createBucketVpcipRequest);
    }

    @override
     VoidResult deleteBucketVpcipWithRequest(DeleteBucketVpcipRequest deleteBucketVpcipRequest)  {
        return bucketOperation.deleteBucketVpcip(deleteBucketVpcipRequest);
    }

    @override
     List<VpcPolicy> getBucketVpcipWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketVpcip(genericRequest);
    }

    @override
     VoidResult setBucketInventoryConfiguration(String bucketName, InventoryConfiguration inventoryConfiguration)
             {
        return setBucketInventoryConfigurationWithRequest(SetBucketInventoryConfigurationRequest(bucketName, inventoryConfiguration));
    }

    @override
     VoidResult setBucketInventoryConfiguration(SetBucketInventoryConfigurationRequest
            setBucketInventoryConfigurationRequest)  {
        return bucketOperation.setBucketInventoryConfiguration(setBucketInventoryConfigurationRequest);
    }

    @override
     GetBucketInventoryConfigurationResult getBucketInventoryConfiguration(String bucketName, String inventoryId)
             {
        return getBucketInventoryConfigurationWithRequest(GetBucketInventoryConfigurationRequest(bucketName, inventoryId));
    }

    @override
     GetBucketInventoryConfigurationResult getBucketInventoryConfiguration(GetBucketInventoryConfigurationRequest
            getBucketInventoryConfigurationRequest)  {
        return bucketOperation.getBucketInventoryConfiguration(getBucketInventoryConfigurationRequest);
    }

    @override
     ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(String bucketName)
            {
        return listBucketInventoryConfigurationsWithRequest(ListBucketInventoryConfigurationsRequest(bucketName));
    }

    @override
     ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(
            String bucketName, String continuationToken)  {
        return listBucketInventoryConfigurationsWithRequest(ListBucketInventoryConfigurationsRequest(
                bucketName, continuationToken));
    }

    @override
     ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(ListBucketInventoryConfigurationsRequest
            listBucketInventoryConfigurationsRequest)  {
        return bucketOperation.listBucketInventoryConfigurations(listBucketInventoryConfigurationsRequest);
    }

    @override
     VoidResult deleteBucketInventoryConfiguration(String bucketName, String inventoryId)  {
        return deleteBucketInventoryConfigurationWithRequest(DeleteBucketInventoryConfigurationRequest(bucketName, inventoryId));
    }

    @override
     VoidResult deleteBucketInventoryConfiguration(
            DeleteBucketInventoryConfigurationRequest deleteBucketInventoryConfigurationRequest)
             {
        return bucketOperation.deleteBucketInventoryConfiguration(deleteBucketInventoryConfigurationRequest);
    }

    @override
     InitiateBucketWormResult initiateBucketWormWithRequest(InitiateBucketWormRequest initiateBucketWormRequest)  {
        return bucketOperation.initiateBucketWorm(initiateBucketWormRequest);
    }

    @override
     InitiateBucketWormResult initiateBucketWorm(String bucketName, int retentionPeriodInDays)  {
        return initiateBucketWormWithRequest(InitiateBucketWormRequest(bucketName, retentionPeriodInDays));
    }

    @override
     VoidResult abortBucketWormWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.abortBucketWorm(genericRequest);
    }

    @override
     VoidResult abortBucketWorm(String bucketName)  {
        return abortBucketWormWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult completeBucketWormWithRequest(CompleteBucketWormRequest completeBucketWormRequest)  {
        return bucketOperation.completeBucketWorm(completeBucketWormRequest);
    }

    @override
     VoidResult completeBucketWorm(String bucketName, String wormId)  {
        return completeBucketWormWithRequest(CompleteBucketWormRequest(bucketName, wormId));
    }

    @override
     VoidResult extendBucketWormWithRequest(ExtendBucketWormRequest extendBucketWormRequest)  {
        return bucketOperation.extendBucketWorm(extendBucketWormRequest);
    }

    @override
     VoidResult extendBucketWorm(String bucketName, String wormId, int retentionPeriodInDays)  {
        return extendBucketWormWithRequest(ExtendBucketWormRequest(bucketName, wormId, retentionPeriodInDays));
    }

    @override
     GetBucketWormResult getBucketWormWithRequest(GenericRequest genericRequest)  {
        return bucketOperation.getBucketWorm(genericRequest);
    }

    @override
     GetBucketWormResult getBucketWorm(String bucketName)  {
        return getBucketWormWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult createDirectory(String bucketName, String dirName)  {
        return createDirectoryWithRequest(CreateDirectoryRequest(bucketName, dirName));
    }

    @override
     VoidResult createDirectoryWithRequest(CreateDirectoryRequest createDirectoryRequest)  {
        return objectOperation.createDirectory(createDirectoryRequest);
    }

    @override
     DeleteDirectoryResult deleteDirectory(String bucketName, String dirName)  {
        return deleteDirectory(bucketName, dirName, false, null);
    }

    @override
     DeleteDirectoryResult deleteDirectory(String bucketName, String dirName,
                        bool deleteRecursive, String nextDeleteToken)  {
        return deleteDirectoryWithRequest(DeleteDirectoryRequest(bucketName, dirName, deleteRecursive, nextDeleteToken));
    }

    @override
     DeleteDirectoryResult deleteDirectoryWithRequest(DeleteDirectoryRequest deleteDirectoryRequest)  {
        return objectOperation.deleteDirectory(deleteDirectoryRequest);
    }

    @override
     VoidResult renameObject(String bucketName, String sourceObjectName, String destinationObject)  {
        return renameObjectWithRequest(RenameObjectRequest(bucketName, sourceObjectName, destinationObject));
    }
	
	@override
     VoidResult renameObjectWithRequest(RenameObjectRequest renameObjectRequest)  {
        return objectOperation.renameObject(renameObjectRequest);
    }

	@override
	 VoidResult setBucketResourceGroupWithRequest(SetBucketResourceGroupRequest setBucketResourceGroupRequest)  {
		return bucketOperation.setBucketResourceGroup(setBucketResourceGroupRequest);
	}

	@override
	 GetBucketResourceGroupResult getBucketResourceGroup(String bucketName)  {
		return bucketOperation.getBucketResourceGroupWithRequest(GenericRequest(bucketName: bucketName));
	}

    @override
     VoidResult createUdfWithRequest(CreateUdfRequest createUdfRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     UdfInfo getUdfInfoWithRequest(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     List<UdfInfo> listUdfs()  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult deleteUdfWithRequest(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult uploadUdfImageWithRequest(UploadUdfImageRequest uploadUdfImageRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     List<UdfImageInfo> getUdfImageInfoWithRequest(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult deleteUdfImageWithRequest(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult createUdfApplicationWithRequest(CreateUdfApplicationRequest createUdfApplicationRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     UdfApplicationInfo getUdfApplicationInfoWithRequest(UdfGenericRequest genericRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     List<UdfApplicationInfo> listUdfApplications()  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult deleteUdfApplicationWithRequest(UdfGenericRequest genericRequest)  {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult upgradeUdfApplicationWithRequest(UpgradeUdfApplicationRequest upgradeUdfApplicationRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult resizeUdfApplicationWithRequest(ResizeUdfApplicationRequest resizeUdfApplicationRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     UdfApplicationLog getUdfApplicationLogWithRequest(GetUdfApplicationLogRequest getUdfApplicationLogRequest)
             {
        throw ClientException("Not supported.");
    }

    @override
     VoidResult setBucketTransferAcceleration(String bucketName, bool enable)  {
        return bucketOperation.setBucketTransferAccelerationWithRequest(SetBucketTransferAccelerationRequest(bucketName, enable));
    }

    @override
     TransferAcceleration getBucketTransferAcceleration(String bucketName)  {
        return bucketOperation.getBucketTransferAccelerationWithRequest(GenericRequest(bucketName: bucketName));
    }

    @override
     VoidResult deleteBucketTransferAcceleration(String bucketName)  {
        return bucketOperation.deleteBucketTransferAccelerationWithRequest(GenericRequest(bucketName: bucketName));
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
        } catch (e) {
        }
        return "";
    }
}
