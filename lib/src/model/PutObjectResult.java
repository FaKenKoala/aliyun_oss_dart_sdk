package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/23/15.
 */

/**
 * The result class of uploading an object
 */
 class PutObjectResult extends OSSResult {

    // Object ETag
     String eTag;

    // The callback response if the servercallback is specified
     String serverCallbackReturnBody;

    /**
     * Gets the Etag value of the target object
     */
     String getETag() {
        return eTag;
    }

    /**
     * @param eTag target object's ETag value.
     */
     void setETag(String eTag) {
        this.eTag = eTag;
    }

    /**
     * Gets the callback response if the servercallback is specified
     *
     * @return The callback response in Json
     */
     String getServerCallbackReturnBody() {
        return serverCallbackReturnBody;
    }

     void setServerCallbackReturnBody(String serverCallbackReturnBody) {
        this.serverCallbackReturnBody = serverCallbackReturnBody;
    }
}
