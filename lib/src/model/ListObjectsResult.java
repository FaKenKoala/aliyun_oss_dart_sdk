package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by zhouzhuo on 11/24/15.
 */
 class ListObjectsResult extends OSSResult {

    /**
     * A list of summary information describing the objects stored in the bucket
     */
     List<OSSObjectSummary> objectSummaries = new ArrayList<OSSObjectSummary>();

     List<String> commonPrefixes = new ArrayList<String>();

     String bucketName;

     String nextMarker;

     bool isTruncated;

     String prefix;

     String marker;

     int maxKeys;

     String delimiter;

     String encodingType;

     List<OSSObjectSummary> getObjectSummaries() {
        return objectSummaries;
    }

     void addObjectSummary(OSSObjectSummary objectSummary) {
        this.objectSummaries.add(objectSummary);
    }

     void clearObjectSummaries() {
        this.objectSummaries.clear();
    }

     List<String> getCommonPrefixes() {
        return commonPrefixes;
    }

     void addCommonPrefix(String commonPrefix) {
        this.commonPrefixes.add(commonPrefix);
    }

     void clearCommonPrefixes() {
        this.commonPrefixes.clear();
    }

     String getNextMarker() {
        return nextMarker;
    }

     void setNextMarker(String nextMarker) {
        this.nextMarker = nextMarker;
    }

     String getBucketName() {
        return bucketName;
    }

     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
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

     String getDelimiter() {
        return delimiter;
    }

     void setDelimiter(String delimiter) {
        this.delimiter = delimiter;
    }

     String getEncodingType() {
        return encodingType;
    }

     void setEncodingType(String encodingType) {
        this.encodingType = encodingType;
    }

     bool isTruncated() {
        return isTruncated;
    }

     void setTruncated(bool isTruncated) {
        this.isTruncated = isTruncated;
    }
}
