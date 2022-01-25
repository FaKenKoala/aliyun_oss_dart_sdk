package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/24/15.
 */
 class ListObjectsRequest extends OSSRequest {
     static final int MAX_RETURNED_KEYS_LIMIT = 1000;

    // bucket name
     String bucketName;

    // prefix filter
     String prefix;

    // maker filter--the returned objects' keys must be greater than this value in lexicographic order.
     String marker;

    // the max keys to return--by default it's 100
     Integer maxKeys;

    // delimiter for grouping object keys.
     String delimiter;

    /**
     * The encoding type of the object name in the response body. For now object name could have any unicode character.
     * However the XML1.0 cannot handle some unicode characters such as ASCII 0 to 10.
     * For these unsupported characters, they could be encoded by the the specified encoding type.
     */
     String encodingType;

     ListObjectsRequest() {
        this(null);
    }

     ListObjectsRequest(String bucketName) {
        this(bucketName, null, null, null, null);
    }

    /**
     * Constructor
     *
     * @param bucketName bucket name
     * @param prefix     prefix filter
     * @param marker     maker filter
     * @param maxKeys    Max keys to return, by default it's 100.
     * @param delimiter  delimiter character to group object name
     */
     ListObjectsRequest(String bucketName, String prefix, String marker, String delimiter, Integer maxKeys) {
        setBucketName(bucketName);
        setPrefix(prefix);
        setMarker(marker);
        setDelimiter(delimiter);
        if (maxKeys != null) {
            setMaxKeys(maxKeys);
        }
    }

    /**
     * Gets bucket name
     *
     * @return bucket name
     */
     String getBucketName() {
        return bucketName;
    }

    /**
     * Sets bucket name
     *
     * @param bucketName bucket name
     */
     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

    /**
     * Gets prefix filter.
     *
     * @return prefix
     */
     String getPrefix() {
        return prefix;
    }

    /**
     * Sets prefix filter.
     *
     * @param prefix prefix filter.
     */
     void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    /**
     * Gets the marker filter.
     *
     * @return marker filter
     */
     String getMarker() {
        return marker;
    }

    /**
     * Sets the marker filter.
     *
     * @param marker marker filter
     */
     void setMarker(String marker) {
        this.marker = marker;
    }

    /**
     * Gets the max keys to return, by default it's 100.
     *
     * @return The max keys to return
     */
     Integer getMaxKeys() {
        return maxKeys;
    }

    /**
     * Sets the max keys to return. By default it's 100 and max value is 1000.
     *
     * @param maxKeys The max keys to return.
     */
     void setMaxKeys(Integer maxKeys) {
        if (maxKeys < 0 || maxKeys > MAX_RETURNED_KEYS_LIMIT) {
            throw IllegalArgumentException("Maxkeys should less can not exceed 1000.");
        }

        this.maxKeys = maxKeys;
    }

    /**
     * Gets the delimiter character for grouping object keys.
     *
     * @return the delimiter character.
     */
     String getDelimiter() {
        return delimiter;
    }

    /**
     * Sets the object key's delimiter character
     *
     * @param delimiter the delimiter to set
     */
     void setDelimiter(String delimiter) {
        this.delimiter = delimiter;
    }

    /**
     * Gets the encoding type of the object
     *
     * @return the encoding type of the object
     */
     String getEncodingType() {
        return encodingType;
    }

    /**
     * Sets the encoding type
     *
     * @param encodingType Encoding type
     *                     Valid values: null (no encoding) or "url".
     */
     void setEncodingType(String encodingType) {
        this.encodingType = encodingType;
    }
}
