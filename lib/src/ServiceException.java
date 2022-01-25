/**
 * Copyright (C) Alibaba Cloud Computing, 2015
 * All rights reserved.
 * <p>
 * 版权所有 （C）阿里巴巴云计算，2015
 */

package com.alibaba.sdk.android.oss;

import com.alibaba.sdk.android.oss.common.OSSLog;

/**
 * <p>
 * The OSS server side exception class definition.
 * </p>
 * <p>
 * <p>
 * {@link OSSClientException} means there're errors occurred when sending request to OSS or parsing the response from OSS.
 * For example when the network is unavailable, this exception will be thrown.
 * </p>
 * <p>
 * <p>
 * {@link OSSServiceException} means there're errors occurred in OSS service side. For example, the Access Id
 * does not exist for authentication, then {@link OSSServiceException} or its subclass is thrown.
 * The OSSServiceException has the error code for the caller to have some specific handling.
 * </p>
 * <p>
 * <p>
 * Generally speaking, the caller only needs to handle {@link OSSServiceException} as it means the request
 * has reached OSS, but there're some errors occurred. This error in most of cases are expected due to
 * wrong parameters int the request or some wrong settings in user's account. The error code is very helpful
 * for troubleshooting.
 * </p>
 */
 class OSSServiceException extends Exception {

     static final String PARSE_RESPONSE_FAIL = "SDKParseResponseFail";

     static final int serialVersionUID = 430933593095358673L;

    /**
     * http status code
     */
     int statusCode;

    /**
     * OSS error code, check out：http://help.aliyun.com/document_detail/oss/api-reference/error-response.html
     */
     String errorCode;

    /**
     * OSS request Id
     */
     String requestId;

    /**
     * The OSS host Id which is same as the one in the request
     */
     String hostId;

    /**
     * The raw message in the response
     */
     String rawMessage;

    /**
     * part number
     */
     String partNumber;

    /**
     * part etag
     */
     String partEtag;

     String getPartNumber() {
        return partNumber;
    }

     void setPartNumber(String partNumber) {
        this.partNumber = partNumber;
    }

     String getPartEtag() {
        return partEtag;
    }

     void setPartEtag(String partEtag) {
        this.partEtag = partEtag;
    }

    /**
     * The constructor with status code, message, error code , request Id and host Id
     *
     * @param statusCode HTTP status code
     * @param message    error message
     * @param errorCode  error code
     * @param requestId  Request ID
     * @param hostId     Host ID
     */
     OSSServiceException(int statusCode, String message,
                            String errorCode, String requestId, String hostId, String rawMessage) {

        super(message);

        this.statusCode = statusCode;
        this.errorCode = errorCode;
        this.requestId = requestId;
        this.hostId = hostId;
        this.rawMessage = rawMessage;

        OSSLog.logThrowable2Local(this);
    }

    /**
     * Gets the http status code
     *
     * @return
     */
     int getStatusCode() {
        return statusCode;
    }

    /**
     * Gets the error code
     *
     * @return error code in string
     */
     String getErrorCode() {
        return errorCode;
    }

    /**
     * Gets the request Id
     *
     * @return Request Id
     */
     String getRequestId() {
        return requestId;
    }

    /**
     * Gets the host Id
     *
     * @return Host Id
     */
     String getHostId() {
        return hostId;
    }

    @override
     String toString() {
        return "[StatusCode]: " + statusCode + ", "
                + "[Code]: " + getErrorCode() + ", "
                + "[Message]: " + getMessage() + ", "
                + "[Requestid]: " + getRequestId() + ", "
                + "[HostId]: " + getHostId() + ", "
                + "[RawMessage]: " + getRawMessage();
    }

    /**
     * @return The raw message
     */
     String getRawMessage() {
        return rawMessage;
    }
}
