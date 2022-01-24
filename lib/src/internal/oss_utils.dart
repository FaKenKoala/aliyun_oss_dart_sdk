
 import 'package:aliyun_oss_dart_sdk/src/common/utils/resource_manager.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_constants.dart';

class OSSUtils {

     static final ResourceManager OSS_RESOURCE_MANAGER = ResourceManager.getInstance(OSSConstants.RESOURCE_NAME_OSS);
     static final ResourceManager COMMON_RESOURCE_MANAGER = ResourceManager.getInstance(OSSConstants.RESOURCE_NAME_COMMON);

     static final String BUCKET_NAMING_CREATION_REGEX = "^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]\$";
     static final String BUCKET_NAMING_REGEX = "^[a-z0-9][a-z0-9-_]{1,61}[a-z0-9]\$";
     static final String ENDPOINT_REGEX = "^[a-zA-Z0-9._-]+\$";

    /// Validate endpoint.
     static bool validateEndpoint(String? endpoint) {
        if (endpoint == null) {
            return false;
        }
        return endpoint.matches(ENDPOINT_REGEX);
    }

     static void ensureEndpointValid(String endpoint) {
        if (!validateEndpoint(endpoint)) {
            throw ArgumentError(
                    OSS_RESOURCE_MANAGER.getFormattedString("EndpointInvalid", endpoint));
        }
    }

    /**
     * Validate bucket name.
     */
     static bool validateBucketName(String bucketName) {

        if (bucketName == null) {
            return false;
        }

        return bucketName.matches(BUCKET_NAMING_REGEX);
    }

     static void ensureBucketNameValid(String bucketName) {
        if (!validateBucketName(bucketName)) {
            throw ArgumentError(
                    OSS_RESOURCE_MANAGER.getFormattedString("BucketNameInvalid", bucketName));
        }
    }

    /**
     * Validate bucket creation name.
     */
     static bool validateBucketNameCreation(String bucketName) {

        if (bucketName == null) {
            return false;
        }

        return bucketName.matches(BUCKET_NAMING_CREATION_REGEX);
    }

     static void ensureBucketNameCreationValid(String bucketName) {
        if (!validateBucketNameCreation(bucketName)) {
            throw ArgumentError(
                    OSS_RESOURCE_MANAGER.getFormattedString("BucketNameInvalid", bucketName));
        }
    }

    /**
     * Validate object name.
     */
     static bool validateObjectKey(String? key) {

        if (key == null || key.isEmpty) {
            return false;
        }

        byte[] bytes = null;
        try {
            bytes = key.getBytes(DEFAULT_CHARSET_NAME);
        } catch (UnsupportedEncodingException e) {
            return false;
        }

        // Validate exculde xml unsupported chars
        char keyChars[] = key.toCharArray();
        char firstChar = keyChars[0];
        if (firstChar == '\\') {
            return false;
        }

        return (bytes.length > 0 && bytes.length < OBJECT_NAME_MAX_LENGTH);
    }

     static void ensureObjectKeyValid(String key) {
        if (!validateObjectKey(key)) {
            throw ArgumentError(OSS_RESOURCE_MANAGER.getFormattedString("ObjectKeyInvalid", key));
        }
    }

     static void ensureLiveChannelNameValid(String liveChannelName) {
        if (!validateObjectKey(liveChannelName)) {
            throw ArgumentError(
                    OSS_RESOURCE_MANAGER.getFormattedString("LiveChannelNameInvalid", liveChannelName));
        }
    }

    /**
     * Make a third-level domain by appending bucket name to front of original
     * endpoint if no binding to CNAME, otherwise use original endpoint as
     * second-level domain directly.
     */
     static URI determineFinalEndpoint(URI endpoint, String bucket, ClientConfiguration clientConfig) {
        try {
            StringBuilder conbinedEndpoint = new StringBuilder();
            conbinedEndpoint.append(String.format("%s://", endpoint.getScheme()));
            conbinedEndpoint.append(buildCanonicalHost(endpoint, bucket, clientConfig));
            conbinedEndpoint.append(endpoint.getPort() != -1 ? String.format(":%s", endpoint.getPort()) : "");
            conbinedEndpoint.append(endpoint.getPath());
            return new URI(conbinedEndpoint.toString());
        } catch (URISyntaxException ex) {
            throw ArgumentError(ex.getMessage(), ex);
        }
    }

     static String buildCanonicalHost(URI endpoint, String bucket, ClientConfiguration clientConfig) {
        String host = endpoint.getHost();

        bool isCname = false;
        if (clientConfig.isSupportCname()) {
            isCname = cnameExcludeFilter(host, clientConfig.getCnameExcludeList());
        }

        StringBuffer cannonicalHost = new StringBuffer();
        if (bucket != null && !isCname && !clientConfig.isSLDEnabled()) {
            cannonicalHost.append(bucket).append(".").append(host);
        } else {
            cannonicalHost.append(host);
        }

        return cannonicalHost.toString();
    }

