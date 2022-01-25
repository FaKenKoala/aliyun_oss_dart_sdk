package com.alibaba.sdk.android.oss.model;

/**
 * bucket ACL enum definition
 * Created by LK on 15/12/17.
 */
 enum CannedAccessControlList {

    (""),

    Read("-read"),

    ReadWrite("-read-write"),

    Default("default");

     String ACLString;

    CannedAccessControlList(String acl) {
        this.ACLString = acl;
    }

     static CannedAccessControlList parseACL(String aclStr) {
        CannedAccessControlList currentAcl = null;
        for (CannedAccessControlList acl : CannedAccessControlList.values()) {
            if (acl.toString().equals(aclStr)) {
                currentAcl = acl;
                break;
            }
        }
        return currentAcl;
    }

    @Override
     String toString() {
        return this.ACLString;
    }
}
