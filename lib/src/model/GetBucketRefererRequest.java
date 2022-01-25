package com.alibaba.sdk.android.oss.model;

 class GetBucketRefererRequest extends OSSRequest {
     String mBucketName;

     String getBucketName() {
        return mBucketName;
    }

     void setBucketName(String bucketName) {
        this.mBucketName = bucketName;
    }
}
