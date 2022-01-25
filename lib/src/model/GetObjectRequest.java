package com.alibaba.sdk.android.oss.model;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;

import java.util.Map;

/**
 * Created by zhouzhuo on 11/23/15.
 */
 class GetObjectRequest extends OSSRequest {
    //  Object bucket's name
     String bucketName;

    // Object Key
     String objectKey;

    // Gets the range of the object to return (starting from 0 to the object length -1)
     Range range;

    // image processing parameters
     String xOssProcess;

    // progress callback run with not ui thread
     OSSProgressCallback progressListener;

    // request headers
     Map<String, String> requestHeaders;

     Map<String, String> getRequestHeaders() {
        return requestHeaders;
    }

     void setRequestHeaders(Map<String, String> requestHeaders) {
        this.requestHeaders = requestHeaders;
    }

    /**
     * Creates the request to get the specified object
     *
     * @param bucketName Bucket name
     * @param objectKey  Object key
     */
     GetObjectRequest(String bucketName, String objectKey) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
    }

     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the bucket name
     *
     * @param bucketName Bucket name
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     String getObjectKey() {
        return objectKey;
    }

    /**
     * Sets the object to download
     *
     * @param objectKey Object key
     */
     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

     Range getRange() {
        return range;
    }

    /**
     * Sets the range to download
     *
     * @param range The range to download (starting from 0 to the length -1)
     */
     void setRange(Range range) {
        this.range = range;
    }

     String getxOssProcess() {
        return xOssProcess;
    }

     void setxOssProcess(String xOssProcess) {
        this.xOssProcess = xOssProcess;
    }

     OSSProgressCallback getProgressListener() {
        return progressListener;
    }

     void setProgressListener(OSSProgressCallback<GetObjectRequest> progressListener) {
        this.progressListener = progressListener;
    }
}
