package com.alibaba.sdk.android.oss.model;

 class GetSymlinkResult extends OSSResult {
     String targetObjectName;

     String getTargetObjectName() {
        return targetObjectName;
    }

     void setTargetObjectName(String targetObjectName) {
        this.targetObjectName = targetObjectName;
    }
}
