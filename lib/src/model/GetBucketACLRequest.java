package com.alibaba.sdk.android.oss.model;

/**
 * Created by LK on 15/12/18.
 */
 class GetBucketACLRequest extends OSSRequest {

     String bucketName;

    /**
     * Creates the request to get the bucket ACL
     *
     * @param bucketName
     */
     GetBucketACLRequest(String bucketName) {
        setBucketName(bucketName);
    }

    /**
     * Gets the bucket name
     *
     * @return
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the bucket name
     *
     * @param bucketName
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }
}
