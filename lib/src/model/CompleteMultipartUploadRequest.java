package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by zhouzhuo on 11/24/15.
 */
 class CompleteMultipartUploadRequest extends OSSRequest {

    /**
     * The name of the bucket containing the multipart upload to complete
     */
     String bucketName;

    /**
     * The objectKey of the multipart upload to complete
     */
     String objectKey;

    /**
     * The ID of the multipart upload to complete
     */
     String uploadId;

    /**
     * The list of part numbers and ETags to use when completing the multipart upload
     */
     List<PartETag> partETags = [];

     Map<String, String> callbackParam;

     Map<String, String> callbackVars;

     ObjectMetadata metadata;

    /**
     * Constructor of CompleteMultipartUploadRequest
     *
     * @param bucketName bucket name
     * @param objectKey  Object objectKey.
     * @param uploadId   Mutlipart upload ID.
     * @param partETags  The list of PartETag instances
     */
     CompleteMultipartUploadRequest(String bucketName, String objectKey, String uploadId, List<PartETag> partETags) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadId(uploadId);
        setPartETags(partETags);
    }

    /**
     * Gets bucket name
     *
     * @return bucket name
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets bucket name
     *
     * @param bucketName bucket name
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    /**
     * Gets OSSObject.
     *
     * @return Object objectKey。
     */
     String getObjectKey() {
        return objectKey;
    }

    /**
     * Sets objectKey.
     *
     * @param objectKey Object objectKey。
     */
     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

    /**
     * Gets the multipart upload Id
     *
     * @return the multipart upload Id
     */
     String getUploadId() {
        return uploadId;
    }

    /**
     * Sets the multipart upload Id
     *
     * @param uploadId the multipart upload Id
     */
     void setUploadId(String uploadId) {
        this.uploadId = uploadId;
    }

    /**
     * Gets the list of PartETag instances
     *
     * @return The list of PartETag instances
     */
     List<PartETag> getPartETags() {
        return partETags;
    }

    /**
     * Sets the list of PartETag instances
     *
     * @param partETags The list of PartETag instances
     */
     void setPartETags(List<PartETag> partETags) {
        this.partETags = partETags;
    }

     Map<String, String> getCallbackParam() {
        return callbackParam;
    }

    /**
     * Sets the servercallback parameters
     */
     void setCallbackParam(Map<String, String> callbackParam) {
        this.callbackParam = callbackParam;
    }

     Map<String, String> getCallbackVars() {
        return callbackVars;
    }

    /**
     * Sets the servercallback custom variables
     */
     void setCallbackVars(Map<String, String> callbackVars) {
        this.callbackVars = callbackVars;
    }

    /**
     * Sets the medatadata
     */
     ObjectMetadata getMetadata() {
        return metadata;
    }

    /**
     * Gets the metadata
     */
     void setMetadata(ObjectMetadata metadata) {
        this.metadata = metadata;
    }
}
