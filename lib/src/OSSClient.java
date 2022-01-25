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

    @Override
     OSSAsyncTask<ListBucketsResult> asyncListBuckets(
            ListBucketsRequest request, OSSCompletedCallback<ListBucketsRequest, ListBucketsResult> completedCallback) {
        return mOss.asyncListBuckets(request, completedCallback);
    }

    @Override
     ListBucketsResult listBuckets(ListBucketsRequest request)
            throws ClientException, ServiceException {
        return mOss.listBuckets(request);
    }

    @Override
     OSSAsyncTask<CreateBucketResult> asyncCreateBucket(
            CreateBucketRequest request, OSSCompletedCallback<CreateBucketRequest, CreateBucketResult> completedCallback) {

        return mOss.asyncCreateBucket(request, completedCallback);
    }

    @Override
     CreateBucketResult createBucket(CreateBucketRequest request)
            throws ClientException, ServiceException {

        return mOss.createBucket(request);
    }

    @Override
     OSSAsyncTask<DeleteBucketResult> asyncDeleteBucket(
            DeleteBucketRequest request, OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult> completedCallback) {

        return mOss.asyncDeleteBucket(request, completedCallback);
    }

    @Override
     DeleteBucketResult deleteBucket(DeleteBucketRequest request)
            throws ClientException, ServiceException {

        return mOss.deleteBucket(request);
    }

    @Override
     OSSAsyncTask<GetBucketInfoResult> asyncGetBucketInfo(GetBucketInfoRequest request, OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult> completedCallback) {
        return mOss.asyncGetBucketInfo(request, completedCallback);
    }

    @Override
     GetBucketInfoResult getBucketInfo(GetBucketInfoRequest request) throws ClientException, ServiceException {
        return mOss.getBucketInfo(request);
    }

    @Override
     OSSAsyncTask<GetBucketACLResult> asyncGetBucketACL(
            GetBucketACLRequest request, OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult> completedCallback) {

        return mOss.asyncGetBucketACL(request, completedCallback);
    }

    @Override
     GetBucketACLResult getBucketACL(GetBucketACLRequest request)
            throws ClientException, ServiceException {

        return mOss.getBucketACL(request);
    }

    @Override
     OSSAsyncTask<PutBucketRefererResult> asyncPutBucketReferer(PutBucketRefererRequest request, OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult> completedCallback) {
        return mOss.asyncPutBucketReferer(request, completedCallback);
    }

    @Override
     PutBucketRefererResult putBucketReferer(PutBucketRefererRequest request) throws ClientException, ServiceException {
        return mOss.putBucketReferer(request);
    }

    @Override
     GetBucketRefererResult getBucketReferer(GetBucketRefererRequest request) throws ClientException, ServiceException {
        return mOss.getBucketReferer(request);
    }

    @Override
     OSSAsyncTask<GetBucketRefererResult> asyncGetBucketReferer(GetBucketRefererRequest request, OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult> completedCallback) {
        return mOss.asyncGetBucketReferer(request, completedCallback);
    }

    @Override
     DeleteBucketLoggingResult deleteBucketLogging(DeleteBucketLoggingRequest request) throws ClientException, ServiceException {
        return mOss.deleteBucketLogging(request);
    }

    @Override
     OSSAsyncTask<DeleteBucketLoggingResult> asyncDeleteBucketLogging(DeleteBucketLoggingRequest request, OSSCompletedCallback<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> completedCallback) {
        return mOss.asyncDeleteBucketLogging(request, completedCallback);
    }

    @Override
     PutBucketLoggingResult putBucketLogging(PutBucketLoggingRequest request) throws ClientException, ServiceException {
        return mOss.putBucketLogging(request);
    }

    @Override
     OSSAsyncTask<PutBucketLoggingResult> asyncPutBucketLogging(PutBucketLoggingRequest request, OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult> completedCallback) {
        return mOss.asyncPutBucketLogging(request, completedCallback);
    }

    @Override
     GetBucketLoggingResult getBucketLogging(GetBucketLoggingRequest request) throws ClientException, ServiceException {
        return mOss.getBucketLogging(request);
    }

    @Override
     OSSAsyncTask<GetBucketLoggingResult> asyncGetBucketLogging(GetBucketLoggingRequest request, OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult> completedCallback) {
        return mOss.asyncGetBucketLogging(request, completedCallback);
    }

    @Override
     PutBucketLifecycleResult putBucketLifecycle(PutBucketLifecycleRequest request) throws ClientException, ServiceException {
        return mOss.putBucketLifecycle(request);
    }

    @Override
     OSSAsyncTask<PutBucketLifecycleResult> asyncPutBucketLifecycle(PutBucketLifecycleRequest request, OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult> completedCallback) {
        return mOss.asyncPutBucketLifecycle(request, completedCallback);
    }

    @Override
     GetBucketLifecycleResult getBucketLifecycle(GetBucketLifecycleRequest request) throws ClientException, ServiceException {
        return mOss.getBucketLifecycle(request);
    }

    @Override
     OSSAsyncTask<GetBucketLifecycleResult> asyncGetBucketLifecycle(GetBucketLifecycleRequest request, OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult> completedCallback) {
        return mOss.asyncGetBucketLifecycle(request, completedCallback);
    }

    @Override
     DeleteBucketLifecycleResult deleteBucketLifecycle(DeleteBucketLifecycleRequest request) throws ClientException, ServiceException {
        return mOss.deleteBucketLifecycle(request);
    }

    @Override
     OSSAsyncTask<DeleteBucketLifecycleResult> asyncDeleteBucketLifecycle(DeleteBucketLifecycleRequest request, OSSCompletedCallback<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> completedCallback) {
        return mOss.asyncDeleteBucketLifecycle(request, completedCallback);
    }

    @Override
     OSSAsyncTask<PutObjectResult> asyncPutObject(
            PutObjectRequest request, OSSCompletedCallback<PutObjectRequest, PutObjectResult> completedCallback) {

        return mOss.asyncPutObject(request, completedCallback);
    }

    @Override
     PutObjectResult putObject(PutObjectRequest request)
            throws ClientException, ServiceException {

        return mOss.putObject(request);
    }

    @Override
     OSSAsyncTask<GetObjectResult> asyncGetObject(
            GetObjectRequest request, OSSCompletedCallback<GetObjectRequest, GetObjectResult> completedCallback) {

        return mOss.asyncGetObject(request, completedCallback);
    }

    @Override
     GetObjectResult getObject(GetObjectRequest request)
            throws ClientException, ServiceException {

        return mOss.getObject(request);
    }

    @Override
     OSSAsyncTask<GetObjectACLResult> asyncGetObjectACL(
            GetObjectACLRequest request, OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult> completedCallback) {
        return mOss.asyncGetObjectACL(request, completedCallback);
    }

    @Override
     GetObjectACLResult getObjectACL(GetObjectACLRequest request)
            throws ClientException, ServiceException {
        return mOss.getObjectACL(request);
    }

    @Override
     OSSAsyncTask<DeleteObjectResult> asyncDeleteObject(
            DeleteObjectRequest request, OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult> completedCallback) {

        return mOss.asyncDeleteObject(request, completedCallback);
    }

    @Override
     DeleteObjectResult deleteObject(DeleteObjectRequest request)
            throws ClientException, ServiceException {

        return mOss.deleteObject(request);
    }

    @Override
     OSSAsyncTask<DeleteMultipleObjectResult> asyncDeleteMultipleObject(
            DeleteMultipleObjectRequest request, OSSCompletedCallback<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> completedCallback) {

        return mOss.asyncDeleteMultipleObject(request, completedCallback);
    }

    @Override
     DeleteMultipleObjectResult deleteMultipleObject(DeleteMultipleObjectRequest request)
            throws ClientException, ServiceException {
        return mOss.deleteMultipleObject(request);
    }

    @Override
     OSSAsyncTask<AppendObjectResult> asyncAppendObject(
            AppendObjectRequest request, OSSCompletedCallback<AppendObjectRequest, AppendObjectResult> completedCallback) {

        return mOss.asyncAppendObject(request, completedCallback);
    }

    @Override
     AppendObjectResult appendObject(AppendObjectRequest request)
            throws ClientException, ServiceException {

        return mOss.appendObject(request);
    }

    @Override
     OSSAsyncTask<HeadObjectResult> asyncHeadObject(HeadObjectRequest request, OSSCompletedCallback<HeadObjectRequest, HeadObjectResult> completedCallback) {

        return mOss.asyncHeadObject(request, completedCallback);
    }

    @Override
     HeadObjectResult headObject(HeadObjectRequest request)
            throws ClientException, ServiceException {

        return mOss.headObject(request);
    }

    @Override
     OSSAsyncTask<CopyObjectResult> asyncCopyObject(CopyObjectRequest request, OSSCompletedCallback<CopyObjectRequest, CopyObjectResult> completedCallback) {

        return mOss.asyncCopyObject(request, completedCallback);
    }

    @Override
     CopyObjectResult copyObject(CopyObjectRequest request)
            throws ClientException, ServiceException {

        return mOss.copyObject(request);
    }

    @Override
     OSSAsyncTask<ListObjectsResult> asyncListObjects(
            ListObjectsRequest request, OSSCompletedCallback<ListObjectsRequest, ListObjectsResult> completedCallback) {

        return mOss.asyncListObjects(request, completedCallback);
    }

    @Override
     ListObjectsResult listObjects(ListObjectsRequest request)
            throws ClientException, ServiceException {

        return mOss.listObjects(request);
    }

    @Override
     OSSAsyncTask<InitiateMultipartUploadResult> asyncInitMultipartUpload(InitiateMultipartUploadRequest request, OSSCompletedCallback<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> completedCallback) {

        return mOss.asyncInitMultipartUpload(request, completedCallback);
    }

    @Override
     InitiateMultipartUploadResult initMultipartUpload(InitiateMultipartUploadRequest request)
            throws ClientException, ServiceException {

        return mOss.initMultipartUpload(request);
    }

    @Override
     OSSAsyncTask<UploadPartResult> asyncUploadPart(UploadPartRequest request, OSSCompletedCallback<UploadPartRequest, UploadPartResult> completedCallback) {

        return mOss.asyncUploadPart(request, completedCallback);
    }

    @Override
     UploadPartResult uploadPart(UploadPartRequest request)
            throws ClientException, ServiceException {

        return mOss.uploadPart(request);
    }

    @Override
     OSSAsyncTask<CompleteMultipartUploadResult> asyncCompleteMultipartUpload(CompleteMultipartUploadRequest request, OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> completedCallback) {

        return mOss.asyncCompleteMultipartUpload(request, completedCallback);
    }

    @Override
     CompleteMultipartUploadResult completeMultipartUpload(CompleteMultipartUploadRequest request)
            throws ClientException, ServiceException {

        return mOss.completeMultipartUpload(request);
    }

    @Override
     OSSAsyncTask<AbortMultipartUploadResult> asyncAbortMultipartUpload(AbortMultipartUploadRequest request, OSSCompletedCallback<AbortMultipartUploadRequest, AbortMultipartUploadResult> completedCallback) {

        return mOss.asyncAbortMultipartUpload(request, completedCallback);
    }

    @Override
     AbortMultipartUploadResult abortMultipartUpload(AbortMultipartUploadRequest request)
            throws ClientException, ServiceException {

        return mOss.abortMultipartUpload(request);
    }

    @Override
     OSSAsyncTask<ListPartsResult> asyncListParts(ListPartsRequest request, OSSCompletedCallback<ListPartsRequest, ListPartsResult> completedCallback) {

        return mOss.asyncListParts(request, completedCallback);
    }

    @Override
     ListPartsResult listParts(ListPartsRequest request)
            throws ClientException, ServiceException {

        return mOss.listParts(request);
    }

    @Override
     OSSAsyncTask<ListMultipartUploadsResult> asyncListMultipartUploads(ListMultipartUploadsRequest request, OSSCompletedCallback<ListMultipartUploadsRequest, ListMultipartUploadsResult> completedCallback) {
        return mOss.asyncListMultipartUploads(request, completedCallback);
    }

    @Override
     ListMultipartUploadsResult listMultipartUploads(ListMultipartUploadsRequest request) throws ClientException, ServiceException {
        return mOss.listMultipartUploads(request);
    }

    @Override
     void updateCredentialProvider(OSSCredentialProvider credentialProvider) {
        mOss.updateCredentialProvider(credentialProvider);
    }

    @Override
     OSSAsyncTask<CompleteMultipartUploadResult> asyncMultipartUpload(
            MultipartUploadRequest request, OSSCompletedCallback<MultipartUploadRequest, CompleteMultipartUploadResult> completedCallback) {

        return mOss.asyncMultipartUpload(request, completedCallback);
    }

    @Override
     CompleteMultipartUploadResult multipartUpload(MultipartUploadRequest request)
            throws ClientException, ServiceException {

        return mOss.multipartUpload(request);
    }

    @Override
     OSSAsyncTask<ResumableUploadResult> asyncResumableUpload(
            ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback) {

        return mOss.asyncResumableUpload(request, completedCallback);
    }

    @Override
     ResumableUploadResult resumableUpload(ResumableUploadRequest request)
            throws ClientException, ServiceException {
        return mOss.resumableUpload(request);
    }

    @Override
     OSSAsyncTask<ResumableUploadResult> asyncSequenceUpload(ResumableUploadRequest request, OSSCompletedCallback<ResumableUploadRequest, ResumableUploadResult> completedCallback) {
        return mOss.asyncSequenceUpload(request, completedCallback);
    }

    @Override
     ResumableUploadResult sequenceUpload(ResumableUploadRequest request) throws ClientException, ServiceException {
        return mOss.sequenceUpload(request);
    }

    @Override
     String presignConstrainedObjectURL(GeneratePresignedUrlRequest request) throws ClientException {
        return mOss.presignConstrainedObjectURL(request);
    }

    @Override
     String presignConstrainedObjectURL(String bucketName, String objectKey, int expiredTimeInSeconds)
            throws ClientException {

        return mOss.presignConstrainedObjectURL(bucketName, objectKey, expiredTimeInSeconds);
    }

    @Override
     String presignObjectURL(String bucketName, String objectKey) {

        return mOss.presignObjectURL(bucketName, objectKey);
    }

    @Override
     bool doesObjectExist(String bucketName, String objectKey)
            throws ClientException, ServiceException {

        return mOss.doesObjectExist(bucketName, objectKey);
    }

    @Override
     void abortResumableUpload(ResumableUploadRequest request) throws IOException {

        mOss.abortResumableUpload(request);
    }

    @Override
     OSSAsyncTask<TriggerCallbackResult> asyncTriggerCallback(TriggerCallbackRequest request, OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult> completedCallback) {
        return mOss.asyncTriggerCallback(request, completedCallback);
    }

    @Override
     TriggerCallbackResult triggerCallback(TriggerCallbackRequest request) throws ClientException, ServiceException {
        return mOss.triggerCallback(request);
    }

    @Override
     OSSAsyncTask<ImagePersistResult> asyncImagePersist(ImagePersistRequest request, OSSCompletedCallback<ImagePersistRequest, ImagePersistResult> completedCallback) {
        return mOss.asyncImagePersist(request, completedCallback);
    }

    @Override
     ImagePersistResult imagePersist(ImagePersistRequest request) throws ClientException, ServiceException {
        return mOss.imagePersist(request);
    }

    @Override
     PutSymlinkResult putSymlink(PutSymlinkRequest request) throws ClientException, ServiceException {
        return mOss.putSymlink(request);
    }

    @Override
     OSSAsyncTask<PutSymlinkResult> asyncPutSymlink(PutSymlinkRequest request, OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult> completedCallback) {
        return mOss.asyncPutSymlink(request, completedCallback);
    }

    @Override
     GetSymlinkResult getSymlink(GetSymlinkRequest request) throws ClientException, ServiceException {
        return mOss.getSymlink(request);
    }

    @Override
     OSSAsyncTask<GetSymlinkResult> asyncGetSymlink(GetSymlinkRequest request, OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult> completedCallback) {
        return mOss.asyncGetSymlink(request, completedCallback);
    }

    @Override
     RestoreObjectResult restoreObject(RestoreObjectRequest request) throws ClientException, ServiceException {
        return mOss.restoreObject(request);
    }

    @Override
     OSSAsyncTask<RestoreObjectResult> asyncRestoreObject(RestoreObjectRequest request, OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult> completedCallback) {
        return mOss.asyncRestoreObject(request, completedCallback);
    }

    @Override
     OSSAsyncTask<ResumableDownloadResult> asyncResumableDownload(ResumableDownloadRequest request, OSSCompletedCallback<ResumableDownloadRequest, ResumableDownloadResult> completedCallback) {
        return mOss.asyncResumableDownload(request, completedCallback);
    }

    @Override
     ResumableDownloadResult syncResumableDownload(ResumableDownloadRequest request) throws ClientException, ServiceException {
        return mOss.syncResumableDownload(request);
    }
}
