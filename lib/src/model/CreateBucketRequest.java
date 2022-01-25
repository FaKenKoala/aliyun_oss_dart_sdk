package com.alibaba.sdk.android.oss.model;

/**
 * Created by LK on 15/12/15.
 */
 class CreateBucketRequest extends OSSRequest {

     static final String TAB_LOCATIONCONSTRAINT = "LocationConstraint";
     static final String TAB_STORAGECLASS = "StorageClass";
     String bucketName;
     CannedAccessControlList bucketACL;
     String locationConstraint;
     StorageClass bucketStorageClass = StorageClass.Standard;

    /**
     * The constructor of CreateBucketRequest
     *
     * @param bucketName
     */
     CreateBucketRequest(String bucketName) {
        setBucketName(bucketName);
    }

    /**
     * Gets the bucket name
     *
     * @return
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the bucket name
     * bucketName is globally unique cross all OSS users in all regions. Otherwise returns 409.
     *
     * @param bucketName
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    /**
     * Gets the bucket location's constraint.
     *
     * @return
     */
    @Deprecated
     String getLocationConstraint() {
        return locationConstraint;
    }

    /**
     * Sets the location constraint.
     * Valid values：oss-cn-hangzhou、oss-cn-qingdao、oss-cn-beijing、oss-cn-hongkong、oss-cn-shenzhen、
     * oss-cn-shanghai、oss-us-west-1 、oss-ap-southeast-1
     * If it's not specified，the default value is oss-cn-hangzhou
     *
     * @param locationConstraint
     */
    @Deprecated
     void setLocationConstraint(String locationConstraint) {
        this.locationConstraint = locationConstraint;
    }

    /**
     * Gets bucket ACL
     *
     * @return
     */
     CannedAccessControlList getBucketACL() {
        return bucketACL;
    }

    /**
     * Sets bucket ACL
     * For now there're three permissions of Bucket: 、-read、-read-write
     *
     * @param bucketACL
     */
     void setBucketACL(CannedAccessControlList bucketACL) {
        this.bucketACL = bucketACL;
    }

    /**
     * Get bucket storage class
     *
     * @return
     */
     StorageClass getBucketStorageClass() {
        return bucketStorageClass;
    }

    /**
     * Set bucket storage class
     *
     * @param storageClass
     */
     void setBucketStorageClass(StorageClass storageClass) {
        this.bucketStorageClass = storageClass;
    }
}
