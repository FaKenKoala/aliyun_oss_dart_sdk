 import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/common/auth/hmac_sha1_signature.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_federation_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_federation_token.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_constants.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/model/copy_object_request.dart';

import 'http_util.dart';

class OSSUtils {

     static final String _newLine = "\n";

     static final List<String> signedParameters = [
            subresourceBucketinfo, subresourceAcl, subresourceUploads, subresourceLocation,
            subresourceCors, subresourceLogging, subresourceWebsite,
            subresourceReferer, subresourceLifecycle, subresourceDelete,
            subresourceAppend, uploadId, partNumber, securityToken, position,
            responseHeaderCacheControl, responseHeaderContentDisposition,
            responseHeaderContentEncoding, responseHeaderContentLanguage,
            responseHeaderContentType, responseHeaderExpires, xOssProcess,
            subresourceSequential, xOssSymlink, xOssRestore,
     ];

    /// Populate metadata to headers.
     static void populateRequestMetadata(Map<String, String> headers, ObjectMetadata metadata) {
        if (metadata == null) {
            return;
        }

        Map<String, Object> rawMetadata = metadata.getRawMetadata();
        if (rawMetadata != null) {
            for (Map.Entry<String, Object> entry : rawMetadata.entrySet()) {
                headers[entry.getKey()] = entry.getValue().toString();
            }
        }

        Map<String, String> userMetadata = metadata.getUserMetadata();
        if (userMetadata != null) {
            for (Map.Entry<String, String> entry : userMetadata.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (key != null) key = key.trim();
                if (value != null) value = value.trim();
                headers[key] = value;
            }
        }
    }

     static void populateListBucketRequestParameters(ListBucketsRequest listBucketsRequest,
                                                           Map<String, String> params) {
        if (listBucketsRequest.getPrefix() != null) {
            params[PREFIX] = listBucketsRequest.getPrefix();
        }

        if (listBucketsRequest.getMarker() != null) {
            params[MARKER] = listBucketsRequest.getMarker();
        }

        if (listBucketsRequest.getMaxKeys() != null) {
            params[MAXKEYS] = Integer.toString(listBucketsRequest.getMaxKeys());
        }
    }

     static void populateListObjectsRequestParameters(ListObjectsRequest listObjectsRequest,
                                                            Map<String, String> params) {

        if (listObjectsRequest.getPrefix() != null) {
            params[PREFIX] = listObjectsRequest.getPrefix();
        }

        if (listObjectsRequest.getMarker() != null) {
            params[MARKER] = listObjectsRequest.getMarker();
        }

        if (listObjectsRequest.getDelimiter() != null) {
            params[DELIMITER] = listObjectsRequest.getDelimiter();
        }

        if (listObjectsRequest.getMaxKeys() != null) {
            params[MAXKEYS] = Integer.toString(listObjectsRequest.getMaxKeys());
        }

        if (listObjectsRequest.getEncodingType() != null) {
            params[ENCODINGTYPE] = listObjectsRequest.getEncodingType();
        }
    }

     static void populateListMultipartUploadsRequestParameters(ListMultipartUploadsRequest request,
                                                                     Map<String, String> params) {

        if (request.getDelimiter() != null) {
            params[DELIMITER] = request.getDelimiter();
        }

        if (request.getMaxUploads() != null) {
            params[MAXUPLOADS] = Integer.toString(request.getMaxUploads());
        }

        if (request.getKeyMarker() != null) {
            params[KEYMARKER] = request.getKeyMarker();
        }

        if (request.getPrefix() != null) {
            params[PREFIX] = request.getPrefix();
        }

        if (request.getUploadIdMarker() != null) {
            params[UPLOADIDMARKER] = request.getUploadIdMarker();
        }

        if (request.getEncodingType() != null) {
            params[ENCODINGTYPE] = request.getEncodingType();
        }
    }

