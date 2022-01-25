package com.alibaba.sdk.android.oss.model;

 class GetBucketInfoRequest extends OSSRequest {

     String bucketName;

     String getBucketName() {
        return bucketName;
    }

     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     GetBucketInfoRequest(String bucketName) {
        this.bucketName = bucketName;
    }
}
