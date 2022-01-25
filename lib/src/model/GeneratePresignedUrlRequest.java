package com.alibaba.sdk.android.oss.model;

import com.alibaba.sdk.android.oss.common.HttpMethod;

import java.util.HashMap;
import java.util.Map;

/**
 * This class wraps all the information needed to generate a presigned URl.
 * And it's not the real "request" class.
 */
 class GeneratePresignedUrlRequest {

    /**
     * The HTTP method (GET, PUT, DELETE, HEAD) to be used in this request and when the pre-signed URL is used
     */
     HttpMethod method;

    /**
     * The name of the bucket involved in this request
     */
     String bucketName;

    /**
     * The key of the object involved in this request
     */
     String key;

    /**
     * process
     */
     String process;

    /**
     * An optional expiration date at which point the generated pre-signed URL
     * will no inter be accepted by OSS. If not specified, a default
     * value will be supplied.
     */
     int expiration;

    /**
     * Content-Type to url sign
     */
     String contentType;

    /**
     * Content-MD5
     */
     String contentMD5;

     Map<String, String> queryParam = HashMap<String, String>();

    /**
     * Constructor with GET as the httpMethod
     *
     * @param bucketName Bucket name.
     * @param key        Object key.
     */
     GeneratePresignedUrlRequest(String bucketName, String key) {
        this(bucketName, key, 60 * 60);
    }

    /**
     * Constructor.
     *
     * @param bucketName Bucket name.
     * @param key        Object key.
     * @param expiration
     */
     GeneratePresignedUrlRequest(String bucketName, String key, int expiration) {
        this(bucketName, key, 60 * 60, HttpMethod.GET);
    }

    /**
     * Constructor.
     *
     * @param bucketName Bucket name.
     * @param key        Object key.
     * @param expiration
     * @param method     {@link HttpMethod#GET}。
     */
     GeneratePresignedUrlRequest(String bucketName, String key, int expiration, HttpMethod method) {
        this.bucketName = bucketName;
        this.key = key;
        this.expiration = expiration;
        this.method = method;
    }

    /**
     * Gets the content type header.
     *
     * @return Content-Type Header
     */
     String getContentType() {
        return this.contentType;
    }

    /**
     * Sets the content-type header which indicates the file's type.
     *
     * @param contentType The file's content type.
     */
     void setContentType(String contentType) {
        this.contentType = contentType;
    }

    /**
     * Gets the file's MD5 value.
     *
     * @return Content-MD5
     */
     String getContentMD5() {
        return this.contentMD5;
    }

    /**
     * Sets the file's MD5 value.
     *
     * @param contentMD5 The target file's MD5 value.
     */
     void setContentMD5(String contentMD5) {
        this.contentMD5 = contentMD5;
    }

    /**
     * Gets Http method.
     *
     * @return HTTP method.
     */
     HttpMethod getMethod() {
        return method;
    }

    /**
     * Sets Http method.
     *
     * @param method HTTP method.
     */
     void setMethod(HttpMethod method) {
        if (method != HttpMethod.GET && method != HttpMethod.PUT)
            throw ArgumentError("Only GET or PUT is supported!");

        this.method = method;
    }

    /**
     * @return Bucket name
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * @param bucketName
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    /**
     * @return Object key.
     */
     String getKey() {
        return key;
    }

    /**
     * @param key
     */
     void setKey(String key) {
        this.key = key;
    }

    /**
     * Gets the expiration time of the Url
     *
     * @return The expiration time of the Url.
     */
     int getExpiration() {
        return expiration;
    }

    /**
     * Sets the expiration time of the Url
     *
     * @param expiration The expiration time of the Url.
     */
     void setExpiration(int expiration) {
        this.expiration = expiration;
    }


    /**
     * Gets the query parameters.
     *
     * @return Query parameters.
     */
     Map<String, String> getQueryParameter() {
        return this.queryParam;
    }

    /**
     * Sets the query parameters.
     *
     * @param queryParam Query parameters.
     */
     void setQueryParameter(Map<String, String> queryParam) {
        if (queryParam == null) {
            throw NullPointerException("The argument 'queryParameter' is null.");
        }
        if (this.queryParam != null && this.queryParam.size() > 0) {
            this.queryParam.clear();
        }
        this.queryParam.putAll(queryParam);
    }

    /**
     * @param key
     * @param value
     */
     void addQueryParameter(String key, String value) {
        this.queryParam[key] = value;
    }

    /**
     * Gets the process header.
     *
     * @return The process header.
     */
     String getProcess() {
        return process;
    }

    /**
     * Sets the process header.
     *
     * @param process The process header.
     */
     void setProcess(String process) {
        this.process = process;
    }
}
