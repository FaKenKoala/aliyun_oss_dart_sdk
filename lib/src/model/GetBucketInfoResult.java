package com.alibaba.sdk.android.oss.model;

 class GetBucketInfoResult extends OSSResult {
     OSSBucketSummary bucket;

     OSSBucketSummary getBucket() {
        return this.bucket;
    }

     void setBucket(OSSBucketSummary bucket) {
        this.bucket = bucket;
    }

    @override
     String toString() {
        return String.format("GetBucketInfoResult<%s>:\n bucket:%s", super.toString(), bucket.toString());
    }
}
