import 'dart:io';

import 'common/auth/credentials.dart';
import 'common/comm/sign_version.dart';
import 'event/progress_input_stream.dart';
import 'http_method.dart';
import 'model/abort_multipart_upload_request.dart';
import 'model/access_control_list.dart';
import 'model/add_bucket_cname_request.dart';
import 'model/add_bucket_cname_result.dart';
import 'model/add_bucket_replication_request.dart';
import 'model/append_object_request.dart';
import 'model/append_object_result.dart';
import 'model/async_fetch_task_configuration.dart';
import 'model/bucket.dart';
import 'model/bucket_info.dart';
import 'model/bucket_list.dart';
import 'model/bucket_logging_result.dart';
import 'model/bucket_metadata.dart';
import 'model/bucket_process.dart';
import 'model/bucket_qos_info.dart';
import 'model/bucket_referer.dart';
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
import 'model/create_bucket_request.dart';
import 'model/create_bucket_vpcip_request.dart';
import 'model/create_directory_request.dart';
import 'model/create_live_channel_request.dart';
import 'model/create_live_channel_result.dart';
import 'model/create_select_object_metadata_request.dart';
import 'model/create_symlink_request.dart';
import 'model/create_udf_application_request.dart';
import 'model/create_udf_request.dart';
import 'model/create_vpcip_request.dart';
import 'model/create_vpcip_result.dart';
import 'model/delete_bucket_cname_request.dart';
import 'model/delete_bucket_inventory_configuration_request.dart';
import 'model/delete_bucket_replication_request.dart';
import 'model/delete_bucket_vpcip_request.dart';
import 'model/delete_directory_request.dart';
import 'model/delete_directory_result.dart';
import 'model/delete_objects_request.dart';
import 'model/delete_objects_result.dart';
import 'model/delete_version_request.dart';
import 'model/delete_versions_request.dart';
import 'model/delete_versions_result.dart';
import 'model/delete_vpcip_request.dart';
import 'model/download_file_request.dart';
import 'model/download_file_result.dart';
import 'model/extend_bucket_worm_request.dart';
import 'model/generate_presigned_url_request.dart';
import 'model/generate_rtmp_uri_request.dart';
import 'model/generate_vod_playlist_request.dart';
import 'model/generic_request.dart';
import 'model/generic_result.dart';
import 'model/get_async_fetch_task_request.dart';
import 'model/get_async_fetch_task_result.dart';
import 'model/get_bucket_image_result.dart';
import 'model/get_bucket_inventory_configuration_request.dart';
import 'model/get_bucket_inventory_configuration_result.dart';
import 'model/get_bucket_policy_result.dart';
import 'model/get_bucket_replication_progress_request.dart';
import 'model/get_bucket_request_payment_result.dart';
import 'model/get_bucket_resource_group_result.dart';
import 'model/get_bucket_worm_result.dart';
import 'model/get_image_style_result.dart';
import 'model/get_object_request.dart';
import 'model/get_udf_application_log_request.dart';
import 'model/get_vod_playlist_request.dart';
import 'model/head_object_request.dart';
import 'model/initiate_bucket_worm_request.dart';
import 'model/initiate_bucket_worm_result.dart';
import 'model/initiate_multipart_upload_request.dart';
import 'model/initiate_multipart_upload_result.dart';
import 'model/inventory_configuration.dart';
import 'model/lifecycle_rule.dart';
import 'model/list_bucket_inventory_configurations_request.dart';
import 'model/list_bucket_inventory_configurations_result.dart';
import 'model/list_buckets_request.dart';
import 'model/list_live_channels_request.dart';
import 'model/list_multipart_uploads_request.dart';
import 'model/list_objects_request.dart';
import 'model/list_objects_v2_request.dart';
import 'model/list_objects_v2_result.dart';
import 'model/list_parts_request.dart';
import 'model/list_versions_request.dart';
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
import 'model/object_metadata.dart';
import 'model/oss_object.dart';
import 'model/oss_symlink.dart';
import 'model/part_listing.dart';
import 'model/payer.dart';
import 'model/policy_conditions.dart';
import 'model/process_object_request.dart';
import 'model/pub_bucket_image_request.dart';
import 'model/pub_object_request.dart';
import 'model/put_image_style_request.dart';
import 'model/put_object_result.dart';
import 'model/rename_object_request.dart';
import 'model/replication_rule.dart';
import 'model/resize_udf_application_request.dart';
import 'model/restore_configuration.dart';
import 'model/restore_object_request.dart';
import 'model/restore_object_result.dart';
import 'model/select_object_metadata.dart';
import 'model/select_object_request.dart';
import 'model/server_side_encryption_configuration.dart';
import 'model/set_async_fetch_task_request.dart';
import 'model/set_async_fetch_task_result.dart';
import 'model/set_bucket_acl_request.dart';
import 'model/set_bucket_cors_request.dart';
import 'model/set_bucket_encryption_request.dart';
import 'model/set_bucket_inventory_configuration_request.dart';
import 'model/set_bucket_lifecycle_request.dart';
import 'model/set_bucket_logging_request.dart';
import 'model/set_bucket_policy_request.dart';
import 'model/set_bucket_process_request.dart';
import 'model/set_bucket_qos_info_request.dart';
import 'model/set_bucket_referer_request.dart';
import 'model/set_bucket_request_payment_request.dart';
import 'model/set_bucket_resource_group_request.dart';
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
import 'model/transfer_acceleration.dart';
import 'model/udf_application_info.dart';
import 'model/udf_application_log.dart';
import 'model/udf_generic_request.dart';
import 'model/udf_image_info.dart';
import 'model/udf_info.dart';
import 'model/upgrade_udf_application_request.dart';
import 'model/upload_file_request.dart';
import 'model/upload_file_result.dart';
import 'model/upload_part_copy_request.dart';
import 'model/upload_part_copy_result.dart';
import 'model/upload_part_request.dart';
import 'model/upload_part_result.dart';
import 'model/upload_udf_image_request.dart';
import 'model/user_qos.dart';
import 'model/user_qos_info.dart';
import 'model/version_listing.dart';
import 'model/void_result.dart';
import 'model/vpc_ip.dart';
import 'model/vpc_policy.dart';

/// Entry point interface of Alibaba Cloud's OSS (Object Store Service)
/// <p>
/// Object Store Service (a.k.a OSS) is the massive, secure, low cost and highly
/// reliable  storage which could be accessed from anywhere at anytime via
/// REST APIs, SDKs or web console. <br>
/// Developers could use OSS to create any services that need huge data storage
/// and access throughput, such as media sharing web apps, cloud storage service
/// or enterprise or personal data backup.
/// </p>
abstract class OSS {
  /// Switches to another users with specified credentials
  ///
  /// @param creds
  ///              the credential to switch to。
  void switchCredentials(Credentials creds);

  /// Switches to another signature version
  ///
  /// @param signatureVersion
  ///                         the signature version to switch to。
  void switchSignatureVersion(SignVersion signatureVersion);

  /// Shuts down the OSS instance (release all resources) The OSS instance is
  /// not usable after its shutdown() is called.
  void shutdown();

  /// Get the statistics of the connection pool.
  String getConnectionPoolStats();

  /// Creates {@link Bucket} instance. The bucket name specified must be
  /// globally unique and follow the naming rules from
  /// https://www.alibabacloud.com/help/doc-detail/31827.htm?spm=a3c0i.o32012en
  /// .a3.1.64ece5e0jPpa2t.
  ///
  /// @param bucketName
  ///                   bucket name
  Bucket createBucket(String bucketName);

  /// Creates a {@link Bucket} instance with specified CreateBucketRequest
  /// information.
  ///
  /// @param createBucketRequest
  ///                            instance of {@link CreateBucketRequest}, which at
  ///                            least has
  ///                            bucket name information.
  Bucket createBucketWithRequest(CreateBucketRequest createBucketRequest);

  /// Deletes the {@link Bucket} instance. A non-empty bucket could not be
  /// deleted.
  ///
  /// @param bucketName
  ///                   bucket name to delete.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteBucket(String bucketName);

  /// Deletes the {@link Bucket} instance.
  ///
  /// @param genericRequest
  ///                       the generic request instance that has the bucket name
  ///                       information.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteBucketWithRequest(GenericRequest genericRequest);

  /// Returns all {@link Bucket} instances of the current account.
  ///
  /// @return A list of {@link Bucket} instances. If there's no buckets, the
  ///         list will be empty (instead of null).
  List<Bucket> listBucketsEmpty();

  /// Returns all {@link Bucket} instances of the current account that meet the
  /// conditions specified.
  ///
  /// @param prefix
  ///                The prefix of the bucket name returned. If null, the bucket
  ///                name could have any prefix.
  /// @param marker
  ///                The start point in the lexicographic order for the buckets to
  ///                return. If null, return the buckets from the beginning in the
  ///                lexicographic order. For example, if the account has buckets
  ///                bk1, bk2, bk3. If the marker is set as bk2, then only bk2 and
  ///                bk3 meet the criteria. But if the marker is null, then all
  ///                three buckets meet the criteria.
  /// @param maxKeys
  ///                Max bucket count to return. The valid value is from 1 to 1000,
  ///                default is 100 if it's null.
  /// @return The list of {@link Bucket} instances.
  BucketList listBuckets(String prefix, String marker, int maxKeys);

  /// Returns all {@link Bucket} instances of the current account that meet the
  /// conditions specified.
  ///
  /// @param listBucketsRequest
  ///                           the ListBucketsRequest instance that defines the
  ///                           criteria
  ///                           which could have requirements on prefix, marker,
  ///                           maxKeys.
  /// @return The list of {@link Bucket} instances.
  BucketList listBucketsWithRequest(ListBucketsRequest listBucketsRequest);

  /// Applies the Access Control List(ACL) on the {@link Bucket}.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param acl
  ///                   {@link CannedAccessControlList} instance. If the instance
  ///                   is
  ///                   null, no ACL change on the bucket WithRequest(but the Request is still
  ///                   sent).
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketAcl(String bucketName, CannedAccessControlList acl);

  /// Sends the request to apply ACL on a {@link Bucket} instance.
  ///
  /// @param setBucketAclRequest
  ///                            SetBucketAclRequest instance which specifies the
  ///                            ACL and the
  ///                            bucket information.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketAclWithRequest(SetBucketAclRequest setBucketAclRequest);

  /// Returns the Access control List (ACL) of the {@link Bucket} instance.
  ///
  /// @param bucketName
  ///                   Bucket Name.
  /// @return Access Control List(ACL) {@link AccessControlList}.
  AccessControlList getBucketAcl(String bucketName);

  /// Gets the Access Control List(ACL) of the {@link Bucket} instance.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name
  ///                       information.
  /// @return {@link AccessControlList} instance.
  AccessControlList getBucketAclWithRequest(GenericRequest genericRequest);

  /// Gets the metadata of {@link Bucket}.
  ///
  /// @param bucketName
  ///                   Bucket name.
  ///
  /// @return The {@link BucketMetadata} instance.
  BucketMetadata getBucketMetadata(String bucketName);

  /// Gets all the metadata of {@link Bucket}.
  ///
  /// @param genericRequest
  ///                       Generic request which specifies the bucket name.
  ///
  /// @return The {@link BucketMetadata} instance.
  ///
  BucketMetadata getBucketMetadataWithRequest(GenericRequest genericRequest);

  /// Sets the http referer on the {@link Bucket} instance specified by the
  /// bucket name.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param referer
  ///                   The {@link BucketReferer} instance. If null, it would
  ///                   create a
  ///                   {@link BucketReferer} instance from default constructor.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketReferer(String bucketName, BucketReferer referer);

