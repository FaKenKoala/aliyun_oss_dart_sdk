/**
 * The entry point class of (Open Storage Service, OSS）, which is the implementation of abstract class
 * OSS.
 */
 class OSSClient implements OSS {

     OSS mOss;

    /**
     * Creates a {@link OSSClient} instance.
     *
     * @param context            android application's application context
     * @param endpoint           OSS endpoint, check out:http://help.aliyun.com/document_detail/oss/user_guide/endpoint_region.html
     * @param credentialProvider credential provider instance
     */
     OSSClient(Context context, String endpoint, OSSCredentialProvider credentialProvider) {
        this(context, endpoint, credentialProvider, null);
    }

    /**
     * Creates a {@link OSSClient} instance.
     *
     * @param context            aandroid application's application context
     * @param endpoint           OSS endpoint, check out:http://help.aliyun.com/document_detail/oss/user_guide/endpoint_region.html
     * @param credentialProvider credential provider instance
     * @param conf               Client side configuration
     */
     OSSClient(Context context, String endpoint, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        mOss = OSSImpl(context, endpoint, credentialProvider, conf);
    }

     OSSClient(Context context, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        mOss = OSSImpl(context, credentialProvider, conf);
    }

    @override
     OSSAsyncTask<ListBucketsResult> asyncListBuckets(
            ListBucketsRequest request, OSSCompletedCallback<ListBucketsRequest, ListBucketsResult> completedCallback) {
        return mOss.asyncListBuckets(request, completedCallback);
    }

    @override
     ListBucketsResult listBuckets(ListBucketsRequest request)
             {
        return mOss.listBuckets(request);
    }

    @override
     OSSAsyncTask<CreateBucketResult> asyncCreateBucket(
            CreateBucketRequest request, OSSCompletedCallback<CreateBucketRequest, CreateBucketResult> completedCallback) {

        return mOss.asyncCreateBucket(request, completedCallback);
    }

    @override
     CreateBucketResult createBucket(CreateBucketRequest request)
             {

        return mOss.createBucket(request);
    }

    @override
     OSSAsyncTask<DeleteBucketResult> asyncDeleteBucket(
            DeleteBucketRequest request, OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult> completedCallback) {

        return mOss.asyncDeleteBucket(request, completedCallback);
    }

    @override
     DeleteBucketResult deleteBucket(DeleteBucketRequest request)
             {

        return mOss.deleteBucket(request);
    }

    @override
     OSSAsyncTask<GetBucketInfoResult> asyncGetBucketInfo(GetBucketInfoRequest request, OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult> completedCallback) {
        return mOss.asyncGetBucketInfo(request, completedCallback);
    }

    @override
     GetBucketInfoResult getBucketInfo(GetBucketInfoRequest request)  {
        return mOss.getBucketInfo(request);
    }

    @override
     OSSAsyncTask<GetBucketACLResult> asyncGetBucketACL(
            GetBucketACLRequest request, OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult> completedCallback) {

        return mOss.asyncGetBucketACL(request, completedCallback);
    }

    @override
     GetBucketACLResult getBucketACL(GetBucketACLRequest request)
             {

        return mOss.getBucketACL(request);
    }

    @override
     OSSAsyncTask<PutBucketRefererResult> asyncPutBucketReferer(PutBucketRefererRequest request, OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult> completedCallback) {
        return mOss.asyncPutBucketReferer(request, completedCallback);
    }

    @override
     PutBucketRefererResult putBucketReferer(PutBucketRefererRequest request)  {
        return mOss.putBucketReferer(request);
    }

    @override
     GetBucketRefererResult getBucketReferer(GetBucketRefererRequest request)  {
        return mOss.getBucketReferer(request);
    }

    @override
     OSSAsyncTask<GetBucketRefererResult> asyncGetBucketReferer(GetBucketRefererRequest request, OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult> completedCallback) {
        return mOss.asyncGetBucketReferer(request, completedCallback);
    }

    @override
     DeleteBucketLoggingResult deleteBucketLogging(DeleteBucketLoggingRequest request)  {
        return mOss.deleteBucketLogging(request);
    }

    @override
     OSSAsyncTask<DeleteBucketLoggingResult> asyncDeleteBucketLogging(DeleteBucketLoggingRequest request, OSSCompletedCallback<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> completedCallback) {
        return mOss.asyncDeleteBucketLogging(request, completedCallback);
    }

    @override
     PutBucketLoggingResult putBucketLogging(PutBucketLoggingRequest request)  {
        return mOss.putBucketLogging(request);
    }

    @override
     OSSAsyncTask<PutBucketLoggingResult> asyncPutBucketLogging(PutBucketLoggingRequest request, OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult> completedCallback) {
        return mOss.asyncPutBucketLogging(request, completedCallback);
    }

    @override
     GetBucketLoggingResult getBucketLogging(GetBucketLoggingRequest request)  {
        return mOss.getBucketLogging(request);
    }

    @override
     OSSAsyncTask<GetBucketLoggingResult> asyncGetBucketLogging(GetBucketLoggingRequest request, OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult> completedCallback) {
        return mOss.asyncGetBucketLogging(request, completedCallback);
    }

    @override
     PutBucketLifecycleResult putBucketLifecycle(PutBucketLifecycleRequest request)  {
        return mOss.putBucketLifecycle(request);
    }

    @override
     OSSAsyncTask<PutBucketLifecycleResult> asyncPutBucketLifecycle(PutBucketLifecycleRequest request, OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult> completedCallback) {
        return mOss.asyncPutBucketLifecycle(request, completedCallback);
    }

    @override
     GetBucketLifecycleResult getBucketLifecycle(GetBucketLifecycleRequest request)  {
        return mOss.getBucketLifecycle(request);
    }

    @override
     OSSAsyncTask<GetBucketLifecycleResult> asyncGetBucketLifecycle(GetBucketLifecycleRequest request, OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult> completedCallback) {
        return mOss.asyncGetBucketLifecycle(request, completedCallback);
    }

    @override
     DeleteBucketLifecycleResult deleteBucketLifecycle(DeleteBucketLifecycleRequest request)  {
        return mOss.deleteBucketLifecycle(request);
    }

    @override
     OSSAsyncTask<DeleteBucketLifecycleResult> asyncDeleteBucketLifecycle(DeleteBucketLifecycleRequest request, OSSCompletedCallback<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> completedCallback) {
        return mOss.asyncDeleteBucketLifecycle(request, completedCallback);
    }

    @override
     OSSAsyncTask<PutObjectResult> asyncPutObject(
            PutObjectRequest request, OSSCompletedCallback<PutObjectRequest, PutObjectResult> completedCallback) {

        return mOss.asyncPutObject(request, completedCallback);
    }

    @override
     PutObjectResult putObject(PutObjectRequest request)
             {

        return mOss.putObject(request);
    }

    @override
     OSSAsyncTask<GetObjectResult> asyncGetObject(
            GetObjectRequest request, OSSCompletedCallback<GetObjectRequest, GetObjectResult> completedCallback) {

        return mOss.asyncGetObject(request, completedCallback);
    }

    @override
     GetObjectResult getObject(GetObjectRequest request)
             {

        return mOss.getObject(request);
    }

    @override
     OSSAsyncTask<GetObjectACLResult> asyncGetObjectACL(
            GetObjectACLRequest request, OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult> completedCallback) {
        return mOss.asyncGetObjectACL(request, completedCallback);
    }

    @override
     GetObjectACLResult getObjectACL(GetObjectACLRequest request)
             {
        return mOss.getObjectACL(request);
    }

    @override
     OSSAsyncTask<DeleteObjectResult> asyncDeleteObject(
            DeleteObjectRequest request, OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult> completedCallback) {

        return mOss.asyncDeleteObject(request, completedCallback);
    }

    @override
     DeleteObjectResult deleteObject(DeleteObjectRequest request)
             {

        return mOss.deleteObject(request);
    }

    @override
     OSSAsyncTask<DeleteMultipleObjectResult> asyncDeleteMultipleObject(
            DeleteMultipleObjectRequest request, OSSCompletedCallback<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> completedCallback) {

        return mOss.asyncDeleteMultipleObject(request, completedCallback);
    }

    @override
     DeleteMultipleObjectResult deleteMultipleObject(DeleteMultipleObjectRequest request)
             {
        return mOss.deleteMultipleObject(request);
    }

    @override
     OSSAsyncTask<AppendObjectResult> asyncAppendObject(
            AppendObjectRequest request, OSSCompletedCallback<AppendObjectRequest, AppendObjectResult> completedCallback) {

        return mOss.asyncAppendObject(request, completedCallback);
    }

    @override
     AppendObjectResult appendObject(AppendObjectRequest request)
             {

        return mOss.appendObject(request);
    }

    @override
     OSSAsyncTask<HeadObjectResult> asyncHeadObject(HeadObjectRequest request, OSSCompletedCallback<HeadObjectRequest, HeadObjectResult> completedCallback) {

        return mOss.asyncHeadObject(request, completedCallback);
    }

    @override
     HeadObjectResult headObject(HeadObjectRequest request)
             {

        return mOss.headObject(request);
    }

    @override
     OSSAsyncTask<CopyObjectResult> asyncCopyObject(CopyObjectRequest request, OSSCompletedCallback<CopyObjectRequest, CopyObjectResult> completedCallback) {

        return mOss.asyncCopyObject(request, completedCallback);
    }

    @override
     CopyObjectResult copyObject(CopyObjectRequest request)
             {

        return mOss.copyObject(request);
    }

    @override
     OSSAsyncTask<ListObjectsResult> asyncListObjects(
            ListObjectsRequest request, OSSCompletedCallback<ListObjectsRequest, ListObjectsResult> completedCallback) {

        return mOss.asyncListObjects(request, completedCallback);
    }

    @override
     ListObjectsResult listObjects(ListObjectsRequest request)
             {

        return mOss.listObjects(request);
    }

    @override
     OSSAsyncTask<InitiateMultipartUploadResult> asyncInitMultipartUpload(InitiateMultipartUploadRequest request, OSSCompletedCallback<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> completedCallback) {

        return mOss.asyncInitMultipartUpload(request, completedCallback);
    }

    @override
     InitiateMultipartUploadResult initMultipartUpload(InitiateMultipartUploadRequest request)
             {

        return mOss.initMultipartUpload(request);
    }

    @override
     OSSAsyncTask<UploadPartResult> asyncUploadPart(UploadPartRequest request, OSSCompletedCallback<UploadPartRequest, UploadPartResult> completedCallback) {

        return mOss.asyncUploadPart(request, completedCallback);
    }

    @override
     UploadPartResult uploadPart(UploadPartRequest request)
             {

        return mOss.uploadPart(request);
    }

    @override
     OSSAsyncTask<CompleteMultipartUploadResult> asyncCompleteMultipartUpload(CompleteMultipartUploadRequest request, OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> completedCallback) {

        return mOss.asyncCompleteMultipartUpload(request, completedCallback);
    }

    @override
     CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request)
             {

        return mOss.completeMultipartUpload(request);
    }

    @override
     OSSAsyncTask<AbortMultipartUploadResult> asyncAbortMultipartUpload(AbortMultipartUploadRequest request, OSSCompletedCallback<AbortMultipartUploadRequest, AbortMultipartUploadResult> completedCallback) {

        return mOss.asyncAbortMultipartUpload(request, completedCallback);
    }

    @override
     AbortMultipartUploadResult abortMultipartUpload(AbortMultipartUploadRequest request)
             {

        return mOss.abortMultipartUpload(request);
    }

    @override
     OSSAsyncTask<ListPartsResult> asyncListParts(ListPartsRequest request, OSSCompletedCallback<ListPartsRequest, ListPartsResult> completedCallback) {

        return mOss.asyncListParts(request, completedCallback);
    }

    @override
     ListPartsResult listParts(ListPartsRequest request)
             {

        return mOss.listParts(request);
    }

    @override
     OSSAsyncTask<ListMultipartUploadsResult> asyncListMultipartUploads(ListMultipartUploadsRequest request, OSSCompletedCallback<ListMultipartUploadsRequest, ListMultipartUploadsResult> completedCallback) {
        return mOss.asyncListMultipartUploads(request, completedCallback);
    }

    @override
     ListMultipartUploadsResult listMultipartUploads(ListMultipartUploadsRequest request)  {
        return mOss.listMultipartUploads(request);
    }

    @override
     void updateCredentialProvider(OSSCredentialProvider credentialProvider) {
        mOss.updateCredentialProvider(credentialProvider);
    }

    @override
     OSSAsyncTask<CompleteMultipartUploadResult> asyncMultipartUpload(
            MultipartUploadRequest request, OSSCompletedCallback<MultipartUploadRequest, CompleteMultipartUploadResult> completedCallback) {

        return mOss.asyncMultipartUpload(request, completedCallback);
    }

    @override
     CompleteMultipartUploadResult multipartUpload(MultipartUploadRequest request)
             {

        return mOss.multipartUpload(request);
    }

    @override
     OSSAsyncTask<ResumableUploadResult> asyncResumableUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback) {

        return mOss.asyncResumableUpload(request, completedCallback);
    }

    @override
     ResumableUploadResult resumableUpload(ResumableUploadRequest request)
             {
        return mOss.resumableUpload(request);
    }

    @override
     OSSAsyncTask<ResumableUploadResult> asyncSequenceUpload(ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback) {
        return mOss.asyncSequenceUpload(request, completedCallback);
    }

    @override
     ResumableUploadResult sequenceUpload(ResumableUploadRequest request)  {
        return mOss.sequenceUpload(request);
    }

    @override
     String presignConstrainedObjectURL(GeneratePresignedUrlRequest request)  {
        return mOss.presignConstrainedObjectURL(request);
    }

    @override
     String presignConstrainedObjectURL(String bucketName, String objectKey, int expiredTimeInSeconds)
             {

        return mOss.presignConstrainedObjectURL(bucketName, objectKey, expiredTimeInSeconds);
    }

    @override
     String presignObjectURL(String bucketName, String objectKey) {

        return mOss.presignObjectURL(bucketName, objectKey);
    }

    @override
     bool doesObjectExist(String bucketName, String objectKey)
             {

        return mOss.doesObjectExist(bucketName, objectKey);
    }

    @override
     void abortResumableUpload(ResumableUploadRequest request)  {

        mOss.abortResumableUpload(request);
    }

    @override
     OSSAsyncTask<TriggerCallbackResult> asyncTriggerCallback(TriggerCallbackRequest request, OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult> completedCallback) {
        return mOss.asyncTriggerCallback(request, completedCallback);
    }

    @override
     TriggerCallbackResult triggerCallback(TriggerCallbackRequest request)  {
        return mOss.triggerCallback(request);
    }

    @override
     OSSAsyncTask<ImagePersistResult> asyncImagePersist(ImagePersistRequest request, OSSCompletedCallback<ImagePersistRequest, ImagePersistResult> completedCallback) {
        return mOss.asyncImagePersist(request, completedCallback);
    }

    @override
     ImagePersistResult imagePersist(ImagePersistRequest request)  {
        return mOss.imagePersist(request);
    }

    @override
     PutSymlinkResult putSymlink(PutSymlinkRequest request)  {
        return mOss.putSymlink(request);
    }

    @override
     OSSAsyncTask<PutSymlinkResult> asyncPutSymlink(PutSymlinkRequest request, OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult> completedCallback) {
        return mOss.asyncPutSymlink(request, completedCallback);
    }

    @override
     GetSymlinkResult getSymlink(GetSymlinkRequest request)  {
        return mOss.getSymlink(request);
    }

    @override
     OSSAsyncTask<GetSymlinkResult> asyncGetSymlink(GetSymlinkRequest request, OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult> completedCallback) {
        return mOss.asyncGetSymlink(request, completedCallback);
    }

    @override
     RestoreObjectResult restoreObject(RestoreObjectRequest request)  {
        return mOss.restoreObject(request);
    }

    @override
     OSSAsyncTask<RestoreObjectResult> asyncRestoreObject(RestoreObjectRequest request, OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult> completedCallback) {
        return mOss.asyncRestoreObject(request, completedCallback);
    }

    @override
     OSSAsyncTask<ResumableDownloadResult> asyncResumableDownload(ResumableDownloadRequest request, OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult> completedCallback) {
        return mOss.asyncResumableDownload(request, completedCallback);
    }

    @override
     ResumableDownloadResult syncResumableDownload(ResumableDownloadRequest request)  {
        return mOss.syncResumableDownload(request);
    }
}
