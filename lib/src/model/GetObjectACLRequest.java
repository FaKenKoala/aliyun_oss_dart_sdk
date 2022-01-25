package com.alibaba.sdk.android.oss.model;

/**
 * Created by chenjie on 17/11/25.
 */

 class GetObjectACLRequest extends OSSRequest {

     String bucketName;
     String objectKey;

    /**
     * Creates the request to get the bucket ACL
     *
     * @param bucketName
     */
     GetObjectACLRequest(String bucketName, String objectKey) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
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

    /**
     * Gets the object key
     *
     * @return
     */
     String getObjectKey() {
        return objectKey;
    }

    /**
     * Sets the object key
     *
     * @param objectKey
     */
     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

}
