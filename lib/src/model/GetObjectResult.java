package com.alibaba.sdk.android.oss.model;

import com.alibaba.sdk.android.oss.internal.CheckCRC64DownloadInputStream;

import java.io.InputStream;

/**
 * Created by zhouzhuo on 11/23/15.
 */
 class GetObjectResult extends OSSResult {

    // object metadata
     ObjectMetadata metadata = ObjectMetadata();

    // content length
     int contentLength;

    // object's content
     InputStream objectContent;

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

    /**
     * Gets the object content
     *
     * @return Object's content in the form of InoutStream
     */
     InputStream getObjectContent() {
        return objectContent;
    }

     void setObjectContent(InputStream objectContent) {
        this.objectContent = objectContent;
    }

    /**
     * Gets the object length
     *
     * @return object length
     */
     int getContentLength() {
        return contentLength;
    }

     void setContentLength(int contentLength) {
        this.contentLength = contentLength;
    }

    @override
     int getClientCRC() {
        if (objectContent != null && (objectContent instanceof CheckCRC64DownloadInputStream)) {
            return ((CheckCRC64DownloadInputStream) objectContent).getClientCRC64();
        }
        return super.getClientCRC();
    }
}
