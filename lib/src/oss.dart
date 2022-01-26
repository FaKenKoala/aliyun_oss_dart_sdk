import 'callback/oss_completed_callback.dart';
import 'common/auth/oss_credential_provider.dart';
import 'internal/oss_async_task.dart';
import 'model/lib_model.dart';

abstract class OSS {
  /// Asynchronously list buckets
  /// RESTFul API:PutObject
  OSSAsyncTask<ListBucketsResult> asyncListBuckets(
      ListBucketsRequest request,
      OSSCompletedCallback<ListBucketsRequest, ListBucketsResult>
          completedCallback);

  /// Synchronously list buckets
  /// RESTFul API:PutObject

  Future<ListBucketsResult> listBuckets(ListBucketsRequest request);

  /// Asynchronously upload file
  /// RESTFul API:PutObject

  OSSAsyncTask<PutObjectResult> asyncPutObject(
      PutObjectRequest request,
      OSSCompletedCallback<PutObjectRequest, PutObjectResult>
          completedCallback);

  /// Synchronously upload file
  /// RESTFul API:PutObject

  Future<PutObjectResult> putObject(PutObjectRequest request);

  /// Asynchronously download file
  /// Gets the object. (the caller needs the read permission on the object)
  /// RESTFul API:GetObject

  OSSAsyncTask<GetObjectResult> asyncGetObject(
      GetObjectRequest request,
      OSSCompletedCallback<GetObjectRequest, GetObjectResult>
          completedCallback);

  /// Synchronously download file
  /// Gets the object. (the caller needs the read permission on the object)
  /// RESTFul API:GetObject

  Future<GetObjectResult> getObject(GetObjectRequest request);

  /// Asynchronously delete file
  /// RESTFul API:DeleteObject

  OSSAsyncTask<DeleteObjectResult> asyncDeleteObject(
      DeleteObjectRequest request,
      OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult>
          completedCallback);

  /// Synchronously delete file
  /// RESTFul API:DeleteObject

  Future<DeleteObjectResult> deleteObject(DeleteObjectRequest request);

  /// Asynchronously delete multiple objects

  OSSAsyncTask<DeleteMultipleObjectResult> asyncDeleteMultipleObject(
      DeleteMultipleObjectRequest request,
      OSSCompletedCallback<DeleteMultipleObjectRequest,
              DeleteMultipleObjectResult>
          completedCallback);

  /// delete multiple objects

  Future<DeleteMultipleObjectResult> deleteMultipleObject(
      DeleteMultipleObjectRequest request);

  /// Asynchronously append the file
  /// The object created by this method is Appendable type. While the object
  /// created by PUT Object is
  /// normal type (not appendable).

  OSSAsyncTask<AppendObjectResult> asyncAppendObject(
      AppendObjectRequest request,
      OSSCompletedCallback<AppendObjectRequest, AppendObjectResult>
          completedCallback);

  /// Synchronously append the file
  /// The object created by this method is Appendable type. While the object
  /// created by PUT Object is
  /// normal type (not appendable).

  Future<AppendObjectResult> appendObject(AppendObjectRequest request);

  /// Asynchronously get the file's metadata.
  /// Head Object only returns the metadata information, not the object content.

  OSSAsyncTask<HeadObjectResult> asyncHeadObject(
      HeadObjectRequest request,
      OSSCompletedCallback<HeadObjectRequest, HeadObjectResult>
          completedCallback);

  /// Synchronously get the file's metadata.
  /// Head Object only returns the metadata information, not the object content.

  Future<HeadObjectResult> headObject(HeadObjectRequest request);

  /// Asynchronously copy a file
  /// It copies an existing file to another one.
  /// This API just sends the PUT object request to OSS with the x-oss-copy-source
  /// information.
  /// And therefore the file's content is not downloaded or uploaded from to
  /// server.
  /// This API only fit the files whose size is less than 1GB.
  /// For bigger files, please use multipart copy API. Checks out the multipart
  /// upload APIs.

  OSSAsyncTask<CopyObjectResult> asyncCopyObject(
      CopyObjectRequest request,
      OSSCompletedCallback<CopyObjectRequest, CopyObjectResult>
          completedCallback);

  /// Synchronously copy a file
  /// It copies an existing file to another one.
  /// This API just sends the PUT object request to OSS with the x-oss-copy-source
  /// information.
  /// And therefore the file's content is not downloaded or uploaded from to
  /// server.
  /// This API only fit the files whose size is less than 1GB.
  /// For bigger files, please use multipart copy API. Checks out the multipart
  /// upload APIs.