     static bool checkParamRange(int param, int from, bool leftInclusive,
                                          int to, bool rightInclusive) {
        if (leftInclusive && rightInclusive) {    // [from, to]
            if (from <= param && param <= to) {
                return true;
            } else {
                return false;
            }
        } else if (leftInclusive && !rightInclusive) {  // [from, to)
            if (from <= param && param < to) {
                return true;
            } else {
                return false;
            }
        } else if (!leftInclusive && !rightInclusive) {    // (from, to)
            if (from < param && param < to) {
                return true;
            } else {
                return false;
            }
        } else {     // (from, to]
            if (from < param && param <= to) {
                return true;
            } else {
                return false;
            }
        }
    }

     static void populateCopyObjectHeaders(CopyObjectRequest copyObjectRequest,
                                                 Map<String, String> headers) {
        String copySourceHeader = "/" + copyObjectRequest.getSourceBucketName() + "/"
                + HttpUtil.urlEncode(copyObjectRequest.getSourceKey(), OSSConstants.defaultCharsetName);
        headers[OSSHeaders.COPYOBJECTSOURCE] = copySourceHeader;

        addDateHeader(headers,
                OSSHeaders.COPYOBJECTSOURCEIFMODIFIEDSINCE,
                copyObjectRequest.getModifiedSinceConstraint());
        addDateHeader(headers,
                OSSHeaders.COPYOBJECTSOURCEIFUNMODIFIEDSINCE,
                copyObjectRequest.getUnmodifiedSinceConstraint());

        addStringListHeader(headers,
                OSSHeaders.COPYOBJECTSOURCEIFMATCH,
                copyObjectRequest.getMatchingETagConstraints());
        addStringListHeader(headers,
                OSSHeaders.COPYOBJECTSOURCEIFNONEMATCH,
                copyObjectRequest.getNonmatchingEtagConstraints());

        addHeader(headers,
                OSSHeaders.OSSSERVERSIDEENCRYPTION,
                copyObjectRequest.getServerSideEncryption());

        ObjectMetadata newObjectMetadata = copyObjectRequest.getNewObjectMetadata();
        if (newObjectMetadata != null) {
            headers[OSSHeaders.COPYOBJECTMETADATADIRECTIVE] = MetadataDirective.REPLACE.toString();
            populateRequestMetadata(headers, newObjectMetadata);
        }

        // The header of Content-Length should not be specified on copying an object.
        removeHeader(headers, HttpHeaders.CONTENTLENGTH);
    }

     static String buildXMLFromPartEtagList(List<PartETag> partETagList) {
        StringBuffer builder = StringBuffer();
        builder.write("<CompleteMultipartUpload>\n");
        for (PartETag partETag : partETagList) {
            builder.write("<Part>\n");
            builder.write("<PartNumber>" + partETag.getPartNumber() + "</PartNumber>\n");
            builder.write("<ETag>" + partETag.getETag() + "</ETag>\n");
            builder.write("</Part>\n");
        }
        builder.write("</CompleteMultipartUpload>\n");
        return builder.toString();
    }

     static void addHeader(Map<String, String> headers, String header, String value) {
        if (value != null) {
            headers[header] = value;
        }
    }

     static void addDateHeader(Map<String, String> headers, String header, Date value) {
        if (value != null) {
            headers[header] = DateUtil.formatRfc822Date(value);
        }
    }

     static void addStringListHeader(Map<String, String> headers, String header,
                                           List<String> values) {
        if (values != null && !values.isEmpty()) {
            headers[header] = join(values);
        }
    }

     static void removeHeader(Map<String, String> headers, String header) {
        if (header != null && headers.containsKey(header)) {
            headers.remove(header);
        }
    }

     static String join(List<String> strings) {
        StringBuffer result = StringBuffer();

        bool first = true;
        for (String s : strings) {
            if (!first) result.write(", ");

            result.write(s);
            first = false;
        }

        return result.toString();
    }

    /// 判断一个字符串是否为空
    ///
    /// @param str
    /// @return
     static bool isEmptyString(String? str) {
        return str?.isEmpty??true;
    }

