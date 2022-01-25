package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;
import java.util.List;

 class PutBucketRefererRequest extends OSSRequest {
     String mBucketName;
     bool mAllowEmpty;
     ArrayList<String> mReferers;

     String getBucketName() {
        return mBucketName;
    }

     void setBucketName(String bucketName) {
        this.mBucketName = bucketName;
    }

     bool isAllowEmpty() {
        return mAllowEmpty;
    }

     void setAllowEmpty(bool allowEmpty) {
        this.mAllowEmpty = allowEmpty;
    }

     ArrayList<String> getReferers() {
        return mReferers;
    }

     void setReferers(ArrayList<String> referers) {
        this.mReferers = referers;
    }
}
