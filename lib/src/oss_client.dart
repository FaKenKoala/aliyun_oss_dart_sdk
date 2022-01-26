import 'callback/lib_callback.dart';
import 'client_configuration.dart';
import 'common/auth/lib_auth.dart';
import 'internal/lib_internal.dart';
import 'model/lib_model.dart';
import 'oss.dart';
import 'oss_impl.dart';

/// The entry point class of (Open Storage Service, OSS）, which is the implementation of abstract class
/// OSS.
class OSSClient implements OSS {
  OSS mOss;

  OSSClient.endpoint(String endpoint, OSSCredentialProvider credentialProvider,
      [ClientConfiguration? conf])
      : mOss = OSSImpl.endpoint(endpoint, credentialProvider, conf);

  OSSClient(OSSCredentialProvider credentialProvider, ClientConfiguration conf)
      : mOss = OSSImpl(credentialProvider, conf);

  @override
  OSSAsyncTask<ListBucketsResult> asyncListBuckets(
      ListBucketsRequest request,
      OSSCompletedCallback<ListBucketsRequest, ListBucketsResult>
          completedCallback) {
    return mOss.asyncListBuckets(request, completedCallback);
  }

  @override
  Future<ListBucketsResult> listBuckets(ListBucketsRequest request) {
    return mOss.listBuckets(request);
  }

  @override
  OSSAsyncTask<CreateBucketResult> asyncCreateBucket(
      CreateBucketRequest request,
      OSSCompletedCallback<CreateBucketRequest, CreateBucketResult>
          completedCallback) {
    return mOss.asyncCreateBucket(request, completedCallback);
  }

  @override
  Future<CreateBucketResult> createBucket(CreateBucketRequest request) {
    return mOss.createBucket(request);
  }

  @override
  OSSAsyncTask<DeleteBucketResult> asyncDeleteBucket(
      DeleteBucketRequest request,
      OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult>
          completedCallback) {
    return mOss.asyncDeleteBucket(request, completedCallback);
  }

  @override
  Future<DeleteBucketResult> deleteBucket(DeleteBucketRequest request) {
    return mOss.deleteBucket(request);
  }

  @override
  OSSAsyncTask<GetBucketInfoResult> asyncGetBucketInfo(
      GetBucketInfoRequest request,
      OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult>
          completedCallback) {
    return mOss.asyncGetBucketInfo(request, completedCallback);
  }

  @override
  Future<GetBucketInfoResult> getBucketInfo(GetBucketInfoRequest request) {
    return mOss.getBucketInfo(request);
  }

  @override
  OSSAsyncTask<GetBucketACLResult> asyncGetBucketACL(
      GetBucketACLRequest request,
      OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult>
          completedCallback) {
    return mOss.asyncGetBucketACL(request, completedCallback);
  }

  @override
  Future<GetBucketACLResult> getBucketACL(GetBucketACLRequest request) {
    return mOss.getBucketACL(request);
  }

  @override
  OSSAsyncTask<PutBucketRefererResult> asyncPutBucketReferer(
      PutBucketRefererRequest request,
      OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult>
          completedCallback) {
    return mOss.asyncPutBucketReferer(request, completedCallback);
  }

  @override
  Future<PutBucketRefererResult> putBucketReferer(
      PutBucketRefererRequest request) {
    return mOss.putBucketReferer(request);
  }

  @override
  Future<GetBucketRefererResult> getBucketReferer(
      GetBucketRefererRequest request) {
    return mOss.getBucketReferer(request);
  }

  @override
  OSSAsyncTask<GetBucketRefererResult> asyncGetBucketReferer(
      GetBucketRefererRequest request,
      OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult>
          completedCallback) {
    return mOss.asyncGetBucketReferer(request, completedCallback);
  }

  @override
  Future<DeleteBucketLoggingResult> deleteBucketLogging(
      DeleteBucketLoggingRequest request) {
    return mOss.deleteBucketLogging(request);
  }

  @override
  OSSAsyncTask<DeleteBucketLoggingResult> asyncDeleteBucketLogging(
      DeleteBucketLoggingRequest request,
      OSSCompletedCallback<DeleteBucketLoggingRequest,
              DeleteBucketLoggingResult>
          completedCallback) {
    return mOss.asyncDeleteBucketLogging(request, completedCallback);
  }

  @override
  Future<PutBucketLoggingResult> putBucketLogging(
      PutBucketLoggingRequest request) {
    return mOss.putBucketLogging(request);
  }