  Future<CopyObjectResult> copyObject(CopyObjectRequest request);

  OSSAsyncTask<GetObjectACLResult> asyncGetObjectACL(
      GetObjectACLRequest request,
      OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult>
          completedCallback);

  Future<GetObjectACLResult> getObjectACL(GetObjectACLRequest request);

  /// Asynchronously create bucket

  OSSAsyncTask<CreateBucketResult> asyncCreateBucket(
      CreateBucketRequest request,
      OSSCompletedCallback<CreateBucketRequest, CreateBucketResult>
          completedCallback);

  /// Synchronously create bucket

  Future<CreateBucketResult> createBucket(CreateBucketRequest request);

  /// Asynchronously delete bucket

  OSSAsyncTask<DeleteBucketResult> asyncDeleteBucket(
      DeleteBucketRequest request,
      OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult>
          completedCallback);

  /// Synchronously delete bucket

  Future<DeleteBucketResult> deleteBucket(DeleteBucketRequest request);

  /// Asynchronously get bucket info

  OSSAsyncTask<GetBucketInfoResult> asyncGetBucketInfo(
      GetBucketInfoRequest request,
      OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult>
          completedCallback);

  /// Gets the Bucket's basic information as well as its ACL.

  Future<GetBucketInfoResult> getBucketInfo(GetBucketInfoRequest request);

  /// Asynchronously get bucket ACL

  OSSAsyncTask<GetBucketACLResult> asyncGetBucketACL(
      GetBucketACLRequest request,
      OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult>
          completedCallback);

  /// Synchronously get bucket ACL

  Future<GetBucketACLResult> getBucketACL(GetBucketACLRequest request);

  /// Synchronously get bucket referer

  Future<GetBucketRefererResult> getBucketReferer(
      GetBucketRefererRequest request);

  /// Asynchronously put bucket referer

  OSSAsyncTask<PutBucketRefererResult> asyncPutBucketReferer(
      PutBucketRefererRequest request,
      OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult>
          completedCallback);

  /// Synchronously put bucket referer

  Future<PutBucketRefererResult> putBucketReferer(
      PutBucketRefererRequest request);

  /// Synchronously delete bucket logging

  Future<DeleteBucketLoggingResult> deleteBucketLogging(
      DeleteBucketLoggingRequest request);

  /// Asynchronously delete bucket logging

  OSSAsyncTask<DeleteBucketLoggingResult> asyncDeleteBucketLogging(
      DeleteBucketLoggingRequest request,
      OSSCompletedCallback<DeleteBucketLoggingRequest,
              DeleteBucketLoggingResult>
          completedCallback);

  /// Synchronously put bucket logging

  Future<PutBucketLoggingResult> putBucketLogging(
      PutBucketLoggingRequest request);

  /// Asynchronously delete bucket logging

  OSSAsyncTask<PutBucketLoggingResult> asyncPutBucketLogging(
      PutBucketLoggingRequest request,
      OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult>
          completedCallback);

  /// Synchronously get bucket logging

  Future<GetBucketLoggingResult> getBucketLogging(
      GetBucketLoggingRequest request);

  /// Asynchronously get bucket logging

  OSSAsyncTask<GetBucketLoggingResult> asyncGetBucketLogging(
      GetBucketLoggingRequest request,
      OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult>
          completedCallback);

  /// Asynchronously get bucket referer

  OSSAsyncTask<GetBucketRefererResult> asyncGetBucketReferer(
      GetBucketRefererRequest request,
      OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult>
          completedCallback);

  /// Synchronously put bucket lifecycle

  Future<PutBucketLifecycleResult> putBucketLifecycle(
      PutBucketLifecycleRequest request);

  /// Asynchronously put bucket lifecycle

  OSSAsyncTask<PutBucketLifecycleResult> asyncPutBucketLifecycle(
      PutBucketLifecycleRequest request,
      OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult>
          completedCallback);

  /// Synchronously get bucket lifecycle

  Future<GetBucketLifecycleResult> getBucketLifecycle(
      GetBucketLifecycleRequest request);

  /// Asynchronously get bucket lifecycle

  OSSAsyncTask<GetBucketLifecycleResult> asyncGetBucketLifecycle(
      GetBucketLifecycleRequest request,
      OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult>
          completedCallback);

  /// Synchronously delete bucket lifecycle

  Future<DeleteBucketLifecycleResult> deleteBucketLifecycle(
      DeleteBucketLifecycleRequest request);

  /// Asynchronously delete bucket lifecycle

