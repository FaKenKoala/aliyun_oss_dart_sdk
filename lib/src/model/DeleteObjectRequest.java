package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/24/15.
 */
 class DeleteObjectRequest extends OSSRequest {

     String bucketName;

     String objectKey;

     DeleteObjectRequest(String bucketName, String objectKey) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
    }

     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the object's bucket name to delete.
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
     * Sets the object key to delete
     *
     * @param objectKey
     */
     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }
}
