package com.alibaba.sdk.android.oss.model;

import java.util.Map;

/**
 * Created by zhouzhuo on 11/23/15.
 */
 class OSSResult {

     int statusCode;

     Map<String, String> responseHeader;

     String requestId;

    //client crc64
     int clientCRC;
    //server crc64
     int serverCRC;

    /**
     * The HTTP status code
     *
     * @return HTTP status code
     */
     int getStatusCode() {
        return statusCode;
    }

     void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    /**
     * The response header
     *
     * @return ALl headers in the response
     */
     Map<String, String> getResponseHeader() {
        return responseHeader;
    }

     void setResponseHeader(Map<String, String> responseHeader) {
        this.responseHeader = responseHeader;
    }

    /**
     * The request Id---it's generated from OSS server side.
     *
     * @return The globally unique request Id
     */
     String getRequestId() {
        return requestId;
    }

     void setRequestId(String requestId) {
        this.requestId = requestId;
    }

     int getClientCRC() {
        return clientCRC;
    }

     void setClientCRC(int clientCRC) {
        if (clientCRC != null && clientCRC != 0) {
            this.clientCRC = clientCRC;
        }
    }

     int getServerCRC() {
        return serverCRC;
    }

     void setServerCRC(int serverCRC) {
        if (serverCRC != null && serverCRC != 0) {
            this.serverCRC = serverCRC;
        }
    }

    @Override
     String toString() {
        String desc = String.format("OSSResult<%s>: \nstatusCode:%d,\nresponseHeader:%s,\nrequestId:%s", super.toString(), statusCode, responseHeader.toString(), requestId);
        return desc;
    }
}
