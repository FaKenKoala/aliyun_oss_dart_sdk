package com.alibaba.sdk.android.oss.internal;

import okhttp3.Response;

/**
 * Created by jingdan on 2017/11/27.
 */

 class ResponseMessage extends HttpMessage {

     Response response;
     RequestMessage request;
     int statusCode;

     int getStatusCode() {
        return statusCode;
    }

     void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

     Response getResponse() {
        return response;
    }

     void setResponse(Response response) {
        this.response = response;
    }

     RequestMessage getRequest() {
        return request;
    }

     void setRequest(RequestMessage request) {
        this.request = request;
    }
}