  @override
  OSSAsyncTask<PutBucketLoggingResult> asyncPutBucketLogging(
      PutBucketLoggingRequest request,
      OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult>
          completedCallback) {
    return mOss.asyncPutBucketLogging(request, completedCallback);
  }

  @override
  Future<GetBucketLoggingResult> getBucketLogging(
      GetBucketLoggingRequest request) {
    return mOss.getBucketLogging(request);
  }

  @override
  OSSAsyncTask<GetBucketLoggingResult> asyncGetBucketLogging(
      GetBucketLoggingRequest request,
      OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult>
          completedCallback) {
    return mOss.asyncGetBucketLogging(request, completedCallback);
  }

  @override
  Future<PutBucketLifecycleResult> putBucketLifecycle(
      PutBucketLifecycleRequest request) {
    return mOss.putBucketLifecycle(request);
  }

  @override
  OSSAsyncTask<PutBucketLifecycleResult> asyncPutBucketLifecycle(
      PutBucketLifecycleRequest request,
      OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult>
          completedCallback) {
    return mOss.asyncPutBucketLifecycle(request, completedCallback);
  }

  @override
  Future<GetBucketLifecycleResult> getBucketLifecycle(
      GetBucketLifecycleRequest request) {
    return mOss.getBucketLifecycle(request);
  }

  @override
  OSSAsyncTask<GetBucketLifecycleResult> asyncGetBucketLifecycle(
      GetBucketLifecycleRequest request,
      OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult>
          completedCallback) {
    return mOss.asyncGetBucketLifecycle(request, completedCallback);
  }

  @override
  Future<DeleteBucketLifecycleResult> deleteBucketLifecycle(
      DeleteBucketLifecycleRequest request) {
    return mOss.deleteBucketLifecycle(request);
  }

  @override
  OSSAsyncTask<DeleteBucketLifecycleResult> asyncDeleteBucketLifecycle(
      DeleteBucketLifecycleRequest request,
      OSSCompletedCallback<DeleteBucketLifecycleRequest,
              DeleteBucketLifecycleResult>
          completedCallback) {
    return mOss.asyncDeleteBucketLifecycle(request, completedCallback);
  }

  @override
  OSSAsyncTask<PutObjectResult> asyncPutObject(
      PutObjectRequest request,
      OSSCompletedCallback<PutObjectRequest, PutObjectResult>
          completedCallback) {
    return mOss.asyncPutObject(request, completedCallback);
  }

  @override
  Future<PutObjectResult> putObject(PutObjectRequest request) {
    return mOss.putObject(request);
  }

  @override
  OSSAsyncTask<GetObjectResult> asyncGetObject(
      GetObjectRequest request,
      OSSCompletedCallback<GetObjectRequest, GetObjectResult>
          completedCallback) {
    return mOss.asyncGetObject(request, completedCallback);
  }

  @override
  Future<GetObjectResult> getObject(GetObjectRequest request) {
    return mOss.getObject(request);
  }

  @override
  OSSAsyncTask<GetObjectACLResult> asyncGetObjectACL(
      GetObjectACLRequest request,
      OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult>
          completedCallback) {
    return mOss.asyncGetObjectACL(request, completedCallback);
  }

  @override
  Future<GetObjectACLResult> getObjectACL(GetObjectACLRequest request) {
    return mOss.getObjectACL(request);
  }

  @override
  OSSAsyncTask<DeleteObjectResult> asyncDeleteObject(
      DeleteObjectRequest request,
      OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult>
          completedCallback) {
    return mOss.asyncDeleteObject(request, completedCallback);
  }

  @override
  Future<DeleteObjectResult> deleteObject(DeleteObjectRequest request) {
    return mOss.deleteObject(request);
  }

  @override
  OSSAsyncTask<DeleteMultipleObjectResult> asyncDeleteMultipleObject(
      DeleteMultipleObjectRequest request,
      OSSCompletedCallback<DeleteMultipleObjectRequest,
              DeleteMultipleObjectResult>
          completedCallback) {
    return mOss.asyncDeleteMultipleObject(request, completedCallback);
  }

  @override
  Future<DeleteMultipleObjectResult> deleteMultipleObject(
      DeleteMultipleObjectRequest request) {
    return mOss.deleteMultipleObject(request);
  }

  @override
  OSSAsyncTask<AppendObjectResult> asyncAppendObject(
      AppendObjectRequest request,
      OSSCompletedCallback<AppendObjectRequest, AppendObjectResult>
          completedCallback) {
    return mOss.asyncAppendObject(request, completedCallback);
  }

