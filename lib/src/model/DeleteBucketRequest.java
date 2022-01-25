package com.alibaba.sdk.android.oss.model;

/**
 * Created by LK on 15/12/15.
 */
 class DeleteBucketRequest extends OSSRequest {

     String bucketName;

    /**
     * Creates the request to delete the specified bucket
     *
     * @param bucketName
     */
     DeleteBucketRequest(String bucketName) {
        setBucketName(bucketName);
    }

    /**
     * Gets the bucket name to delete
     *
     * @return
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the bucket name to delete
     *
     * @param bucketName
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

}
