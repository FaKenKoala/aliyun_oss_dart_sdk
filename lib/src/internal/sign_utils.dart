
 import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';

import 'sign_parameters.dart';

class SignUtils {

     static String composeRequestAuthorization(String accessKeyId, String signature) {
        return AUTHORIZATION_PREFIX + accessKeyId + ":" + signature;
    }

     static String buildCanonicalString(String method, String resourcePath, RequestMessage request,
            String expires) {

        StringBuffer canonicalString = StringBuffer();
        canonicalString..write(method)..write(SignParameters.NEW_LINE);

        Map<String, String> headers = request.headers;
        Map<String, String> headersToSign = <String, String>{};

        if (headers != null) {
            for (Entry<String, String> header in headers.entrySet()) {
                if (header.getKey() == null) {
                    continue;
                }

                String lowerKey = header.getKey().toLowerCase();
                if (lowerKey.equals(HttpHeaders.CONTENT_TYPE.toLowerCase())
                        || lowerKey.equals(HttpHeaders.CONTENT_MD5.toLowerCase())
                        || lowerKey.equals(HttpHeaders.DATE.toLowerCase())
                        || lowerKey.startsWith(OSSHeaders.OSS_PREFIX)) {
                    headersToSign.put(lowerKey, header.getValue().trim());
                }
            }
        }

        if (!headersToSign.containsKey(HttpHeaders.CONTENT_TYPE.toLowerCase())) {
            headersToSign.put(HttpHeaders.CONTENT_TYPE.toLowerCase(), "");
        }
        if (!headersToSign.containsKey(HttpHeaders.CONTENT_MD5.toLowerCase())) {
            headersToSign.put(HttpHeaders.CONTENT_MD5.toLowerCase(), "");
        }

        // Append all headers to sign to canonical string
        for (Map.Entry<String, String> entry : headersToSign.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            if (key.startsWith(OSSHeaders.OSS_PREFIX)) {
                canonicalString.append(key).append(':').append(value);
            } else {
                canonicalString.append(value);
            }

            canonicalString.append(SignParameters.NEW_LINE);
        }

        // Append canonical resource to canonical string
        canonicalString.append(buildCanonicalizedResource(resourcePath, request.getParameters()));

        return canonicalString.toString();
    }

     static String buildRtmpCanonicalString(String canonicalizedResource, RequestMessage request,
            String expires) {

        StringBuffer canonicalString = StringBuffer();

        // Append expires
        canonicalString.append(expires + SignParameters.NEW_LINE);

        // Append canonicalized parameters
        for (Map.Entry<String, String> entry : request.getParameters().entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            canonicalString.append(key).append(':').append(value);
            canonicalString.append(SignParameters.NEW_LINE);
        }

        // Append canonicalized resource
        canonicalString.append(canonicalizedResource);

        return canonicalString.toString();
    }

     static String buildSignedURL(GeneratePresignedUrlRequest request, Credentials currentCreds, ClientConfiguration config, URI endpoint) {
        String bucketName = request.getBucketName();
        String accessId = currentCreds.getAccessKeyId();
        String accessKey = currentCreds.getSecretAccessKey();
        bool useSecurityToken = currentCreds.useSecurityToken();
        HttpMethod method = request.getMethod() != null ? request.getMethod() : HttpMethod.GET;

        String expires = String.valueOf(request.getExpiration().getTime() / 1000L);
        String key = request.getKey();
        String resourcePath = OSSUtils.determineResourcePath(bucketName, key, config.isSLDEnabled());

        RequestMessage requestMessage = RequestMessage(bucketName, key);
        requestMessage.setEndpoint(OSSUtils.determineFinalEndpoint(endpoint, bucketName, config));
        requestMessage.setMethod(method);
        requestMessage.setResourcePath(resourcePath);
        requestMessage.setHeaders(request.getHeaders());

        requestMessage.addHeader(HttpHeaders.DATE, expires);
        if (request.getContentType() != null && !request.getContentType().trim().equals("")) {
            requestMessage.addHeader(HttpHeaders.CONTENT_TYPE, request.getContentType());
        }
        if (request.getContentMD5() != null && !request.getContentMD5().trim().equals("")) {
            requestMessage.addHeader(HttpHeaders.CONTENT_MD5, request.getContentMD5());
        }
        for (Map.Entry<String, String> h : request.getUserMetadata().entrySet()) {
            requestMessage.addHeader(OSSHeaders.OSS_USER_METADATA_PREFIX + h.getKey(), h.getValue());
        }

        Map<String, String> responseHeaderParams = HashMap<String, String>();
        populateResponseHeaderParameters(responseHeaderParams, request.getResponseHeaders());
        populateTrafficLimitParams(responseHeaderParams, request.getTrafficLimit());
        if (responseHeaderParams.size() > 0) {
            requestMessage.setParameters(responseHeaderParams);
        }

        if (request.getQueryParameter() != null && request.getQueryParameter().size() > 0) {
            for (Map.Entry<String, String> entry : request.getQueryParameter().entrySet()) {
                requestMessage.addParameter(entry.getKey(), entry.getValue());
            }
        }

        if (request.getProcess() != null && !request.getProcess().trim().equals("")) {
            requestMessage.addParameter(RequestParameters.SUBRESOURCE_PROCESS, request.getProcess());
        }

        if (useSecurityToken) {
            requestMessage.addParameter(SECURITY_TOKEN, currentCreds.getSecurityToken());
        }

        String canonicalResource = "/" + ((bucketName != null) ? bucketName : "") + ((key != null ? "/" + key : ""));
        String canonicalString = buildCanonicalString(method.toString(), canonicalResource, requestMessage,
                expires);
        String signature = ServiceSignature.create().computeSignature(accessKey, canonicalString);

        Map<String, String> params = LinkedHashMap<String, String>();
        params.put(HttpHeaders.EXPIRES, expires);
        params.put(OSS_ACCESS_KEY_ID, accessId);
        params.put(SIGNATURE, signature);
        params.putAll(requestMessage.getParameters());

        String queryString = HttpUtil.paramToQueryString(params, DEFAULT_CHARSET_NAME);

        /* Compse HTTP request uri. */
        String url = requestMessage.getEndpoint().toString();
        if (!url.endsWith("/")) {
            url += "/";
        }
        url += resourcePath + "?" + queryString;
        return url;
    }

     static String buildCanonicalizedResource(String resourcePath, Map<String, String> parameters) {
        assertTrue(resourcePath.startsWith("/"), "Resource path should start with slash character");

        StringBuffer builder = StringBuffer();
        builder.append(resourcePath);

        if (parameters != null) {
            String[] parameterNames = parameters.keySet().toArray(String[parameters.size()]);
            Arrays.sort(parameterNames);

            char separator = '?';
            for (String paramName : parameterNames) {
                if (!SignParameters.SIGNED_PARAMTERS.contains(paramName)) {
                    continue;
                }

                builder.append(separator);
                builder.append(paramName);
                String paramValue = parameters.get(paramName);
                if (paramValue != null) {
                    builder.append("=").append(paramValue);
                }

                separator = '&';
            }
        }

        return builder.toString();
    }

     static String buildSignature(String secretAccessKey, String httpMethod, String resourcePath, RequestMessage request) {
        String canonicalString = buildCanonicalString(httpMethod, resourcePath, request, null);
        return ServiceSignature.create().computeSignature(secretAccessKey, canonicalString);
    }

     static void populateTrafficLimitParams(Map<String, String> params, int limit) {
        if (limit > 0) {
            params.put(OSS_TRAFFIC_LIMIT, String.valueOf(limit));
        }
    }
}
