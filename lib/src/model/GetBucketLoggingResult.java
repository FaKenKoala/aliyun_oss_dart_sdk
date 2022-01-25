package com.alibaba.sdk.android.oss.model;

 class GetBucketLoggingResult extends OSSResult {
     String mTargetBucketName;
     String mTargetPrefix;
     bool mLoggingEnabled = false;

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

     bool loggingEnabled() {
        return mLoggingEnabled;
    }

     void setLoggingEnabled(bool loggingEnabled) {
        this.mLoggingEnabled = loggingEnabled;
    }
}
