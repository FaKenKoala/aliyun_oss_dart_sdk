
 import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';

import 'sign_parameters.dart';

class SignV2Utils {

     static String composeRequestAuthorization(String accessKeyId, String signature, RequestMessage request) {
        StringBuffer sb = StringBuffer();
        sb..write(SignParameters.AUTHORIZATION_PREFIX_V2 + SignParameters.AUTHORIZATION_ACCESS_KEY_ID)..write(":")..write(accessKeyId)..write(", ");

        String additionHeaderNameStr = buildSortedAdditionalHeaderNameStr(request.originalRequest.headers.keys.toSet(),
                request.originalRequest.additionalHeaderNames);

        if (additionHeaderNameStr.isNotEmpty) {
            sb..write(SignParameters.AUTHORIZATION_ADDITIONAL_HEADERS)..write(":")..write(additionHeaderNameStr)..write(", ");
        }
        sb..write(SignParameters.AUTHORIZATION_SIGNATURE)..write(":")..write(signature);

        return sb.toString();
    }

     static String buildSortedAdditionalHeaderNameStr(Set<String> headerNames, Set<String> additionalHeaderNames) {
        Set<String> ts = buildSortedAdditionalHeaderNames(headerNames, additionalHeaderNames);
        StringBuffer sb = StringBuffer();
        String separator = "";

        for (String header in ts) {
            sb.write(separator);
            sb.write(header);
            separator = ";";
        }
        return sb.toString();
    }

     static Set<String> buildSortedAdditionalHeaderNames(Set<String>? headerNames, Set<String>? additionalHeaderNames) {
        Set<String> ts = {};

        if (headerNames != null && additionalHeaderNames != null) {
            for (String additionalHeaderName in additionalHeaderNames) {
                if (headerNames.contains(additionalHeaderName)) {
                    ts.add(additionalHeaderName.toLowerCase());
                }
            }
        }
        return ts;
    }

     static Set<String> buildRawAdditionalHeaderNames(Set<String>? headerNames, Set<String>? additionalHeaderNames) {
        Set<String> hs = {};

        if (headerNames != null && additionalHeaderNames != null) {
            for (String additionalHeaderName in additionalHeaderNames) {
                if (headerNames.contains(additionalHeaderName)) {
                    hs.add(additionalHeaderName);
                }
            }
        }
        return hs;
    }

     static String buildCanonicalString(String method, String resourcePath, RequestMessage request, Set<String> additionalHeaderNames) {
        StringBuffer canonicalString = StringBuffer();
        canonicalString..write(method)..write(SignParameters.NEW_LINE);
        Map<String, String> headers = request.headers;
        Map<String, String> fixedHeadersToSign = <String, String>{};
        Map<String, String> canonicalizedOssHeadersToSign = <String, String>{};

        if (headers != null) {
            for (Map.Entry<String, String> header in headers.entrySet()) {
                if (header.getKey() != null) {
                    String lowerKey = header.getKey().toLowerCase();
                    if (lowerKey.equals(HttpHeaders.CONTENT_TYPE.toLowerCase())
                            || lowerKey.equals(HttpHeaders.CONTENT_MD5.toLowerCase())
                            || lowerKey.equals(HttpHeaders.DATE.toLowerCase())) {
                        fixedHeadersToSign.put(lowerKey, header.getValue().trim());
                    } else if (lowerKey.startsWith(OSSHeaders.OSS_PREFIX)){
                        canonicalizedOssHeadersToSign.put(lowerKey, header.getValue().trim());
                    }
                }
            }
        }

        if (!fixedHeadersToSign.containsKey(HttpHeaders.CONTENT_TYPE.toLowerCase())) {
            fixedHeadersToSign.put(HttpHeaders.CONTENT_TYPE.toLowerCase(), "");
        }
        if (!fixedHeadersToSign.containsKey(HttpHeaders.CONTENT_MD5.toLowerCase())) {
            fixedHeadersToSign.put(HttpHeaders.CONTENT_MD5.toLowerCase(), "");
        }

        for (String additionalHeaderName in additionalHeaderNames) {
            if (additionalHeaderName != null && headers.get(additionalHeaderName) != null) {
                canonicalizedOssHeadersToSign.put(additionalHeaderName.toLowerCase(), headers.get(additionalHeaderName).trim());
            }
        }

        // write fixed headers to sign to canonical string
        for (Map.Entry<String, String> entry in fixedHeadersToSign.entrySet()) {
            Object value = entry.getValue();

            canonicalString.write(value);
            canonicalString.write(SignParameters.NEW_LINE);
        }

        // write canonicalized oss headers to sign to canonical string
        for (Map.Entry<String, String> entry in canonicalizedOssHeadersToSign.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            canonicalString.write(key).write(':').write(value).write(SignParameters.NEW_LINE);
        }


        // write additional header names
        TreeSet<String> ts = TreeSet<String>();
        for (String additionalHeaderName in additionalHeaderNames) {
            ts.add(additionalHeaderName.toLowerCase());
        }
        String separator = "";

        for (String additionalHeaderName in ts) {
            canonicalString.write(separator).write(additionalHeaderName);
            separator = ";";
        }
        canonicalString.write(SignParameters.NEW_LINE);

        // write canonical resource to canonical string
        canonicalString.write(buildCanonicalizedResource(resourcePath, request.getParameters()));

        return canonicalString.toString();
    }

