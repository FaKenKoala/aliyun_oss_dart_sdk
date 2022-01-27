import 'callback/lib_callback.dart';
import 'client_configuration.dart';
import 'common/lib_common.dart';
import 'internal/lib_internal.dart';
import 'model/lib_model.dart';
import 'oss.dart';

/**
 * The entry point class of (Open Storage Service, OSS）, which is the implementation of abstract class
 * OSS.
 */
class OSSImpl implements OSS {
  Uri? endpointUri;
  OSSCredentialProvider credentialProvider;
  late InternalRequestOperation internalRequestOperation;
  late ExtensionRequestOperation extensionRequestOperation;
  ClientConfiguration? conf;

  OSSImpl.endpoint(String endpoint, this.credentialProvider,
      [ClientConfiguration? conf]) {
    OSSLogToFileUtils.init(conf); //init log
    try {
      endpoint = endpoint.trim();
      if (!endpoint.startsWith("http")) {
        endpoint = "http://" + endpoint;
      }
      endpointUri = Uri.parse(endpoint);
    } catch (e) {
      throw ArgumentError(
          "Endpoint must be a string like 'http://oss-cn-****.aliyuncs.com'," +
              "or your cname like 'http://image.cnamedomain.com'!");
    }

    bool hostIsIP = false;
    try {
      hostIsIP = OSSUtils.isValidateIP(endpointUri!.host);
    } catch (e) {
      OSSLog.logError('$e');
    }

    if (endpointUri!.scheme == "https" && hostIsIP) {
      throw ArgumentError("endpoint should not be format with https://ip.");
    }

    this.conf = (conf ?? ClientConfiguration.getDefaultConf());

    internalRequestOperation =
        InternalRequestOperation.endpoint(endpointUri!, credentialProvider, this.conf!);
    extensionRequestOperation =
        ExtensionRequestOperation(internalRequestOperation);
  }

  OSSImpl(this.credentialProvider, ClientConfiguration? conf) {
    this.conf = (conf ?? ClientConfiguration.getDefaultConf());
    internalRequestOperation =
        InternalRequestOperation(credentialProvider, this.conf!);
    extensionRequestOperation =
        ExtensionRequestOperation(internalRequestOperation);
  }

  @override
  OSSAsyncTask<ListBucketsResult> asyncListBuckets(
      ListBucketsRequest request,
      OSSCompletedCallback<ListBucketsRequest, ListBucketsResult>
          completedCallback) {
    return internalRequestOperation.listBuckets(request, completedCallback);
  }

  @override
  Future<ListBucketsResult> listBuckets(ListBucketsRequest request) {
    return internalRequestOperation.listBuckets(request, null).getResult();
  }

  @override
  OSSAsyncTask<CreateBucketResult>? asyncCreateBucket(
      CreateBucketRequest request,
      OSSCompletedCallback<CreateBucketRequest, CreateBucketResult>
          completedCallback) {
    return internalRequestOperation.createBucket(request, completedCallback);
  }

  @override
  Future<CreateBucketResult>? createBucket(CreateBucketRequest request) {
    return internalRequestOperation.createBucket(request, null)?.getResult();
  }

  @override
  OSSAsyncTask<DeleteBucketResult> asyncDeleteBucket(
      DeleteBucketRequest request,
      OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult>
          completedCallback) {
    return internalRequestOperation.deleteBucket(request, completedCallback);
  }

  @override
  Future<DeleteBucketResult> deleteBucket(DeleteBucketRequest request) {
    return internalRequestOperation.deleteBucket(request, null).getResult();
  }

  @override
  OSSAsyncTask<GetBucketInfoResult> asyncGetBucketInfo(
      GetBucketInfoRequest request,
      OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult>
          completedCallback) {
    return internalRequestOperation.getBucketInfo(request, completedCallback);
  }

  @override
  Future<GetBucketInfoResult> getBucketInfo(GetBucketInfoRequest request) {
    return internalRequestOperation.getBucketInfo(request, null).getResult();
  }

  @override
  OSSAsyncTask<GetBucketACLResult> asyncGetBucketACL(
      GetBucketACLRequest request,
      OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult>
          completedCallback) {
    return internalRequestOperation.getBucketACL(request, completedCallback);
  }

