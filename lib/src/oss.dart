import 'package:aliyun_oss_dart_sdk/src/model/get_object_request.dart';

import 'callback/oss_completed_callback.dart';
import 'model/get_object_result.dart';
import 'model/list_buckets_request.dart';
import 'model/list_buckets_result.dart';

abstract class OSS {

       /// Asynchronously list buckets
       /// RESTFul API:PutObject
       OSSAsyncTask<ListBucketsResult> asyncListBuckets(
                     ListBucketsRequest request,
                     OSSCompletedCallback<ListBucketsRequest, ListBucketsResult> completedCallback);

       /// Synchronously list buckets
       /// RESTFul API:PutObject
       ///
       /// @param request
       /// @return
       ListBucketsResult listBuckets(ListBucketsRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously upload file
       /// RESTFul API:PutObject
       ///
       /// @param request           the PutObjectRequest instance
       /// @param completedCallback
       /// @return
       OSSAsyncTask<PutObjectResult> asyncPutObject(
                     PutObjectRequest request,
                     OSSCompletedCallback<PutObjectRequest, PutObjectResult> completedCallback);

       /// Synchronously upload file
       /// RESTFul API:PutObject
       ///
       /// @param request the PutObjectRequest instance
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       PutObjectResult putObject(PutObjectRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously download file
       /// Gets the object. (the caller needs the read permission on the object)
       /// RESTFul API:GetObject
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<GetObjectResult> asyncGetObject(
                     GetObjectRequest request,
                     OSSCompletedCallback<GetObjectRequest, GetObjectResult> completedCallback);

       /// Synchronously download file
       /// Gets the object. (the caller needs the read permission on the object)
       /// RESTFul API:GetObject
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       GetObjectResult getObject(GetObjectRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously delete file
       /// RESTFul API:DeleteObject
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<DeleteObjectResult> asyncDeleteObject(
                     DeleteObjectRequest request,
                     OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult> completedCallback);

       /// Synchronously delete file
       /// RESTFul API:DeleteObject
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       DeleteObjectResult deleteObject(DeleteObjectRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously delete multiple objects
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<DeleteMultipleObjectResult> asyncDeleteMultipleObject(
                     DeleteMultipleObjectRequest request,
                     OSSCompletedCallback<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> completedCallback);

       /// delete multiple objects
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       DeleteMultipleObjectResult deleteMultipleObject(DeleteMultipleObjectRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously append the file
       /// The object created by this method is Appendable type. While the object
       /// created by PUT Object is
       /// normal type (not appendable).
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<AppendObjectResult> asyncAppendObject(
                     AppendObjectRequest request,
                     OSSCompletedCallback<AppendObjectRequest, AppendObjectResult> completedCallback);

       /// Synchronously append the file
       /// The object created by this method is Appendable type. While the object
       /// created by PUT Object is
       /// normal type (not appendable).
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       AppendObjectResult appendObject(AppendObjectRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously get the file's metadata.
       /// Head Object only returns the metadata information, not the object content.
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<HeadObjectResult> asyncHeadObject(
                     HeadObjectRequest request,
                     OSSCompletedCallback<HeadObjectRequest, HeadObjectResult> completedCallback);

       /// Synchronously get the file's metadata.
       /// Head Object only returns the metadata information, not the object content.
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       HeadObjectResult headObject(HeadObjectRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously copy a file
       /// It copies an existing file to another one.
       /// This API just sends the PUT object request to OSS with the x-oss-copy-source
       /// information.
       /// And therefore the file's content is not downloaded or uploaded from to
       /// server.
       /// This API only fit the files whose size is less than 1GB.
       /// For bigger files, please use multipart copy API. Checks out the multipart
       /// upload APIs.
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<CopyObjectResult> asyncCopyObject(
                     CopyObjectRequest request,
                     OSSCompletedCallback<CopyObjectRequest, CopyObjectResult> completedCallback);

       /// Synchronously copy a file
       /// It copies an existing file to another one.
       /// This API just sends the PUT object request to OSS with the x-oss-copy-source
       /// information.
       /// And therefore the file's content is not downloaded or uploaded from to
       /// server.
       /// This API only fit the files whose size is less than 1GB.
       /// For bigger files, please use multipart copy API. Checks out the multipart
       /// upload APIs.
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       CopyObjectResult copyObject(CopyObjectRequest request)
                     throws OSSClientException, OSSServiceException;

       OSSAsyncTask<GetObjectACLResult> asyncGetObjectACL(
                     GetObjectACLRequest request,
                     OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult> completedCallback);

       GetObjectACLResult getObjectACL(GetObjectACLRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously create bucket
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<CreateBucketResult> asyncCreateBucket(
                     CreateBucketRequest request,
                     OSSCompletedCallback<CreateBucketRequest, CreateBucketResult> completedCallback);

       /// Synchronously create bucket
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       CreateBucketResult createBucket(CreateBucketRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously delete bucket
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<DeleteBucketResult> asyncDeleteBucket(
                     DeleteBucketRequest request,
                     OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult> completedCallback);

       /// Synchronously delete bucket
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       DeleteBucketResult deleteBucket(DeleteBucketRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously get bucket info
       ///
       /// @param request
       ///                          A {@link GetBucketInfoRequest} instance which
       ///                          specifies the bucket
       ///                          name.
       /// @param completedCallback
       ///                          A {@link OSSCompletedCallback<GetBucketInfoRequest,
       ///                          GetBucketInfoResult>} instance that specifies
       ///                          callback functions
       /// @return
       OSSAsyncTask<GetBucketInfoResult> asyncGetBucketInfo(
                     GetBucketInfoRequest request,
                     OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult> completedCallback);

       /// Gets the Bucket's basic information as well as its ACL.
       ///
       /// @param request
       ///                A {@link GetBucketInfoRequest} instance which specifies the
       ///                bucket
       ///                name.
       /// @return A {@link GetBucketInfoResult} instance.
       /// @throws OSSClientException
       ///                          OSS Client side exception.
       /// @throws OSSServiceException
       ///                          OSS Server side exception.
       GetBucketInfoResult getBucketInfo(GetBucketInfoRequest request) throws OSSClientException, OSSServiceException;

       /// Asynchronously get bucket ACL
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<GetBucketACLResult> asyncGetBucketACL(
                     GetBucketACLRequest request,
                     OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult> completedCallback);

       /// Synchronously get bucket ACL
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       GetBucketACLResult getBucketACL(GetBucketACLRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Synchronously get bucket referer
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       GetBucketRefererResult getBucketReferer(GetBucketRefererRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously put bucket referer
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<PutBucketRefererResult> asyncPutBucketReferer(
                     PutBucketRefererRequest request,
                     OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult> completedCallback);

       /// Synchronously put bucket referer
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       PutBucketRefererResult putBucketReferer(PutBucketRefererRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Synchronously delete bucket logging
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       DeleteBucketLoggingResult deleteBucketLogging(DeleteBucketLoggingRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously delete bucket logging
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<DeleteBucketLoggingResult> asyncDeleteBucketLogging(
                     DeleteBucketLoggingRequest request,
                     OSSCompletedCallback<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> completedCallback);

       /// Synchronously put bucket logging
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       PutBucketLoggingResult putBucketLogging(PutBucketLoggingRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously delete bucket logging
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<PutBucketLoggingResult> asyncPutBucketLogging(
                     PutBucketLoggingRequest request,
                     OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult> completedCallback);

       /// Synchronously get bucket logging
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       GetBucketLoggingResult getBucketLogging(GetBucketLoggingRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously get bucket logging
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<GetBucketLoggingResult> asyncGetBucketLogging(
                     GetBucketLoggingRequest request,
                     OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult> completedCallback);

       /// Asynchronously get bucket referer
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<GetBucketRefererResult> asyncGetBucketReferer(
                     GetBucketRefererRequest request,
                     OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult> completedCallback);

       /// Synchronously put bucket lifecycle
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       PutBucketLifecycleResult putBucketLifecycle(PutBucketLifecycleRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously put bucket lifecycle
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<PutBucketLifecycleResult> asyncPutBucketLifecycle(
                     PutBucketLifecycleRequest request,
                     OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult> completedCallback);

       /// Synchronously get bucket lifecycle
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       GetBucketLifecycleResult getBucketLifecycle(GetBucketLifecycleRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously get bucket lifecycle
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<GetBucketLifecycleResult> asyncGetBucketLifecycle(
                     GetBucketLifecycleRequest request,
                     OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult> completedCallback);

       /// Synchronously delete bucket lifecycle
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       DeleteBucketLifecycleResult deleteBucketLifecycle(DeleteBucketLifecycleRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously delete bucket lifecycle
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<DeleteBucketLifecycleResult> asyncDeleteBucketLifecycle(
                     DeleteBucketLifecycleRequest request,
                     OSSCompletedCallback<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> completedCallback);

       /// Asynchronously list files
       /// Get Bucket API is for listing bucket's all object information (not data
       /// itself).
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<ListObjectsResult> asyncListObjects(
                     ListObjectsRequest request,
                     OSSCompletedCallback<ListObjectsRequest, ListObjectsResult> completedCallback);

       /// Synchronously list files
       /// Get Bucket API is for listing bucket's all object information (not data
       /// itself).
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       ListObjectsResult listObjects(ListObjectsRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously initialize a multipart upload
       /// Before use Multipart Upload for uploading data, this API is called to
       /// initiate the multipart upload,
       /// which will get the upload Id from OSS.
       /// Then this upload Id will be used in the subsequent calls, such as abort the
       /// multipart upload,
       /// query the multipart upload, upload part, etc.
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<InitiateMultipartUploadResult> asyncInitMultipartUpload(
                     InitiateMultipartUploadRequest request,
                     OSSCompletedCallback<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> completedCallback);

       /// Synchronously initialize a multipart upload
       /// Before use Multipart Upload for uploading data, this API is called to
       /// initiate the multipart upload,
       /// which will get the upload Id from OSS.
       /// Then this upload Id will be used in the subsequent calls, such as abort the
       /// multipart upload,
       /// query the multipart upload, upload part, etc.
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       InitiateMultipartUploadResult initMultipartUpload(InitiateMultipartUploadRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously upload the part data
       /// After the multipart upload is initialized, we can upload the part data with
       /// specified object key
       /// and upload Id.
       /// For each part to upload, it has a unique part number (from 1 to 10000).
       /// And for the same upload Id, this part number identify the part and its
       /// position in the whole target
       /// object. If the same part number and upload Id are uploaded with other data
       /// later, then this
       /// part's data is overwritten.
       /// Except the last part, the minimal part size is 100KB.
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<UploadPartResult> asyncUploadPart(
                     UploadPartRequest request,
                     OSSCompletedCallback<UploadPartRequest, UploadPartResult> completedCallback);

       /// Synchronously upload the part data
       /// After the multipart upload is initialized, we can upload the part data with
       /// specified object key
       /// and upload Id.
       /// For each part to upload, it has a unique part number (from 1 to 10000).
       /// And for the same upload Id, this part number identify the part and its
       /// position in the whole target
       /// object. If the same part number and upload Id are uploaded with other data
       /// later, then this
       /// part's data is overwritten.
       /// Except the last part, the minimal part size is 100KB.
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       UploadPartResult uploadPart(UploadPartRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously complete the multipart upload.
       /// After uploading all parts' data, this API needs to be called to complete the
       /// whole upload.
       /// To call this API, the valid list of the part numbers and ETags (wrapped as
       /// PartETag) are specified.
       /// The OSS will validate very part and their rankings and then merge the parts
       /// into target file.
       /// After this call, the parts data is unavailable to user.
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<CompleteMultipartUploadResult> asyncCompleteMultipartUpload(
                     CompleteMultipartUploadRequest request,
                     OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> completedCallback);

       /// Synchronously complete the multipart upload.
       /// After uploading all parts' data, this API needs to be called to complete the
       /// whole upload.
       /// To call this API, the valid list of the part numbers and ETags (wrapped as
       /// PartETag) are specified.
       /// The OSS will validate very part and their rankings and then merge the parts
       /// into target file.
       /// After this call, the parts data is unavailable to user.
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously cancel the multipart upload.
       /// This API is to abort the multipart upload with specified upload Id.
       /// When the multipart upload is aborted, the upload Id is invalid anymore and
       /// all parts data will
       /// be deleted.
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<AbortMultipartUploadResult> asyncAbortMultipartUpload(
                     AbortMultipartUploadRequest request,
                     OSSCompletedCallback<AbortMultipartUploadRequest, AbortMultipartUploadResult> completedCallback);

       /// Synchronously cancel the multipart upload.
       /// This API is to abort the multipart upload with specified upload Id.
       /// When the multipart upload is aborted, the upload Id is invalid anymore and
       /// all parts data will
       /// be deleted.
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       AbortMultipartUploadResult abortMultipartUpload(AbortMultipartUploadRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously list parts uploaded
       /// List Parts API could list all uploaded parts of the specified upload Id.
       ///
       /// @param request
       /// @param completedCallback
       /// @return
       OSSAsyncTask<ListPartsResult> asyncListParts(
                     ListPartsRequest request,
                     OSSCompletedCallback<ListPartsRequest, ListPartsResult> completedCallback);

       /// Synchronously list parts uploaded
       /// List Parts API could list all uploaded parts of the specified upload Id.
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       ListPartsResult listParts(ListPartsRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously list multipart uploads
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       OSSAsyncTask<ListMultipartUploadsResult> asyncListMultipartUploads(
                     ListMultipartUploadsRequest request,
                     OSSCompletedCallback<ListMultipartUploadsRequest, ListMultipartUploadsResult> completedCallback);

       /// Synchronously list multipart uploads
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       ListMultipartUploadsResult listMultipartUploads(ListMultipartUploadsRequest request)
                     throws OSSClientException, OSSServiceException;

       /******************** extension functions **********************/

       /// Update the credential provider instance. The old one will not be used.
       void updateCredentialProvider(OSSCredentialProvider credentialProvider);

       /// Asynchronously do a multipart upload
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       OSSAsyncTask<CompleteMultipartUploadResult> asyncMultipartUpload(
                     MultipartUploadRequest request,
                     OSSCompletedCallback<MultipartUploadRequest, CompleteMultipartUploadResult> completedCallback);

       /// Synchronously do a multipart upload
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       CompleteMultipartUploadResult multipartUpload(MultipartUploadRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Asynchronously do a resumable upload
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       OSSAsyncTask<ResumableUploadResult> asyncResumableUpload(
                     ResumableUploadRequest request,
                     OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback);

       /// Synchronously do a resumable upload
       ///
       /// @param request
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       ResumableUploadResult resumableUpload(ResumableUploadRequest request)
                     throws OSSClientException, OSSServiceException;

       OSSAsyncTask<ResumableUploadResult> asyncSequenceUpload(
                     ResumableUploadRequest request,
                     OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback);

       ResumableUploadResult sequenceUpload(ResumableUploadRequest request)
                     throws OSSClientException, OSSServiceException;

       /// Generates the signed url for 3rd parties accessing object
       ///
       /// @param request Generates the signed by custom config @see
       ///                {GeneratePresignedUrlRequest}
       /// @return
       /// @throws OSSClientException
       String presignConstrainedObjectURL(GeneratePresignedUrlRequest request)
                     throws OSSClientException;

       /// Generates the signed url for 3rd parties accessing object
       ///
       /// @param bucketName           bucket name
       /// @param objectKey            Object key
       /// @param expiredTimeInSeconds URL's expiration time in seconds
       /// @return
       /// @throws OSSClientException
       String presignConstrainedObjectURL(String bucketName, String objectKey, int expiredTimeInSeconds)
                     throws OSSClientException;

       /// Generates the signed url for the available object
       ///
       /// @param bucketName bucket name
       /// @param objectKey  Object key
       /// @return
       String presignObjectURL(String bucketName, String objectKey);

       /// Checks if the object exists in OSS
       ///
       /// @param bucketName
       /// @param objectKey
       /// @return
       /// @throws OSSClientException
       /// @throws OSSServiceException
       bool doesObjectExist(String bucketName, String objectKey)
                     throws OSSClientException, OSSServiceException;

       /// If the multipart upload is not aborted in a resumable upload,
       /// this API needs to be called to abort the underlying multipart upload.
       ///
       /// @param request
       /// @throws OSSIOException
       void abortResumableUpload(ResumableUploadRequest request) throws OSSIOException;

       OSSAsyncTask<TriggerCallbackResult> asyncTriggerCallback(TriggerCallbackRequest request,
                     OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult> completedCallback);

       TriggerCallbackResult triggerCallback(TriggerCallbackRequest request) throws OSSClientException, OSSServiceException;

       OSSAsyncTask<ImagePersistResult> asyncImagePersist(ImagePersistRequest request,
                     OSSCompletedCallback<ImagePersistRequest, ImagePersistResult> completedCallback);

       ImagePersistResult imagePersist(ImagePersistRequest request) throws OSSClientException, OSSServiceException;

       /// Synchronously creates a symbol link to a target file under the bucket---this
       /// is not
       /// supported for archive class bucket.
       ///
       /// @param request
       ///                A {@link PutSymlinkRequest} instance that specifies the
       ///                bucket name, symlink name.
       /// @throws OSSClientException
       ///                          OSS Client side exception.
       /// @throws OSSServiceException
       ///                          OSS Server side exception.
       /// @return An instance of PutSymlinkResult
       PutSymlinkResult putSymlink(PutSymlinkRequest request) throws OSSClientException, OSSServiceException;

       /// Asynchronously creates a symbol link to a target file under the bucket---this
       /// is not
       /// supported for archive class bucket.
       ///
       /// @param request
       ///                          A {@link PutSymlinkRequest} instance that specifies
       ///                          the
       ///                          bucket name, symlink name.
       /// @param completedCallback
       ///                          A {@link OSSCompletedCallback<PutSymlinkRequest,
       ///                          PutSymlinkResult>} instance that specifies callback
       ///                          functions
       /// @return A {@link OSSAsyncTask<PutSymlinkResult>} instance.
       OSSAsyncTask<PutSymlinkResult> asyncPutSymlink(PutSymlinkRequest request,
                     OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult> completedCallback);

       /// Synchronously gets the symlink information for the given symlink name.
       ///
       /// @param request
       ///                A {@link GetSymlinkRequest} instance which specifies the
       ///                bucket
       ///                name and symlink name.
       /// @return The symlink information, including the target file name and its
       ///         metadata.
       /// @throws OSSClientException
       ///                          OSS Client side exception.
       /// @throws OSSServiceException
       ///                          OSS Server side exception.
       /// @return A {@link GetSymlinkResult} instance.
       GetSymlinkResult getSymlink(GetSymlinkRequest request) throws OSSClientException, OSSServiceException;

       /// Asynchronously gets the symlink information for the given symlink name.
       ///
       /// @param request
       ///                          A {@link GetSymlinkRequest} instance which specifies
       ///                          the bucket
       ///                          name and symlink name.
       /// @param completedCallback
       ///                          A {@link OSSCompletedCallback<GetSymlinkRequest,
       ///                          GetSymlinkResult>} instance that specifies callback
       ///                          functions
       /// @return A {@link OSSAsyncTask<GetSymlinkResult>} instance.
       OSSAsyncTask<GetSymlinkResult> asyncGetSymlink(GetSymlinkRequest request,
                     OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult> completedCallback);

       /// Synchronously restores the object of archive storage. The function is not
       /// applicable to
       /// Normal or IA storage. The restoreObject() needs to be called prior to
       /// calling getObject() on an archive object.
       ///
       /// @param request
       ///                A {@link RestoreObjectRequest} instance that specifies the
       ///                bucket
       ///                name and object key.
       /// @return A {@link RestoreObjectResult} instance.
       RestoreObjectResult restoreObject(RestoreObjectRequest request) throws OSSClientException, OSSServiceException;

       /// Asynchronously restores the object of archive storage. The function is not
       /// applicable to
       /// Normal or IA storage. The restoreObject() needs to be called prior to
       /// calling getObject() on an archive object.
       ///
       /// @param request
       ///                          A {@link RestoreObjectRequest} instance that
       ///                          specifies the bucket
       ///                          name and object key.
       /// @param completedCallback
       ///                          A {@link OSSCompletedCallback<RestoreObjectRequest,
       ///                          RestoreObjectResult>} instance that specifies
       ///                          callback functions
       /// @return A {@link OSSAsyncTask<RestoreObjectResult>} instance.
       OSSAsyncTask<RestoreObjectResult> asyncRestoreObject(RestoreObjectRequest request,
                     OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult> completedCallback);

       /// Asynchronously do a resumable download
       ///
       /// @param request
       ///                          A {@link ResumableDownloadRequest} instance that
       ///                          specifies the bucket
       ///                          name and object key.
       /// @param completedCallback
       ///                          A
       ///                          {@link OSSCompletedCallback<ResumableDownloadRequest,
       ///                          ResumableDownloadResult>} instance that specifies
       ///                          callback functions
       /// @return A {@link OSSAsyncTask<ResumableDownloadResult>} instance.
       OSSAsyncTask<ResumableDownloadResult> asyncResumableDownload(ResumableDownloadRequest request,
                     OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult> completedCallback);

       /// Synchronously do a resumable download
       ///
       /// @param request
       ///                A {@link ResumableDownloadRequest} instance that specifies the
       ///                bucket
       ///                name and object key.
       ResumableDownloadResult syncResumableDownload(ResumableDownloadRequest request)
                     throws OSSClientException, OSSServiceException;
}
