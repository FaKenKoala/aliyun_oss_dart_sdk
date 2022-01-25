package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by chenjie on 17/11/28.
 */

 class DeleteMultipleObjectResult extends OSSResult {

     List<String> deletedObjects;
     List<String> failedObjects;
     bool isQuiet;

     void clear() {
        if (deletedObjects != null) {
            deletedObjects.clear();
        }
        if (failedObjects != null) {
            failedObjects.clear();
        }
    }

     void addDeletedObject(String object) {
        if (deletedObjects == null) {
            deletedObjects = [];
        }
        deletedObjects.add(object);
    }

     void addFailedObjects(String object) {
        if (failedObjects == null) {
            failedObjects = [];
        }
        failedObjects.add(object);
    }

     List<String> getDeletedObjects() {
        return deletedObjects;
    }

     List<String> getFailedObjects() {
        return failedObjects;
    }

     bool getQuiet() {
        return isQuiet;
    }

     void setQuiet(bool isQuiet) {
        this.isQuiet = isQuiet;
    }

}
