package com.alibaba.sdk.android.oss.model;

/**
 * Created by huaixu on 2018/1/29.
 */

 class TriggerCallbackResult extends OSSResult {

     String mServerCallbackReturnBody;

    /**
     * Gets the callback response if the servercallback is specified
     *
     * @return The callback response in Json
     */
     String getServerCallbackReturnBody() {
        return mServerCallbackReturnBody;
    }

     void setServerCallbackReturnBody(String serverCallbackReturnBody) {
        this.mServerCallbackReturnBody = serverCallbackReturnBody;
    }
}
