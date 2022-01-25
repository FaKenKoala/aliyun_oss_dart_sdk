package com.alibaba.sdk.android.oss.model;

/**
 * Created by chenjie on 17/12/6.
 */

 class ListBucketsRequest extends OSSRequest {

     static final int MAX_RETURNED_KEYS_LIMIT = 1000;

    // prefix filter
     String prefix;

    // maker filter--the returned bucket' keys must be greater than this value in lexicographic order.
     String marker;

    // the max keys to return--by default it's 100
     Integer maxKeys;

     ListBucketsRequest() {
    }

     ListBucketsRequest(String prefix) {
        this(prefix, null);
    }

     ListBucketsRequest(String prefix, String marker) {
        this(prefix, marker, 100);
    }

     ListBucketsRequest(String prefix, String marker, Integer maxKeys) {
        this.prefix = prefix;
        this.marker = marker;
        this.maxKeys = maxKeys;
    }

     String getPrefix() {
        return this.prefix;
    }

     void setPrefix(String prefix) {
        this.prefix = prefix;
    }

     String getMarker() {
        return this.marker;
    }

     void setMarker(String marker) {
        this.marker = marker;
    }

     Integer getMaxKeys() {
        return this.maxKeys;
    }

     void setMaxKeys(Integer maxKeys) {
        this.maxKeys = maxKeys;
    }

}
