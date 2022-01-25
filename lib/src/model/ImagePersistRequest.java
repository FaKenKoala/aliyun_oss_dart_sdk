package com.alibaba.sdk.android.oss.model;

/**
 * Created by huaixu on 2018/1/29.
 */

 class ImagePersistRequest extends OSSRequest {

     String mFromBucket;

     String mFromObjectkey;

     String mToBucketName;

     String mToObjectKey;

     String mAction;


     ImagePersistRequest(String fromBucket, String fromObjectKey, String toBucketName, String mToObjectKey, String action) {
        this.mFromBucket = fromBucket;
        this.mFromObjectkey = fromObjectKey;
        this.mToBucketName = toBucketName;
        this.mToObjectKey = mToObjectKey;
        this.mAction = action;
    }

}
