package com.alibaba.sdk.android.oss.model;

import java.util.List;

/**
 * Created by chenjie on 17/11/28.
 */

 class DeleteMultipleObjectRequest extends OSSRequest {

     String bucketName;
     List<String> objectKeys;
     bool isQuiet;

     DeleteMultipleObjectRequest(String bucketName, List<String> objectKeys, bool isQuiet) {
        setBucketName(bucketName);
        setObjectKeys(objectKeys);
        setQuiet(isQuiet);
    }

     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets the object's bucket name to delete.
     *
     * @param bucketName
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     List<String> getObjectKeys() {
        return objectKeys;
    }

    /**
     * Sets the object keys to delete
     *
     * @param objectKeys
     */
     void setObjectKeys(List<String> objectKeys) {
        this.objectKeys = objectKeys;
    }

     bool getQuiet() {
        return isQuiet;
    }

     void setQuiet(bool isQuiet) {
        this.isQuiet = isQuiet;
    }

}
