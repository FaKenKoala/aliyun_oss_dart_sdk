/**
 * Copyright (C) Alibaba Cloud Computing, 2015
 * All rights reserved.
 * <p>
 * 版权所有 （C）阿里巴巴云计算，2015
 */

package com.alibaba.sdk.android.oss;

import android.content.Context;

import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.internal.OSSAsyncTask;
import com.alibaba.sdk.android.oss.model.AbortMultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.AbortMultipartUploadResult;
import com.alibaba.sdk.android.oss.model.AppendObjectRequest;
import com.alibaba.sdk.android.oss.model.AppendObjectResult;
import com.alibaba.sdk.android.oss.model.ResumableDownloadResult;
import com.alibaba.sdk.android.oss.model.CompleteMultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.CompleteMultipartUploadResult;
import com.alibaba.sdk.android.oss.model.CopyObjectRequest;
import com.alibaba.sdk.android.oss.model.CopyObjectResult;
import com.alibaba.sdk.android.oss.model.CreateBucketRequest;
import com.alibaba.sdk.android.oss.model.CreateBucketResult;
import com.alibaba.sdk.android.oss.model.DeleteBucketLifecycleRequest;
import com.alibaba.sdk.android.oss.model.DeleteBucketLifecycleResult;
import com.alibaba.sdk.android.oss.model.DeleteBucketLoggingRequest;
import com.alibaba.sdk.android.oss.model.DeleteBucketLoggingResult;
import com.alibaba.sdk.android.oss.model.DeleteBucketRequest;
import com.alibaba.sdk.android.oss.model.DeleteBucketResult;
import com.alibaba.sdk.android.oss.model.DeleteMultipleObjectRequest;
import com.alibaba.sdk.android.oss.model.DeleteMultipleObjectResult;
import com.alibaba.sdk.android.oss.model.DeleteObjectRequest;
import com.alibaba.sdk.android.oss.model.DeleteObjectResult;
import com.alibaba.sdk.android.oss.model.GeneratePresignedUrlRequest;
import com.alibaba.sdk.android.oss.model.GetBucketACLRequest;
import com.alibaba.sdk.android.oss.model.GetBucketACLResult;
import com.alibaba.sdk.android.oss.model.GetBucketInfoRequest;
import com.alibaba.sdk.android.oss.model.GetBucketInfoResult;
import com.alibaba.sdk.android.oss.model.GetBucketLifecycleRequest;
import com.alibaba.sdk.android.oss.model.GetBucketLifecycleResult;
import com.alibaba.sdk.android.oss.model.GetBucketLoggingRequest;
import com.alibaba.sdk.android.oss.model.GetBucketLoggingResult;
import com.alibaba.sdk.android.oss.model.GetBucketRefererRequest;
import com.alibaba.sdk.android.oss.model.GetBucketRefererResult;
import com.alibaba.sdk.android.oss.model.GetObjectACLRequest;
import com.alibaba.sdk.android.oss.model.GetObjectACLResult;
import com.alibaba.sdk.android.oss.model.GetObjectRequest;
import com.alibaba.sdk.android.oss.model.GetObjectResult;
import com.alibaba.sdk.android.oss.model.GetSymlinkRequest;
import com.alibaba.sdk.android.oss.model.GetSymlinkResult;
import com.alibaba.sdk.android.oss.model.HeadObjectRequest;
import com.alibaba.sdk.android.oss.model.HeadObjectResult;
import com.alibaba.sdk.android.oss.model.ImagePersistRequest;
import com.alibaba.sdk.android.oss.model.ImagePersistResult;
import com.alibaba.sdk.android.oss.model.InitiateMultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.InitiateMultipartUploadResult;
import com.alibaba.sdk.android.oss.model.ListBucketsRequest;
import com.alibaba.sdk.android.oss.model.ListBucketsResult;
import com.alibaba.sdk.android.oss.model.ListMultipartUploadsRequest;
import com.alibaba.sdk.android.oss.model.ListMultipartUploadsResult;
import com.alibaba.sdk.android.oss.model.ListObjectsRequest;
import com.alibaba.sdk.android.oss.model.ListObjectsResult;
import com.alibaba.sdk.android.oss.model.ListPartsRequest;
import com.alibaba.sdk.android.oss.model.ListPartsResult;
import com.alibaba.sdk.android.oss.model.ResumableDownloadRequest;
import com.alibaba.sdk.android.oss.model.MultipartUploadRequest;
import com.alibaba.sdk.android.oss.model.PutBucketLifecycleRequest;
import com.alibaba.sdk.android.oss.model.PutBucketLifecycleResult;
import com.alibaba.sdk.android.oss.model.PutBucketLoggingRequest;
import com.alibaba.sdk.android.oss.model.PutBucketLoggingResult;
import com.alibaba.sdk.android.oss.model.PutBucketRefererRequest;
import com.alibaba.sdk.android.oss.model.PutBucketRefererResult;
import com.alibaba.sdk.android.oss.model.PutObjectRequest;
import com.alibaba.sdk.android.oss.model.PutObjectResult;
import com.alibaba.sdk.android.oss.model.PutSymlinkRequest;
import com.alibaba.sdk.android.oss.model.PutSymlinkResult;
import com.alibaba.sdk.android.oss.model.RestoreObjectRequest;
import com.alibaba.sdk.android.oss.model.RestoreObjectResult;
import com.alibaba.sdk.android.oss.model.ResumableUploadRequest;
import com.alibaba.sdk.android.oss.model.ResumableUploadResult;
import com.alibaba.sdk.android.oss.model.TriggerCallbackRequest;
import com.alibaba.sdk.android.oss.model.TriggerCallbackResult;
import com.alibaba.sdk.android.oss.model.UploadPartRequest;
import com.alibaba.sdk.android.oss.model.UploadPartResult;

