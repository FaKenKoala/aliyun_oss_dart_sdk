package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;

 class GetBucketLifecycleResult extends OSSResult {
     ArrayList<BucketLifecycleRule> mLifecycleRules;

     ArrayList<BucketLifecycleRule> getlifecycleRules() {
        return mLifecycleRules;
    }

     void setLifecycleRules(ArrayList<BucketLifecycleRule> lifecycleRules) {
        this.mLifecycleRules = lifecycleRules;
    }

     void addLifecycleRule(BucketLifecycleRule lifecycleRule) {
        if (mLifecycleRules == null) {
            mLifecycleRules = [];
        }

        mLifecycleRules.add(lifecycleRule);
    }
}
