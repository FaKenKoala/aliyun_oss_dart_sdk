package com.alibaba.sdk.android.oss.model;

import com.alibaba.sdk.android.oss.common.OSSConstants;
import com.alibaba.sdk.android.oss.common.OSSHeaders;
import com.alibaba.sdk.android.oss.common.utils.CaseInsensitiveHashMap;
import com.alibaba.sdk.android.oss.common.utils.DateUtil;

import java.text.ParseException;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * OSS object metadata class definition.
 * It includes user's custom metadata as well as standard HTTP headers (such as Content-Length, ETag, etc)
 */
 class ObjectMetadata {

     static final String AES_256_SERVER_SIDE_ENCRYPTION = "AES256";
    // User's custom metadata dictionary. All keys  will be prefixed with x-oss-meta-in the HTTP headers.
    // The keys in this dictionary should include the prefix 'x-oss-meta-'.
     Map<String, String> userMetadata = CaseInsensitiveHashMap<String, String>();
    // Standard metadata
     Map<String, Object> metadata = CaseInsensitiveHashMap<String, Object>();

    /**
     * <p>
     * Gets the user's custom metadata.
     * </p>
     * <p>
     * The keys in this userMetadata should include the prefix 'x-oss-meta-'.
     * For example, if customMeta is {uuid:value}, the key should be set to 'x-oss-meta-uuid'
     * Meanwhile the metadata's key is case insensitive and all metadata keys returned from OSS is
     * in lowercase.
     * </p>
     *
     * @return User's custom metadata.
     */
     Map<String, String> getUserMetadata() {
        return userMetadata;
    }

    /**
     * Sets user's custom metadata.
     *
     * @param userMetadata User's custom metadata
     */
     void setUserMetadata(Map<String, String> userMetadata) {
        this.userMetadata.clear();
        if (userMetadata != null && !userMetadata.isEmpty()) {
            this.userMetadata.putAll(userMetadata);
        }
    }

    /**
     * Sets header (SDK internal usage only).
     *
     * @param key   Request Key.
     * @param value Request Value.
     */
     void setHeader(String key, Object value) {
        metadata[key] = value;
    }

    /**
     * Adds a custom metadata.
     *
     * @param key   metadata key
     *              This key should include the prefix "x-oss-meta-"
     * @param value metadata value
     */
     void addUserMetadata(String key, String value) {
        this.userMetadata[key] = value;
    }

    /**
     * Gets the Last-Modified value, which is the time of the object's last update.
     *
     * @return The object's last modified time.
     */
     Date getLastModified() {
        return (Date) metadata.get(OSSHeaders.LAST_MODIFIED);
    }

    /**
     * Sets the Last-Modified value, which is the time of the object's last update(SDK internal only).
     *
     * @param lastModified The object's last modified time.
     */
     void setLastModified(Date lastModified) {
        metadata[OSSHeaders.LAST_MODIFIED] = lastModified;
    }

    /**
     * Gets Expires header value in Rfc822 format (EEE, dd MMM yyyy HH:mm:ss 'GMT'")
     * If the 'expires' header was not assigned with value, returns null.
     *
     * @return Expires header value in Rfc822 format.
     * @throws ParseException unable to parse the Expires value into Rfc822 format
     */
     Date getExpirationTime()  {
        return DateUtil.parseRfc822Date((String) metadata.get(OSSHeaders.EXPIRES));
    }

    /**
     * Sets Expires header value
     *
     * @param expirationTime Expires time
     */
     void setExpirationTime(Date expirationTime) {
        metadata[OSSHeaders.EXPIRES] = DateUtil.formatRfc822Date(expirationTime);
    }

    /**
     * Gets the raw expires header value without parsing it.
     * If the 'expires' header was not assigned with value, returns null.
     *
     * @return The raw expires header value
     */
     String getRawExpiresValue() {
        return (String) metadata.get(OSSHeaders.EXPIRES);
    }

    /**
     * Gets Content-Length header value which means the object content's size.
     *
     * @return The value of Content-Length header.
     */
     int getContentLength() {
        int contentLength = (int) metadata.get(OSSHeaders.CONTENT_LENGTH);

        if (contentLength == null) return 0;
        return contentLength.intValue();
    }

    /**
     * Sets Content-Length header value which means the object content's size.
     * The Content-Length header must be specified correctly when uploading an object.
     *
     * @param contentLength Object content length
     * @throws ArgumentError Object content length is more than 5GB or less than 0.
     */
     void setContentLength(int contentLength) {
        if (contentLength > OSSConstants.DEFAULT_FILE_SIZE_LIMIT) {
            throw ArgumentError("The content length could not be more than 5GB.");
        }

        metadata[OSSHeaders.CONTENT_LENGTH] = contentLength;
    }

    /**
     * Gets Content-Type header value in MIME types, which means the object's type.
     *
     * @return The object Content-Type value in MIME types.
     */
     String getContentType() {
        return (String) metadata.get(OSSHeaders.CONTENT_TYPE);
    }

    /**
     * Sets Content-Type header value in MIME types, which means the object's type.
     *
     * @param contentType The object Content-Type value in MIME types.
     */
     void setContentType(String contentType) {
        metadata[OSSHeaders.CONTENT_TYPE] = contentType;
    }

     String getContentMD5() {
        return (String) metadata.get(OSSHeaders.CONTENT_MD5);
    }

     void setContentMD5(String contentMD5) {
        metadata[OSSHeaders.CONTENT_MD5] = contentMD5;
    }

     String getSHA1() {
        return (String) metadata.get(OSSHeaders.OSS_HASH_SHA1);
    }

     void setSHA1(String value) {
        metadata[OSSHeaders.OSS_HASH_SHA1] = value;
    }

    /**
     * Gets Content-Encoding header value which means the object content's encoding method.
     *
     * @return The object content's encoding
     */
     String getContentEncoding() {
        return (String) metadata.get(OSSHeaders.CONTENT_ENCODING);
    }

    /**
     * Gets Content-Encoding header value which means the object content's encoding method.
     *
     * @param encoding The object content's encoding.
     */
     void setContentEncoding(String encoding) {
        metadata[OSSHeaders.CONTENT_ENCODING] = encoding;
    }

    /**
     * Gets Cache-Control header value, which specifies the cache behavior of accessing the object.
     *
     * @return Cache-Control header value
     */
     String getCacheControl() {
        return (String) metadata.get(OSSHeaders.CACHE_CONTROL);
    }

    /**
     * Sets Cache-Control header value, which specifies the cache behavior of accessing the object.
     *
     * @param cacheControl Cache-Control header value
     */
     void setCacheControl(String cacheControl) {
        metadata[OSSHeaders.CACHE_CONTROL] = cacheControl;
    }

    /**
     * Gets Content-Disposition header value, which specifies how MIME agent is going to handle
     * attachments.
     *
     * @return Content-Disposition header value
     */
     String getContentDisposition() {
        return (String) metadata.get(OSSHeaders.CONTENT_DISPOSITION);
    }

    /**
     * Gets Content-Disposition header value, which specifies how MIME agent is going to handle
     * attachments.
     *
     * @param disposition Content-Disposition header value
     */
     void setContentDisposition(String disposition) {
        metadata[OSSHeaders.CONTENT_DISPOSITION] = disposition;
    }

    /**
     * Gets the ETag value which is the 128bit MD5 digest in HEX encoding.
     *
     * @return The ETag value.
     */
     String getETag() {
        return (String) metadata.get(OSSHeaders.ETAG);
    }

    /**
     * Gets the server side encryption algorithm.
     *
     * @return The server side encryption algorithm. No encryption if it returns null.
     */
     String getServerSideEncryption() {
        return (String) metadata.get(OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION);
    }

    /**
     * Sets the server side encryption algorithm.
     */
     void setServerSideEncryption(String serverSideEncryption) {
        metadata[OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION] = serverSideEncryption;
    }

    /**
     * Gets Object type---Normal or Appendable
     *
     * @return Object type
     */
     String getObjectType() {
        return (String) metadata.get(OSSHeaders.OSS_OBJECT_TYPE);
    }

    /**
     * Gets the raw metadata dictionary (SDK internal only)
     *
     * @return The raw metadata (SDK internal only)
     */
     Map<String, Object> getRawMetadata() {
        return Collections.unmodifiableMap(metadata);
    }

    @override
     String toString() {
        String s;
        String expirationTimeStr = "";
        try {
            Date expirationTime = getExpirationTime();
            expirationTimeStr = expirationTime.toString();
        } catch (Exception e) {
        }
        s = OSSHeaders.LAST_MODIFIED + ":" + getLastModified() + "\n"
                + OSSHeaders.EXPIRES + ":" + expirationTimeStr + "\n"
                + "rawExpires" + ":" + getRawExpiresValue() + "\n"
                + OSSHeaders.CONTENT_MD5 + ":" + getContentMD5() + "\n"
                + OSSHeaders.OSS_OBJECT_TYPE + ":" + getObjectType() + "\n"
                + OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION + ":" + getServerSideEncryption() + "\n"
                + OSSHeaders.CONTENT_DISPOSITION + ":" + getContentDisposition() + "\n"
                + OSSHeaders.CONTENT_ENCODING + ":" + getContentEncoding() + "\n"
                + OSSHeaders.CACHE_CONTROL + ":" + getCacheControl() + "\n"
                + OSSHeaders.ETAG + ":" + getETag() + "\n";

        return s;
    }
}