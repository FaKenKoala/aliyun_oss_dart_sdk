package com.alibaba.sdk.android.oss.model;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.callback.OSSRetryCallback;

import java.util.Map;

 class PutSymlinkRequest extends OSSRequest {
     String bucketName;
     String objectKey;
     String targetObjectName;
     ObjectMetadata metadata;

     String getBucketName() {
        return bucketName;
    }

     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     String getObjectKey() {
        return objectKey;
    }

     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

     String getTargetObjectName() {
        return targetObjectName;
    }

     void setTargetObjectName(String targetObjectName) {
        this.targetObjectName = targetObjectName;
    }

     ObjectMetadata getMetadata() {
        return metadata;
    }

     void setMetadata(ObjectMetadata metadata) {
        this.metadata = metadata;
    }
}
