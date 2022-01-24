
 import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_util.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generate_presigned_url_request.dart';

import 'oss_headers.dart';
import 'oss_utils.dart';
import 'request_parameters.dart';
import 'sign_parameters.dart';

class SignUtils {

     static String composeRequestAuthorization(String accessKeyId, String signature) {
        return SignParameters.AUTHORIZATION_PREFIX + accessKeyId + ":" + signature;
    }

     static String buildCanonicalString(String method, String resourcePath, RequestMessage request,
            String expires) {

        StringBuffer canonicalString = StringBuffer();
        canonicalString..write(method)..write(SignParameters.NEW_LINE);

        Map<String, String> headers = request.headers;
        Map<String, String> headersToSign = <String, String>{};

        headers.forEach((key, value) { 
if (key == null) {
                   return;
                }

                String lowerKey = key.toLowerCase();
                if (
                  
                  [HttpHeaders.CONTENT_TYPE.toLowerCase(),
                       HttpHeaders.CONTENT_MD5.toLowerCase(),
                       HttpHeaders.DATE.toLowerCase()].contains(lowerKey)
                        || lowerKey.startsWith(OSSHeaders.ossPrefix)) {
                    headersToSign[lowerKey] =value.trim();
                }
        });

      

        if (!headersToSign.containsKey(HttpHeaders.CONTENT_TYPE.toLowerCase())) {
            headersToSign[HttpHeaders.CONTENT_TYPE.toLowerCase()] = "";
        }
        if (!headersToSign.containsKey(HttpHeaders.CONTENT_MD5.toLowerCase())) {
            headersToSign[HttpHeaders.CONTENT_MD5.toLowerCase()] = "";
        }

        // Append all headers to sign to canonical string

        headersToSign.forEach((key, value) {
if (key.startsWith(OSSHeaders.ossPrefix)) {
                canonicalString..write(key)..write(':')..write(value);
            } else {
                canonicalString.write(value);
            }

            canonicalString.write(SignParameters.NEW_LINE);
         });

        // Append canonical resource to canonical string
        canonicalString.write(buildCanonicalizedResource(resourcePath, request.parameters));

        return canonicalString.toString();
    }

     static String buildRtmpCanonicalString(String canonicalizedResource, RequestMessage request,
            String expires) {

        StringBuffer canonicalString = StringBuffer();

        // Append expires
        canonicalString.write(expires + SignParameters.NEW_LINE);

        // Append canonicalized parameters
        request.parameters.forEach((key, value) { 
canonicalString..write(key)..write(':')..write(value);
            canonicalString.write(SignParameters.NEW_LINE);

        });

        // Append canonicalized resource
        canonicalString.write(canonicalizedResource);

        return canonicalString.toString();
    }

     static String buildSignedURL(GeneratePresignedUrlRequest request, Credentials currentCreds, ClientConfiguration config, Uri endpoint) {
        String? bucketName = request.bucketName;
        String accessId = currentCreds.getAccessKeyId();
        String accessKey = currentCreds.getSecretAccessKey();
        bool useSecurityToken = currentCreds.useSecurityToken();
        HttpMethod method = request.getMethod() ?? HttpMethod.get;

        String expires = String.valueOf(request.expiration.getTime() / 1000);
        String? key = request.key;
        String resourcePath = OSSUtils.determineResourcePath(bucketName, key, config.sldEnabled);

        RequestMessage requestMessage = RequestMessage(bucketName, key);
        requestMessage.setEndpoint(OSSUtils.determineFinalEndpoint(endpoint, bucketName, config));
        requestMessage.setMethod(method);
        requestMessage.setResourcePath(resourcePath);
        requestMessage.setHeaders(request.headers);

        requestMessage.addHeader(HttpHeaders.DATE, expires);
        if (request.contentType?.trim().isNotEmpty ?? false){
            requestMessage.addHeader(HttpHeaders.CONTENT_TYPE, request.contentType!);
        }
        if (request.contentMD5?.trim().isNotEmpty ?? false){
            requestMessage.addHeader(HttpHeaders.CONTENT_MD5, request.contentMD5!);
        }
        request.userMetadata.forEach((key, value) {
            requestMessage.addHeader(OSSHeaders.OSS_USER_METADATA_PREFIX + key, value);

         });

        Map<String, String> responseHeaderParams = <String, String>{};
        populateResponseHeaderParameters(responseHeaderParams, request.responseHeaders);
        populateTrafficLimitParams(responseHeaderParams, request.trafficLimit);
        if (responseHeaderParams.isNotEmpty) {
            requestMessage.parameters = responseHeaderParams;
        }

        request.queryParam.forEach((key, value) { 
                requestMessage.addParameter(key, value);

        });

        if (request.process?.trim().isNotEmpty ?? false) {
            requestMessage.addParameter(RequestParameters.SUBRESOURCE_PROCESS, request.process!);

        }


        if (useSecurityToken) {
            requestMessage.addParameter(RequestParameters.SECURITY_TOKEN, currentCreds.getSecurityToken()!);
        }

        String canonicalResource = "/" + (bucketName ?? "") + ((key != null ? "/" + key : ""));
        String canonicalString = buildCanonicalString(method.toString(), canonicalResource, requestMessage,
                expires);
        String signature = ServiceSignature.create().computeSignature(accessKey, canonicalString);

        Map<String, String> params = <String, String>{};
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
            params[RequestParameters.OSS_TRAFFIC_LIMIT] =  '$limit';
        }
    }
}
