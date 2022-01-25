package com.alibaba.sdk.android.oss.model;

 class GetBucketLifecycleRequest extends OSSRequest {
     String mBucketName;

     String getBucketName() {
        return mBucketName;
    }

     void setBucketName(String bucketName) {
        this.mBucketName = bucketName;
    }
}
