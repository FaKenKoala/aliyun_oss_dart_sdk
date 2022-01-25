package com.alibaba.sdk.android.oss.model;

/**
 * Created by jingdan on 2018/2/13.
 */

 class ListMultipartUploadsRequest extends OSSRequest {

     String bucketName;

     String delimiter;

     String prefix;

     Integer maxUploads;

     String keyMarker;

     String uploadIdMarker;

     String encodingType;

    /**
     * Constructor.
     *
     * @param bucketName Bucket name.
     */
     ListMultipartUploadsRequest(String bucketName) {
        this.bucketName = bucketName;
    }

     String getBucketName() {
        return bucketName;
    }

    /**
     * Gets the max number of uploads to return.
     *
     * @return The max number of uploads.
     */
     Integer getMaxUploads() {
        return maxUploads;
    }

    /**
     * Sets the max number of uploads to return. The both max and default value
     * is 1000。
     *
     * @param maxUploads The max number of uploads.
     */
     void setMaxUploads(Integer maxUploads) {
        this.maxUploads = maxUploads;
    }

    /**
     * Gets the key marker filter---all uploads returned whose target file's key
     * must be greater than the marker filter.
     *
     * @return The key marker filter.
     */
     String getKeyMarker() {
        return keyMarker;
    }

    /**
     * Sets the key marker filter---all uploads returned whose target file's key
     * must be greater than the marker filter.
     *
     * @param keyMarker The key marker.
     */
     void setKeyMarker(String keyMarker) {
        this.keyMarker = keyMarker;
    }

    /**
     * Gets the upload id marker--all uploads returned whose upload id must be
     * greater than the marker filter.
     *
     * @return The upload Id marker.
     */
     String getUploadIdMarker() {
        return uploadIdMarker;
    }

    /**
     * Sets the upload id marker--all uploads returned whose upload id must be
     * greater than the marker filter.
     *
     * @param uploadIdMarker The upload Id marker.
     */
     void setUploadIdMarker(String uploadIdMarker) {
        this.uploadIdMarker = uploadIdMarker;
    }

     String getDelimiter() {
        return delimiter;
    }

     void setDelimiter(String delimiter) {
        this.delimiter = delimiter;
    }

     String getPrefix() {
        return prefix;
    }

     void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    /**
     * Gets the encoding type of the object in the response body.
     *
     * @return The encoding type of the object in the response body.
     */
     String getEncodingType() {
        return encodingType;
    }

    /**
     * Sets the encoding type of the object in the response body.
     *
     * @param encodingType The encoding type of the object in the response body. Valid
     *                     value is either 'null' or 'url'.
     */
     void setEncodingType(String encodingType) {
        this.encodingType = encodingType;
    }

}