  @override
  Future<AppendObjectResult> appendObject(AppendObjectRequest request) {
    return mOss.appendObject(request);
  }

  @override
  OSSAsyncTask<HeadObjectResult> asyncHeadObject(
      HeadObjectRequest request,
      OSSCompletedCallback<HeadObjectRequest, HeadObjectResult>
          completedCallback) {
    return mOss.asyncHeadObject(request, completedCallback);
  }

  @override
  Future<HeadObjectResult> headObject(HeadObjectRequest request) {
    return mOss.headObject(request);
  }

  @override
  OSSAsyncTask<CopyObjectResult> asyncCopyObject(
      CopyObjectRequest request,
      OSSCompletedCallback<CopyObjectRequest, CopyObjectResult>
          completedCallback) {
    return mOss.asyncCopyObject(request, completedCallback);
  }

  @override
  Future<CopyObjectResult> copyObject(CopyObjectRequest request) {
    return mOss.copyObject(request);
  }

  @override
  OSSAsyncTask<ListObjectsResult> asyncListObjects(
      ListObjectsRequest request,
      OSSCompletedCallback<ListObjectsRequest, ListObjectsResult>
          completedCallback) {
    return mOss.asyncListObjects(request, completedCallback);
  }

  @override
  Future<ListObjectsResult> listObjects(ListObjectsRequest request) {
    return mOss.listObjects(request);
  }

  @override
  OSSAsyncTask<InitiateMultipartUploadResult> asyncInitMultipartUpload(
      InitiateMultipartUploadRequest request,
      OSSCompletedCallback<InitiateMultipartUploadRequest,
              InitiateMultipartUploadResult>
          completedCallback) {
    return mOss.asyncInitMultipartUpload(request, completedCallback);
  }

  @override
  Future<InitiateMultipartUploadResult> initMultipartUpload(
      InitiateMultipartUploadRequest request) {
    return mOss.initMultipartUpload(request);
  }

  @override
  OSSAsyncTask<UploadPartResult> asyncUploadPart(
      UploadPartRequest request,
      OSSCompletedCallback<UploadPartRequest, UploadPartResult>
          completedCallback) {
    return mOss.asyncUploadPart(request, completedCallback);
  }

  @override
  Future<UploadPartResult> uploadPart(UploadPartRequest request) {
    return mOss.uploadPart(request);
  }

  @override
  OSSAsyncTask<CompleteMultipartUploadResult> asyncCompleteMultipartUpload(
      CompleteMultipartUploadRequest request,
      OSSCompletedCallback<CompleteMultipartUploadRequest,
              CompleteMultipartUploadResult>
          completedCallback) {
    return mOss.asyncCompleteMultipartUpload(request, completedCallback);
  }

  @override
  Future<CompleteMultipartUploadResult> completeMultipartUpload(
      CompleteMultipartUploadRequest request) {
    return mOss.completeMultipartUpload(request);
  }

  @override
  OSSAsyncTask<AbortMultipartUploadResult> asyncAbortMultipartUpload(
      AbortMultipartUploadRequest request,
      OSSCompletedCallback<AbortMultipartUploadRequest,
              AbortMultipartUploadResult>
          completedCallback) {
    return mOss.asyncAbortMultipartUpload(request, completedCallback);
  }

  @override
  Future<AbortMultipartUploadResult> abortMultipartUpload(
      AbortMultipartUploadRequest request) {
    return mOss.abortMultipartUpload(request);
  }

  @override
  OSSAsyncTask<ListPartsResult> asyncListParts(
      ListPartsRequest request,
      OSSCompletedCallback<ListPartsRequest, ListPartsResult>
          completedCallback) {
    return mOss.asyncListParts(request, completedCallback);
  }

  @override
  Future<ListPartsResult> listParts(ListPartsRequest request) {
    return mOss.listParts(request);
  }

  @override
  OSSAsyncTask<ListMultipartUploadsResult> asyncListMultipartUploads(
      ListMultipartUploadsRequest request,
      OSSCompletedCallback<ListMultipartUploadsRequest,
              ListMultipartUploadsResult>
          completedCallback) {
    return mOss.asyncListMultipartUploads(request, completedCallback);
  }

  @override
  Future<ListMultipartUploadsResult> listMultipartUploads(
      ListMultipartUploadsRequest request) {
    return mOss.listMultipartUploads(request);
  }

  @override
  void updateCredentialProvider(OSSCredentialProvider credentialProvider) {
    mOss.updateCredentialProvider(credentialProvider);
  }