  @override
  Future<GetBucketACLResult> getBucketACL(GetBucketACLRequest request) {
    return internalRequestOperation.getBucketACL(request, null).getResult();
  }

  @override
  OSSAsyncTask<PutBucketRefererResult>? asyncPutBucketReferer(
      PutBucketRefererRequest request,
      OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult>
          completedCallback) {
    return internalRequestOperation.putBucketReferer(
        request, completedCallback);
  }

  @override
  Future<PutBucketRefererResult>? putBucketReferer(PutBucketRefererRequest request) {
    return internalRequestOperation.putBucketReferer(request, null)?.getResult();
  }

  @override
  Future<GetBucketRefererResult> getBucketReferer(GetBucketRefererRequest request) {
    return internalRequestOperation.getBucketReferer(request, null).getResult();
  }

  @override
  OSSAsyncTask<GetBucketRefererResult> asyncGetBucketReferer(
      GetBucketRefererRequest request,
      OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult>
          completedCallback) {
    return internalRequestOperation.getBucketReferer(
        request, completedCallback);
  }

  @override
  Future<DeleteBucketLoggingResult> deleteBucketLogging(
      DeleteBucketLoggingRequest request) {
    return internalRequestOperation
        .deleteBucketLogging(request, null)
        .getResult();
  }

  @override
  OSSAsyncTask<DeleteBucketLoggingResult> asyncDeleteBucketLogging(
      DeleteBucketLoggingRequest request,
      OSSCompletedCallback<DeleteBucketLoggingRequest,
              DeleteBucketLoggingResult>
          completedCallback) {
    return internalRequestOperation.deleteBucketLogging(
        request, completedCallback);
  }

  @override
  Future<PutBucketLoggingResult>? putBucketLogging(PutBucketLoggingRequest request) {
    return internalRequestOperation.putBucketLogging(request, null)?.getResult();
  }

  @override
  OSSAsyncTask<PutBucketLoggingResult>? asyncPutBucketLogging(
      PutBucketLoggingRequest request,
      OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult>
          completedCallback) {
    return internalRequestOperation.putBucketLogging(
        request, completedCallback);
  }

  @override
  Future<GetBucketLoggingResult> getBucketLogging(GetBucketLoggingRequest request) {
    return internalRequestOperation.getBucketLogging(request, null).getResult();
  }

  @override
  OSSAsyncTask<GetBucketLoggingResult> asyncGetBucketLogging(
      GetBucketLoggingRequest request,
      OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult>
          completedCallback) {
    return internalRequestOperation.getBucketLogging(
        request, completedCallback);
  }

  @override
  Future<PutBucketLifecycleResult>? putBucketLifecycle(
      PutBucketLifecycleRequest request) {
    return internalRequestOperation
        .putBucketLifecycle(request, null)?.getResult();
  }

  @override
  OSSAsyncTask<PutBucketLifecycleResult>? asyncPutBucketLifecycle(
      PutBucketLifecycleRequest request,
      OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult>
          completedCallback) {
    return internalRequestOperation.putBucketLifecycle(
        request, completedCallback);
  }

  @override
  Future<GetBucketLifecycleResult> getBucketLifecycle(
      GetBucketLifecycleRequest request) {
    return internalRequestOperation
        .getBucketLifecycle(request, null)
        .getResult();
  }

  @override
  OSSAsyncTask<GetBucketLifecycleResult> asyncGetBucketLifecycle(
      GetBucketLifecycleRequest request,
      OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult>
          completedCallback) {
    return internalRequestOperation.getBucketLifecycle(
        request, completedCallback);
  }

  @override
  Future<DeleteBucketLifecycleResult> deleteBucketLifecycle(
      DeleteBucketLifecycleRequest request) {
    return internalRequestOperation
        .deleteBucketLifecycle(request, null)
        .getResult();
  }

  @override
  OSSAsyncTask<DeleteBucketLifecycleResult> asyncDeleteBucketLifecycle(
      DeleteBucketLifecycleRequest request,
      OSSCompletedCallback<DeleteBucketLifecycleRequest,
              DeleteBucketLifecycleResult>
          completedCallback) {
    return internalRequestOperation.deleteBucketLifecycle(
        request, completedCallback);
  }

