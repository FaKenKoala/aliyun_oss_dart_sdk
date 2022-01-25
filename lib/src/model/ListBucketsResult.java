package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by chenjie on 17/12/6.
 */

 class ListBucketsResult extends OSSResult {

     String prefix;

     String marker;

     int maxKeys;

     bool isTruncated;

     String nextMarker;

     String ownerId;

     String ownerDisplayName;

     List<OSSBucketSummary> buckets = new ArrayList<OSSBucketSummary>();

     void addBucket(OSSBucketSummary bucket) {
        this.buckets.add(bucket);
    }

     String getPrefix() {
        return prefix;
    }

     void setPrefix(String prefix) {
        this.prefix = prefix;
    }

     String getMarker() {
        return marker;
    }

     void setMarker(String marker) {
        this.marker = marker;
    }

     int getMaxKeys() {
        return maxKeys;
    }

     void setMaxKeys(int maxKeys) {
        this.maxKeys = maxKeys;
    }

     bool getTruncated() {
        return isTruncated;
    }

     void setTruncated(bool isTruncated) {
        this.isTruncated = isTruncated;
    }

     String getNextMarker() {
        return nextMarker;
    }

     void setNextMarker(String nextMarker) {
        this.nextMarker = nextMarker;
    }

     String getOwnerId() {
        return ownerId;
    }

     void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

     String getOwnerDisplayName() {
        return ownerDisplayName;
    }

     void setOwnerDisplayName(String ownerDisplayName) {
        this.ownerDisplayName = ownerDisplayName;
    }

     List<OSSBucketSummary> getBuckets() {
        return buckets;
    }

     void setBuckets(List<OSSBucketSummary> buckets) {
        this.buckets = buckets;
    }

     void clearBucketList() {
        buckets.clear();
    }
}