  @override
  OSSAsyncTask<CompleteMultipartUploadResult> asyncMultipartUpload(
      MultipartUploadRequest request,
      OSSCompletedCallback<MultipartUploadRequest,
              CompleteMultipartUploadResult>
          completedCallback) {
    return mOss.asyncMultipartUpload(request, completedCallback);
  }

  @override
  Future<CompleteMultipartUploadResult> multipartUpload(
      MultipartUploadRequest request) {
    return mOss.multipartUpload(request);
  }

  @override
  OSSAsyncTask<ResumableUploadResult> asyncResumableUpload(
      ResumableUploadRequest request,
      OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>
          completedCallback) {
    return mOss.asyncResumableUpload(request, completedCallback);
  }

  @override
  Future<ResumableUploadResult> resumableUpload(
      ResumableUploadRequest request) {
    return mOss.resumableUpload(request);
  }

  @override
  OSSAsyncTask<ResumableUploadResult> asyncSequenceUpload(
      ResumableUploadRequest request,
      OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>
          completedCallback) {
    return mOss.asyncSequenceUpload(request, completedCallback);
  }

  @override
  Future<ResumableUploadResult> sequenceUpload(ResumableUploadRequest request) {
    return mOss.sequenceUpload(request);
  }

  @override
  Future<String> presignConstrainedObjectURLWithRequest(
      GeneratePresignedUrlRequest request) {
    return mOss.presignConstrainedObjectURLWithRequest(request);
  }

  @override
  Future<String> presignConstrainedObjectURL(
      String bucketName, String objectKey, int expiredTimeInSeconds) {
    return mOss.presignConstrainedObjectURL(
        bucketName, objectKey, expiredTimeInSeconds);
  }

  @override
  String presignObjectURL(String bucketName, String objectKey) {
    return mOss.presignObjectURL(bucketName, objectKey);
  }

  @override
  bool doesObjectExist(String bucketName, String objectKey) {
    return mOss.doesObjectExist(bucketName, objectKey);
  }

  @override
  void abortResumableUpload(ResumableUploadRequest request) {
    mOss.abortResumableUpload(request);
  }

  @override
  OSSAsyncTask<TriggerCallbackResult> asyncTriggerCallback(
      TriggerCallbackRequest request,
      OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult>
          completedCallback) {
    return mOss.asyncTriggerCallback(request, completedCallback);
  }

  @override
  Future<TriggerCallbackResult> triggerCallback(
      TriggerCallbackRequest request) {
    return mOss.triggerCallback(request);
  }

  @override
  OSSAsyncTask<ImagePersistResult> asyncImagePersist(
      ImagePersistRequest request,
      OSSCompletedCallback<ImagePersistRequest, ImagePersistResult>
          completedCallback) {
    return mOss.asyncImagePersist(request, completedCallback);
  }

  @override
  Future<ImagePersistResult> imagePersist(ImagePersistRequest request) {
    return mOss.imagePersist(request);
  }

  @override
  Future<PutSymlinkResult> putSymlink(PutSymlinkRequest request) {
    return mOss.putSymlink(request);
  }

  @override
  OSSAsyncTask<PutSymlinkResult> asyncPutSymlink(
      PutSymlinkRequest request,
      OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult>
          completedCallback) {
    return mOss.asyncPutSymlink(request, completedCallback);
  }

  @override
  Future<GetSymlinkResult> getSymlink(GetSymlinkRequest request) {
    return mOss.getSymlink(request);
  }

  @override
  OSSAsyncTask<GetSymlinkResult> asyncGetSymlink(
      GetSymlinkRequest request,
      OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult>
          completedCallback) {
    return mOss.asyncGetSymlink(request, completedCallback);
  }

  @override
  Future<RestoreObjectResult> restoreObject(RestoreObjectRequest request) {
    return mOss.restoreObject(request);
  }

  @override
  OSSAsyncTask<RestoreObjectResult> asyncRestoreObject(
      RestoreObjectRequest request,
      OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult>
          completedCallback) {
    return mOss.asyncRestoreObject(request, completedCallback);
  }

  @override
  OSSAsyncTask<ResumableDownloadResult> asyncResumableDownload(
      ResumableDownloadRequest request,
      OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult>
          completedCallback) {
    return mOss.asyncResumableDownload(request, completedCallback);
  }

  @override
  Future<ResumableDownloadResult> syncResumableDownload(
      ResumableDownloadRequest request) {
    return mOss.syncResumableDownload(request);
  }
}