  @override
  OSSAsyncTask<PutObjectResult> asyncPutObject(
      PutObjectRequest request,
      final OSSCompletedCallback<PutObjectRequest, PutObjectResult>
          completedCallback) {
    return internalRequestOperation.putObject(request, completedCallback);
  }

  @override
  Future<PutObjectResult> putObject(PutObjectRequest request) {
    return internalRequestOperation.syncPutObject(request);
  }

  @override
  OSSAsyncTask<GetObjectResult> asyncGetObject(
      GetObjectRequest request,
      final OSSCompletedCallback<GetObjectRequest, GetObjectResult>
          completedCallback) {
    return internalRequestOperation.getObject(request, completedCallback);
  }

  @override
  Future<GetObjectResult> getObject(GetObjectRequest request) {
    return internalRequestOperation.getObject(request, null).getResult();
  }

  @override
  OSSAsyncTask<GetObjectACLResult> asyncGetObjectACL(
      GetObjectACLRequest request,
      OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult>
          completedCallback) {
    return internalRequestOperation.getObjectACL(request, completedCallback);
  }

  @override
  Future<GetObjectACLResult> getObjectACL(GetObjectACLRequest request) {
    return internalRequestOperation.getObjectACL(request, null).getResult();
  }

  @override
  OSSAsyncTask<DeleteObjectResult> asyncDeleteObject(
      DeleteObjectRequest request,
      OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult>
          completedCallback) {
    return internalRequestOperation.deleteObject(request, completedCallback);
  }

  @override
  Future<DeleteObjectResult> deleteObject(DeleteObjectRequest request) {
    return internalRequestOperation.deleteObject(request, null).getResult();
  }

  @override
  OSSAsyncTask<DeleteMultipleObjectResult> asyncDeleteMultipleObject(
      DeleteMultipleObjectRequest request,
      OSSCompletedCallback<DeleteMultipleObjectRequest,
              DeleteMultipleObjectResult>
          completedCallback) {
    return internalRequestOperation.deleteMultipleObject(
        request, completedCallback);
  }

  @override
  Future<DeleteMultipleObjectResult> deleteMultipleObject(
      DeleteMultipleObjectRequest request) {
    return internalRequestOperation
        .deleteMultipleObject(request, null)
        .getResult();
  }

  @override
  OSSAsyncTask<AppendObjectResult> asyncAppendObject(
      AppendObjectRequest request,
      final OSSCompletedCallback<AppendObjectRequest, AppendObjectResult>
          completedCallback) {
    return internalRequestOperation.appendObject(request, completedCallback);
  }

  @override
  Future<AppendObjectResult> appendObject(AppendObjectRequest request) {
    return internalRequestOperation.syncAppendObject(request);
  }

  @override
  OSSAsyncTask<HeadObjectResult> asyncHeadObject(
      HeadObjectRequest request,
      OSSCompletedCallback<HeadObjectRequest, HeadObjectResult>
          completedCallback) {
    return internalRequestOperation.headObject(request, completedCallback);
  }

  @override
  Future<HeadObjectResult> headObject(HeadObjectRequest request) {
    return internalRequestOperation.headObject(request, null).getResult();
  }

  @override
  OSSAsyncTask<CopyObjectResult> asyncCopyObject(
      CopyObjectRequest request,
      OSSCompletedCallback<CopyObjectRequest, CopyObjectResult>
          completedCallback) {
    return internalRequestOperation.copyObject(request, completedCallback);
  }

  @override
  Future<CopyObjectResult> copyObject(CopyObjectRequest request) {
    return internalRequestOperation.copyObject(request, null).getResult();
  }

  @override
  OSSAsyncTask<ListObjectsResult> asyncListObjects(
      ListObjectsRequest request,
      OSSCompletedCallback<ListObjectsRequest, ListObjectsResult>
          completedCallback) {
    return internalRequestOperation.listObjects(request, completedCallback);
  }

  @override
  Future<ListObjectsResult> listObjects(ListObjectsRequest request) {
    return internalRequestOperation.listObjects(request, null).getResult();
  }

