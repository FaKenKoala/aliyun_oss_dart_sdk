package com.alibaba.sdk.android.oss.model;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;

import java.util.Map;

 class ResumableDownloadRequest extends OSSRequest {

    //  Object bucket's name
     String bucketName;

    // Object Key
     String objectKey;

    // Gets the range of the object to return (starting from 0 to the object length -1)
     Range range;

    // progress callback run with not ui thread
     OSSProgressCallback progressListener;

    //
     String downloadToFilePath;

     bool enableCheckPoint = false;
     String checkPointFilePath;

     int partSize = 256 * 1024;

     Map<String, String> requestHeader;

    /**
     * Constructor
     *
     * @param bucketName     The target object's bucket name
     * @param objectKey      The target object's key
     * @param downloadToFilePath The local path of the file to download
     */
     ResumableDownloadRequest(String bucketName, String objectKey, String downloadToFilePath) {
        this.bucketName = bucketName;
        this.objectKey = objectKey;
        this.downloadToFilePath = downloadToFilePath;
    }

    /**
     * Constructor
     *
     * @param bucketName     The target object's bucket name
     * @param objectKey      The target object's key
     * @param downloadToFilePath The local path of the file to download
     * @param checkPointFilePath The checkpoint files' directory
     */
     ResumableDownloadRequest(String bucketName, String objectKey, String downloadToFilePath, String checkPointFilePath) {
        this.bucketName = bucketName;
        this.objectKey = objectKey;
        this.downloadToFilePath = downloadToFilePath;
        this.enableCheckPoint = true;
        this.checkPointFilePath = checkPointFilePath;
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

     OSSProgressCallback getProgressListener() {
        return progressListener;
    }

    /**
     * Sets the upload progress callback
     */
     void setProgressListener(OSSProgressCallback progressListener) {
        this.progressListener = progressListener;
    }

     String getDownloadToFilePath() {
        return downloadToFilePath;
    }

    /**
     * Sets the local path of the file to download
     *
     * @param downloadToFilePath the local path of the file to upload
     */
     void setDownloadToFilePath(String downloadToFilePath) {
        this.downloadToFilePath = downloadToFilePath;
    }

     bool getEnableCheckPoint() {
        return enableCheckPoint;
    }


     void setEnableCheckPoint(bool enableCheckPoint) {
        this.enableCheckPoint = enableCheckPoint;
    }

     String getCheckPointFilePath() {
        return checkPointFilePath;
    }

    /**
     * Sets the checkpoint files' directory (the directory must exist and is absolute directory path)
     *
     * @param checkPointFilePath the checkpoint files' directory
     */
     void setCheckPointFilePath(String checkPointFilePath) {
        this.checkPointFilePath = checkPointFilePath;
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

     String getTempFilePath() {
        return downloadToFilePath + ".tmp";
    }

     Map<String, String> getRequestHeader() {
        return requestHeader;
    }

    /**
     * Sets the request headers
     *
     * @param requestHeader
     */
     void setRequestHeader(Map<String, String> requestHeader) {
        this.requestHeader = requestHeader;
    }
}
