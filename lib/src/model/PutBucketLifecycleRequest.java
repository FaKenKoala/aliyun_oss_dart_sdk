package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;

 class PutBucketLifecycleRequest extends OSSRequest {
     String mBucketName;
    ArrayList<BucketLifecycleRule> lifecycleRules;

     String getBucketName() {
        return mBucketName;
    }

     void setBucketName(String bucketName) {
        this.mBucketName = bucketName;
    }

     ArrayList<BucketLifecycleRule> getLifecycleRules() {
        return lifecycleRules;
    }

     void setLifecycleRules(ArrayList<BucketLifecycleRule> lifecycleRules) {
        this.lifecycleRules = lifecycleRules;
    }
}