     static String buildCanonicalString(RequestMessage request) {

        StringBuffer canonicalString = StringBuffer();
        canonicalString.write(request.getMethod().toString() + _newLine);

        Map<String, String> headers = request.getHeaders();
        TreeMap<String, String> headersToSign = TreeMap<String, String>();

        if (headers != null) {
            for (Map.Entry<String, String> header : headers.entrySet()) {
                if (header.getKey() == null) {
                    continue;
                }

                String lowerKey = header.getKey().toLowerCase();
                if (lowerKey.equals(HttpHeaders.CONTENTTYPE.toLowerCase()) ||
                        lowerKey.equals(HttpHeaders.CONTENTMD5.toLowerCase()) ||
                        lowerKey.equals(HttpHeaders.DATE.toLowerCase()) ||
                        lowerKey.startsWith(OSSHeaders.OSSPREFIX)) {
                    headersToSign[lowerKey] = header.getValue().trim();
                }
            }
        }

        if (!headersToSign.containsKey(HttpHeaders.CONTENTTYPE.toLowerCase())) {
            headersToSign[HttpHeaders.CONTENTTYPE.toLowerCase()] = "";
        }
        if (!headersToSign.containsKey(HttpHeaders.CONTENTMD5.toLowerCase())) {
            headersToSign[HttpHeaders.CONTENTMD5.toLowerCase()] = "";
        }

        // Append all headers to sign to canonical string
        for (Map.Entry<String, String> entry : headersToSign.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            if (key.startsWith(OSSHeaders.OSSPREFIX)) {
                canonicalString.write(key).write(':').write(value);
            } else {
                canonicalString.write(value);
            }

            canonicalString.write(_newLine);
        }

        // Append canonical resource to canonical string
        canonicalString.write(buildCanonicalizedResource(request.getBucketName(), request.getObjectKey(), request.getParameters()));

        return canonicalString.toString();
    }

     static String buildCanonicalizedResource(String? bucketName, String? objectKey, Map<String, String>? parameters) {
        String resourcePath;
        if (bucketName == null && objectKey == null) {
            resourcePath = "/";
        } else if (objectKey == null) {
            resourcePath = "/$bucketName/";
        } else {
            resourcePath = "/$bucketName/$objectKey";
        }

        return buildCanonicalizedResourceWithPath(resourcePath, parameters);
    }

     static String buildCanonicalizedResourceWithPath(String resourcePath, Map<String, String>? parameters) {

        StringBuffer builder = StringBuffer();
        builder.write(resourcePath);

        if (parameters != null) {
            List<String> parameterNames = parameters.keys.toList()..sort();

            String separater = '?';
            for (String paramName in parameterNames) {
                if (!signedParameters.contains(paramName)) {
                    continue;
                }

                builder.write(separater);
                builder.write(paramName);
                String? paramValue = parameters[paramName];
                if (paramValue.notNullOrEmpty) {
                    builder..write("=")..write(paramValue);
                }

                separater = '&';
            }
        }

        return builder.toString();
    }

    /// Encode request parameters to URL segment.
     static String? paramToQueryString(Map<String, String>? params) {

        if (params == null || params.isEmpty) {
            return null;
        }

        StringBuffer paramString = StringBuffer();
        bool first = true;
        params.forEach((key, value) { 
if (!first) {
                paramString.write("&");
            }

            // Urlencode each request parameter
            paramString.write(HttpUtil.urlEncode(key));
            if (value.notNullOrEmpty) {
                paramString..write("=")..write(HttpUtil.urlEncode(value));
            }

            first = false;
        });

        return paramString.toString();
    }

     static String populateMapToBase64JsonString(Map<String, String> map) {
        JSONObject jsonObj = JSONObject(map);
        return base64.encodeToString(jsonObj.toString().getBytes(), base64.NOWRAP);
    }

