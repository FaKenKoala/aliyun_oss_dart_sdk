package com.alibaba.sdk.android.oss.model;

import java.util.Date;

/**
 * Created by chenjie on 17/12/6.
 */

 class OSSBucketSummary {

    // Bucket name
     String name;

    // Bucket owner
     Owner owner;

    // Created date.
     Date createDate;

    // Bucket location
     String location;

    // External endpoint.It could be accessed from anywhere.
     String extranetEndpoint;

    // Internal endpoint. It could be accessed within AliCloud under the same
    // location.
     String intranetEndpoint;

    // Storage class (Standard, IA, Archive)
     String storageClass;

     CannedAccessControlList acl;

    /**
     * Gets bucket ACL
     *
     * @return
     */
     String getAcl() {
        String bucketAcl = null;
        if (acl != null) {
            bucketAcl = acl.toString();
        }
        return bucketAcl;
    }

    /**
     * Sets bucket ACL
     *
     * @param aclString
     */
     void setAcl(String aclString) {
        this.acl = CannedAccessControlList.parseACL(aclString);
    }

    @Override
     String toString() {
        if (storageClass == null) {
            return "OSSBucket [name=" + name + ", creationDate=" + createDate + ", owner=" + owner.toString()
                    + ", location=" + location + "]";
        } else {
            return "OSSBucket [name=" + name + ", creationDate=" + createDate + ", owner=" + owner.toString()
                    + ", location=" + location + ", storageClass=" + storageClass + "]";
        }
    }
}
