package com.alibaba.sdk.android.oss.model;

 class PutBucketLoggingRequest extends OSSRequest {
     String mBucketName;
     String mTargetBucketName;
     String mTargetPrefix;

     String getBucketName() {
        return mBucketName;
    }

     void setBucketName(String bucketName) {
        this.mBucketName = bucketName;
    }

     String getTargetBucketName() {
        return mTargetBucketName;
    }

     void setTargetBucketName(String targetBucketName) {
        this.mTargetBucketName = targetBucketName;
    }

     String getTargetPrefix() {
        return mTargetPrefix;
    }

     void setTargetPrefix(String targetPrefix) {
        this.mTargetPrefix = targetPrefix;
    }
}