    /// 根据ak/sk、content生成token
    ///
    /// @param accessKey
    /// @param screctKey
    /// @param content
    /// @return
     static String sign(String accessKey, String screctKey, String content) {

        String signature;

        try {
            signature = HmacSHA1Signature().computeSignature(screctKey, content)!;
            signature = signature.trim();
        } catch ( e) {
            throw Exception("Compute signature failed! $e");
        }

        return "OSS " + accessKey + ":" + signature;
    }

     static bool isOssOriginHost(String host){
        if (host.nullOrEmpty){
            return false;
        }
        for (String suffix in OSSConstants.ossOrignHost) {
            if (host.toLowerCase().endsWith(suffix)) {
                return true;
            }
        }
        return false;
    }

    /// 判断一个域名是否是cname
     static bool isCname(String host) {
        for (String suffix in OSSConstants.defaultCnameExcludeList) {
            if (host.toLowerCase().endsWith(suffix)) {
                return false;
            }
        }
        return true;
    }

    /// 判断一个域名是否在自定义Cname排除列表之中
     static bool isInCustomCnameExcludeList(String endpoint, List<String> customCnameExludeList) {
        for (String host in customCnameExludeList) {
            if (endpoint.endsWith(host.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

     static void assertTrue(bool condition, String message) {
        if (!condition) {
            throw ArgumentError(message);
        }
    }

    /// 校验bucketName的合法性
    ///
    /// @param bucketName
    /// @return
     static bool validateBucketName(String? bucketName) {
        if (bucketName == null) {
            return false;
        }
        final String BUCKETNAMEREGX = "^[a-z0-9][a-z0-9\\-]{1,61}[a-z0-9]\$";
        return RegExp(BUCKETNAMEREGX).hasMatch(bucketName);
    }

     static void ensureBucketNameValid(String? bucketName) {
        if (!validateBucketName(bucketName)) {
            throw ArgumentError("The bucket name is invalid. \n" +
                    "A bucket name must: \n" +
                    "1) be comprised of lower-case characters, numbers or dash(-); \n" +
                    "2) start with lower case or numbers; \n" +
                    "3) be between 3-63 characters int. ");
        }
    }

    /// 校验objectKey的合法性
    ///
    /// @param objectKey
    /// @return
     static bool validateObjectKey(String? objectKey) {
        if (objectKey == null) {
            return false;
        }
        if (objectKey.isEmpty || objectKey.length > 1023) {
            return false;
        }
        // List<int> keyBytes;
        // try {
        //     keyBytes = utf8.encode(objectKey);
        // } catch ( e) {
        //     return false;
        // }
        String beginKeyChar = objectKey.substring(0, 1);
        if (beginKeyChar == '/' || beginKeyChar == '\\') {
            return false;
        }
        for (int i = 0; i < objectKey.length; i++) {
          int keyChar = objectKey.codeUnitAt(i);
            if (keyChar != 0x09 && keyChar < 0x20) {
                return false;
            }
        }
        return true;
    }

     static void ensureObjectKeyValid(String? objectKey) {
        if (!validateObjectKey(objectKey)) {
            throw ArgumentError("The object key is invalid. \n" +
                    "An object name should be: \n" +
                    "1) between 1 - 1023 bytes int when encoded as UTF-8 \n" +
                    "2) cannot contain LF or CR or unsupported chars in XML1.0, \n" +
                    "3) cannot begin with \"/\" or \"\\\".");
        }
    }

     static bool doesRequestNeedObjectKey(OSSRequest request) {
        if (request is ListObjectsRequest
                || request is ListBucketsRequest
                || request is CreateBucketRequest
                || request is DeleteBucketRequest
                || request is GetBucketInfoRequest
                || request is GetBucketACLRequest
                || request is DeleteMultipleObjectRequest
                || request is ListMultipartUploadsRequest
                || request is GetBucketRefererRequest
                || request is PutBucketRefererRequest
                || request is PutBucketLoggingRequest
                || request is GetBucketLoggingRequest
                || request is PutBucketLoggingRequest
                || request is GetBucketLoggingRequest
                || request is DeleteBucketLoggingRequest
                || request is PutBucketLifecycleRequest
                || request is GetBucketLifecycleRequest
                || request is DeleteBucketLifecycleRequest) {
            return false;
        } else {
            return true;
        }
    }

     static bool doesBucketNameValid(OSSRequest request) {
        if (request is ListBucketsRequest) {
            return false;
        } else {
            return true;
        }
    }

     static void ensureRequestValid(OSSRequest request, RequestMessage message) {
        if (doesBucketNameValid(request)) {
            ensureBucketNameValid(message.bucketName);
        }
        if (doesRequestNeedObjectKey(request)) {
            ensureObjectKeyValid(message.objectKey);
        }

        if (request is CopyObjectRequest) {
            ensureObjectKeyValid(request.getDestinationKey());
        }
    }

     static String determineContentType(String? initValue, String? srcPath, String? toObjectKey) {
        if (initValue != null) {
            return initValue;
        }

        MimeTypeMap typeMap = MimeTypeMap.getSingleton();
        if (srcPath != null) {
            String extension = srcPath.substring(srcPath.lastIndexOf('.') + 1);
            String? contentType = typeMap.getMimeTypeFromExtension(extension);
            if (contentType != null) {
                return contentType;
            }
        }

        if (toObjectKey != null) {
            String extension = toObjectKey.substring(toObjectKey.lastIndexOf('.') + 1);
            String? contentType = typeMap.getMimeTypeFromExtension(extension);
            if (contentType != null) {
                return contentType;
            }
        }

        return "application/octet-stream";
    }

     static void signRequest(RequestMessage message)  async{
        OSSLog.logDebug("signRequest start");
        if (!message.isAuthorizationRequired()) {
            return;
        } else {
            if (message.credentialProvider == null) {
                throw IllegalStateException("当前CredentialProvider为空！！！"
                        + "\n1. 请检查您是否在初始化OSSService时设置CredentialProvider;"
                        + "\n2. 如果您bucket为公共权限，请确认获取到Bucket后已经调用Bucket中接口声明ACL;");
            }
        }

        OSSCredentialProvider credentialProvider = message.credentialProvider!;
        OSSFederationToken? federationToken;
        if (credentialProvider is OSSFederationCredentialProvider) {
            federationToken =  await credentialProvider.getValidFederationToken();
            if (federationToken == null) {
                OSSLog.logError("Can't get a federation token");
                throw OSSIOException("Can't get a federation token");
            }
            message.getHeaders()[OSSHeaders.OSSSECURITYTOKEN] = federationToken.getSecurityToken();
        } else if (credentialProvider is OSSStsTokenCredentialProvider) {
            federationToken = credentialProvider.getFederationToken();
            message.getHeaders()[OSSHeaders.OSSSECURITYTOKEN] = federationToken.getSecurityToken();
        }

        String contentToSign = OSSUtils.buildCanonicalString(message);
        String signature = "---initValue---";
        OSSLog.logDebug("get contentToSign");
        if (credentialProvider is OSSFederationCredentialProvider ||
                credentialProvider is OSSStsTokenCredentialProvider) {
            signature = OSSUtils.sign(federationToken.getTempAK(), federationToken.getTempSK(), contentToSign);
        } else if (credentialProvider is OSSPlainTextAKSKCredentialProvider) {
            signature = OSSUtils.sign(((OSSPlainTextAKSKCredentialProvider) credentialProvider).getAccessKeyId(),
                    ((OSSPlainTextAKSKCredentialProvider) credentialProvider).getAccessKeySecret(), contentToSign);
        } else if (credentialProvider is OSSCustomSignerCredentialProvider) {
            signature = ((OSSCustomSignerCredentialProvider) credentialProvider).signContent(contentToSign);
        }

//        OSSLog.logDebug("signed content: " + contentToSign.replaceAll("\n", "@") + "   ---------   signature: " + signature);
        OSSLog.logDebug("signed content: " + contentToSign + "   \n ---------   signature: " + signature, false);

        OSSLog.logDebug("get signature");
        message.getHeaders()[OSSHeaders.AUTHORIZATION] = signature;
    }

     static String buildBaseLogInfo(Context context) {
        StringBuffer sb = StringBuffer();
        sb.write("=====[device info]=====\n");
        sb.write("[INFO]: androidVersion：" + Build.VERSION.RELEASE + "\n");
        sb.write("[INFO]: mobileModel：" + Build.MODEL + "\n");
        return sb.toString();
    }

    /// Checks if OSS and SDK's checksum is same. If not, throws InconsistentException.
     static void checkChecksum(int clientChecksum, int serverChecksum, String requestId)  {
        if (clientChecksum != null && serverChecksum != null &&
                !clientChecksum.equals(serverChecksum)) {
            throw InconsistentException(clientChecksum, serverChecksum, requestId);
        }
    }

    /*
     * check is standard ip

     static bool isValidateIP(String addr) {
        if (addr.length() < 7 || addr.length() > 15 || "".equals(addr)) {
            return false;
        }

        //判断IP格式和范围
        String rexp = "([1-9]|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3}";

        Pattern pat = Pattern.compile(rexp);

        Matcher mat = pat.matcher(addr);

        bool ipAddress = mat.find();

        return ipAddress;
    }
    */

    /// *
    /// @param host
    /// @return
     static bool isValidateIP(String? host)  {
        if (host == null) {
            throw Exception("host is null");
        }

        if (Build.VERSION.SDKINT >= Build.VERSIONCODES.Q) {
            return InetAddresses.isNumericAddress(host);
        } else {
            try {
                Class<?> aClass = Class.forName("java.net.InetAddress");
                Method isNumeric = aClass.getMethod("isNumeric", String.class);
                bool isIp = (bool) isNumeric.invoke(null, host);
                return isIp;
            } catch ( e) {
                return false;
            } 
        }
    }

     static String buildTriggerCallbackBody(Map<String, String> callbackParams, Map<String, String> callbackVars) {
        StringBuffer builder = StringBuffer();
        builder.write("x-oss-process=trigger/callback,callback");

        if (callbackParams != null && callbackParams.size() > 0) {
            JSONObject jsonObj = JSONObject(callbackParams);
            String paramsJsonString = base64.encodeToString(jsonObj.toString().getBytes(), base64.NOWRAP);
            builder.write(paramsJsonString);
        }
        builder.write("," + "callback-var");

        if (callbackVars != null && callbackVars.size() > 0) {
            JSONObject jsonObj = JSONObject(callbackVars);
            String varsJsonString = base64.encodeToString(jsonObj.toString().getBytes(), base64.NOWRAP);
            builder.write(varsJsonString);
        }

        return builder.toString();
    }

     static String buildImagePersistentBody(String toBucketName, String toObjectKey, String action) {
        StringBuffer builder = StringBuffer();
        builder.write("x-oss-process=");
        if (action.startsWith("image/")) {
            builder.write(action);
        } else {
            builder.write("image/");
            builder.write(action);
        }
        builder.write("|sys/");
        if (toBucketName.notNullOrEmpty && toObjectKey.notNullOrEmpty) {
          
            String bucketName_base64 = base64.encode(utf8.encode(toBucketName));
            String objectkey_base64 = base64.encode(utf8.encode(toObjectKey));
            builder.write("saveas,o_");
            builder.write(objectkey_base64);
            builder.write(",b_");
            builder.write(bucketName_base64);
        }
        String body = builder.toString();
        OSSLog.logDebug("ImagePersistent body : " + body);
        return body;
    }

    

}

 enum MetadataDirective {

        /* Copy metadata from source object */
        COPY,

        /* Replace metadata with newly metadata */
        REPLACE,

    }