     static bool cnameExcludeFilter(String hostToFilter, List<String> excludeList) {
        if (hostToFilter != null && !hostToFilter.trim().isEmpty()) {
            String canonicalHost = hostToFilter.toLowerCase();
            for (String excl : excludeList) {
                if (canonicalHost.endsWith(excl)) {
                    return false;
                }
            }
            return true;
        }
        throw ArgumentError("Host name can not be null.");
    }

     static String determineResourcePath(String? bucket, String? key, bool sldEnabled) {
        return sldEnabled ? makeResourcePath(bucket, key) : makeResourcePath(key);
    }

    /**
     * Make a resource path from the object key, used when the bucket name
     * pearing in the endpoint.
     */
     static String makeResourcePath(String? key) {
        return key != null ? OSSUtils.urlEncodeKey(key) : null;
    }

    /**
     * Make a resource path from the bucket name and the object key.
     */
     static String makeResourcePath(String? bucket, String? key) {
        if (bucket != null) {
            return bucket + "/" + (key != null ? OSSUtils.urlEncodeKey(key) : "");
        } else {
            return null;
        }
    }

    /**
     * Encode object URI.
     */
     static String urlEncodeKey(String key) {
        if (key.startsWith("/")) {
            return HttpUtil.urlEncode(key, DEFAULT_CHARSET_NAME);
        }

        StringBuffer resultUri = new StringBuffer();

        String[] keys = key.split("/");
        resultUri.append(HttpUtil.urlEncode(keys[0], DEFAULT_CHARSET_NAME));
        for (int i = 1; i < keys.length; i++) {
            resultUri.append("/").append(HttpUtil.urlEncode(keys[i], DEFAULT_CHARSET_NAME));
        }

        if (key.endsWith("/")) {
            // String#split ignores trailing empty strings,
            // e.g., "a/b/" will be split as a 2-entries array,
            // so we have to append all the trailing slash to the uri.
            for (int i = key.length() - 1; i >= 0; i--) {
                if (key.charAt(i) == '/') {
                    resultUri.append("/");
                } else {
                    break;
                }
            }
        }

        return resultUri.toString();
    }

    /**
     * Populate metadata to headers.
     */
     static void populateRequestMetadata(Map<String, String> headers, ObjectMetadata metadata) {
        Map<String, Object> rawMetadata = metadata.getRawMetadata();
        if (rawMetadata != null) {
            for (Entry<String, Object> entry : rawMetadata.entrySet()) {
                if (entry.getKey() != null && entry.getValue() != null) {
                    String key = entry.getKey();
                    String value = entry.getValue().toString();
                    if (key != null)
                        key = key.trim();
                    if (value != null)
                        value = value.trim();
                    headers[key] = value;
                }
            }
        }

        Map<String, String> userMetadata = metadata.getUserMetadata();
        if (userMetadata != null) {
            for (Entry<String, String> entry : userMetadata.entrySet()) {
                if (entry.getKey() != null && entry.getValue() != null) {
                    String key = entry.getKey();
                    String value = entry.getValue();
                    if (key != null)
                        key = key.trim();
                    if (value != null)
                        value = value.trim();
                    headers.put(OSSHeaders.OSS_USER_METADATA_PREFIX + key, value);
                }
            }
        }
    }

     static void addHeader(Map<String, String> headers, String header, String value) {
        if (value != null) {
            headers.put(header, value);
        }
    }

     static void addDateHeader(Map<String, String> headers, String header, Date value) {
        if (value != null) {
            headers.put(header, DateUtil.formatRfc822Date(value));
        }
    }

     static void addStringListHeader(Map<String, String> headers, String header, List<String> values) {
        if (values != null && !values.isEmpty()) {
            headers.put(header, join(values));
        }
    }

     static void removeHeader(Map<String, String> headers, String header) {
        if (header != null && headers.containsKey(header)) {
            headers.remove(header);
        }
    }

     static String join(List<String> strings) {

        StringBuilder sb = new StringBuilder();
        bool first = true;

        for (String s : strings) {
            if (!first) {
                sb.append(", ");
            }
            sb.append(s);

            first = false;
        }

        return sb.toString();
    }

     static String trimQuotes(String s) {

        if (s == null) {
            return null;
        }

        s = s.trim();
        if (s.startsWith("\"")) {
            s = s.substring(1);
        }
        if (s.endsWith("\"")) {
            s = s.substring(0, s.length() - 1);
        }

        return s;
    }

     static void populateResponseHeaderParameters(Map<String, String> params,
            ResponseHeaderoverrides responseHeaders) {

        if (responseHeaders != null) {
            if (responseHeaders.getCacheControl() != null) {
                params.put(ResponseHeaderoverrides.RESPONSE_HEADER_CACHE_CONTROL, responseHeaders.getCacheControl());
            }

            if (responseHeaders.getContentDisposition() != null) {
                params.put(ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_DISPOSITION,
                        responseHeaders.getContentDisposition());
            }

            if (responseHeaders.getContentEncoding() != null) {
                params.put(ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_ENCODING,
                        responseHeaders.getContentEncoding());
            }

            if (responseHeaders.getContentLangauge() != null) {
                params.put(ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_LANGUAGE,
                        responseHeaders.getContentLangauge());
            }

            if (responseHeaders.getContentType() != null) {
                params.put(ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_TYPE, responseHeaders.getContentType());
            }

            if (responseHeaders.getExpires() != null) {
                params.put(ResponseHeaderoverrides.RESPONSE_HEADER_EXPIRES, responseHeaders.getExpires());
            }
        }
    }

