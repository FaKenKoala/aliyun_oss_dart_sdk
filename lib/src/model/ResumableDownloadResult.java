package com.alibaba.sdk.android.oss.model;

import java.util.ArrayList;

 class ResumableDownloadResult extends OSSResult {

     ObjectMetadata metadata;

    /**
     * Gets the metadata
     *
     * @return object metadata
     */
     ObjectMetadata getMetadata() {
        return metadata;
    }

     void setMetadata(ObjectMetadata metadata) {
        this.metadata = metadata;
    }
}
