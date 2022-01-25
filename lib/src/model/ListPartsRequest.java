package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/25/15.
 */
 class ListPartsRequest extends OSSRequest {

     String bucketName;

     String objectKey;

     String uploadId;

     Integer maxParts;

     Integer partNumberMarker;

    /**
     * Constructor
     *
     * @param bucketName bucket name
     * @param objectKey  Object objectKey。
     * @param uploadId   Mutlipart Upload ID。
     */
     ListPartsRequest(String bucketName, String objectKey, String uploadId) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadId(uploadId);
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
     * Gets OSSObject objectKey。
     *
     * @return Object objectKey。
     */
     String getObjectKey() {
        return objectKey;
    }

    /**
     * Sets OSSObject objectKey。
     *
     * @param objectKey Object objectKey。
     */
     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

    /**
     * Gets Multipart upload Id
     *
     * @return The Multipart upload Id
     */
     String getUploadId() {
        return uploadId;
    }

    /**
     * Sets the multipart upload Id
     *
     * @param uploadId The Multipart upload Id
     */
     void setUploadId(String uploadId) {
        this.uploadId = uploadId;
    }

    /**
     * Gets the max parts to return (default is 1000)
     *
     * @return the max parts
     */
     Integer getMaxParts() {
        return maxParts;
    }

    /**
     * Sets the max parts to return
     * Max and default is 1000.
     *
     * @param maxParts the max parts to return
     */
     void setMaxParts(int maxParts) {
        this.maxParts = maxParts;
    }

    /**
     * Gets the part number marker filter
     *
     * @return The part number marker filter---it means the returned parts' part number must be greater than this value.
     */
     Integer getPartNumberMarker() {
        return partNumberMarker;
    }

    /**
     * Sets the part number marker filter--it means the returned parts' part number must be greater than this value.
     *
     * @param partNumberMarker The part number marker filter
     */
     void setPartNumberMarker(Integer partNumberMarker) {
        this.partNumberMarker = partNumberMarker;
    }
}