import java.io.IOException;

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
        mOss = new OSSImpl(context, endpoint, credentialProvider, conf);
    }

     OSSClient(Context context, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        mOss = new OSSImpl(context, credentialProvider, conf);
    }

    @override
     OSSAsyncTask<ListBucketsResult> asyncListBuckets(
            ListBucketsRequest request, OSSCompletedCallback<ListBucketsRequest, ListBucketsResult> completedCallback) {
        return mOss.asyncListBuckets(request, completedCallback);
    }

    @override
     ListBucketsResult listBuckets(ListBucketsRequest request)
            throws OSSClientException, OSSServiceException {
        return mOss.listBuckets(request);
    }

    @override
     OSSAsyncTask<CreateBucketResult> asyncCreateBucket(
            CreateBucketRequest request, OSSCompletedCallback<CreateBucketRequest, CreateBucketResult> completedCallback) {

        return mOss.asyncCreateBucket(request, completedCallback);
    }

    @override
     CreateBucketResult createBucket(CreateBucketRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.createBucket(request);
    }

    @override
     OSSAsyncTask<DeleteBucketResult> asyncDeleteBucket(
            DeleteBucketRequest request, OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult> completedCallback) {

        return mOss.asyncDeleteBucket(request, completedCallback);
    }

    @override
     DeleteBucketResult deleteBucket(DeleteBucketRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.deleteBucket(request);
    }

    @override
     OSSAsyncTask<GetBucketInfoResult> asyncGetBucketInfo(GetBucketInfoRequest request, OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult> completedCallback) {
        return mOss.asyncGetBucketInfo(request, completedCallback);
    }

    @override
     GetBucketInfoResult getBucketInfo(GetBucketInfoRequest request) throws OSSClientException, OSSServiceException {
        return mOss.getBucketInfo(request);
    }

    @override
     OSSAsyncTask<GetBucketACLResult> asyncGetBucketACL(
            GetBucketACLRequest request, OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult> completedCallback) {

        return mOss.asyncGetBucketACL(request, completedCallback);
    }

    @override
     GetBucketACLResult getBucketACL(GetBucketACLRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.getBucketACL(request);
    }

    @override
     OSSAsyncTask<PutBucketRefererResult> asyncPutBucketReferer(PutBucketRefererRequest request, OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult> completedCallback) {
        return mOss.asyncPutBucketReferer(request, completedCallback);
    }

    @override
     PutBucketRefererResult putBucketReferer(PutBucketRefererRequest request) throws OSSClientException, OSSServiceException {
        return mOss.putBucketReferer(request);
    }

    @override
     GetBucketRefererResult getBucketReferer(GetBucketRefererRequest request) throws OSSClientException, OSSServiceException {
        return mOss.getBucketReferer(request);
    }

    @override
     OSSAsyncTask<GetBucketRefererResult> asyncGetBucketReferer(GetBucketRefererRequest request, OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult> completedCallback) {
        return mOss.asyncGetBucketReferer(request, completedCallback);
    }

    @override
     DeleteBucketLoggingResult deleteBucketLogging(DeleteBucketLoggingRequest request) throws OSSClientException, OSSServiceException {
        return mOss.deleteBucketLogging(request);
    }

    @override
     OSSAsyncTask<DeleteBucketLoggingResult> asyncDeleteBucketLogging(DeleteBucketLoggingRequest request, OSSCompletedCallback<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> completedCallback) {
        return mOss.asyncDeleteBucketLogging(request, completedCallback);
    }

    @override
     PutBucketLoggingResult putBucketLogging(PutBucketLoggingRequest request) throws OSSClientException, OSSServiceException {
        return mOss.putBucketLogging(request);
    }

    @override
     OSSAsyncTask<PutBucketLoggingResult> asyncPutBucketLogging(PutBucketLoggingRequest request, OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult> completedCallback) {
        return mOss.asyncPutBucketLogging(request, completedCallback);
    }

    @override
     GetBucketLoggingResult getBucketLogging(GetBucketLoggingRequest request) throws OSSClientException, OSSServiceException {
        return mOss.getBucketLogging(request);
    }

    @override
     OSSAsyncTask<GetBucketLoggingResult> asyncGetBucketLogging(GetBucketLoggingRequest request, OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult> completedCallback) {
        return mOss.asyncGetBucketLogging(request, completedCallback);
    }

    @override
     PutBucketLifecycleResult putBucketLifecycle(PutBucketLifecycleRequest request) throws OSSClientException, OSSServiceException {
        return mOss.putBucketLifecycle(request);
    }

    @override
     OSSAsyncTask<PutBucketLifecycleResult> asyncPutBucketLifecycle(PutBucketLifecycleRequest request, OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult> completedCallback) {
        return mOss.asyncPutBucketLifecycle(request, completedCallback);
    }

    @override
     GetBucketLifecycleResult getBucketLifecycle(GetBucketLifecycleRequest request) throws OSSClientException, OSSServiceException {
        return mOss.getBucketLifecycle(request);
    }

    @override
     OSSAsyncTask<GetBucketLifecycleResult> asyncGetBucketLifecycle(GetBucketLifecycleRequest request, OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult> completedCallback) {
        return mOss.asyncGetBucketLifecycle(request, completedCallback);
    }

    @override
     DeleteBucketLifecycleResult deleteBucketLifecycle(DeleteBucketLifecycleRequest request) throws OSSClientException, OSSServiceException {
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
            throws OSSClientException, OSSServiceException {

        return mOss.putObject(request);
    }

    @override
     OSSAsyncTask<GetObjectResult> asyncGetObject(
            GetObjectRequest request, OSSCompletedCallback<GetObjectRequest, GetObjectResult> completedCallback) {

        return mOss.asyncGetObject(request, completedCallback);
    }

    @override
     GetObjectResult getObject(GetObjectRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.getObject(request);
    }

    @override
     OSSAsyncTask<GetObjectACLResult> asyncGetObjectACL(
            GetObjectACLRequest request, OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult> completedCallback) {
        return mOss.asyncGetObjectACL(request, completedCallback);
    }

    @override
     GetObjectACLResult getObjectACL(GetObjectACLRequest request)
            throws OSSClientException, OSSServiceException {
        return mOss.getObjectACL(request);
    }

    @override
     OSSAsyncTask<DeleteObjectResult> asyncDeleteObject(
            DeleteObjectRequest request, OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult> completedCallback) {

        return mOss.asyncDeleteObject(request, completedCallback);
    }

    @override
     DeleteObjectResult deleteObject(DeleteObjectRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.deleteObject(request);
    }

    @override
     OSSAsyncTask<DeleteMultipleObjectResult> asyncDeleteMultipleObject(
            DeleteMultipleObjectRequest request, OSSCompletedCallback<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> completedCallback) {

        return mOss.asyncDeleteMultipleObject(request, completedCallback);
    }

    @override
     DeleteMultipleObjectResult deleteMultipleObject(DeleteMultipleObjectRequest request)
            throws OSSClientException, OSSServiceException {
        return mOss.deleteMultipleObject(request);
    }

    @override
     OSSAsyncTask<AppendObjectResult> asyncAppendObject(
            AppendObjectRequest request, OSSCompletedCallback<AppendObjectRequest, AppendObjectResult> completedCallback) {

        return mOss.asyncAppendObject(request, completedCallback);
    }

    @override
     AppendObjectResult appendObject(AppendObjectRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.appendObject(request);
    }

    @override
     OSSAsyncTask<HeadObjectResult> asyncHeadObject(HeadObjectRequest request, OSSCompletedCallback<HeadObjectRequest, HeadObjectResult> completedCallback) {

        return mOss.asyncHeadObject(request, completedCallback);
    }

    @override
     HeadObjectResult headObject(HeadObjectRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.headObject(request);
    }

    @override
     OSSAsyncTask<CopyObjectResult> asyncCopyObject(CopyObjectRequest request, OSSCompletedCallback<CopyObjectRequest, CopyObjectResult> completedCallback) {

        return mOss.asyncCopyObject(request, completedCallback);
    }

    @override
     CopyObjectResult copyObject(CopyObjectRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.copyObject(request);
    }

    @override
     OSSAsyncTask<ListObjectsResult> asyncListObjects(
            ListObjectsRequest request, OSSCompletedCallback<ListObjectsRequest, ListObjectsResult> completedCallback) {

        return mOss.asyncListObjects(request, completedCallback);
    }

    @override
     ListObjectsResult listObjects(ListObjectsRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.listObjects(request);
    }

    @override
     OSSAsyncTask<InitiateMultipartUploadResult> asyncInitMultipartUpload(InitiateMultipartUploadRequest request, OSSCompletedCallback<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> completedCallback) {

        return mOss.asyncInitMultipartUpload(request, completedCallback);
    }

    @override
     InitiateMultipartUploadResult initMultipartUpload(InitiateMultipartUploadRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.initMultipartUpload(request);
    }

    @override
     OSSAsyncTask<UploadPartResult> asyncUploadPart(UploadPartRequest request, OSSCompletedCallback<UploadPartRequest, UploadPartResult> completedCallback) {

        return mOss.asyncUploadPart(request, completedCallback);
    }

    @override
     UploadPartResult uploadPart(UploadPartRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.uploadPart(request);
    }

    @override
     OSSAsyncTask<CompleteMultipartUploadResult> asyncCompleteMultipartUpload(CompleteMultipartUploadRequest request, OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> completedCallback) {

        return mOss.asyncCompleteMultipartUpload(request, completedCallback);
    }

    @override
     CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.completeMultipartUpload(request);
    }

    @override
     OSSAsyncTask<AbortMultipartUploadResult> asyncAbortMultipartUpload(AbortMultipartUploadRequest request, OSSCompletedCallback<AbortMultipartUploadRequest, AbortMultipartUploadResult> completedCallback) {

        return mOss.asyncAbortMultipartUpload(request, completedCallback);
    }

    @override
     AbortMultipartUploadResult abortMultipartUpload(AbortMultipartUploadRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.abortMultipartUpload(request);
    }

    @override
     OSSAsyncTask<ListPartsResult> asyncListParts(ListPartsRequest request, OSSCompletedCallback<ListPartsRequest, ListPartsResult> completedCallback) {

        return mOss.asyncListParts(request, completedCallback);
    }

    @override
     ListPartsResult listParts(ListPartsRequest request)
            throws OSSClientException, OSSServiceException {

        return mOss.listParts(request);
    }

    @override
     OSSAsyncTask<ListMultipartUploadsResult> asyncListMultipartUploads(ListMultipartUploadsRequest request, OSSCompletedCallback<ListMultipartUploadsRequest, ListMultipartUploadsResult> completedCallback) {
        return mOss.asyncListMultipartUploads(request, completedCallback);
    }

    @override
     ListMultipartUploadsResult listMultipartUploads(ListMultipartUploadsRequest request) throws OSSClientException, OSSServiceException {
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
            throws OSSClientException, OSSServiceException {

        return mOss.multipartUpload(request);
    }

    @override
     OSSAsyncTask<ResumableUploadResult> asyncResumableUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback) {

        return mOss.asyncResumableUpload(request, completedCallback);
    }

    @override
     ResumableUploadResult resumableUpload(ResumableUploadRequest request)
            throws OSSClientException, OSSServiceException {
        return mOss.resumableUpload(request);
    }

    @override
     OSSAsyncTask<ResumableUploadResult> asyncSequenceUpload(ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback) {
        return mOss.asyncSequenceUpload(request, completedCallback);
    }

    @override
     ResumableUploadResult sequenceUpload(ResumableUploadRequest request) throws OSSClientException, OSSServiceException {
        return mOss.sequenceUpload(request);
    }

    @override
     String presignConstrainedObjectURL(GeneratePresignedUrlRequest request) throws OSSClientException {
        return mOss.presignConstrainedObjectURL(request);
    }

    @override
     String presignConstrainedObjectURL(String bucketName, String objectKey, int expiredTimeInSeconds)
            throws OSSClientException {

        return mOss.presignConstrainedObjectURL(bucketName, objectKey, expiredTimeInSeconds);
    }

    @override
     String presignObjectURL(String bucketName, String objectKey) {

        return mOss.presignObjectURL(bucketName, objectKey);
    }

    @override
     bool doesObjectExist(String bucketName, String objectKey)
            throws OSSClientException, OSSServiceException {

        return mOss.doesObjectExist(bucketName, objectKey);
    }

    @override
     void abortResumableUpload(ResumableUploadRequest request) throws IOException {

        mOss.abortResumableUpload(request);
    }

    @override
     OSSAsyncTask<TriggerCallbackResult> asyncTriggerCallback(TriggerCallbackRequest request, OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult> completedCallback) {
        return mOss.asyncTriggerCallback(request, completedCallback);
    }

    @override
     TriggerCallbackResult triggerCallback(TriggerCallbackRequest request) throws OSSClientException, OSSServiceException {
        return mOss.triggerCallback(request);
    }

    @override
     OSSAsyncTask<ImagePersistResult> asyncImagePersist(ImagePersistRequest request, OSSCompletedCallback<ImagePersistRequest, ImagePersistResult> completedCallback) {
        return mOss.asyncImagePersist(request, completedCallback);
    }

    @override
     ImagePersistResult imagePersist(ImagePersistRequest request) throws OSSClientException, OSSServiceException {
        return mOss.imagePersist(request);
    }

    @override
     PutSymlinkResult putSymlink(PutSymlinkRequest request) throws OSSClientException, OSSServiceException {
        return mOss.putSymlink(request);
    }

    @override
     OSSAsyncTask<PutSymlinkResult> asyncPutSymlink(PutSymlinkRequest request, OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult> completedCallback) {
        return mOss.asyncPutSymlink(request, completedCallback);
    }

    @override
     GetSymlinkResult getSymlink(GetSymlinkRequest request) throws OSSClientException, OSSServiceException {
        return mOss.getSymlink(request);
    }

    @override
     OSSAsyncTask<GetSymlinkResult> asyncGetSymlink(GetSymlinkRequest request, OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult> completedCallback) {
        return mOss.asyncGetSymlink(request, completedCallback);
    }

    @override
     RestoreObjectResult restoreObject(RestoreObjectRequest request) throws OSSClientException, OSSServiceException {
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
     ResumableDownloadResult syncResumableDownload(ResumableDownloadRequest request) throws OSSClientException, OSSServiceException {
        return mOss.syncResumableDownload(request);
    }
}