     static void safeCloseResponse(ResponseMessage response) {
        try {
            response.close();
        } catch (IOException e) {
        }
    }

     static void mandatoryCloseResponse(ResponseMessage response) {
        try {
            response.abort();
        } catch (IOException e) {
        }
    }

     static long determineInputStreamLength(InputStream instream, long hintLength) {

        if (hintLength <= 0 || !instream.markSupported()) {
            return -1;
        }

        return hintLength;
    }

     static long determineInputStreamLength(InputStream instream, long hintLength, bool useChunkEncoding) {

        if (useChunkEncoding) {
            return -1;
        }

        if (hintLength <= 0 || !instream.markSupported()) {
            return -1;
        }

        return hintLength;
    }

     static String joinETags(List<String> eTags) {

        StringBuilder sb = new StringBuilder();
        bool first = true;

        for (String eTag : eTags) {
            if (!first) {
                sb.append(", ");
            }
            sb.append(eTag);

            first = false;
        }

        return sb.toString();
    }

    /**
     * Encode the callback with JSON.
     */
     static String jsonizeCallback(Callback callback) {
        StringBuffer jsonBody = new StringBuffer();

        jsonBody.append("{");
        // url, required
        jsonBody.append("\"callbackUrl\":" + "\"" + callback.getCallbackUrl() + "\"");

        // host, optional
        if (callback.getCallbackHost() != null && !callback.getCallbackHost().isEmpty()) {
            jsonBody.append(",\"callbackHost\":" + "\"" + callback.getCallbackHost() + "\"");
        }

        // body, require
        jsonBody.append(",\"callbackBody\":" + "\"" + callback.getCallbackBody() + "\"");

        // bodyType, optional
        if (callback.getCalbackBodyType() == CalbackBodyType.JSON) {
            jsonBody.append(",\"callbackBodyType\":\"application/json\"");
        } else if (callback.getCalbackBodyType() == CalbackBodyType.URL) {
            jsonBody.append(",\"callbackBodyType\":\"application/x-www-form-urlencoded\"");
        }
        jsonBody.append("}");

        return jsonBody.toString();
    }

    /**
     * Encode CallbackVar with Json.
     */
     static String jsonizeCallbackVar(Callback callback) {
        StringBuffer jsonBody = new StringBuffer();

        jsonBody.append("{");
        for (Map.Entry<String, String> entry : callback.getCallbackVar().entrySet()) {
            if (entry.getKey() != null && entry.getValue() != null) {
                if (!jsonBody.toString().equals("{")) {
                    jsonBody.append(",");
                }
                jsonBody.append("\"" + entry.getKey() + "\":\"" + entry.getValue() + "\" ");
            }
        }
        jsonBody.append("}");

        return jsonBody.toString();
    }

    /**
     * Ensure the callback is valid by checking its url and body are not null or
     * empty.
     */
     static void ensureCallbackValid(Callback callback) {
        if (callback != null) {
            CodingUtils.assertStringNotNullOrEmpty(callback.getCallbackUrl(), "Callback.callbackUrl");
            CodingUtils.assertParameterNotNull(callback.getCallbackBody(), "Callback.callbackBody");
        }
    }

    /**
     * Put the callback parameter into header.
     */
     static void populateRequestCallback(Map<String, String> headers, Callback callback) {
        if (callback != null) {
            String jsonCb = jsonizeCallback(callback);
            String base64Cb = BinaryUtil.toBase64String(jsonCb.getBytes());

            headers.put(OSSHeaders.OSS_HEADER_CALLBACK, base64Cb);

            if (callback.hasCallbackVar()) {
                String jsonCbVar = jsonizeCallbackVar(callback);
                String base64CbVar = BinaryUtil.toBase64String(jsonCbVar.getBytes());
                base64CbVar = base64CbVar.replaceAll("\n", "").replaceAll("\r", "");
                headers.put(OSSHeaders.OSS_HEADER_CALLBACK_VAR, base64CbVar);
            }
        }
    }

    /**
     * Checks if OSS and SDK's checksum is same. If not, throws
     * InconsistentException.
     */
     static void checkChecksum(Long clientChecksum, Long serverChecksum, String requestId) {
        if (clientChecksum != null && serverChecksum != null && !clientChecksum.equals(serverChecksum)) {
            throw new InconsistentException(clientChecksum, serverChecksum, requestId);
        }
    }

     static URI toEndpointURI(String endpoint, String defaultProtocol) throws IllegalArgumentException {
        if (endpoint != null && !endpoint.contains("://")) {
            endpoint = defaultProtocol + "://" + endpoint;
        }

        try {
            return new URI(endpoint);
        } catch (URISyntaxException e) {
            throw ArgumentError(e);
        }
    }
}
