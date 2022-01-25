package com.alibaba.sdk.android.oss.model;

/**
 * Created by LK on 15/12/18.
 */
 class GetBucketACLResult extends OSSResult {

    // bucket owner
     Owner bucketOwner;

    // bucket's ACL
     CannedAccessControlList bucketACL;

     GetBucketACLResult() {
        bucketOwner = Owner();
    }

     Owner getOwner() {
        return bucketOwner;
    }

    /**
     * Gets the bucket owner
     *
     * @return
     */
     String getBucketOwner() {
        return bucketOwner.getDisplayName();
    }

    /**
     * Sets the bucket owner
     *
     * @param ownerName
     */
     void setBucketOwner(String ownerName) {
        this.bucketOwner.setDisplayName(ownerName);
    }

    /**
     * Gets bucket owner Id
     *
     * @return
     */
     String getBucketOwnerID() {
        return bucketOwner.getId();
    }

    /**
     * Sets the bucket owner Id
     *
     * @param id
     */
     void setBucketOwnerID(String id) {
        this.bucketOwner.setId(id);
    }

    /**
     * Gets bucket ACL
     *
     * @return
     */
     String getBucketACL() {
        String acl = null;
        if (bucketACL != null) {
            acl = bucketACL.toString();
        }
        return acl;
    }

    /**
     * Sets bucket ACL
     *
     * @param bucketACL
     */
     void setBucketACL(String bucketACL) {
        this.bucketACL = CannedAccessControlList.parseACL(bucketACL);
    }
}