  @override
  OSSAsyncTask<InitiateMultipartUploadResult> asyncInitMultipartUpload(
      InitiateMultipartUploadRequest request,
      OSSCompletedCallback<InitiateMultipartUploadRequest,
              InitiateMultipartUploadResult>
          completedCallback) {
    return internalRequestOperation.initMultipartUpload(
        request, completedCallback);
  }

  @override
  Future<InitiateMultipartUploadResult> initMultipartUpload(
      InitiateMultipartUploadRequest request) {
    return internalRequestOperation
        .initMultipartUpload(request, null)
        .getResult();
  }

  @override
  OSSAsyncTask<UploadPartResult> asyncUploadPart(
      UploadPartRequest request,
      final OSSCompletedCallback<UploadPartRequest, UploadPartResult>
          completedCallback) {
    return internalRequestOperation.uploadPart(request, completedCallback);
  }

  @override
  Future<UploadPartResult> uploadPart(UploadPartRequest request) {
    return internalRequestOperation.syncUploadPart(request);
  }

  @override
  OSSAsyncTask<CompleteMultipartUploadResult> asyncCompleteMultipartUpload(
      CompleteMultipartUploadRequest request,
      final OSSCompletedCallback<CompleteMultipartUploadRequest,
              CompleteMultipartUploadResult>
          completedCallback) {
    return internalRequestOperation.completeMultipartUpload(
        request, completedCallback);
  }

  @override
  Future<CompleteMultipartUploadResult> completeMultipartUpload(
      CompleteMultipartUploadRequest request) {
    return internalRequestOperation.syncCompleteMultipartUpload(request);
  }

  @override
  OSSAsyncTask<AbortMultipartUploadResult> asyncAbortMultipartUpload(
      AbortMultipartUploadRequest request,
      OSSCompletedCallback<AbortMultipartUploadRequest,
              AbortMultipartUploadResult>
          completedCallback) {
    return internalRequestOperation.abortMultipartUpload(
        request, completedCallback);
  }

  @override
  Future<AbortMultipartUploadResult> abortMultipartUpload(
      AbortMultipartUploadRequest request) {
    return internalRequestOperation
        .abortMultipartUpload(request, null)
        .getResult();
  }

  @override
  OSSAsyncTask<ListPartsResult> asyncListParts(
      ListPartsRequest request,
      OSSCompletedCallback<ListPartsRequest, ListPartsResult>
          completedCallback) {
    return internalRequestOperation.listParts(request, completedCallback);
  }

  @override
  Future<ListPartsResult> listParts(ListPartsRequest request) {
    return internalRequestOperation.listParts(request, null).getResult();
  }

  @override
  OSSAsyncTask<ListMultipartUploadsResult> asyncListMultipartUploads(
      ListMultipartUploadsRequest request,
      OSSCompletedCallback<ListMultipartUploadsRequest,
              ListMultipartUploadsResult>
          completedCallback) {
    return internalRequestOperation.listMultipartUploads(
        request, completedCallback);
  }

  @override
  Future<ListMultipartUploadsResult> listMultipartUploads(
      ListMultipartUploadsRequest request) {
    return internalRequestOperation
        .listMultipartUploads(request, null)
        .getResult();
  }

  @override
  void updateCredentialProvider(OSSCredentialProvider credentialProvider) {
    this.credentialProvider = credentialProvider;
    internalRequestOperation.credentialProvider  = credentialProvider;
  }

  @override
  OSSAsyncTask<CompleteMultipartUploadResult> asyncMultipartUpload(
      MultipartUploadRequest request,
      OSSCompletedCallback<MultipartUploadRequest,
              CompleteMultipartUploadResult>
          completedCallback) {
    return extensionRequestOperation.multipartUpload(
        request, completedCallback);
  }

  @override
  Future<CompleteMultipartUploadResult> multipartUpload(
      MultipartUploadRequest request) {
    return extensionRequestOperation.multipartUpload(request, null).getResult();
  }

  @override
  OSSAsyncTask<ResumableUploadResult> asyncResumableUpload(
      ResumableUploadRequest request,
      OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>
          completedCallback) {
    return extensionRequestOperation.resumableUpload(
        request, completedCallback);
  }

