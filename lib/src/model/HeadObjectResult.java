package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/24/15.
 */
 class HeadObjectResult extends OSSResult {

    // object metadata
     ObjectMetadata metadata = ObjectMetadata();

     ObjectMetadata getMetadata() {
        return metadata;
    }

     void setMetadata(ObjectMetadata metadata) {
        this.metadata = metadata;
    }

    @override
     String toString() {
        String desc = String.format("HeadObjectResult<%s>:\n metadata:%s", super.toString(), metadata.toString());
        return desc;
    }
}
