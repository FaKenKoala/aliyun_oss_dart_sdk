package com.alibaba.sdk.android.oss.model;

import android.net.Uri;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.common.OSSConstants;

import java.util.Map;

 class MultipartUploadRequest<T extends MultipartUploadRequest> extends OSSRequest {
     String bucketName;
     String objectKey;
     String uploadId;

     String uploadFilePath;
     Uri uploadUri;
     int partSize = 256 * 1024;

     ObjectMetadata metadata;

     Map<String, String> callbackParam;
     Map<String, String> callbackVars;

     OSSProgressCallback<T> progressCallback;

    /**
     * Constructor
     *
     * @param bucketName     The target object's bucket name
     * @param objectKey      The target object's key
     * @param uploadFilePath The local path of the file to upload
     */
     MultipartUploadRequest(String bucketName, String objectKey, String uploadFilePath) {
        this(bucketName, objectKey, uploadFilePath, null);
    }

    /**
     * Constructor
     *
     * @param bucketName     The target object's bucket name
     * @param objectKey      The target object's key
     * @param uploadFilePath The local path of the file to upload
     * @param metadata       The metadata of the target object
     */
     MultipartUploadRequest(String bucketName, String objectKey, String uploadFilePath, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadFilePath(uploadFilePath);
        setMetadata(metadata);
    }

    /**
     * Constructor
     *
     * @param bucketName     The target object's bucket name
     * @param objectKey      The target object's key
     * @param uploadUri      The Uri of the file to upload
     */
     MultipartUploadRequest(String bucketName, String objectKey, Uri uploadUri) {
        this(bucketName, objectKey, uploadUri, null);
    }

    /**
     * Constructor
     *
     * @param bucketName     The target object's bucket name
     * @param objectKey      The target object's key
     * @param uploadUri      The Uri of the file to upload
     * @param metadata       The metadata of the target object
     */
     MultipartUploadRequest(String bucketName, String objectKey, Uri uploadUri, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadUri(uploadUri);
        setMetadata(metadata);
    }

     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the OSS bucket name
     *
     * @param bucketName
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     String getObjectKey() {
        return objectKey;
    }

    /**
     * Sets the OSS object key
     *
     * @param objectKey
     */
     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

     String getUploadFilePath() {
        return uploadFilePath;
    }

    /**
     * Sets the local path of the file to upload
     *
     * @param uploadFilePath the local path of the file to upload
     */
     void setUploadFilePath(String uploadFilePath) {
        this.uploadFilePath = uploadFilePath;
    }

     ObjectMetadata getMetadata() {
        return metadata;
    }


     Uri getUploadUri() {
        return uploadUri;
    }

     void setUploadUri(Uri uploadUri) {
        this.uploadUri = uploadUri;
    }

    /**
     * Sets the metadata of the target object
     *
     * @param metadata The metadata
     */
     void setMetadata(ObjectMetadata metadata) {
        this.metadata = metadata;
    }

     OSSProgressCallback<T> getProgressCallback() {
        return progressCallback;
    }

    /**
     * Sets the upload progress callback
     */
     void setProgressCallback(OSSProgressCallback<T> progressCallback) {
        this.progressCallback = progressCallback;
    }

     int getPartSize() {
        return partSize;
    }

    /**
     * Sets the part size, by default it's 256KB and the minimal value is 100KB
     *
     * @param partSize size in byte
     */
     void setPartSize(int partSize) {
        this.partSize = partSize;
    }

     Map<String, String> getCallbackParam() {
        return callbackParam;
    }

    /**
     * Sets the server callback parameters
     */
     void setCallbackParam(Map<String, String> callbackParam) {
        this.callbackParam = callbackParam;
    }

     Map<String, String> getCallbackVars() {
        return callbackVars;
    }

    /**
     * Sets the server callback variables
     */
     void setCallbackVars(Map<String, String> callbackVars) {
        this.callbackVars = callbackVars;
    }

     String getUploadId() {
        return uploadId;
    }

     void setUploadId(String uploadId) {
        this.uploadId = uploadId;
    }
}