  @override
  Future<ResumableUploadResult> resumableUpload(ResumableUploadRequest request) {
    return extensionRequestOperation.resumableUpload(request, null).getResult();
  }

  @override
  OSSAsyncTask<ResumableUploadResult> asyncSequenceUpload(
      ResumableUploadRequest request,
      OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult>
          completedCallback) {
    return extensionRequestOperation.sequenceUpload(request, completedCallback);
  }

  @override
  Future<ResumableUploadResult> sequenceUpload(ResumableUploadRequest request) {
    return extensionRequestOperation.sequenceUpload(request, null).getResult();
  }

  @override
  Future<String> presignConstrainedObjectURLWithRequest(GeneratePresignedUrlRequest request) {
    return ObjectURLPresigner(endpointUri!, credentialProvider, conf!)
        .presignConstrainedURLWithRequest(request);
  }

  @override
  Future<String> presignConstrainedObjectURL(
      String bucketName, String objectKey, int expiredTimeInSeconds) {
    return ObjectURLPresigner(endpointUri!, credentialProvider, conf!)
        .presignConstrainedURL(bucketName, objectKey, expiredTimeInSeconds);
  }

  @override
  String presignObjectURL(String bucketName, String objectKey) {
    return ObjectURLPresigner(endpointUri!, credentialProvider, conf!)
        .presignURL(bucketName, objectKey);
  }

  @override
  bool doesObjectExist(String bucketName, String objectKey) {
    return extensionRequestOperation.doesObjectExist(bucketName, objectKey);
  }

  @override
  void abortResumableUpload(ResumableUploadRequest request) {
    extensionRequestOperation.abortResumableUpload(request);
  }

  @override
  OSSAsyncTask<TriggerCallbackResult> asyncTriggerCallback(
      TriggerCallbackRequest request,
      OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult>
          completedCallback) {
    return internalRequestOperation.triggerCallback(request, completedCallback);
  }

  @override
  Future<TriggerCallbackResult> triggerCallback(TriggerCallbackRequest request) {
    return internalRequestOperation.asyncTriggerCallback(request);
  }

  @override
  OSSAsyncTask<ImagePersistResult> asyncImagePersist(
      ImagePersistRequest request,
      OSSCompletedCallback<ImagePersistRequest, ImagePersistResult>
          completedCallback) {
    return internalRequestOperation.imageActionPersist(
        request, completedCallback);
  }

  @override
  Future<ImagePersistResult> imagePersist(ImagePersistRequest request) {
    return internalRequestOperation
        .imageActionPersist(request, null)
        .getResult();
  }

  @override
  Future<PutSymlinkResult> putSymlink(PutSymlinkRequest request) {
    return internalRequestOperation.syncPutSymlink(request);
  }

  @override
  OSSAsyncTask<PutSymlinkResult> asyncPutSymlink(
      PutSymlinkRequest request,
      OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult>
          completedCallback) {
    return internalRequestOperation.putSymlink(request, completedCallback);
  }

  @override
  Future<GetSymlinkResult> getSymlink(GetSymlinkRequest request) {
    return internalRequestOperation.syncGetSymlink(request);
  }

  @override
  OSSAsyncTask<GetSymlinkResult> asyncGetSymlink(
      GetSymlinkRequest request,
      OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult>
          completedCallback) {
    return internalRequestOperation.getSymlink(request, completedCallback);
  }

  @override
  Future<RestoreObjectResult> restoreObject(RestoreObjectRequest request) {
    return internalRequestOperation.syncRestoreObject(request);
  }

  @override
  OSSAsyncTask<RestoreObjectResult> asyncRestoreObject(
      RestoreObjectRequest request,
      OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult>
          completedCallback) {
    return internalRequestOperation.restoreObject(request, completedCallback);
  }

  @override
  OSSAsyncTask<ResumableDownloadResult> asyncResumableDownload(
      ResumableDownloadRequest request,
      OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult>
          completedCallback) {
    return extensionRequestOperation.resumableDownload(
        request, completedCallback);
  }

  @override
  Future<ResumableDownloadResult> syncResumableDownload(
      ResumableDownloadRequest request) {
    return extensionRequestOperation
        .resumableDownload(request, null)
        .getResult();
  }
}
