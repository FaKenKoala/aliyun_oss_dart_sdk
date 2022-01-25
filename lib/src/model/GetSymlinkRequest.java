package com.alibaba.sdk.android.oss.model;

 class GetSymlinkRequest extends OSSRequest {
     String bucketName;
     String objectKey;

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
