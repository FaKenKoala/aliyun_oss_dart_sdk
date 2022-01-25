package com.alibaba.sdk.android.oss.model;

import java.util.Map;

/**
 * Created by huaixu on 2018/1/29.
 */

 class TriggerCallbackRequest extends OSSRequest {

     String mBucketName;

     String mObjectKey;

     Map<String, String> mCallbackParam;

     Map<String, String> mCallbackVars;

     TriggerCallbackRequest(String bucketName, String objectKey, Map<String, String> callbackParam, Map<String, String> callbackVars) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setCallbackParam(callbackParam);
        setCallbackVars(callbackVars);
    }

     String getBucketName() {
        return mBucketName;
    }

     void setBucketName(String bucketName) {
        this.mBucketName = bucketName;
    }

     String getObjectKey() {
        return mObjectKey;
    }

     void setObjectKey(String objectKey) {
        this.mObjectKey = objectKey;
    }

     Map<String, String> getCallbackParam() {
        return mCallbackParam;
    }

     void setCallbackParam(Map<String, String> callbackParam) {
        this.mCallbackParam = callbackParam;
    }

     Map<String, String> getCallbackVars() {
        return mCallbackVars;
    }

     void setCallbackVars(Map<String, String> callbackVars) {
        this.mCallbackVars = callbackVars;
    }

}