  /// Sets the http referer on the {@link Bucket} instance in the parameter
  /// setBucketRefererRequest.
  ///
  /// @param setBucketRefererRequest
  ///                                {@link SetBucketRefererRequest} instance that
  ///                                specify the
  ///                                bucket name and the {@link BucketReferer}
  ///                                instance.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketRefererWithRequest(
      SetBucketRefererRequest setBucketRefererRequest);

  /// Returns http referer information of the {@link Bucket} specified by
  /// bucket name.
  ///
  /// @param bucketName
  ///                   Bucket name
  /// @return {@link BucketReferer} instance. The BucketReferer object with
  ///         empty referer information is returned if there's no http referer
  ///         information.
  BucketReferer getBucketReferer(String bucketName);

  /// Returns http referer information of the {@link Bucket} specified by
  /// bucket name in GenericRequest object.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  /// @return bucket http referer {@link BucketReferer}。
  BucketReferer getBucketRefererWithRequest(GenericRequest genericRequest);

  /// Returns the datacenter name where the {@link Bucket} instance is hosted.
  /// As of 08/03/2017, the valid datacenter names are oss-cn-hangzhou,
  /// oss-cn-qingdao, oss-cn-beijing, oss-cn-hongkong, oss-cn-shenzhen,
  /// oss-cn-shanghai, oss-us-west-1, oss-us-east-1, and oss-ap-southeast-1.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return The datacenter name in string.
  String getBucketLocation(String bucketName);

  /// Returns the datacenter name where the {@link Bucket} instance specified
  /// by GenericRequest is hosted.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance with bucket name
  ///                       information.
  /// @return The datacenter name in string.
  String getBucketLocationWithRequest(GenericRequest genericRequest);

  /// Sets the tags on the {@link Bucket} instance specified by the bucket name
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param tags
  ///                   The dictionary that contains the tags in the form of
  ///                   &lt;key,
  ///                   value&gt; pairs
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketTagging(String bucketName, Map<String, String> tags);

  /// Sets the tags on the {@link Bucket} instance.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param tagSet
  ///                   {@link TagSet} instance that has the tags in the form of
  ///                   &lt;key,
  ///                   value&gt; paris.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketTaggingWithTagSet(String bucketName, TagSet tagSet);

  /// Sets the tags on the {@link Bucket} instance in
  /// {@link SetBucketTaggingRequest} object.
  ///
  /// @param setBucketTaggingRequest
  ///                                {@link SetBucketTaggingRequest} instance that
  ///                                has bucket
  ///                                information as well as tagging information.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketTaggingWithRequest(
      SetBucketTaggingRequest setBucketTaggingRequest);

  /// Gets all tags of the {@link Bucket} instance.
  ///
  /// @param bucketName
  ///                   Bucket name
  /// @return A {@link TagSet} instance. If there's no tag, the TagSet object
  ///         with empty tag information is returned.
  TagSet getBucketTagging(String bucketName);

  /// Gets the tags of {@link Bucket} instance.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  /// @return A {@link TagSet} instance.
  TagSet getBucketTaggingWithRequest(GenericRequest genericRequest);

  /// Clears all the tags of the {@link Bucket} instance。
  ///
  /// @param bucketName
  ///                   Bucket name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteBucketTagging(String bucketName);

  /// Clears all the tags of the {@link Bucket} instance.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteBucketTaggingWithRequest(GenericRequest genericRequest);

  /// <p>
  /// Returns the versioning configuration for the specified bucket.
  /// </p>
  /// <p>
  /// A bucket's versioning configuration can be in one of three possible
  /// states:
  /// <ul>
  /// <li>{@link BucketVersioningConfiguration#OFF}
  /// <li>{@link BucketVersioningConfiguration#ENABLED}
  /// <li>{@link BucketVersioningConfiguration#SUSPENDED}
  /// </ul>
  /// </p>
  /// <p>
  /// By default, new buckets are in the
  /// {@link BucketVersioningConfiguration#OFF off} state. Once versioning is
  /// enabled for a bucket the status can never be reverted to
  /// {@link BucketVersioningConfiguration#OFF off}.
  /// </p>
  /// <p>
  /// The versioning configuration of a bucket has different implications for
  /// each operation performed on that bucket or for objects within that
  /// bucket. For example, when versioning is enabled a <code>PutObject</code>
  /// operation creates a unique object version-id for the object being uploaded.
  /// The
  /// The <code>PutObject</code> API guarantees that, if versioning is enabled for
  /// a bucket at
  /// the time of the request, the new object can only be permanently deleted
  /// using a <code>DeleteVersion</code> operation. It can never be overwritten.
  /// Additionally, the <code>PutObject</code> API guarantees that,
  /// if versioning is enabled for a bucket the request,
  /// no other object will be overwritten by that request.
  /// </p>
  /// <p>
  /// OSS is eventually consistent. It can take time for the versioning status
  /// of a bucket to be propagated throughout the system.
  /// </p>
  ///
  /// @param bucketName
  ///                   The bucket whose versioning configuration will be
  ///                   retrieved.
  ///
  /// @return The bucket versioning configuration for the specified bucket.
  ///
  /// @throws ClientException
  ///                         If any errors are encountered in the client while
  ///                         making the
  ///                         request or handling the response.
  /// @throws OSSException
  ///                         If any errors occurred in OSS while processing the
  ///                         request.
  ///
  /// @see OSS#setBucketVersioning(SetBucketVersioningRequest)
  /// @see OSS#getBucketVersioning(GenericRequest)
  BucketVersioningConfiguration getBucketVersioning(String bucketName);

  /// <p>
  /// Returns the versioning configuration for the specified bucket.
  /// </p>
  /// <p>
  /// A bucket's versioning configuration can be in one of three possible
  /// states:
  /// <ul>
  /// <li>{@link BucketVersioningConfiguration#OFF}
  /// <li>{@link BucketVersioningConfiguration#ENABLED}
  /// <li>{@link BucketVersioningConfiguration#SUSPENDED}
  /// </ul>
  /// </p>
  /// <p>
  /// By default, new buckets are in the
  /// {@link BucketVersioningConfiguration#OFF off} state. Once versioning is
  /// enabled for a bucket the status can never be reverted to
  /// {@link BucketVersioningConfiguration#OFF off}.
  /// </p>
  /// <p>
  /// The versioning configuration of a bucket has different implications for
  /// each operation performed on that bucket or for objects within that
  /// bucket. For example, when versioning is enabled a <code>PutObject</code>
  /// operation creates a unique object version-id for the object being uploaded.
  /// The
  /// The <code>PutObject</code> API guarantees that, if versioning is enabled for
  /// a bucket at
  /// the time of the request, the new object can only be permanently deleted
  /// using a <code>DeleteVersion</code> operation. It can never be overwritten.
  /// Additionally, the <code>PutObject</code> API guarantees that,
  /// if versioning is enabled for a bucket the request,
  /// no other object will be overwritten by that request.
  /// </p>
  /// <p>
  /// OSS is eventually consistent. It can take time for the versioning status
  /// of a bucket to be propagated throughout the system.
  /// </p>
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  ///
  /// @return The bucket versioning configuration for the specified bucket.
  ///
  /// @throws ClientException
  ///                         If any errors are encountered in the client while
  ///                         making the
  ///                         request or handling the response.
  /// @throws OSSException
  ///                         If any errors occurred in OSS while processing the
  ///                         request.
  ///
  /// @see OSS#setBucketVersioning(SetBucketVersioningRequest)
  /// @see OSS#getBucketVersioning(String)
  BucketVersioningConfiguration getBucketVersioningWithRequest(
      GenericRequest genericRequest);

  /// <p>
  /// Sets the versioning configuration for the specified bucket.
  /// </p>
  /// <p>
  /// A bucket's versioning configuration can be in one of three possible
  /// states:
  /// <ul>
  /// <li>{@link BucketVersioningConfiguration#OFF}
  /// <li>{@link BucketVersioningConfiguration#ENABLED}
  /// <li>{@link BucketVersioningConfiguration#SUSPENDED}
  /// </ul>
  /// </p>
  /// <p>
  /// By default, new buckets are in the
  /// {@link BucketVersioningConfiguration#OFF off} state. Once versioning is
  /// enabled for a bucket the status can never be reverted to
  /// {@link BucketVersioningConfiguration#OFF off}.
  /// </p>
  /// <p>
  /// Objects created before versioning was enabled or when versioning is
  /// suspended will be given the default <code>null</code> version ID (see
  /// {@link com.aliyun.oss.internal.OSSConstants#NULL_VERSION_ID}). Note that the
  /// <code>null</code> version ID is a valid version ID and is not the
  /// same as not having a version ID.
  /// </p>
  /// <p>
  /// The versioning configuration of a bucket has different implications for
  /// each operation performed on that bucket or for objects within that
  /// bucket. For example, when versioning is enabled a <code>PutObject</code>
  /// operation creates a unique object version-id for the object being uploaded.
  /// The
  /// The <code>PutObject</code> API guarantees that, if versioning is enabled for
  /// a bucket at
  /// the time of the request, the new object can only be permanently deleted
  /// using a <code>DeleteVersion</code> operation. It can never be overwritten.
  /// Additionally, the <code>PutObject</code> API guarantees that,
  /// if versioning is enabled for a bucket the request,
  /// no other object will be overwritten by that request.
  /// Refer to the documentation sections for each API for information on how
  /// versioning status affects the semantics of that particular API.
  /// </p>
  /// <p>
  /// OSS is eventually consistent. It can take time for the versioning status
  /// of a bucket to be propagated throughout the system.
  /// </p>
  ///
  /// @param setBucketVersioningRequest
  ///                                   The request object containing all options
  ///                                   for setting the
  ///                                   bucket versioning configuration.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws ClientException
  ///                         If any errors are encountered in the client while
  ///                         making the
  ///                         request or handling the response.
  /// @throws OSSException
  ///                         If any errors occurred in OSS while processing the
  ///                         request.
  ///
  /// @see OSS#getBucketVersioning(String)
  VoidResult setBucketVersioningWithRequest(
      SetBucketVersioningRequest setBucketVersioningRequest);

  /// Checks the {@link Bucket} exists .
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return Returns true if the bucket exists and false if not.
  bool doesBucketExist(String bucketName);

  /// Checks if the {@link Bucket} exists。
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  /// @return Returns true if the bucket exists and false if not.
  bool doesBucketExistWithRequest(GenericRequest genericRequest);

  /// Lists all objects under the specified {@link Bucket} with the specified
  /// prefix.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param prefix
  ///                   The prefix returned object must have.
  /// @return A {@link ObjectListing} instance that has all objects
  /// @throws OSSException
  /// @throws ClientException
  ObjectListing listObjects(String bucketName, [String? prefix]);

  /// Lists all objects under the specified {@link Bucket} in the parameter of
  /// {@link ListObjectsRequest}
  ///
  /// @param listObjectsRequest
  ///                           The {@link ListObjectsRequest} instance that
  ///                           defines the
  ///                           bucket name as well as the criteria such as prefix,
  ///                           marker,
  ///                           maxKeys, delimiter, etc.
  /// @return A {@link ObjectListing} instance that has the objects meet the
  ///         criteria
  /// @throws OSSException
  /// @throws ClientException
  ObjectListing listObjectsWithRequest(ListObjectsRequest listObjectsRequest);

  /// Lists all objects under the specified {@link Bucket} in the parameter of
  /// {@link ListObjectsRequest}
  ///
  /// @param listObjectsV2Request
  ///                             The {@link ListObjectsRequest} instance that
  ///                             defines the
  ///                             bucket name as well as the criteria such as
  ///                             prefix, marker,
  ///                             maxKeys, delimiter, etc.
  ///
  /// @return A {@link ListObjectsV2Result} instance that has the objects meet the
  ///         criteria
  ///
  /// @throws OSSException
  /// @throws ClientException
  ListObjectsV2Result listObjectsV2WithRequest(
      ListObjectsV2Request listObjectsV2Request);

  /// Lists all objects under the specified {@link Bucket} in the parameter of
  /// {@link ListObjectsRequest}
  ///
  /// @param bucketName
  ///                          The bucket name.
  /// @param prefix
  ///                          The prefix restricting the objects listing.
  /// @param continuationToken
  ///                          The continuation token allows list to be continued
  ///                          from a specific point.
  ///                          It values the last result
  ///                          {@link ListObjectsV2Result#getNextContinuationToken()}.
  /// @param startAfter
  ///                          Where you want oss to start the object listing from.
  /// @param delimiter
  ///                          The delimiter for condensing common prefixes in the
  ///                          returned listing results.
  /// @param maxKeys
  ///                          The maximum number of results to return.
  /// @param encodingType
  ///                          the encoding method to be applied on the response.
  /// @param fetchOwner
  ///                          Whether to get the owner filed in the response or
  ///                          not.
  ///
  /// @return A {@link ListObjectsV2Result} instance that has the listing result.
  ///
  /// @throws OSSException
  /// @throws ClientException
  ListObjectsV2Result listObjectsV2(
      String bucketName,
      [String? prefix,
      String? continuationToken,
      String? startAfter,
      String? delimiter,
      int maxKeys = 0,
      String? encodingType,
      bool fetchOwner = false ]);

  /// <p>
  /// Returns a list of summary information about the versions in the specified
  /// bucket.
  /// </p>
  /// <p>
  /// The returned version summaries are ordered first by key and then by
  /// version. Keys are sorted lexicographically (alphabetically)
  /// and versions are sorted from most recent to least recent.
  /// Versions
  /// with data and delete markers are included in the results.
  /// </p>
  /// <p>
  /// Because buckets can contain a virtually unlimited number of versions, the
  /// complete results of a list query can be extremely large. To manage large
  /// result sets, OSS uses pagination to split them into multiple
  /// responses. Always check the
  /// {@link VersionListing#isTruncated()} method to determine if the
  /// returned listing is complete or if additional calls are needed
  /// to get more results.
  /// </p>
  /// <p>
  /// The <code>keyMarker</code> and <code>versionIdMarker</code> parameters allow
  /// callers to specify where to start the version listing.
  /// </p>
  /// <p>
  /// The <code>delimiter</code> parameter allows groups of keys that share a
  /// delimiter-terminated prefix to be included
  /// in the returned listing. This allows applications to organize and browse
  /// their keys hierarchically, much like how a file system organizes
  /// files into directories. These common prefixes can be retrieved
  /// by calling the {@link VersionListing#getCommonPrefixes()} method.
  /// </p>
  /// <p>
  /// For example, consider a bucket that contains the following keys:
  /// <ul>
  /// <li>"foo/bar/baz"</li>
  /// <li>"foo/bar/bash"</li>
  /// <li>"foo/bar/bang"</li>
  /// <li>"foo/boo"</li>
  /// </ul>
  /// If calling <code>listVersions</code> with
  /// a <code>prefix</code> value of "foo/" and a <code>delimiter</code> value of
  /// "/"
  /// on this bucket, a <code>VersionListing</code> is returned that contains:
  /// <ul>
  /// <li>all the versions for one key ("foo/boo")</li>
  /// <li>one entry in the common prefixes list ("foo/bar/")</li>
  /// </ul>
  /// </p>
  /// <p>
  /// To see deeper into the virtual hierarchy, make
  /// another call to <code>listVersions</code> setting the prefix parameter to any
  /// interesting common prefix to list the individual versions under that
  /// prefix.
  /// </p>
  /// <p>
  /// For more information about enabling versioning for a bucket, see
  /// {@link #setBucketVersioning(SetBucketVersioningRequest)}.
  /// </p>
  ///
  /// @param bucketName
  ///                        The name of the OSS bucket whose versions are to be
  ///                        listed.
  /// @param prefix
  ///                        An optional parameter restricting the response to keys
  ///                        that
  ///                        begin with the specified prefix. Use prefixes to
  ///                        separate a bucket into different sets of keys,
  ///                        similar to how a file system organizes files
  ///                        into directories.
  /// @param keyMarker
  ///                        Optional parameter indicating where in the sorted list
  ///                        of all
  ///                        versions in the specified bucket to begin returning
  ///                        results.
  ///                        Results are always ordered first lexicographically
  ///                        (i.e.
  ///                        alphabetically) and then from most recent version to
  ///                        least
  ///                        recent version. If a keyMarker is used without a
  ///                        versionIdMarker, results begin immediately after that
  ///                        key's
  ///                        last version. When a keyMarker is used with a
  ///                        versionIdMarker,
  ///                        results begin immediately after the version with the
  ///                        specified
  ///                        key and version ID.
  ///                        <p>
  ///                        This enables pagination; to get the next page of
  ///                        results use
  ///                        the next key marker and next version ID marker (from
  ///                        {@link VersionListing#getNextKeyMarker()} and
  ///                        {@link VersionListing#getNextVersionIdMarker()}) as
  ///                        the
  ///                        markers for the next request to list versions.
  /// @param versionIdMarker
  ///                        Optional parameter indicating where in the sorted list
  ///                        of all
  ///                        versions in the specified bucket to begin returning
  ///                        results.
  ///                        Results are always ordered first lexicographically
  ///                        (i.e.
  ///                        alphabetically) and then from most recent version to
  ///                        least
  ///                        recent version. A keyMarker must be specified when
  ///                        specifying
  ///                        a versionIdMarker. Results begin immediately after the
  ///                        version
  ///                        with the specified key and version ID.
  ///                        <p>
  ///                        This enables pagination; to get the next page of
  ///                        results use
  ///                        the next key marker and next version ID marker (from
  ///                        {@link VersionListing#getNextKeyMarker()} and
  ///                        {@link VersionListing#getNextVersionIdMarker()}) as
  ///                        the
  ///                        markers for the next request to list versions.
  /// @param delimiter
  ///                        Optional parameter that causes keys that contain the
  ///                        same
  ///                        string between the prefix and the first occurrence of
  ///                        the
  ///                        delimiter to be rolled up into a single result element
  ///                        in the
  ///                        {@link VersionListing#getCommonPrefixes()} list. These
  ///                        rolled-up keys are not returned elsewhere in the
  ///                        response. The
  ///                        most commonly used delimiter is "/", which simulates a
  ///                        hierarchical organization similar to a file system
  ///                        directory
  ///                        structure.
  /// @param maxResults
  ///                        Optional parameter indicating the maximum number of
  ///                        results to
  ///                        include in the response. OSS might return fewer than
  ///                        this, but will not return more. Even if maxResults is
  ///                        not
  ///                        specified, OSS will limit the number of results in the
  ///                        response.
  ///
  /// @return A listing of the versions in the specified bucket, aint with any
  ///         other associated information such as common prefixes (if a
  ///         delimiter was specified), the original request parameters, etc.
  ///
  /// @throws ClientException
  ///                         If any errors are encountered in the client while
  ///                         making the
  ///                         request or handling the response.
  /// @throws OSSException
  ///                         If any errors occurred in OSS while processing the
  ///                         request.
  ///
  /// @see OSSClient#listVersions(String, String)
  /// @see OSSClient#listVersions(ListVersionsRequest)
  VersionListing listVersions(
      String bucketName,
      String prefix,
      [String? keyMarker,
      String? versionIdMarker,
      String? delimiter,
      int? maxResults]);

  /// <p>
  /// Returns a list of summary information about the versions in the specified
  /// bucket.
  /// </p>
  /// <p>
  /// The returned version summaries are ordered first by key and then by
  /// version. Keys are sorted lexicographically (alphabetically)
  /// and versions are sorted from most recent to least recent.
  /// Versions
  /// with data and delete markers are included in the results.
  /// </p>
  /// <p>
  /// Because buckets can contain a virtually unlimited number of versions, the
  /// complete results of a list query can be extremely large. To manage large
  /// result sets, OSS uses pagination to split them into multiple
  /// responses. Always check the
  /// {@link VersionListing#isTruncated()} method to determine if the
  /// returned listing is complete or if additional calls are needed
  /// to get more results.
  /// </p>
  /// <p>
  /// The <code>keyMarker</code> and <code>versionIdMarker</code> parameters allow
  /// callers to specify where to start the version listing.
  /// </p>
  /// <p>
  /// The <code>delimiter</code> parameter allows groups of keys that share a
  /// delimiter-terminated prefix to be included
  /// in the returned listing. This allows applications to organize and browse
  /// their keys hierarchically, much like how a file system organizes
  /// files into directories. These common prefixes can be retrieved
  /// by calling the {@link VersionListing#getCommonPrefixes()} method.
  /// </p>
  /// <p>
  /// For example, consider a bucket that contains the following keys:
  /// <ul>
  /// <li>"foo/bar/baz"</li>
  /// <li>"foo/bar/bash"</li>
  /// <li>"foo/bar/bang"</li>
  /// <li>"foo/boo"</li>
  /// </ul>
  /// If calling <code>listVersions</code> with
  /// a <code>prefix</code> value of "foo/" and a <code>delimiter</code> value of
  /// "/"
  /// on this bucket, a <code>VersionListing</code> is returned that contains:
  /// <ul>
  /// <li>all the versions for one key ("foo/boo")</li>
  /// <li>one entry in the common prefixes list ("foo/bar/")</li>
  /// </ul>
  /// </p>
  /// <p>
  /// To see deeper into the virtual hierarchy, make
  /// another call to <code>listVersions</code> setting the prefix parameter to any
  /// interesting common prefix to list the individual versions under that
  /// prefix.
  /// </p>
  /// <p>
  /// For more information about enabling versioning for a bucket, see
  /// {@link #setBucketVersioning(SetBucketVersioningRequest)}.
  /// </p>
  ///
  /// @param listVersionsRequest
  ///                            The request object containing all options for
  ///                            listing the
  ///                            versions in a specified bucket.
  ///
  /// @return A listing of the versions in the specified bucket, aint with any
  ///         other associated information such as common prefixes (if a
  ///         delimiter was specified), the original request parameters, etc.
  ///
  /// @throws ClientException
  ///                         If any errors are encountered in the client while
  ///                         making the
  ///                         request or handling the response.
  /// @throws OSSException
  ///                         If any errors occurred in OSS while processing the
  ///                         request.
  ///
  /// @see OSSClient#listVersions(String, String)
  /// @see OSSClient#listVersions(String, String, String, String, String, Integer)
  VersionListing listVersionsWithRequest(
      ListVersionsRequest listVersionsRequest);

  /// Uploads the file to the {@link Bucket} from the @{link InputStream} with
  /// the {@link ObjectMetadata} information。
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object key.
  /// @param input
  ///                   {@link InputStream} instance to write from. It must be
  ///                   readable.
  /// @param metadata
  ///                   The {@link ObjectMetadata} instance. If it does not specify
  ///                   the Content-Length information, the data is encoded by
  ///                   chunked
  ///                   tranfer encoding.
  PutObjectResult putObjectWithStream(String bucketName, String key, InputStream input,
      [ObjectMetadata? metadata]);

  /// Uploads the file to the {@link Bucket} from the file with the
  /// {@link ObjectMetadata}.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object key.
  /// @param file
  ///                   File object to read from.
  /// @param metadata
  ///                   The {@link ObjectMetadata} instance. If it does not specify
  ///                   the Content-Length information, the data is encoded by
  ///                   chunked
  ///                   tranfer encoding.
  PutObjectResult putObjectWithFile(
      String bucketName, String key, File file, [ObjectMetadata? metadata]);

  /// Uploads the file to {@link Bucket}.
  ///
  /// @param putObjectRequest
  ///                         The {@link PutObjectRequest} instance that has bucket
  ///                         name,
  ///                         object key, metadata information.
  /// @return A {@link PutObjectResult} instance.
  /// @throws OSSException
  /// @throws ClientException
  PutObjectResult putObjectWithRequest(PutObjectRequest putObjectRequest);

  /// Uploads the file from a specified file path to the signed URL with
  /// specified headers with the flag of using chunked tranfer encoding.
  ///
  /// @param signedUrl
  ///                         Signed url, which has the bucket name, object key,
  ///                         account
  ///                         information and accessed Ids and its signature. The
  ///                         url is
  ///                         recommended to be generated by
  ///                         generatePresignedUrl().
  /// @param filePath
  ///                         The file path to read from.
  /// @param requestHeaders
  ///                         Request headers, including standard or customized
  ///                         http headers
  ///                         documented by PutObject REST API.
  /// @param useChunkEncoding
  ///                         The flag of using chunked transfer encoding.
  /// @return A {@link PutObjectResult} instance.
  PutObjectResult putObjectWithHeaders(Uri signedUrl, String filePath,
      Map<String, String> requestHeaders, [bool useChunkEncoding = false]);

  /// Uploads the file from a InputStream instance to the signed URL with
  /// specified headers.
  ///
  /// @param signedUrl
  ///                         Signed Url, which has the bucket name, object key,
  ///                         account
  ///                         information and accessed Ids and its signature. The
  ///                         url is
  ///                         recommended to be generated by
  ///                         generatePresignedUrl().
  /// @param requestContent
  ///                         {@link InputStream} instance to read from.
  /// @param contentLength
  ///                         Hint content length to write. if useChunkEncoding is
  ///                         true,
  ///                         then -1 is used.
  /// @param requestHeaders
  ///                         Rquest headers,including standard or customized http
  ///                         headers
  ///                         documented by PutObject REST API.
  /// @param useChunkEncoding
  ///                         The flag of using chunked transfer encoding.
  /// @return A {@link PutObjectResult} instance.
  PutObjectResult putObject(
      Uri signedUrl,
      InputStream requestContent,
      int contentLength,
      Map<String, String> requestHeaders,
      [bool useChunkEncoding = false]);

  /// Copies an existing file in OSS from source bucket to the target bucket.
  /// If target file exists, it would be overwritten by the source file.
  ///
  /// @param sourceBucketName
  ///                              Source object's bucket name.
  /// @param sourceKey
  ///                              Source object's key.
  /// @param destinationBucketName
  ///                              Target object's bucket name.
  /// @param destinationKey
  ///                              Target object's key.
  /// @return A {@link CopyObjectResult} instance.
  /// @throws OSSException
  /// @throws ClientException
  CopyObjectResult copyObject(String sourceBucketName, String sourceKey,
      String destinationBucketName, String destinationKey);

  /// Copies an existing file in OSS from source bucket to the target bucket.
  /// If target file exists, it would be overwritten by the source file.
  ///
  /// @param copyObjectRequest
  ///                          A {@link CopyObjectRequest} instance that specifies
  ///                          source
  ///                          file, source bucket and target file, target bucket。
  /// @return A {@link CopyObjectResult} instance.
  /// @throws OSSException
  /// @throws ClientException
  CopyObjectResult copyObjectWithRequest(CopyObjectRequest copyObjectRequest);

  /// Gets a {@link OSSObject} from {@link Bucket}.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object Key.
  /// @return A {@link OSSObject} instance. The caller is responsible to close
  ///         the connection after usage.
  OSSObject getObject(String bucketName, String key);

  /// Downloads the file from a file specified by the {@link GetObjectRequest}
  /// parameter.
  ///
  /// @param getObjectRequest
  ///                         A {@link GetObjectRequest} instance which specifies
  ///                         bucket
  ///                         name and object key.
  /// @param file
  ///                         Target file instance to download as.
  ObjectMetadata getObjectWithRequestFile(
      GetObjectRequest getObjectRequest, File file);

  /// Gets the {@link OSSObject} from the bucket specified in
  /// {@link GetObjectRequest} parameter.
  ///
  /// @param getObjectRequest
  ///                         A {@link GetObjectRequest} instance which specifies
  ///                         the bucket
  ///                         name and the object key.
  /// @return A {@link OSSObject} instance of the bucket file. The caller is
  ///         responsible to close the connection after usage.
  OSSObject getObjectWithRequest(GetObjectRequest getObjectRequest);

  /// Select the {@link OSSObject} from the bucket specified in
  /// {@link SelectObjectRequest} parameter
  ///
  /// @param selectObjectRequest
  ///                            A {@link SelectObjectRequest} instance which
  ///                            specifies the
  ///                            bucket name
  ///                            object key
  ///                            filter expression
  ///                            input serialization
  ///                            output serialization
  /// @return A {@link OSSObject} instance will be returned. The caller is
  ///         responsible to close the connection after usage.
  /// @throws OSSException
  /// @throws ClientException
  OSSObject selectObjectWithRequest(SelectObjectRequest selectObjectRequest);

  /// Gets the {@link OSSObject} from the signed Url.
  ///
  /// @param signedUrl
  ///                       The signed Url.
  /// @param requestHeaders
  ///                       Request headers, including http standard or OSS
  ///                       customized
  ///                       headers.
  /// @return A{@link OSSObject} instance.The caller is responsible to close
  ///         the connection after usage.
  OSSObject getObjectWithHeader(Uri signedUrl, Map<String, String> requestHeaders);

  /// Gets the simplified metadata information of {@link OSSObject}.
  /// <p>
  /// Simplified metadata includes ETag, Size, LastModified and thus it's more
  /// lightweight then GetObjectMeta().
  /// </p>
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object key.
  /// @return A {@link SimplifiedObjectMeta} instance of the object.
  SimplifiedObjectMeta getSimplifiedObjectMeta(String bucketName, String key);

  /// Gets the simplified metadata information of {@link OSSObject}.
  /// <p>
  /// Simplified metadata includes ETag, Size, LastModified and thus it's more
  /// lightweight then GetObjectMeta().
  /// </p>
  ///
  /// @param genericRequest
  ///                       Generic request which specifies the bucket name and
  ///                       object key
  /// @return The {@link SimplifiedObjectMeta} instance of specified file.
  SimplifiedObjectMeta getSimplifiedObjectMetaWithRequest(
      GenericRequest genericRequest);

  /// Gets all the metadata of {@link OSSObject}.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object key.
  ///
  /// @return The {@link ObjectMetadata} instance.
  ObjectMetadata getObjectMetadata(String bucketName, String key);

  /// Gets all the metadata of {@link OSSObject}.
  ///
  /// @param genericRequest
  ///                       Generic request which specifies the bucket name and
  ///                       object
  ///                       key.
  ///
  /// @return The {@link ObjectMetadata} instance.
  ///
  ObjectMetadata getObjectMetadataWithRequest(GenericRequest genericRequest);

  /// Create select object metadata(create metadata if not exists or overwrite flag
  /// set in {@link CreateSelectObjectMetadataRequest})
  ///
  /// @param createSelectObjectMetadataRequest
  ///                                          {@link CreateSelectObjectMetadataRequest}
  ///                                          create select object metadata
  ///                                          request.
  ///
  /// @return The {@link SelectObjectMetadata} instance.
  SelectObjectMetadata createSelectObjectMetadataWithRequest(
      CreateSelectObjectMetadataRequest createSelectObjectMetadataRequest);

  /// Gets all the head data of {@link OSSObject}.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object key.
  ///
  /// @return The {@link ObjectMetadata} instance.
  ObjectMetadata headObject(String bucketName, String key);

  /// Gets all the head data of {@link OSSObject}.
  ///
  /// @param headObjectRequest
  ///                          A {@link HeadObjectRequest} instance which specifies
  ///                          the
  ///                          bucket name and object key, and some constraint
  ///                          information can be set.
  /// @return The {@link ObjectMetadata} instance.
  ObjectMetadata headObjectWithRequest(HeadObjectRequest headObjectRequest);

  /// Append the data to the appendable object specified in
  /// {@link AppendObjectRequest}. It's not applicable to normal OSS object.
  ///
  /// @param appendObjectRequest
  ///                            A {@link AppendObjectRequest} instance which
  ///                            specifies the
  ///                            bucket name, appendable object key, the file or
  ///                            the
  ///                            InputStream object to append.
  /// @return A {@link AppendObjectResult} instance.
  AppendObjectResult appendObjectWithRequest(
      AppendObjectRequest appendObjectRequest);

  /// Deletes the specified {@link OSSObject} by bucket name and object key.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object key.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteObject(String bucketName, String key);

  /// Deletes the specified {@link OSSObject} by the {@link GenericRequest}
  /// instance.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance that specfies the
  ///                       bucket
  ///                       name and object key.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteObjectWithRequest(GenericRequest genericRequest);

  /// Batch deletes the specified files under a specific bucket. If the files
  /// are non-exist, the operation will still return successful.
  ///
  /// @param deleteObjectsRequest
  ///                             A {@link DeleteObjectsRequest} instance which
  ///                             specifies the
  ///                             bucket and file keys to delete.
  /// @return A {@link DeleteObjectsResult} instance which specifies each
  ///         file's result in normal mode or only failed deletions in quite
  ///         mode. By default it's normal mode.
  DeleteObjectsResult deleteObjectsWithRequest(
      DeleteObjectsRequest deleteObjectsRequest);

  /// <p>
  /// Deletes a specific version of the specified object in the specified
  /// bucket. Once deleted, there is no method to restore or undelete an object
  /// version. This is the only way to permanently delete object versions that
  /// are protected by versioning.
  /// </p>
  /// <p>
  /// Deleting an object version is permanent and irreversible.
  /// It is a
  /// privileged operation that only the owner of the bucket containing the
  /// version can perform.
  /// </p>
  /// <p>
  /// Users can only delete a version of an object if versioning is enabled
  /// for the bucket.
  /// For more information about enabling versioning for a bucket, see
  /// {@link #setBucketVersioning(SetBucketVersioningRequest)}.
  /// </p>
  /// <p>
  /// If attempting to delete an object that does not exist,
  /// OSS will return a success message instead of an error message.
  /// </p>
  ///
  /// @param bucketName
  ///                   The name of the OSS bucket containing the object to delete.
  /// @param key
  ///                   The key of the object to delete.
  /// @param versionId
  ///                   The version of the object to delete.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws ClientException
  ///                         If any errors are encountered in the client while
  ///                         making the
  ///                         request or handling the response.
  /// @throws OSSException
  ///                         If any errors occurred in OSS while processing the
  ///                         request.
  VoidResult deleteVersion(String bucketName, String key, String versionId);

  /// <p>
  /// Deletes a specific version of an object in the specified bucket. Once
  /// deleted, there is no method to restore or undelete an object version.
  /// This is the only way to permanently delete object versions that are
  /// protected by versioning.
  /// </p>
  /// <p>
  /// Deleting an object version is permanent and irreversible.
  /// It is a
  /// privileged operation that only the owner of the bucket containing the
  /// version can perform.
  /// </p>
  /// <p>
  /// Users can only delete a version of an object if versioning is enabled
  /// for the bucket.
  /// For more information about enabling versioning for a bucket, see
  /// {@link #setBucketVersioning(SetBucketVersioningRequest)}.
  /// </p>
  /// <p>
  /// If attempting to delete an object that does not exist,
  /// OSS will return a success message instead of an error message.
  /// </p>
  ///
  /// @param deleteVersionRequest
  ///                             The request object containing all options for
  ///                             deleting a
  ///                             specific version of an OSS object.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws ClientException
  ///                         If any errors are encountered in the client while
  ///                         making the
  ///                         request or handling the response.
  /// @throws OSSException
  ///                         If any errors occurred in OSS while processing the
  ///                         request.
  VoidResult deleteVersionWithRequest(
      DeleteVersionRequest deleteVersionRequest);

  /// Batch deletes the specified object versions under a specific bucket. If the
  /// versions
  /// are non-exist, the operation will still return successful.
  ///
  /// @param deleteVersionsRequest
  ///                              A {@link DeleteVersionsRequest} instance which
  ///                              specifies the
  ///                              bucket and file keys to delete.
  /// @return A {@link DeleteVersionsResult} instance which specifies each
  ///         file's result in normal mode or only failed deletions in quite
  ///         mode. By default it's normal mode.
  DeleteVersionsResult deleteVersionsWithRequest(
      DeleteVersionsRequest deleteVersionsRequest);

  /// Checks if a specific {@link OSSObject} exists under the specific
  /// {@link Bucket}. 302 Redirect or OSS mirroring will not impact the result
  /// of this function.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object Key.
  /// @return True if exists; false if not.
  bool doesObjectExist(String bucketName, String key);

  /// Checks if a specific {@link OSSObject} exists under the specific
  /// {@link Bucket}. 302 Redirect or OSS mirroring will not impact the result
  /// of this function.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       and object key.
  /// @return True if exists; false if not.
  bool doesObjectExistWithGenericRequest(GenericRequest genericRequest);

  /// Checks if a specific {@link OSSObject} exists under the specific
  /// {@link Bucket}. 302 Redirect or OSS mirroring will impact the result of
  /// this function if isOnlyInOSS is true.
  ///
  /// @param bucketName
  ///                    Bucket name.
  /// @param key
  ///                    Object Key.
  /// @param isOnlyInOSS
  ///                    true if ignore 302 redirect or mirroring； false if
  ///                    considering
  ///                    302 redirect or mirroring, which could download the object
  ///                    from source to OSS when the file exists in source but is
  ///                    not
  ///                    in OSS yet.
  /// @return True if the file exists; false if not.
  bool doesObjectExistWithOSS(String bucketName, String key, bool isOnlyInOSS);

  /// Checks if a specific {@link OSSObject} exists under the specific
  /// {@link Bucket}. 302 Redirect or OSS mirroring will not impact the result
  /// of this function.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       and object key.
  /// @param isOnlyInOSS
  ///                       true if ignore 302 redirect or mirroring； false if
  ///                       considering
  ///                       302 redirect or mirroring, which could download the
  ///                       object
  ///                       from source to OSS when the file exists in source but
  ///                       is not
  ///                       in OSS yet.
  /// @return True if exists; false if not.
  bool doesObjectExistWithRequest(
      GenericRequest genericRequest, bool isOnlyInOSS);

  /// Sets the Access Control List (ACL) on a {@link OSSObject} instance.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object Key.
  /// @param cannedAcl
  ///                   One of the three values: , Read or
  ///                   ReadWrite.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setObjectAcl(
      String bucketName, String key, CannedAccessControlList cannedAcl);

  /// Sets the Access Control List (ACL) on a {@link OSSObject} instance.
  ///
  /// @param setObjectAclRequest
  ///                            A {@link SetObjectAclRequest} instance which
  ///                            specifies the
  ///                            object's bucket name and key as well as the ACL
  ///                            information.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setObjectAclWithRequest(SetObjectAclRequest setObjectAclRequest);

  /// Gets the Access Control List (ACL) of the OSS object.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object Key.
  /// @return The {@link ObjectAcl} instance of the object.
  ObjectAcl getObjectAcl(String bucketName, String key);

  /// Gets the Access Control List (ACL) of the OSS object.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name and object key.
  ObjectAcl getObjectAclWithRequest(GenericRequest genericRequest);

  /// Restores the object of archive storage. The function is not applicable to
  /// Normal or IA storage. The restoreObject() needs to be called prior to
  /// calling getObject() on an archive object.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object Key.
  /// @return A {@link RestoreObjectResult} instance.
  RestoreObjectResult restoreObject(String bucketName, String key);

  /// Restores the object of archive storage. The function is not applicable to
  /// Normal or IA storage. The restoreObject() needs to be called prior to
  /// calling getObject() on an archive object.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that specifies the
  ///                       bucket
  ///                       name and object key.
  /// @return A {@link RestoreObjectResult} instance.
  RestoreObjectResult restoreObjectWithGenericRequest(GenericRequest genericRequest);

  /// Restores the object of archive storage. The function is not applicable to
  /// Normal or IA storage. The restoreObject() needs to be called prior to
  /// calling getObject() on an archive object.
  ///
  /// @param bucketName
  ///                             Bucket name.
  /// @param key
  ///                             Object Key.
  /// @param restoreConfiguration
  ///                             A {@link RestoreConfiguration} instance that
  ///                             specifies the restore configuration.
  /// @return A {@link RestoreObjectResult} instance.
  RestoreObjectResult restoreObjectWithConfig(
      String bucketName, String key, RestoreConfiguration restoreConfiguration);

  /// Restores the object of archive storage. The function is not applicable to
  /// Normal or IA storage. The restoreObject() needs to be called prior to
  /// calling getObject() on an archive object.
  ///
  /// @param restoreObjectRequest
  ///                             A {@link RestoreObjectRequest} instance that
  ///                             specifies the bucket
  ///                             name, object key and restore configuration.
  /// @return A {@link RestoreObjectResult} instance.
  RestoreObjectResult restoreObjectWithRequest(
      RestoreObjectRequest restoreObjectRequest);

  /// Sets the tags on the OSS object.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object name.
  /// @param tags
  ///                   The dictionary that contains the tags in the form of
  ///                   &lt;key,
  ///                   value&gt; pairs.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setObjectTagging(
      String bucketName, String key, Map<String, String> tags);

  /// Sets the tags on the OSS object.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object name.
  /// @param tagSet
  ///                   {@link TagSet} instance that has the tags in the form of
  ///                   &lt;key,
  ///                   value&gt; pairs.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setObjectTaggingWithTagSet(String bucketName, String key, TagSet tagSet);

  /// Sets the tags on the OSS object.
  ///
  /// @param setObjectTaggingRequest
  ///                                {@link SetObjectTaggingRequest} instance that
  ///                                has object
  ///                                information as well as tagging information.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setObjectTaggingWithRequest(
      SetObjectTaggingRequest setObjectTaggingRequest);

  /// Gets all tags of the OSS object.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object name.
  /// @return A {@link TagSet} instance. If there's no tag, the TagSet object
  ///         with empty tag information is returned.
  TagSet getObjectTagging(String bucketName, String key);

  /// Gets all tags of the OSS object.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that specifies the
  ///                       bucket
  ///                       name and object name.
  /// @return A {@link TagSet} instance.
  TagSet getObjectTaggingWithRequest(GenericRequest genericRequest);

  /// Clears all the tags of the OSS object.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteObjectTagging(String bucketName, String key);

  /// Clears all the tags of the OSS object.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that specifies the
  ///                       bucket
  ///                       name and object name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult deleteObjectTaggingWithRequest(GenericRequest genericRequest);

  /// Generates a signed url for accessing the {@link OSSObject} with HTTP GET
  /// method.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object key.
  /// @param expiration
  ///                   URL's expiration time.
  /// @return A signed URL that could be used for accessing the
  ///         {@link OSSObject} object.
  /// @throws ClientException
  Uri generatePresignedUrl(String bucketName, String key, DateTime expiration);

  /// Generates a signed url for accessing the {@link OSSObject} with a
  /// specific HTTP method.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param key
  ///                   Object Key.
  /// @param expiration
  ///                   URL's expiration time.
  /// @param method
  ///                   HTTP method，Only {@link HttpMethod#GET} and
  ///                   {@link HttpMethod#PUT} are supported.
  /// @return A signed URL that could be used for accessing the
  ///         {@link OSSObject} object.
  /// @throws ClientException
  Uri generatePresignedUrlWithMethod(
      String bucketName, String key, DateTime expiration, HttpMethod method);

  /// Generates a signed url for accessing the {@link OSSObject} with a
  /// specific HTTP method.
  ///
  /// @param request
  ///                A {@link GeneratePresignedUrlRequest} instance which specifies
  ///                the bucket name, file key, expiration time, HTTP method, and
  ///                the MD5 signature of the content, etc.
  /// @return A signed URL that could be used for accessing the
  ///         {@link OSSObject} object.
  /// @throws ClientException
  Uri generatePresignedUrlWithRequest(GeneratePresignedUrlRequest request);

  /// Sets image processing attributes on the specific {@link Bucket}
  ///
  /// @param request
  ///                A {@link PutBucketImageRequest} instances which specifies some
  ///                attributes of image processing.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult putBucketImageWithRequest(PutBucketImageRequest request);

  /// Gets the image processing attributes on the specific {@link Bucket}.
  ///
  /// @param bucketName
  ///                   The bucket name
  /// @return A {@link GetBucketImageResult} instance which has attributes of
  ///         image processing
  /// @throws OSSException
  /// @throws ClientException
  GetBucketImageResult getBucketImage(String bucketName);

  /// Gets the image processing attributes on the specific {@link Bucket}.
  ///
  /// @param bucketName
  ///                       The bucket name.
  /// @param genericRequest
  ///                       The origin request.
  /// @return A {@link GetBucketImageResult} which has the attributes of image
  ///         processing.
  /// @throws OSSException
  /// @throws ClientException
  GetBucketImageResult getBucketImageWithRequest(
      String bucketName, GenericRequest genericRequest);

  /// Deletes the image processing attributes on the specific {@link Bucket}.
  ///
  /// @param bucketName
  ///                   Bucket name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketImage(String bucketName);

  /// Deletes the image processing attributes on the specific {@link Bucket}.
  ///
  /// @param bucketName
  ///                       Bucket name
  /// @param genericRequest
  ///                       The origin request
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketImageWithRequest(
      String bucketName, GenericRequest genericRequest);

  /// Deletes a style named by parameter styleName under {@link Bucket}
  ///
  /// @param bucketName
  ///                   Bucket name
  /// @param styleName
  ///                   Style name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteImageStyle(String bucketName, String styleName);

  /// Deletes a style named by parameter styleName under {@link Bucket}
  ///
  /// @param bucketName
  ///                       Bucket name
  /// @param styleName
  ///                       Style name
  /// @param genericRequest
  ///                       The origin request
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteImageStyleWithRequest(
      String bucketName, String styleName, GenericRequest genericRequest);

  /// Adds a new style under {@link Bucket}.
  ///
  /// @param putImageStyleRequest
  ///                             A {@link PutImageStyleRequest} instance that has
  ///                             bucket name
  ///                             and style information
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult putImageStyleWithRequest(
      PutImageStyleRequest putImageStyleRequest);

  /// Gets a style named by parameter styleName under {@link Bucket}
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param styleName
  ///                   Style name.
  /// @return A {@link GetImageStyleResult} instance which has the style
  ///         information if successful or error code if failed.
  /// @throws OSSException
  /// @throws ClientException
  GetImageStyleResult getImageStyle(String bucketName, String styleName);

  /// Gets a style named by parameter styleName under the {@link Bucket}
  ///
  /// @param bucketName
  ///                       Bucket name.
  /// @param styleName
  ///                       Style name.
  /// @param genericRequest
  ///                       The origin request.
  /// @return A {@link GetImageStyleResult} instance which has the style
  ///         information if successful or error code if failed.
  /// @throws OSSException
  /// @throws ClientException
  GetImageStyleResult getImageStyleWithRequest(
      String bucketName, String styleName, GenericRequest genericRequest);

  /// Lists all styles under the {@link Bucket}
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return A {@link List} of all styles of the Bucket. If there's no style,
  ///         it will be an empty list.
  /// @throws OSSException
  /// @throws ClientException
  List<Style> listImageStyle(String bucketName);

  /// Lists all styles under the {@link Bucket}
  ///
  /// @param bucketName
  ///                       Bucket name.
  /// @param genericRequest
  ///                       The origin request.
  /// @return A {@link List} of all styles of the Bucket. If there's no style,
  ///         it will be an empty list.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<Style> listImageStyleWithRequest(
      String bucketName, GenericRequest genericRequest);

  /// Creates the image accessing configuration according to the parameter
  /// setBucketProcessRequest.
  ///
  /// @param setBucketProcessRequest
  ///                                A {@link SetBucketTaggingRequest} instance
  ///                                that contains the
  ///                                image accessing configuration such as enable
  ///                                original picture
  ///                                protection, etc.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketProcessWithRequest(
      SetBucketProcessRequest setBucketProcessRequest);

  /// Gets the bucket's image accessing configuration.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return A {@link BucketProcess} which contains the image accessing
  ///         configurations if succeeds.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketProcess getBucketProcess(String bucketName);

  /// Get the bucket's image accessing configuration
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that has the bucket
  ///                       name.
  /// @return A {@link BucketProcess} which contains the image accessing
  ///         configurations if succeeds.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketProcess getBucketProcessWithRequest(GenericRequest genericRequest);

  /// Initiates a multiple part upload
  /// <p>
  /// Prior to starting a multiple part upload, this method needs to be called
  /// to ask OSS service do some initialization work. Upon a successful call,
  /// it returns a globally unique upload ID which could be used for the
  /// subsequent operations such as pause, lookup multiple parts, etc. This
  /// method will not automatically retry even if the max retry count is
  /// greater than 0, because it's not idempotent.
  /// </p>
  ///
  /// @param request
  ///                A {@link InitiateMultipartUploadRequest} instance which
  ///                specifies the bucket name, object key and metadata.
  /// @return a {@link InitiateMultipartUploadResult} instance which has the
  ///         global unique id if succeeds.
  /// @throws ClientException
  InitiateMultipartUploadResult initiateMultipartUploadWithRequest(
      InitiateMultipartUploadRequest request);

  /// Lists executing multiple parts uploads.
  /// <p>
  /// Those initialized but not finished multipart uploads would be listed by
  /// this method. If the executing multiple parts upload count is more than
  /// maxUploads (which could be up to 1000), then it would return the
  /// nextUploadIdMaker and nextKeyMaker which could be used for next call.
  /// When keyMarker in parameter request is specified, it would list executing
  /// multipart uploads whose keys are greater than the keyMarker in
  /// lexicographic order and multipart uploads whose keys are equal to the
  /// keyMarker and uploadIds are greater than uploadIdMarker in lexicographic
  /// order. In the other words, the keyMarker has the priority over the
  /// uploadIdMarker and uploadIdMarker only impacts the uploads who has the
  /// same keys as the keyMarker.
  /// </p>
  ///
  /// @param request
  ///                A {@link ListMultipartUploadsRequest} instance.
  /// @return MultipartUploadListing A {@link MultipartUploadListing} instance.
  ///         Upon a successful call, it may has nextKeyMarker and
  ///         nextUploadIdMarker for the next call in case OSS has remaining
  ///         uploads not returned.
  /// @throws ClientException
  MultipartUploadListing listMultipartUploadsWithRequest(
      ListMultipartUploadsRequest request);

  /// Lists all parts in a multiple parts upload.
  ///
  /// @param request
  ///                A {@link ListPartsRequest} instance.
  /// @return PartListing
  /// @throws ClientException
  PartListing listPartsWithRequest(ListPartsRequest request);

  /// Uploads a part to a specified multiple upload.
  ///
  /// @param request
  ///                A {@link UploadPartRequest} instance which specifies bucket,
  ///                object key, upload id, part number, content and length, MD5
  ///                digest and chunked transfer encoding flag.
  /// @return UploadPartResult A {@link UploadPartResult} instance to indicate
  ///         the upload result.
  /// @throws ClientException
  UploadPartResult uploadPartWithRequest(UploadPartRequest request);

  /// Uploads Part copy from an existing source object to a target object with
  /// specified upload Id and part number
  ///
  /// @param request
  ///                A {@link UploadPartCopyRequest} instance which specifies: 1)
  ///                source file 2) source file's copy range 3) target file 4)
  ///                target file's upload Id and its part number 5) constraints
  ///                such as ETag match or non-match, last modified match or
  ///                non-match, etc.
  /// @return A {@link UploadPartCopyResult} instance which has the part number
  ///         and ETag upon a successful upload.
  /// @throws OSSException
  /// @throws ClientException
  UploadPartCopyResult uploadPartCopyWithRequest(UploadPartCopyRequest request);

  /// Abort a multiple parts upload. All uploaded data will be released in OSS.
  /// The executing uploads of the same upload Id will get immediate failure
  /// once this method is called.
  ///
  /// @param request
  ///                A {@link AbortMultipartUploadRequest} instance which specifies
  ///                the file name and the upload Id to abort.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws ClientException
  VoidResult abortMultipartUploadWithRequest(
      AbortMultipartUploadRequest request);

  /// Complete a multiple parts upload.
  /// <p>
  /// After all parts uploads finish, this API needs to be called to finalize
  /// the upload. All parts' number and their ETag are required and if ETag
  /// verification is not passed, the API will fail. The parts' are not
  /// necessarily ordered and the final file's content is determined by the
  /// order in partETags list.
  /// </p>
  ///
  /// <p>
  /// The API will not automatically retry even if the max retry count is
  /// greater than 0 because it's not idempotent.
  /// </p>
  ///
  /// @param request
  ///                A {@link CompleteMultipartUploadRequest} instance which
  ///                specifies all parameters to complete multiple part upload.
  /// @return A {@link CompleteMultipartUploadResult} instance which has the
  ///         key, ETag, url of the final object.
  /// @throws ClientException
  CompleteMultipartUploadResult completeMultipartUploadWithRequest(
      CompleteMultipartUploadRequest request);

  /// Adds CORS rules to the bucket. If the same source has been specified with
  /// other rules, this will overwrite (not merge) them. For example, if
  /// alibaba-inc.com is a trusted source and was specified to allow GET
  /// Method. Then in this request, it's specified with POST Method. In the
  /// end, alibaba-inc.com will only be allowed with POST method.
  ///
  /// @param request
  ///                A {@link SetBucketCORSRequest} object that has defined all
  ///                CORS rules.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult setBucketCORSWithRequest(SetBucketCORSRequest request);

  /// Lists all CORS rules from the bucket.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return A list of {@link CORSRule} under the bucket.
  /// @throws OSSException
  /// @throws ClientException
  List<CORSRule> getBucketCORSRules(String bucketName);

  /// Lists all CORS rules from the bucket.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that specifies the
  ///                       bucket
  ///                       name.
  /// @return A list of {@link CORSRule} under the bucket.
  /// @throws OSSException
  /// @throws ClientException
  List<CORSRule> getBucketCORSRulesWithRequest(GenericRequest genericRequest);

  /// Get CORS configuration from the bucket.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that specifies the
  ///                       bucket
  ///                       name.
  /// @return A {@link CORSConfiguration} instance which has the CORS configuration
  ///         under the bucket.
  /// @throws OSSException
  /// @throws ClientException
  CORSConfiguration getBucketCORSWithRequest(GenericRequest genericRequest);

  /// Deletes all CORS rules under the bucket.
  ///
  /// @param bucketName
  ///                   The bucket name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketCORSRules(String bucketName);

  /// Deletes all CORS rules under the bucket.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance that specifies the
  ///                       bucket
  ///                       name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketCORSRulesWithRequest(GenericRequest genericRequest);

  /// Enables or disables the {@link Bucket}'s logging. To enable the logging,
  /// the TargetBucket attribute in SetBucketLoggingRequest object must be
  /// specified. To disable the logging, the TargetBucket attribute in
  /// SetBucketLoggingRequest object must be null. The logging file will be
  /// hourly rolling log.
  ///
  /// @param request
  ///                A {@link SetBucketLoggingRequest} instance which specifies the
  ///                bucket name to set the logging, the target bucket to store the
  ///                logging data and the prefix of the logging file.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult setBucketLoggingWithRequest(SetBucketLoggingRequest request);

  /// Gets the {@link Bucket}'s logging setting.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @return A {@link BucketLoggingResult} instance which contains the logging
  ///         settings such as target bucket for data, logging file prefix.
  /// @throws OSSException
  /// @throws ClientException
  BucketLoggingResult getBucketLogging(String bucketName);

  /// Gets the {@link Bucket}'s logging setting.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return A {@link BucketLoggingResult} instance which contains the logging
  ///         settings such as target bucket for data, logging file prefix.
  /// @throws OSSException
  /// @throws ClientException
  BucketLoggingResult getBucketLoggingWithRequest(
      GenericRequest genericRequest);

  /// Disables the logging on {@link Bucket}.
  ///
  /// @param bucketName
  ///                   Bucket Name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketLogging(String bucketName);

  /// Disables the logging on {@link Bucket}.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketLoggingWithRequest(GenericRequest genericRequest);

  /// Sets the static website settings for the {@link Bucket}. The settings
  /// includes the mandatory home page, the optional 404 page and the routing
  /// rules. If home page is null, then the static website is not enabled on
  /// the bucket.
  ///
  /// @param setBucketWebSiteRequest
  ///                                A {@link SetBucketWebsiteRequest} instance to
  ///                                set with.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult setBucketWebsiteWithRequest(
      SetBucketWebsiteRequest setBucketWebSiteRequest);

  /// Gets the {@link Bucket}'s static website settings.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @return A {@link BucketWebsiteResult} instance
  /// @throws OSSException
  /// @throws ClientException
  BucketWebsiteResult getBucketWebsite(String bucketName);

  /// Gets the {@link Bucket}'s static webite settings.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return A {@link BucketWebsiteResult} instance.
  /// @throws OSSException
  /// @throws ClientException
  BucketWebsiteResult getBucketWebsiteWithRequest(
      GenericRequest genericRequest);

  /// Deletes the {@link Bucket}'s static website configuration, which means
  /// disabling the static website on the bucket.
  ///
  /// @param bucketName
  ///                   Bucket name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketWebsite(String bucketName);

  /// Deletes the {@link Bucket}'s static website configuration, which means
  /// disabling the static website on the bucket.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketWebsiteWithRequest(GenericRequest genericRequest);

  /// Generates the post policy form field in JSON format.
  ///
  /// @param expiration
  ///                   Policy expiration time.
  /// @param conds
  ///                   Policy condition lists.
  /// @return Policy string in JSON format.
  String generatePostPolicy(DateTime expiration, PolicyConditions conds);

  /// Calculates the signature based on the policy and access key secret.
  ///
  /// @param postPolicy
  ///                   Post policy string in JSON which is generated from
  ///                   {@link #generatePostPolicy(DateTime, PolicyConditions)}.
  /// @return Post signature in bas464 string.
  String calculatePostSignature(String postPolicy);

  /// Sets the {@link Bucket}'s lifecycle rule.
  ///
  /// @param setBucketLifecycleRequest
  ///                                  A {@link SetBucketWebsiteRequest} instance
  ///                                  which specifies the
  ///                                  lifecycle rules
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketLifecycleWithRequest(
      SetBucketLifecycleRequest setBucketLifecycleRequest);

  /// Gets the {@link Bucket}'s lifecycle rules.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return A list of {@link LifecycleRule}.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<LifecycleRule> getBucketLifecycle(String bucketName);

  /// Gets the {@link Bucket}'s Lifecycle rules.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return A List of {@link LifecycleRule} instances.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<LifecycleRule> getBucketLifecycleWithRequest(
      GenericRequest genericRequest);

  /// Deletes all the {@link Bucket}'s Lifecycle rules.
  ///
  /// @param bucketName
  ///                   The bucket name to operate on.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketLifecycle(String bucketName);

  /// Deletes all the {@link Bucket}'s Lifecycle rules.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketLifecycleWithRequest(GenericRequest genericRequest);

  /// Adds a {@link Bucket}'s cross-region replication rule.
  ///
  /// @param addBucketReplicationRequest
  ///                                    A {@link AddBucketReplicationRequest}
  ///                                    instance which specifies
  ///                                    a replication rule.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult addBucketReplicationWithRequest(
      AddBucketReplicationRequest addBucketReplicationRequest);

  /// Gets all the {@link Bucket}'s cross region replication rules.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return A list of {@link ReplicationRule} under the bucket.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<ReplicationRule> getBucketReplication(String bucketName);

  /// Gets all the {@link Bucket}'s cross region replication rules.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return A list of {@link ReplicationRule} under the bucket.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<ReplicationRule> getBucketReplicationWithRequest(
      GenericRequest genericRequest);

  /// Deletes the specified {@link Bucket}'s cross region replication rule.
  ///
  /// @param bucketName
  ///                          Bucket name.
  /// @param replicationRuleID
  ///                          Replication Id to delete.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketReplication(
      String bucketName, String replicationRuleID);

  /// Deletes the specified {@link Bucket}'s cross region replication rule.
  ///
  /// @param deleteBucketReplicationRequest
  ///                                       The
  ///                                       {@link DeleteBucketReplicationRequest}
  ///                                       instance which
  ///                                       specifies the replication rule Id to
  ///                                       delete.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketReplicationWithRequest(
      DeleteBucketReplicationRequest deleteBucketReplicationRequest);

  /// Gets the {@link Bucket}'s progress of the specified cross region
  /// replication rule.
  ///
  /// @param bucketName
  ///                          Bucket name.
  /// @param replicationRuleID
  ///                          Replication Rule Id.
  /// @return The new data's and historical data's replication progress in
  ///         float.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketReplicationProgress getBucketReplicationProgress(
      String bucketName, String replicationRuleID);

  /// Gets the {@link Bucket}'s progress of the specified cross region
  /// replication rule.
  ///
  /// @param getBucketReplicationProgressRequest
  ///                                            The
  ///                                            {@link GetBucketReplicationProgressRequest}
  ///                                            instance which
  ///                                            specifies the replication rule Id
  ///                                            and bucket name.
  /// @return The new data's and historical data's replication progress in
  ///         float.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketReplicationProgress getBucketReplicationProgressWithRequest(
      GetBucketReplicationProgressRequest getBucketReplicationProgressRequest);

  /// Gets the {@link Bucket}'s replication reachable data centers.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return Replication reachable data center list.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<String> getBucketReplicationLocation(String bucketName);

  /// Gets the {@link Bucket}'s replication reachable data centers.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance that specifies the
  ///                       bucket
  ///                       name.
  /// @return Replication reachable data center list.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<String> getBucketReplicationLocationWithRequest(
      GenericRequest genericRequest);

  /// Adds a Cname for the {@link Bucket} instance.
  ///
  /// @param addBucketCnameRequest
  ///                              The request specifies the bucket name and the
  ///                              Cname
  ///                              information.
  ///
  /// @return A {@link AddBucketCnameResult} instance wrapped certificate ID if
  ///         exist and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  AddBucketCnameResult addBucketCnameWithRequest(
      AddBucketCnameRequest addBucketCnameRequest);

  /// Gets the {@link Bucket}'s Cnames.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return The list of Cnames under the bucket.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<CnameConfiguration> getBucketCname(String bucketName);

  /// Gets the {@link Bucket}'s Cnames.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return The list of Cnames under the bucket.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<CnameConfiguration> getBucketCnameWithRequest(
      GenericRequest genericRequest);

  /// Deletes one {@link Bucket}'s Cname specified by the parameter domain.
  ///
  /// @param bucketName
  ///                   The bucket name。
  /// @param domain
  ///                   cname。
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketCname(String bucketName, String domain);

  /// Deletes one {@link Bucket}'s specific Cname specified by the parameter
  /// domain.
  ///
  /// @param deleteBucketCnameRequest
  ///                                 A {@link DeleteBucketCnameRequest} instance
  ///                                 that specifies the
  ///                                 bucket name and the domain name to delete
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketCnameWithRequest(
      DeleteBucketCnameRequest deleteBucketCnameRequest);

  /// Gets the {@link Bucket}'s basic information as well as its ACL.
  ///
  /// @param bucketName
  ///                   The bucket name。
  /// @return A {@link BucketInfo} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketInfo getBucketInfo(String bucketName);

  /// Gets the {@link Bucket}'s basic information as well as its ACL.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return A {@link BucketInfo} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketInfo getBucketInfoWithRequest(GenericRequest genericRequest);

  /// Gets the {@link Bucket}'s storage information such as object counts,
  /// storage size and executing multipart uploads.
  ///
  /// @param bucketName
  ///                   The bucket name。
  /// @return A {@link BucketStat} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketStat getBucketStat(String bucketName);

  /// Gets the {@link Bucket}'s storage information such as object counts,
  /// storage size and executing multipart uploads.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return A {@link BucketStat} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketStat getBucketStatWithRequest(GenericRequest genericRequest);

  /// Sets the capacity of the {@link Bucket}.
  ///
  /// @param bucketName
  ///                   The bucket name。
  /// @param userQos
  ///                   A {@link UserQos} instance which specifies the capacity in
  ///                   GB
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketStorageCapacity(String bucketName, UserQos userQos);

  /// Sets the capacity of the {@link Bucket}.
  ///
  /// @param setBucketStorageCapacityRequest
  ///                                        A
  ///                                        {@link SetBucketStorageCapacityRequest}
  ///                                        instance which
  ///                                        specifies the bucket name as well as a
  ///                                        UserQos instance
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketStorageCapacityWithRequest(
      SetBucketStorageCapacityRequest setBucketStorageCapacityRequest);

  /// Gets the {@link Bucket}'s capacity
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @return A {@link UserQos} instance which has the capacity information.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  UserQos getBucketStorageCapacity(String bucketName);

  /// Gets the {@link Bucket}'s capacity
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  /// @return A {@link UserQos} instance which has the capacity information.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  UserQos getBucketStorageCapacityWithRequest(GenericRequest genericRequest);

  /// Creates a new server-side encryption configuration (or replaces an existing
  /// one, if present).
  ///
  /// @param setBucketEncryptionRequest The request object for setting the bucket
  ///                                   encryption configuration.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketEncryptionWithRequest(
      SetBucketEncryptionRequest setBucketEncryptionRequest);

  /// Returns the server-side encryption configuration of a bucket.
  ///
  /// @param bucketName Name of the bucket to retrieve encryption configuration
  ///                   for.
  ///
  /// @return A {@link ServerSideEncryptionConfiguration}.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  ServerSideEncryptionConfiguration getBucketEncryption(String bucketName);

  /// Returns the server-side encryption configuration of a bucket.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  ///
  /// @return A {@link ServerSideEncryptionConfiguration}.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  ServerSideEncryptionConfiguration getBucketEncryptionWithRequest(
      GenericRequest genericRequest);

  /// Deletes the server-side encryption configuration from the bucket.
  ///
  /// @param bucketName
  ///                   The bucket name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketEncryption(String bucketName);

  /// Deletes the server-side encryption configuration from the bucket.
  ///
  /// @param genericRequest
  ///                       The {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketEncryptionWithRequest(GenericRequest genericRequest);

  /// Sets the policy on the {@link Bucket} instance.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param policyText
  ///                   Policy JSON text, please refer to the policy writing rules
  ///                   of Aliyun
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketPolicy(String bucketName, String policyText);

  /// Sets the policy on the {@link Bucket} instance.
  ///
  /// @param setBucketPolicyRequest
  ///                               {@link SetBucketPolicyRequest} instance that
  ///                               has bucket
  ///                               information as well as policy information.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketPolicyWithRequest(
      SetBucketPolicyRequest setBucketPolicyRequest);

  /// Gets policy text of the {@link Bucket} instance.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  /// @return The policy's content in {@link InputStream}.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetBucketPolicyResult getBucketPolicyWithRequest(
      GenericRequest genericRequest);

  /// Gets policy text of the {@link Bucket} instance.
  ///
  /// @param bucketName
  ///                   Bucket name
  /// @return The policy's content in {@link InputStream}.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetBucketPolicyResult getBucketPolicy(String bucketName);

  /// Delete policy of the {@link Bucket} instance.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketPolicyWithRequest(GenericRequest genericRequest);

  /// Delete policy of the {@link Bucket} instance.
  ///
  /// @param bucketName
  ///                   Bucket name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketPolicy(String bucketName);

  /// File upload
  ///
  /// This method will automatically split files into parts and upload them in
  /// parallel by a thread pool, though by default the thread pool only has one
  /// thread. After all parts are uploaded, then it will merge them into one
  /// file. But if any one part fails to be uploaded, the whole upload fails.
  /// Optionally a checkpoint file could be used to track the progress of the
  /// upload and resume the upload later upon failure. Once the upload
  /// completes, the checkpoint file would be deleted. By default checkpoint
  /// file is disabled.
  ///
  /// @param uploadFileRequest
  ///                          A {@link UploadFileRequest} instance that specifies
  ///                          the bucket
  ///                          name, object key, file path ,part size (&gt; 100K)
  ///                          and thread
  ///                          count (from 1 to 1000) and checkpoint file.
  /// @return A {@link UploadFileRequest} instance which has the new uploaded
  ///         file's key, ETag, location.
  /// @throws Throwable
  UploadFileResult uploadFileWithRequest(UploadFileRequest uploadFileRequest);

  /// File download
  ///
  /// Very similar with file upload, this method will split the OSS object into
  /// parts and download them in parallel by a thread pool, though by default
  /// the thread pool only has one thread. After all parts are downloaded, then
  /// the method will merge them into one file. But if any one part fails to be
  /// downloaded, the whole download fails. Optionally a checkpoint file could
  /// be used to track the progress of the download and resume the download
  /// later upon failure. Once the download completes, the checkpoint file
  /// would be deleted. By default checkpoint file is disabled.
  ///
  /// @param downloadFileRequest
  ///                            A {@link DownloadFileRequest} instance that
  ///                            specifies the
  ///                            bucket name, object key, file path, part size
  ///                            (&gt; 100K) and
  ///                            thread count (from 1 to 1000) and checkpoint file.
  ///                            Also it
  ///                            could have the ETag and ModifiedSince constraints.
  /// @return A {@link DownloadFileResult} instance that has the
  ///         {@link ObjectMetadata} information.
  /// @throws Throwable
  DownloadFileResult downloadFileWithRequest(
      DownloadFileRequest downloadFileRequest);

  /// Creates a live streaming channel. OSS could manage the RTMP inbound
  /// stream by the "Live Channel". To store the RTMP stream into OSS, this
  /// method needs to be called first to create a "Live Channel".
  ///
  /// @param createLiveChannelRequest
  ///                                 A {@link CreateLiveChannelRequest} instance
  ///                                 that specifies the
  ///                                 target bucket name, channel name, channel
  ///                                 status (Enabled or
  ///                                 Disabled), streaming storage status such as
  ///                                 media file name,
  ///                                 its .ts file time duration, etc.
  /// @return A {@link CreateLiveChannelResult} instance that specifies the
  ///         publish url and playback url.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  CreateLiveChannelResult createLiveChannelWithRequest(
      CreateLiveChannelRequest createLiveChannelRequest);

  /// Sets the Live Channel status.
  ///
  /// A Live Channel could be disabled or enabled by setting its status.
  ///
  /// @param bucketName
  ///                    Bucket name.
  /// @param liveChannel
  ///                    Live Channel name.
  /// @param status
  ///                    Live Channel status: "Enabled" or "Disabled".
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setLiveChannelStatus(
      String bucketName, String liveChannel, LiveChannelStatus status);

  /// Sets the Live Channel status.
  ///
  /// A Live Channel could be disabled or enabled by setting its status.
  ///
  /// @param setLiveChannelRequest
  ///                              A {@link SetLiveChannelRequest} instance that
  ///                              specifies the
  ///                              bucket name, the channel name and the Live
  ///                              Channel status.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setLiveChannelStatusWithRequest(
      SetLiveChannelRequest setLiveChannelRequest);

  /// Gets the Live Channel's configuration.
  ///
  /// @param bucketName
  ///                    Bucket name.
  /// @param liveChannel
  ///                    Live Channel name.
  /// @return A {@link LiveChannelInfo} instance that contains the Live
  ///         Channel's name, description, bucket name and its streaming
  ///         storage information.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  LiveChannelInfo getLiveChannelInfo(String bucketName, String liveChannel);

  /// Gets the Live Channel's configuration.
  ///
  /// @param liveChannelGenericRequest
  ///                                  A {@link LiveChannelGenericRequest} instance
  ///                                  that specifies
  ///                                  the bucket name and Live Channel name.
  /// @return A {@link LiveChannelInfo} instance that contains the Live
  ///         Channel's name, description, bucket name and its streaming
  ///         storage information.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  LiveChannelInfo getLiveChannelInfoWithRequest(
      LiveChannelGenericRequest liveChannelGenericRequest);

  /// Gets Live Channel's streaming information.
  ///
  /// @param bucketName
  ///                    Bucket name.
  /// @param liveChannel
  ///                    Live Channel name.
  /// @return A {@link LiveChannelStat} instance that contains the media's
  ///         resolution, frame rate and bandwidth.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  LiveChannelStat getLiveChannelStat(String bucketName, String liveChannel);

  /// Gets Live Channel's streaming information.
  ///
  /// @param liveChannelGenericRequest
  ///                                  A {@link LiveChannelGenericRequest} instance
  ///                                  that specifies
  ///                                  the bucket name and channel name.
  /// @return A {@link LiveChannelStat} instance that contains the media's
  ///         resolution, frame rate and bandwidth.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  LiveChannelStat getLiveChannelStatWithRequest(
      LiveChannelGenericRequest liveChannelGenericRequest);

  /// Deletes the Live Channel.
  ///
  /// @param bucketName
  ///                    Bucket name.
  /// @param liveChannel
  ///                    Live Channel name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteLiveChannel(String bucketName, String liveChannel);

  /// Deletes the Live Channel。
  ///
  /// After the deletion, the media files are still kept. But the streaming
  /// will not work on these files.
  ///
  /// @param liveChannelGenericRequest
  ///                                  A {@link LiveChannelGenericRequest} instance
  ///                                  that specifies
  ///                                  the
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteLiveChannelWithRequest(
      LiveChannelGenericRequest liveChannelGenericRequest);

  /// Lists all Live Channels under a bucket.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @return A list of all {@link LiveChannel} instances under the bucket.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<LiveChannel> listLiveChannels(String bucketName);

  /// Lists all Live Channels under a bucket that meets the requirement
  /// specified by the parameter listLiveChannelRequest.
  ///
  /// @param listLiveChannelRequest
  ///                               A {@link ListLiveChannelsRequest} that
  ///                               specifies the bucket
  ///                               name and its requirement on Live Channel
  ///                               instances to return,
  ///                               such as prefix, marker, max entries to return.
  /// @return A list of {@link LiveChannel} instances that meet the
  ///         requirements.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  LiveChannelListing listLiveChannelsWithRequest(
      ListLiveChannelsRequest listLiveChannelRequest);

  /// Gets recent {@link LiveRecord} entries from the specified Live Channel.
  /// OSS saves recent 10 LiveRecord (pushing streaming record) for every Live
  /// Channel.
  ///
  /// @param bucketName
  ///                    Bucket name.
  /// @param liveChannel
  ///                    Live Channel name.
  /// @return Recent (up to 10) {@link LiveRecord} for the live channel.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<LiveRecord> getLiveChannelHistory(String bucketName, String liveChannel);

  /// Gets recent {@link LiveRecord} entries from the specified Live Channel.
  /// OSS saves recent 10 LiveRecord (pushing streaming record) for every Live
  /// Channel.
  ///
  /// @param liveChannelGenericRequest
  ///                                  A {@link LiveChannelGenericRequest} instance
  ///                                  that specifies
  ///                                  the bucket name and Live Channel name.
  /// @return Recent (up to 10) {@link LiveRecord} for the live channel.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<LiveRecord> getLiveChannelHistoryWithRequest(
      LiveChannelGenericRequest liveChannelGenericRequest);

  /// Generates a VOD playlist (*.m3u8 file) for the *.ts files with specified
  /// time range under the Live Channel.
  ///
  /// @param bucketName
  ///                        Bucket name.
  /// @param liveChannelName
  ///                        Live Channel name.
  /// @param PlaylistName
  ///                        The playlist file name, such as (playlist.m3u8).
  /// @param startTime
  ///                        The start time of the playlist in epoch time (means
  ///                        *.ts files
  ///                        time is same or later than it)
  /// @param endTime
  ///                        The end time of the playlist in epoch time(means *.ts
  ///                        files
  ///                        time is no later than it).
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult generateVodPlaylist(String bucketName, String liveChannelName,
      String PlaylistName, int startTime, int endTime);

  /// Generates a VOD playlist (*.m3u8 file) for the *.ts files with specified
  /// time range under the Live Channel.
  ///
  /// @param generateVodPlaylistRequest
  ///                                   A {@link GenerateVodPlaylistRequest}
  ///                                   instance the specifies
  ///                                   the bucket name and the Live Channel name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult generateVodPlaylistWithRequest(
      GenerateVodPlaylistRequest generateVodPlaylistRequest);

  /// Generates and returns a VOD playlist (m3u8 format) for the *.ts files with
  /// specified
  /// time range under the Live Channel, but this VOD playlist would not be stored
  /// in OSS Server.
  ///
  /// @param bucketName
  ///                        Bucket name.
  /// @param liveChannelName
  ///                        Live Channel name.
  /// @param startTime
  ///                        The start time of the playlist in epoch time (means
  ///                        *.ts files
  ///                        time is same or later than it)
  /// @param endTime
  ///                        The end time of the playlist in epoch time(means *.ts
  ///                        files
  ///                        time is no later than it).
  /// @return A {@link OSSObject} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  OSSObject getVodPlaylist(
      String bucketName, String liveChannelName, int startTime, int endTime);

  /// Generates and returns a VOD playlist (m3u8 format) for the *.ts files with
  /// specified
  /// time range under the Live Channel, but this VOD playlist would not be stored
  /// in OSS Server.
  ///
  /// @param getVodPlaylistRequest
  ///                              A {@link GetVodPlaylistRequest} instance the
  ///                              specifies
  ///                              the bucket name and the Live Channel name.
  /// @return A {@link OSSObject} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  OSSObject getVodPlaylistWithRequest(
      GetVodPlaylistRequest getVodPlaylistRequest);

  /// Generates a RTMP pushing streaming address in the Live Channel.
  ///
  /// @param bucketName
  ///                        Bucket name.
  /// @param liveChannelName
  ///                        Live Channel name.
  /// @param PlaylistName
  ///                        The playlist file name such as playlist.m3u8.
  /// @param expires
  ///                        Expiration time in epoch time, such as 1459922563.
  /// @return Live Channel's RTMP pushing streaming address.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  String generateRtmpUri(String bucketName, String liveChannelName,
      String playlistName, int expires);

  /// Generates a RTMP pushing streaming address in the Live Channel.
  ///
  /// @param generatePushflowUrlRequest
  ///                                   A {@link GenerateRtmpUriRequest} instance
  ///                                   that specifies the
  ///                                   bucket name and the Live Channel name.
  /// @return Live Channel's RTMP pushing streaming address.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  String generateRtmpUriWithRequest(
      GenerateRtmpUriRequest generatePushflowUrlRequest);

  /// Creates a symlink link to a target file under the bucket---this is not
  /// supported for archive class bucket.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param symlink
  ///                   symlink name.
  /// @param target
  ///                   target file key.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult createSymlink(String bucketName, String symlink, String target);

  /// Creates a symbol link to a target file under the bucket---this is not
  /// supported for archive class bucket.
  ///
  /// @param createSymlinkRequest
  ///                             A {@link CreateSymlinkRequest} instance that
  ///                             specifies the
  ///                             bucket name, symlink name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult createSymlinkWithRequest(
      CreateSymlinkRequest createSymlinkRequest);

  /// Gets the symlink information for the given symlink name.
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param symlink
  ///                   The symlink name.
  /// @return The symlink information, including the target file name and its
  ///         metadata.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  OSSSymlink getSymlink(String bucketName, String symlink);

  /// Gets the symlink information for the given symlink name.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance which specifies the
  ///                       bucket
  ///                       name and symlink name.
  /// @return The symlink information, including the target file name and its
  ///         metadata.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  OSSSymlink getSymlinkWithRequest(GenericRequest genericRequest);

  /// Apply process on the specified image file.
  /// <p>
  /// The supported process includes resize, rotate, crop, watermark, format,
  /// udf, customized style, etc. The {@link GenericResult} instance returned
  /// must be closed by the calller to release connection via calling
  /// getResponse().getContent().close().
  /// </p>
  ///
  /// @param processObjectRequest
  ///                             A {@link ProcessObjectRequest} instance that
  ///                             specifies the
  ///                             bucket name, the object key and the process (such
  ///                             as
  ///                             image/resize,w_500)
  /// @return A {@link GenericResult} instance which must be closed after the
  ///         usage by the caller.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GenericResult processObjectWithRequest(
      ProcessObjectRequest processObjectRequest);

  /// Sets the request payment of the {@link Bucket}.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @param payer
  ///                   The request payer setting
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketRequestPayment(String bucketName, Payer payer);

  /// Sets the request payment of the {@link Bucket}.
  ///
  /// @param setBucketRequestPaymentRequest
  ///                                       A
  ///                                       {@link SetBucketRequestPaymentRequest}
  ///                                       instance that has
  ///                                       the bucket name and payer setting.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketRequestPaymentWithRequest(
      SetBucketRequestPaymentRequest setBucketRequestPaymentRequest);

  /// Gets the request payment of the {@link Bucket}.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetBucketRequestPaymentResult getBucketRequestPayment(String bucketName);

  /// Gets the request payment of the {@link Bucket}.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetBucketRequestPaymentResult getBucketRequestPaymentWithRequest(
      GenericRequest genericRequest);

  /// sets the qos info for the {@link Bucket}.
  ///
  /// @param bucketName
  ///                      The bucket name.
  /// @param bucketQosInfo
  ///                      The bucket qos info setting
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketQosInfo(String bucketName, BucketQosInfo bucketQosInfo);

  /// sets the qos info for the {@link Bucket}.
  ///
  /// @param setBucketQosInfoRequest
  ///                                {@link SetBucketQosInfoRequest} instance that
  ///                                has the bucket name and bucket qos info.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketQosInfoWithRequest(
      SetBucketQosInfoRequest setBucketQosInfoRequest);

  /// Gets the bucket qos info of the {@link Bucket}.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @return A {@link BucketQosInfo} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketQosInfo getBucketQosInfo(String bucketName);

  /// Gets the bucket qos info of the {@link Bucket}.
  ///
  /// @param genericRequest
  ///                       {@link GenericRequest} instance that has the bucket
  ///                       name.
  /// @return A {@link BucketQosInfo} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  BucketQosInfo getBucketQosInfoWithRequest(GenericRequest genericRequest);

  /// Deletes the bucket qos info.
  ///
  /// @param bucketName
  ///                   The bucket name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketQosInfo(String bucketName);

  /// Deletes the bucket qos info.
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that has the bucket
  ///                       name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketQosInfoWithRequest(GenericRequest genericRequest);

  /// Gets the User qos info.
  ///
  /// @return A {@link UserQosInfo} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  UserQosInfo getUserQosInfo();

  /// Sets an async fetch task.
  ///
  /// @param bucketName
  ///                                    The bucket name.
  /// @param asyncFetchTaskConfiguration
  ///                                    The async fetch task configuration.
  /// @return A {@link SetAsyncFetchTaskResult} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  SetAsyncFetchTaskResult setAsyncFetchTask(String bucketName,
      AsyncFetchTaskConfiguration asyncFetchTaskConfiguration);

  /// Sets an async fetch task.
  ///
  /// @param setAsyncFetchTaskRequest
  ///                                 A {@link SetAsyncFetchTaskRequest} instance
  ///                                 that specified the bucket name
  ///                                 and the task configuration.
  /// @return A {@link SetAsyncFetchTaskResult} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  SetAsyncFetchTaskResult setAsyncFetchTaskWithRequest(
      SetAsyncFetchTaskRequest setAsyncFetchTaskRequest);

  /// Gets the async fetch task information.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @param taskId
  ///                   The id of the task which you want to get.
  /// @return A {@link GetAsyncFetchTaskResult} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetAsyncFetchTaskResult getAsyncFetchTask(String bucketName, String taskId);

  /// Gets the async fetch task information.
  ///
  /// @param getAsyncFetchTaskRequest
  ///                                 A {@link GetAsyncFetchTaskRequest} instance
  ///                                 that specified the bucket name
  ///                                 and the task id.
  /// @return A {@link GetAsyncFetchTaskResult} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetAsyncFetchTaskResult getAsyncFetchTaskWithRequest(
      GetAsyncFetchTaskRequest getAsyncFetchTaskRequest);

  /// Creates a vpcip tunnel {@link Vpcip}.
  ///
  /// @param createVpcipRequest
  ///                           A {@link CreateVpcipRequest} instance that
  ///                           specified the vpc information.
  /// @return A {@link CreateVpcipResult} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  CreateVpcipResult createVpcipWithRequest(
      CreateVpcipRequest createVpcipRequest);

  /// Returns all {@link Vpcip} instances of the current account.
  ///
  /// @return A list of {@link Vpcip} instances. If there's no Vpcips, the
  ///         list will be empty (instead of null).
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<VpcIp> listVpcip();

  /// Deletes the {@link Vpcip} instance.
  ///
  /// @param deleteVpcipRequest
  ///                           A {@link DeleteVpcipRequest} that specified the vpc
  ///                           policy.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteVpcipWithRequest(DeleteVpcipRequest deleteVpcipRequest);

  /// Bind a Vpcip to a bucket.
  ///
  /// @param createBucketVpcipRequest
  ///                                 A {@link CreateBucketVpcipRequest} instance
  ///                                 that specified the bucketName and the
  ///                                 {@link VpcPolicy} instance.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult createBucketVpcipWithRequest(
      CreateBucketVpcipRequest createBucketVpcipRequest);

  /// Returns all {@link VpcPolicy} instances of the Bucket.
  ///
  /// @return A list of {@link VpcPolicy} instances. If there's no list, the
  ///         list will be empty (instead of null).
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  List<VpcPolicy> getBucketVpcipWithRequest(GenericRequest genericRequest);

  /// Deletes the {@link VpcPolicy} instance that has binded to the bucket.
  ///
  /// @param deleteBucketVpcipRequest
  ///                                 A {@link DeleteBucketVpcipRequest} instance
  ///                                 that has specified the bucketName and the
  ///                                 {@link VpcPolicy} instance.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult deleteBucketVpcipWithRequest(
      DeleteBucketVpcipRequest deleteBucketVpcipRequest);

  /// Sets the bucket inventory configuration.
  ///
  /// @param bucketName
  ///                               The bucket name.
  /// @param inventoryConfiguration
  ///                               The inventory configuration.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketInventoryConfiguration(
      String bucketName, InventoryConfiguration inventoryConfiguration);

  /// Sets the bucket inventory configuration.
  ///
  /// @param setBucketInventoryConfigurationRequest
  ///                                               The
  ///                                               {@link SetBucketInventoryConfigurationRequest}
  ///                                               instance that has the inventory
  ///                                               configuration.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketInventoryConfigurationWithRequest(
      SetBucketInventoryConfigurationRequest
          setBucketInventoryConfigurationRequest);

  /// Gets the bucket inventory configuration.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @param id
  ///                   The id of the inventory configuration that want to get.
  /// @return A {@link GetBucketInventoryConfigurationResult} instance.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetBucketInventoryConfigurationResult getBucketInventoryConfiguration(
      String bucketName, String id);

  /// Gets the bucket inventory configuration.
  ///
  /// @param getBucketInventoryConfigurationRequest
  ///                                               The
  ///                                               {@link GetBucketInventoryConfigurationRequest}
  ///                                               instance that has the
  ///                                               bucketName and the
  ///                                               configuration id.
  /// @return A {@link GetBucketInventoryConfigurationResult} instance that has the
  ///         result.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetBucketInventoryConfigurationResult getBucketInventoryConfigurationWithRequest(
      GetBucketInventoryConfigurationRequest
          getBucketInventoryConfigurationRequest);

  /// Returns the list of inventory configurations for the bucket.
  ///
  /// @param bucketName
  ///                   The bucket name.
  ///
  /// @return A {@link ListBucketInventoryConfigurationsResult} object
  ///         containing the list of {@link InventoryConfiguration}.
  ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(
      String bucketName);

  /// Returns the list of inventory configurations for the bucket.
  ///
  /// @param bucketName
  ///                          The bucket name.
  /// @param continuationToken
  ///                          The continuation token allows list to be continued
  ///                          from a specific point.
  ///
  /// @return A {@link ListBucketInventoryConfigurationsResult} object containing
  ///         the inventory configurations.
  ListBucketInventoryConfigurationsResult listBucketInventoryConfigurationsWithToken(
      String bucketName, String continuationToken);

  /// Returns the list of inventory configurations for the bucket.
  ///
  /// @param listBucketInventoryConfigurationsRequest
  ///                                                 The request object to list
  ///                                                 the inventory configurations
  ///                                                 in a bucket.
  ///
  /// @return A {@link ListBucketInventoryConfigurationsResult} object
  ///         containing the list of {@link InventoryConfiguration}.
  ListBucketInventoryConfigurationsResult listBucketInventoryConfigurationsWithRequest(
      ListBucketInventoryConfigurationsRequest
          listBucketInventoryConfigurationsRequest);

  /// Deletes an inventory configuration of the bucket.
  ///
  /// @param bucketName
  ///                   The name of the bucket.
  /// @param id
  ///                   The id of the inventory configuration.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  VoidResult deleteBucketInventoryConfiguration(String bucketName, String id);

  /// Deletes an inventory configuration of the bucket.
  ///
  /// @param deleteBucketInventoryConfigurationRequest
  ///                                                  The request object for
  ///                                                  deleting an inventory
  ///                                                  configuration.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  VoidResult deleteBucketInventoryConfigurationWithRequest(
      DeleteBucketInventoryConfigurationRequest
          deleteBucketInventoryConfigurationRequest);

  /// Initiate a bucket worm configuration
  /// <p>
  /// OSS support character of "Write Once Read Many".
  /// This method is intend to create a worm configuration that will be reserved
  /// for 24 hours
  /// unless you use the completeBucketWorm method to complete the worm
  /// configuration.
  /// </p>
  ///
  /// @param initiateBucketWormRequest
  ///                                  The {@lin InitiateBucketWormRequest}
  ///                                  instance includes worm configuration.
  ///
  /// @return A {@link InitiateBucketWormResult} instance that contains worm id.
  InitiateBucketWormResult initiateBucketWormWithRequest(
      InitiateBucketWormRequest initiateBucketWormRequest);

  /// Initiate a bucket worm configuration
  /// <p>
  /// OSS support character of "Write Once Read Many".
  /// This method is intend to create a worm configuration that will be reserved
  /// for 24 hours
  /// unless you use the completeBucketWorm method to complete the worm
  /// configuration.
  /// </p>
  ///
  /// @param bucketName
  ///                              The name of the bucket.
  ///
  /// @param retentionPeriodInDays
  ///                              The object's retention days.
  ///
  /// @return A {@link InitiateBucketWormResult} instance that contains worm id.
  InitiateBucketWormResult initiateBucketWorm(
      String bucketName, int retentionPeriodInDays);

  /// Abort the bucket worm configuration
  ///
  /// @param bucketName
  ///                   The name of the bucket.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  VoidResult abortBucketWorm(String bucketName);

  /// Abort the bucket worm configuration
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that include the
  ///                       bucket name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  VoidResult abortBucketWormWithRequest(GenericRequest genericRequest);

  /// Complete the bucket worm configuration
  ///
  /// @param bucketName
  ///                   The name of the bucket.
  /// @param wormId
  ///                   The id of the worm configuration you want to complete.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  VoidResult completeBucketWorm(String bucketName, String wormId);

  /// Complete the bucket worm configuration
  ///
  /// @param completeBucketWormRequest
  ///                                  A {@link CompleteBucketWormRequest} instance
  ///                                  that includes bucket name and worm id.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  VoidResult completeBucketWormWithRequest(
      CompleteBucketWormRequest completeBucketWormRequest);

  /// Extend the bucket worm configuration
  ///
  /// @param bucketName
  ///                              The name of the bucket.
  /// @param wormId
  ///                              The id of the worm configuration you want to
  ///                              extend.
  ///
  /// @param retentionPeriodInDays
  ///                              The object's retention days.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  VoidResult extendBucketWorm(
      String bucketName, String wormId, int retentionPeriodInDays);

  /// Extend the bucket worm configuration
  ///
  /// @param extendBucketWormRequest
  ///                                A {@link ExtendBucketWormRequest} instance
  ///                                that includes bucket name, worm id and
  ///                                retention days.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult extendBucketWormWithRequest(
      ExtendBucketWormRequest extendBucketWormRequest);

  /// Get the bucket worm configuration
  ///
  /// @param bucketName
  ///                   The name of the bucket.
  ///
  /// @return A {@link GetBucketWormResult} instance that contains the worm
  ///         configuration.
  GetBucketWormResult getBucketWorm(String bucketName);

  /// Get the bucket worm configuration
  ///
  /// @param genericRequest
  ///                       A {@link GenericRequest} instance that includes bucket
  ///                       name.
  ///
  /// @return A {@link GetBucketWormResult} instance that contains the worm
  ///         configuration.
  GetBucketWormResult getBucketWormWithRequest(GenericRequest genericRequest);

  /// Creates a directory to the Bucket
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param dirName
  ///                   Directory name
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult createDirectory(String bucketName, String dirName);

  /// Creates a directory to the Bucket
  ///
  /// @param createDirectoryRequest
  ///                               A {@link CreateDirectoryRequest} instance that
  ///                               includes bucket name and directory name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult createDirectoryWithRequest(
      CreateDirectoryRequest createDirectoryRequest);

  /// Delete a directory
  ///
  /// @param bucketName
  ///                   Bucket name.
  /// @param dirName
  ///                   Directory name
  ///
  /// @return A {@link DeleteDirectoryResult} instance contains delete number and
  ///         next delete token.
  DeleteDirectoryResult deleteDirectory(String bucketName, String dirName);

  /// Delete a directory
  ///
  /// @param bucketName
  ///                        Bucket name.
  /// @param dirName
  ///                        Directory name.
  /// @param deleteRecursive
  ///                        Whether delete recursively? true or false, default is
  ///                        false.
  /// @param nextDeleteToken
  ///                        Next delete token.
  ///
  /// @return A {@link DeleteDirectoryResult} instance contains delete number and
  ///         next delete token.
  DeleteDirectoryResult deleteDirectoryWithToken(String bucketName, String dirName,
      bool deleteRecursive, String nextDeleteToken);

  /// Delete a directory
  ///
  /// @param deleteDirectoryRequest
  ///                               A {@link DeleteDirectoryRequest} instance that
  ///                               includes bucket, directory name and other
  ///                               configurations.
  ///
  /// @return A {@link DeleteDirectoryResult} instance contains delete number and
  ///         next delete token.
  DeleteDirectoryResult deleteDirectoryWithRequest(
      DeleteDirectoryRequest deleteDirectoryRequest);

  /// Rename an object, it can be a file or directory.
  ///
  /// @param bucketName
  ///                              Bucket name.
  /// @param sourceObjectName
  ///                              The source of the object.
  /// @param destinationObjectName
  ///                              The destination of the object.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult renameObject(
      String bucketName, String sourceObjectName, String destinationObjectName);

  /// Rename an object
  ///
  /// @param renameObjectRequest
  ///                            A {@link RenameObjectRequest} instance that
  ///                            includes bucketName, source object name
  ///                            and destination object name.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  VoidResult renameObjectWithRequest(RenameObjectRequest renameObjectRequest);

  /// Sets the resource group id of the {@link Bucket}.
  ///
  /// @param setBucketResourceGroupRequest
  ///                                      A {@link SetBucketResourceGroupRequest}
  ///                                      instance that has
  ///                                      the resource group id setting.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult setBucketResourceGroupWithRequest(
      SetBucketResourceGroupRequest setBucketResourceGroupRequest);

  /// Gets the resource group id of the {@link Bucket}.
  ///
  /// @param bucketName
  ///                   The bucket name.
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  GetBucketResourceGroupResult getBucketResourceGroup(String bucketName);

  /// Creates UDF
  ///
  /// @param createUdfRequest
  ///                         A {@link CreateUdfRequest} instance.
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  ///                         OSS Server side exception.
  /// @throws ClientException
  ///                         OSS Client side exception.
  VoidResult createUdfWithRequest(CreateUdfRequest createUdfRequest);

  UdfInfo getUdfInfoWithRequest(UdfGenericRequest genericRequest);

  List<UdfInfo> listUdfs();

  VoidResult deleteUdfWithRequest(UdfGenericRequest genericRequest);

  VoidResult uploadUdfImageWithRequest(
      UploadUdfImageRequest uploadUdfImageRequest);

  List<UdfImageInfo> getUdfImageInfoWithRequest(
      UdfGenericRequest genericRequest);

  VoidResult deleteUdfImageWithRequest(UdfGenericRequest genericRequest);

  VoidResult createUdfApplicationWithRequest(
      CreateUdfApplicationRequest createUdfApplicationRequest);

  UdfApplicationInfo getUdfApplicationInfoWithRequest(
      UdfGenericRequest genericRequest);

  List<UdfApplicationInfo> listUdfApplications();

  VoidResult deleteUdfApplicationWithRequest(UdfGenericRequest genericRequest);

  VoidResult upgradeUdfApplicationWithRequest(
      UpgradeUdfApplicationRequest upgradeUdfApplicationRequest);

  VoidResult resizeUdfApplicationWithRequest(
      ResizeUdfApplicationRequest resizeUdfApplicationRequest);

  UdfApplicationLog getUdfApplicationLogWithRequest(
      GetUdfApplicationLogRequest getUdfApplicationLogRequest);

  /// Set transferAcceleration configuration to the OSS Server
  ///
  /// @param bucketName
  /// @param enable
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult setBucketTransferAcceleration(String bucketName, bool enable);

  /// Get transferAcceleration configuration from the OSS Server
  ///
  /// @param bucketName
  /// @return
  /// @throws OSSException
  /// @throws ClientException
  TransferAcceleration getBucketTransferAcceleration(String bucketName);

  /// Delete transferAcceleration configuration from the OSS Server
  ///
  /// @param bucketName
  ///
  /// @return A {@link VoidResult} instance wrapped void return and
  ///         contains some basic response options, such as requestId.
  ///
  /// @throws OSSException
  /// @throws ClientException
  VoidResult deleteBucketTransferAcceleration(String bucketName);
}
