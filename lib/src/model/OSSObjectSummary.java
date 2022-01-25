package com.alibaba.sdk.android.oss.model;

import java.util.Date;

/**
 * OSSObject summary class definition.
 */
 class OSSObjectSummary {

    /**
     * The name of the bucket in which this object is stored
     */
     String bucketName;

    /**
     * The key under which this object is stored
     */
     String key;

     String type;

     String eTag;

     int size;

     Date lastModified;

     String storageClass;

    /**
     * {@link Owner}
     */
     Owner owner;

    /**
     * Creates a {@link OSSObjectSummary}
     */
     OSSObjectSummary() {
    }

    /**
     * Gets the bucket name.
     *
     * @return The bucket name
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the bucket name
     *
     * @param bucketName The bucket name
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    /**
     * Gets Object key
     *
     * @return Object key
     */
     String getKey() {
        return key;
    }

    /**
     * Sets Object key
     *
     * @param key Object Key.
     */
     void setKey(String key) {
        this.key = key;
    }

    /**
     * Gets the ETag which is the object's 128 bit MD5 digest in hex encoding.
     *
     * @return The 128 bit MD5 digest in hex encoding.
     */
     String getETag() {
        return eTag;
    }

    /**
     * Sets the ETag which is the object's 128 bit MD5 digest in hex encoding.
     *
     * @param eTag The 128 bit MD5 digest in hex encoding.
     */
     void setETag(String eTag) {
        this.eTag = eTag;
    }

    /**
     * Gets Object size in byte
     *
     * @return Object size in byte
     */
     int getSize() {
        return size;
    }

    /**
     * Sets Object size in byte
     *
     * @param size Object size in byte
     */
     void setSize(int size) {
        this.size = size;
    }

    /**
     * Gets the last modified time of the object.
     *
     * @return The object's last modified time
     */
     Date getLastModified() {
        return lastModified;
    }

    /**
     * Sets the last modified time of the object.
     *
     * @param lastModified The object's last modified time
     */
     void setLastModified(Date lastModified) {
        this.lastModified = lastModified;
    }

    /**
     * Gets the object's storage class (Standard, IA, Archive)
     *
     * @return The object's storage class
     */
     String getStorageClass() {
        return storageClass;
    }

    /**
     * Sets the object's storage class
     *
     * @param storageClass Object storage class
     */
     void setStorageClass(String storageClass) {
        this.storageClass = storageClass;
    }

    /**
     * Gets Object type
     *
     * @return Object type
     */
     String getType() {
        return type;
    }

    /**
     * Sets object type
     *
     * @param type Object type
     */
     void setType(String type) {
        this.type = type;
    }

     Owner getOwner() {
        return owner;
    }

     void setOwner(Owner owner) {
        this.owner = owner;
    }
}