  OSSAsyncTask<DeleteBucketLifecycleResult> asyncDeleteBucketLifecycle(
      DeleteBucketLifecycleRequest request,
      OSSCompletedCallback<DeleteBucketLifecycleRequest,
              DeleteBucketLifecycleResult>
          completedCallback);

  /// Asynchronously list files
  /// Get Bucket API is for listing bucket's all object information (not data
  /// itself).

  OSSAsyncTask<ListObjectsResult> asyncListObjects(
      ListObjectsRequest request,
      OSSCompletedCallback<ListObjectsRequest, ListObjectsResult>
          completedCallback);

  /// Synchronously list files
  /// Get Bucket API is for listing bucket's all object information (not data
  /// itself).

  Future<ListObjectsResult> listObjects(ListObjectsRequest request);

  /// Asynchronously initialize a multipart upload
  /// Before use Multipart Upload for uploading data, this API is called to
  /// initiate the multipart upload,
  /// which will get the upload Id from OSS.
  /// Then this upload Id will be used in the subsequent calls, such as abort the
  /// multipart upload,
  /// query the multipart upload, upload part, etc.

  OSSAsyncTask<InitiateMultipartUploadResult> asyncInitMultipartUpload(
      InitiateMultipartUploadRequest request,
      OSSCompletedCallback<InitiateMultipartUploadRequest,
              InitiateMultipartUploadResult>
          completedCallback);

  /// Synchronously initialize a multipart upload
  /// Before use Multipart Upload for uploading data, this API is called to
  /// initiate the multipart upload,
  /// which will get the upload Id from OSS.
  /// Then this upload Id will be used in the subsequent calls, such as abort the
  /// multipart upload,
  /// query the multipart upload, upload part, etc.

  Future<InitiateMultipartUploadResult> initMultipartUpload(
      InitiateMultipartUploadRequest request);

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

  OSSAsyncTask<UploadPartResult> asyncUploadPart(
      UploadPartRequest request,
      OSSCompletedCallback<UploadPartRequest, UploadPartResult>
          completedCallback);

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

  Future<UploadPartResult> uploadPart(UploadPartRequest request);

  /// Asynchronously complete the multipart upload.
  /// After uploading all parts' data, this API needs to be called to complete the
  /// whole upload.
  /// To call this API, the valid list of the part numbers and ETags (wrapped as
  /// PartETag) are specified.
  /// The OSS will validate very part and their rankings and then merge the parts
  /// into target file.
  /// After this call, the parts data is unavailable to user.

  OSSAsyncTask<CompleteMultipartUploadResult> asyncCompleteMultipartUpload(
      CompleteMultipartUploadRequest request,
      OSSCompletedCallback<CompleteMultipartUploadRequest,
              CompleteMultipartUploadResult>
          completedCallback);

  /// Synchronously complete the multipart upload.
  /// After uploading all parts' data, this API needs to be called to complete the
  /// whole upload.
  /// To call this API, the valid list of the part numbers and ETags (wrapped as
  /// PartETag) are specified.
  /// The OSS will validate very part and their rankings and then merge the parts
  /// into target file.
  /// After this call, the parts data is unavailable to user.

  Future<CompleteMultipartUploadResult> completeMultipartUpload(
      CompleteMultipartUploadRequest request);

  /// Asynchronously cancel the multipart upload.
  /// This API is to abort the multipart upload with specified upload Id.
  /// When the multipart upload is aborted, the upload Id is invalid anymore and
  /// all parts data will
  /// be deleted.

  OSSAsyncTask<AbortMultipartUploadResult> asyncAbortMultipartUpload(
      AbortMultipartUploadRequest request,
      OSSCompletedCallback<AbortMultipartUploadRequest,
              AbortMultipartUploadResult>
          completedCallback);

  /// Synchronously cancel the multipart upload.
  /// This API is to abort the multipart upload with specified upload Id.
  /// When the multipart upload is aborted, the upload Id is invalid anymore and
  /// all parts data will
  /// be deleted.

  Future<AbortMultipartUploadResult> abortMultipartUpload(
      AbortMultipartUploadRequest request);

  /// Asynchronously list parts uploaded
  /// List Parts API could list all uploaded parts of the specified upload Id.

  OSSAsyncTask<ListPartsResult> asyncListParts(
      ListPartsRequest request,
      OSSCompletedCallback<ListPartsRequest, ListPartsResult>
          completedCallback);

  /// Synchronously list parts uploaded
  /// List Parts API could list all uploaded parts of the specified upload Id.

  Future<ListPartsResult> listParts(ListPartsRequest request);

  /// Asynchronously list multipart uploads

