package com.alibaba.sdk.android.oss.model;

/**
 * Created by chenjie on 17/11/25.
 */

 class GetObjectACLResult extends OSSResult {

    // object owner
     Owner objectOwner;

    // object's ACL
     CannedAccessControlList objectACL;

     GetObjectACLResult() {
        objectOwner = Owner();
    }

     Owner getOwner() {
        return objectOwner;
    }

    /**
     * Gets the object owner
     *
     * @return
     */
     String getObjectOwner() {
        return objectOwner.getDisplayName();
    }

    /**
     * Sets the object owner
     *
     * @param ownerName
     */
     void setObjectOwner(String ownerName) {
        this.objectOwner.setDisplayName(ownerName);
    }

    /**
     * Gets object owner Id
     *
     * @return
     */
     String getObjectOwnerID() {
        return objectOwner.getId();
    }

    /**
     * Sets the object owner Id
     *
     * @param id
     */
     void setObjectOwnerID(String id) {
        this.objectOwner.setId(id);
    }

    /**
     * Gets object ACL
     *
     * @return
     */
     String getObjectACL() {
        String acl = null;
        if (objectACL != null) {
            acl = objectACL.toString();
        }
        return acl;
    }

    /**
     * Sets object ACL
     *
     * @param objectACL
     */
     void setObjectACL(String objectACL) {
        this.objectACL = CannedAccessControlList.parseACL(objectACL);
    }

}
