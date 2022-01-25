package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/24/15.
 */
 class HeadObjectRequest extends OSSRequest {

     String bucketName;

     String objectKey;

     HeadObjectRequest(String bucketName, String objectKey) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
    }

     String getBucketName() {
        return bucketName;
    }

     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     String getObjectKey() {
        return objectKey;
    }

     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }
}