  OSSAsyncTask<ListMultipartUploadsResult> asyncListMultipartUploads(
      ListMultipartUploadsRequest request,
      OSSCompletedCallback<ListMultipartUploadsRequest,
              ListMultipartUploadsResult>
          completedCallback);

  /// Synchronously list multipart uploads

  Future<ListMultipartUploadsResult> listMultipartUploads(
      ListMultipartUploadsRequest request);

  /******************** extension functions **********************/

  /// Update the credential provider instance. The old one will not be used.
  void updateCredentialProvider(OSSCredentialProvider credentialProvider);

  /// Asynchronously do a multipart upload

  OSSAsyncTask<CompleteMultipartUploadResult> asyncMultipartUpload(
      MultipartUploadRequest request,
      OSSCompletedCallback<MultipartUploadRequest,
              CompleteMultipartUploadResult>
          completedCallback);

  /// Synchronously do a multipart upload

  Future<CompleteMultipartUploadResult> multipartUpload(
      MultipartUploadRequest request);

  /// Asynchronously do a resumable upload

  OSSAsyncTask<ResumableUploadResult> asyncResumableUpload(
      ResumableUploadRequest request,
      OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>
          completedCallback);

  /// Synchronously do a resumable upload

  Future<ResumableUploadResult> resumableUpload(ResumableUploadRequest request);

  OSSAsyncTask<ResumableUploadResult> asyncSequenceUpload(
      ResumableUploadRequest request,
      OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>
          completedCallback);

  Future<ResumableUploadResult> sequenceUpload(ResumableUploadRequest request);

  /// Generates the signed url for 3rd parties accessing object

  Future<String> presignConstrainedObjectURLWithRequest(
      GeneratePresignedUrlRequest request);

  /// Generates the signed url for 3rd parties accessing object

  Future<String> presignConstrainedObjectURL(
      String bucketName, String objectKey, int expiredTimeInSeconds);

  /// Generates the signed url for the available object

  String presignObjectURL(String bucketName, String objectKey);

  /// Checks if the object exists in OSS

  bool doesObjectExist(String bucketName, String objectKey);

  /// If the multipart upload is not aborted in a resumable upload,
  /// this API needs to be called to abort the underlying multipart upload.

  void abortResumableUpload(ResumableUploadRequest request);

  OSSAsyncTask<TriggerCallbackResult> asyncTriggerCallback(
      TriggerCallbackRequest request,
      OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult>
          completedCallback);

  Future<TriggerCallbackResult> triggerCallback(TriggerCallbackRequest request);

  OSSAsyncTask<ImagePersistResult> asyncImagePersist(
      ImagePersistRequest request,
      OSSCompletedCallback<ImagePersistRequest, ImagePersistResult>
          completedCallback);

  Future<ImagePersistResult> imagePersist(ImagePersistRequest request);

  /// Synchronously creates a symbol link to a target file under the bucket---this
  /// is not
  /// supported for archive class bucket.

  Future<PutSymlinkResult> putSymlink(PutSymlinkRequest request);

  /// Asynchronously creates a symbol link to a target file under the bucket---this
  /// is not
  /// supported for archive class bucket.

  OSSAsyncTask<PutSymlinkResult> asyncPutSymlink(
      PutSymlinkRequest request,
      OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult>
          completedCallback);

  /// Synchronously gets the symlink information for the given symlink name.

  Future<GetSymlinkResult> getSymlink(GetSymlinkRequest request);

  /// Asynchronously gets the symlink information for the given symlink name.

  OSSAsyncTask<GetSymlinkResult> asyncGetSymlink(
      GetSymlinkRequest request,
      OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult>
          completedCallback);

  /// Synchronously restores the object of archive storage. The function is not
  /// applicable to
  /// Normal or IA storage. The restoreObject() needs to be called prior to
  /// calling getObject() on an archive object.

  Future<RestoreObjectResult> restoreObject(RestoreObjectRequest request);

  /// Asynchronously restores the object of archive storage. The function is not
  /// applicable to
  /// Normal or IA storage. The restoreObject() needs to be called prior to
  /// calling getObject() on an archive object.

  OSSAsyncTask<RestoreObjectResult> asyncRestoreObject(
      RestoreObjectRequest request,
      OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult>
          completedCallback);

  /// Asynchronously do a resumable download

  OSSAsyncTask<ResumableDownloadResult> asyncResumableDownload(
      ResumableDownloadRequest request,
      OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult>
          completedCallback);

  /// Synchronously do a resumable download
  Future<ResumableDownloadResult> syncResumableDownload(
      ResumableDownloadRequest request);
}