     static String buildSignedURL(GeneratePresignedUrlRequest request, Credentials currentCreds, ClientConfiguration config, URI endpoint) {
        String bucketName = request.getBucketName();
        String accessId = currentCreds.getAccessKeyId();
        String accessKey = currentCreds.getSecretAccessKey();
        bool useSecurityToken = currentCreds.useSecurityToken();
        HttpMethod method = request.getMethod() != null ? request.getMethod() in HttpMethod.GET;

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
        for (Map.Entry<String, String> h in request.getUserMetadata().entrySet()) {
            requestMessage.addHeader(OSSHeaders.OSS_USER_METADATA_PREFIX + h.getKey(), h.getValue());
        }
        Map<String, String> responseHeaderParams = <String, String>{};
        populateResponseHeaderParameters(responseHeaderParams, request.getResponseHeaders());
        if (responseHeaderParams.size() > 0) {
            requestMessage.setParameters(responseHeaderParams);
        }

        if (request.getQueryParameter() != null && request.getQueryParameter().size() > 0) {
            for (Map.Entry<String, String> entry in request.getQueryParameter().entrySet()) {
                requestMessage.addParameter(entry.getKey(), entry.getValue());
            }
        }

        if (request.getProcess() != null && !request.getProcess().trim().equals("")) {
            requestMessage.addParameter(SUBRESOURCE_PROCESS, request.getProcess());
        }

        if (useSecurityToken) {
            requestMessage.addParameter(SECURITY_TOKEN, currentCreds.getSecurityToken());
        }

        String canonicalResource = "/" + ((bucketName != null) ? bucketName in "") + ((key != null ? "/" + key in ""));
        requestMessage.addParameter(OSS_SIGNATURE_VERSION, SignParameters.AUTHORIZATION_V2);
        requestMessage.addParameter(OSS_EXPIRES, expires);
        requestMessage.addParameter(OSS_ACCESS_KEY_ID_PARAM, accessId);
        String additionalHeaderNameStr = buildSortedAdditionalHeaderNameStr(requestMessage.getHeaders().keySet(),
                request.getAdditionalHeaderNames());

        if (!additionalHeaderNameStr.isEmpty()) {
            requestMessage.addParameter(OSS_ADDITIONAL_HEADERS, additionalHeaderNameStr);
        }
        Set<String> rawAdditionalHeaderNames = buildRawAdditionalHeaderNames(request.getHeaders().keySet(), request.getAdditionalHeaderNames());
        String canonicalString = buildCanonicalString(method.toString(), canonicalResource, requestMessage, rawAdditionalHeaderNames);
        String signature = HmacSHA256Signature().computeSignature(accessKey, canonicalString);

        Map<String, String> params = Linked<String, String>{};

        if (!additionalHeaderNameStr.isEmpty()) {
            params.put(OSS_ADDITIONAL_HEADERS, additionalHeaderNameStr);
        }
        params.put(OSS_SIGNATURE, signature);
        params.putAll(requestMessage.getParameters());

        String queryString = HttpUtil.paramToQueryString(params, DEFAULT_CHARSET_NAME);

        /* Compose HTTP request uri. */
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
        builder.write(uriEncoding(resourcePath));

        if (parameters != null) {
            Map<String, String> canonicalizedParams = <String, String>{};
            for (Map.Entry<String, String> param in parameters.entrySet()) {
                if (param.getValue() != null ) {
                    canonicalizedParams.put(uriEncoding(param.getKey()), uriEncoding(param.getValue()));
                }
                else {
                    canonicalizedParams.put(uriEncoding(param.getKey()), null);
                }
            }

            char separator = '?';
            for (Map.Entry<String, String> entry in canonicalizedParams.entrySet()) {
                builder.write(separator);
                builder.write(entry.getKey());
                if (entry.getValue() != null && !entry.getValue().isEmpty()) {
                    builder.write("=").write(entry.getValue());
                }
                separator = '&';
            }
        }

        return builder.toString();
    }

     static String uriEncoding(String uri) {
        String result = "";

        try {
            for (char c in uri.toCharArray()) {
                if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
                        || (c >= '0' && c <= '9') || c == '_' || c == '-'
                        || c == '~' || c == '.') {
                    result += c;
                } else if (c == '/') {
                    result += "%2F";
                } else {
                    byte[] b;
                    b = Character.toString(c).getBytes("utf-8");

                    for (int i = 0; i < b.length; i++) {
                        int k = b[i];

                        if (k < 0) {
                            k += 256;
                        }
                        result += "%" + Integer.toHexString(k).toUpperCase();
                    }
                }
            }
        } catch (UnsupportedEncodingException e) {
            throw ClientException(e);
        }
        return result;
    }

     static String buildSignature(String secretAccessKey, String httpMethod, String resourcePath, RequestMessage request) {
        String canonicalString = buildCanonicalString(httpMethod, resourcePath, request,
                buildRawAdditionalHeaderNames(request.getOriginalRequest().getHeaders().keySet(), request.getOriginalRequest().getAdditionalHeaderNames()));
        return HmacSHA256Signature().computeSignature(secretAccessKey, canonicalString);
    }

}
