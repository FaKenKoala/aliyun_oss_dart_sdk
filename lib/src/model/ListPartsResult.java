package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by zhouzhuo on 11/25/15.
 */
 class ListPartsResult extends OSSResult {

     String bucketName;

     String key;

     String uploadId;

     int maxParts = 0;

     int partNumberMarker = 0;

     String storageClass;

     bool isTruncated = false;

     int nextPartNumberMarker = 0;

     List<PartSummary> parts = [];

    /**
     * Gets bucket name
     *
     * @return bucket name
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets bucket name
     *
     * @param bucketName bucket name
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    /**
     * Gets OSSObject key
     *
     * @return Object key
     */
     String getKey() {
        return key;
    }

    /**
     * Sets OSSObject key
     *
     * @param key Object key
     */
     void setKey(String key) {
        this.key = key;
    }

    /**
     * Gets the Multipart Upload ID
     *
     * @return The Multipart Upload ID
     */
     String getUploadId() {
        return uploadId;
    }

    /**
     * Sets the Multipart Upload ID
     *
     * @param uploadId The Multipart Upload ID
     */
     void setUploadId(String uploadId) {
        this.uploadId = uploadId;
    }

     String getStorageClass() {
        return storageClass;
    }

     void setStorageClass(String storageClass) {
        this.storageClass = storageClass;
    }

    /**
     * Gets the part number marker --- it comes from {@link ListPartsRequest#getPartNumberMarker()}
     *
     * @return Part number marker.
     */
     int getPartNumberMarker() {
        return partNumberMarker;
    }

    /**
     * Sets the part number marker---it comes from {@link ListPartsRequest#getPartNumberMarker()}。
     *
     * @param partNumberMarker Part number marker.
     */
     void setPartNumberMarker(int partNumberMarker) {
        this.partNumberMarker = partNumberMarker;
    }

    /**
     * Gets the next part number marker
     *
     * @return the next part number marker
     */
     int getNextPartNumberMarker() {
        return nextPartNumberMarker;
    }

    /**
     * Sets the next part number marker
     *
     * @param nextPartNumberMarker the next part number marker
     */
     void setNextPartNumberMarker(int nextPartNumberMarker) {
        this.nextPartNumberMarker = nextPartNumberMarker;
    }

    /**
     * Gets the max parts count----it comes from ({@link ListPartsRequest#getMaxParts()})
     *
     * @return Max Part count
     */
     int getMaxParts() {
        return maxParts;
    }

    /**
     * Sets the max parts count----it comes from ({@link ListPartsRequest#getMaxParts()}).
     *
     * @param maxParts Gets the max part count.
     */
     void setMaxParts(int maxParts) {
        this.maxParts = maxParts;
    }

    /**
     * Gets the flag of truncation. If true, it means there's more data to return.
     *
     * @return The flag of truncation.
     */
     bool isTruncated() {
        return isTruncated;
    }

    /**
     * Sets the flag of truncation.If true, it means there's more data to return.
     *
     * @param isTruncated The flag of truncation.
     */
     void setTruncated(bool isTruncated) {
        this.isTruncated = isTruncated;
    }

    /**
     * Gets the list of PartSummary.
     *
     * @return The list of PartSummary
     */
     List<PartSummary> getParts() {
        return parts;
    }

    /**
     * Sets the list of {@link PartSummary}.
     *
     * @param parts the list of {@link PartSummary}
     */
     void setParts(List<PartSummary> parts) {
        this.parts.clear();
        if (parts != null && !parts.isEmpty()) {
            this.parts.addAll(parts);
        }
    }

}
