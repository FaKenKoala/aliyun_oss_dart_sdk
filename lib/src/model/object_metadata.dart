 import 'dart:collection';

import 'package:aliyun_oss_dart_sdk/src/common/oss_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';

class ObjectMetadata {

     static final String AES_256_SERVER_SIDE_ENCRYPTION = "AES256";
    // User's custom metadata dictionary. All keys  will be prefixed with x-oss-meta-in the HTTP headers.
    // The keys in this dictionary should include the prefix 'x-oss-meta-'.
     Map<String, String> userMetadata = LinkedHashMap<String, String>(equals: (p0, p1) => p0.equalsIgnoreCase(p1));
    // Standard metadata
     Map<String, Object> metadata = LinkedHashMap<String, Object>(equals: (p0, p1) => p0.equalsIgnoreCase(p1),);

     Map<String, String> getUserMetadata() {
        return userMetadata;
    }

     void setUserMetadata(Map<String, String>? userMetadata) {
        this.userMetadata.clear();
        if (userMetadata != null && userMetadata.isNotEmpty) {
            this.userMetadata.addAll(userMetadata);
        }
    }

     void setHeader(String key, Object value) {
        metadata[key] = value;
    }

     void addUserMetadata(String key, String value) {
        userMetadata[key] = value;
    }

     DateTime? getLastModified() {
        return metadata[HttpHeaders.lastModified] as DateTime?;
    }

     void setLastModified(DateTime lastModified) {
        metadata[HttpHeaders.lastModified] = lastModified;
    }

     DateTime getExpirationTime()  {
        return DateTimeUtil.parseRfc822DateTime((String) metadata.get(OSSHeaders.EXPIRES));
    }

     void setExpirationTime(DateTime expirationTime) {
        metadata[OSSHeaders.EXPIRES] = DateTimeUtil.formatRfc822DateTime(expirationTime);
    }

     String getRawExpiresValue() {
        return (String) metadata.get(OSSHeaders.EXPIRES);
    }

     int getContentLength() {
        int contentLength = (int) metadata.get(OSSHeaders.CONTENT_LENGTH);

        if (contentLength == null) return 0;
        return contentLength.intValue();
    }

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
            DateTime expirationTime = getExpirationTime();
            expirationTimeStr = expirationTime.toString();
        } catch ( e) {
        }
        s = HttpHeaders.lastModified + ":" + getLastModified() + "\n"
                + HttpHeaders.expires + ":" + expirationTimeStr + "\n"
                + "rawExpires" + ":" + getRawExpiresValue() + "\n"
                + HttpHeaders.contentMd5 + ":" + getContentMD5() + "\n"
                + OSSHeaders.ossObjectType + ":" + getObjectType() + "\n"
                + OSSHeaders.ossServerSideEncryption + ":" + getServerSideEncryption() + "\n"
                + HttpHeaders.contentDisposition + ":" + getContentDisposition() + "\n"
                + HttpHeaders.contentEncoding + ":" + getContentEncoding() + "\n"
                + HttpHeaders.cacheControl + ":" + getCacheControl() + "\n"
                + HttpHeaders.etag + ":" + getETag() + "\n";

        return s;
    }
}