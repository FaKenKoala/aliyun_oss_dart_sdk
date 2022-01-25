package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/23/15.
 */

import android.net.Uri;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.callback.OSSRetryCallback;

import java.util.Map;

/**
 * The request class definition of uploading an object either from local file or in-memory data
 */
 class PutObjectRequest extends OSSRequest {

     String bucketName;
     String objectKey;

     String uploadFilePath;

     byte[] uploadData;

     Uri uploadUri;

     ObjectMetadata metadata;

     Map<String, String> callbackParam;

     Map<String, String> callbackVars;

    //run with not ui thread
     OSSProgressCallback<PutObjectRequest> progressCallback;

    //run with not ui thread
     OSSRetryCallback retryCallback;

    /**
     * Constructor
     *
     * @param bucketName     The bucket name
     * @param objectKey      The object key
     * @param uploadFilePath The local file path to upload from
     */
     PutObjectRequest(String bucketName, String objectKey, String uploadFilePath) {
        this(bucketName, objectKey, uploadFilePath, null);
    }

    /**
     * Constructor
     *
     * @param bucketName     The bucket name
     * @param objectKey      The object key
     * @param uploadFilePath The local file path
     * @param metadata       The metadata information of the target object
     */
     PutObjectRequest(String bucketName, String objectKey, String uploadFilePath, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadFilePath(uploadFilePath);
        setMetadata(metadata);
    }

    /**
     * Constructor
     *
     * @param bucketName The bucket name
     * @param objectKey  The object key
     * @param uploadData The in-memory data to upload
     */
     PutObjectRequest(String bucketName, String objectKey, byte[] uploadData) {
        this(bucketName, objectKey, uploadData, null);
    }

    /**
     * Constructor
     *
     * @param bucketName The bucket name
     * @param objectKey  The object key
     * @param uploadData The in-memory data to upload
     * @param metadata   The metadata information of the target object
     */
     PutObjectRequest(String bucketName, String objectKey, byte[] uploadData, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadData(uploadData);
        setMetadata(metadata);
    }

     PutObjectRequest(String bucketName, String objectKey, Uri uploadUri) {
        this(bucketName, objectKey, uploadUri, null);
    }

     PutObjectRequest(String bucketName, String objectKey, Uri uploadUri, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadUri(uploadUri);
        setMetadata(metadata);
    }

    /**
     * Gets the bucket name
     *
     * @return The bucket name
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the bucket name
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    /**
     * Gets the object key
     *
     * @return The object key
     */
     String getObjectKey() {
        return objectKey;
    }

    /**
     * Sets the object key
     */
     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

     String getUploadFilePath() {
        return uploadFilePath;
    }

    /**
     * Sets the local upload file path
     *
     * @param uploadFilePath The local upload file path
     */
     void setUploadFilePath(String uploadFilePath) {
        this.uploadFilePath = uploadFilePath;
    }

     byte[] getUploadData() {
        return uploadData;
    }

    /**
     * Sets the upload data
     *
     * @param uploadData
     */
     void setUploadData(byte[] uploadData) {
        this.uploadData = uploadData;
    }

     ObjectMetadata getMetadata() {
        return metadata;
    }

    /**
     * Sets the upload Uri
     *
     * @param uploadUri
     */
     Uri getUploadUri() {
        return uploadUri;
    }

     void setUploadUri(Uri uploadUri) {
        this.uploadUri = uploadUri;
    }

    /**
     * Sets the metadata of the target object
     *
     * @param metadata the target object metadata
     */
     void setMetadata(ObjectMetadata metadata) {
        this.metadata = metadata;
    }

     OSSProgressCallback<PutObjectRequest> getProgressCallback() {
        return progressCallback;
    }

    /**
     * Sets the upload progress callback
     *
     * @param progressCallback
     */
     void setProgressCallback(OSSProgressCallback<PutObjectRequest> progressCallback) {
        this.progressCallback = progressCallback;
    }

     OSSRetryCallback getRetryCallback() {
        return retryCallback;
    }

    /**
     * Sets the upload retry request callback
     *
     * @param retryCallback
     */
     void setRetryCallback(OSSRetryCallback retryCallback) {
        this.retryCallback = retryCallback;
    }

     Map<String, String> getCallbackParam() {
        return callbackParam;
    }

    /**
     * Sets the callback parameters
     */
     void setCallbackParam(Map<String, String> callbackParam) {
        this.callbackParam = callbackParam;
    }

     Map<String, String> getCallbackVars() {
        return callbackVars;
    }

    /**
     * Sets the callback variables
     */
     void setCallbackVars(Map<String, String> callbackVars) {
        this.callbackVars = callbackVars;
    }
}