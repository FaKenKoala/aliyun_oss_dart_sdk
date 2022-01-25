package com.alibaba.sdk.android.oss.internal;

import android.net.Uri;
import android.text.TextUtils;

import com.alibaba.sdk.android.oss.common.HttpMethod;
import com.alibaba.sdk.android.oss.common.OSSConstants;
import com.alibaba.sdk.android.oss.common.OSSHeaders;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.utils.HttpUtil;
import com.alibaba.sdk.android.oss.common.utils.HttpdnsMini;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.model.BucketLifecycleRule;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by zhouzhuo on 11/22/15.
 */
 class RequestMessage extends HttpMessage {

     URI service;
     URI endpoint;
     String bucketName;
     String objectKey;
     HttpMethod method;
     bool isAuthorizationRequired = true;
     Map<String, String> parameters = LinkedHashMap<String, String>();
     bool checkCRC64;
     OSSCredentialProvider credentialProvider;
     bool httpDnsEnable = false;
     bool pathStyleAccessEnable = false;
     bool customPathPrefixEnable = false;
     String ipWithHeader;
     bool isInCustomCnameExcludeList = false;

     String uploadFilePath;
     List<int> uploadData;
     Uri uploadUri;

     HttpMethod getMethod() {
        return method;
    }

     void setMethod(HttpMethod method) {
        this.method = method;
    }

     OSSCredentialProvider getCredentialProvider() {
        return credentialProvider;
    }

     void setCredentialProvider(OSSCredentialProvider credentialProvider) {
        this.credentialProvider = credentialProvider;
    }

     URI getService() {
        return service;
    }

     void setService(URI service) {
        this.service = service;
    }

     URI getEndpoint() {
        return endpoint;
    }

     void setEndpoint(URI endpoint) {
        this.endpoint = endpoint;
    }

     bool isHttpDnsEnable() {
        return httpDnsEnable;
    }

     void setHttpDnsEnable(bool httpDnsEnable) {
        this.httpDnsEnable = httpDnsEnable;
    }

     String getBucketName() {
        return bucketName;
    }

     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     String getObjectKey() {
        return objectKey;
    }

     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

     Map<String, String> getParameters() {
        return parameters;
    }

     void setParameters(Map<String, String> parameters) {
        this.parameters = parameters;
    }

     String getUploadFilePath() {
        return uploadFilePath;
    }

     void setUploadFilePath(String uploadFilePath) {
        this.uploadFilePath = uploadFilePath;
    }

     List<int> getUploadData() {
        return uploadData;
    }

     void setUploadData(List<int> uploadData) {
        this.uploadData = uploadData;
    }

     Uri getUploadUri() {
        return uploadUri;
    }

     void setUploadUri(Uri uploadUri) {
        this.uploadUri = uploadUri;
    }

     bool isAuthorizationRequired() {
        return isAuthorizationRequired;
    }

     void setIsAuthorizationRequired(bool isAuthorizationRequired) {
        this.isAuthorizationRequired = isAuthorizationRequired;
    }

     bool isInCustomCnameExcludeList() {
        return isInCustomCnameExcludeList;
    }

     void setIsInCustomCnameExcludeList(bool isInExcludeCnameList) {
        this.isInCustomCnameExcludeList = isInExcludeCnameList;
    }

     bool isCheckCRC64() {
        return checkCRC64;
    }

     void setCheckCRC64(bool checkCRC64) {
        this.checkCRC64 = checkCRC64;
    }

     String getIpWithHeader() {
        return ipWithHeader;
    }

     void setIpWithHeader(String ipWithHeader) {
        this.ipWithHeader = ipWithHeader;
    }

     bool isPathStyleAccessEnable() {
        return pathStyleAccessEnable;
    }

     void setPathStyleAccessEnable(bool pathStyleAccessEnable) {
        this.pathStyleAccessEnable = pathStyleAccessEnable;
    }

     bool isCustomPathPrefixEnable() {
        return customPathPrefixEnable;
    }

     void setCustomPathPrefixEnable(bool customPathPrefixEnable) {
        this.customPathPrefixEnable = customPathPrefixEnable;
    }

     void createBucketRequestBodyMarshall(Map<String, String> configures)  {
        StringBuffer xmlBody = StringBuffer();
        if (configures != null) {
            xmlBody.write("<CreateBucketConfiguration>");
            for (Map.Entry<String, String> entry : configures.entrySet()) {
                xmlBody.write("<" + entry.getKey() + ">" + entry.getValue() + "</" + entry.getKey() + ">");
            }
            xmlBody.write("</CreateBucketConfiguration>");
            List<int> binaryData = xmlBody.toString().getBytes(OSSConstants.defaultCharsetName);
            int length = binaryData.length;
            InputStream inStream = ByteArrayInputStream(binaryData);
            setContent(inStream);
            setContentLength(length);
        }
    }

     void putBucketRefererRequestBodyMarshall(ArrayList<String> referers, bool allowEmpty)  {
        StringBuffer xmlBody = StringBuffer();
        xmlBody.write("<RefererConfiguration>");
        xmlBody.write("<AllowEmptyReferer>" + (allowEmpty ? "true" : "false") + "</AllowEmptyReferer>");
        if (referers != null && referers.size() > 0) {
            xmlBody.write("<RefererList>");
            for (String referer : referers) {
                xmlBody.write("<Referer>" + referer + "</Referer>");
            }
            xmlBody.write("</RefererList>");
        }
        xmlBody.write("</RefererConfiguration>");

        List<int> binaryData = xmlBody.toString().getBytes(OSSConstants.defaultCharsetName);
        int length = binaryData.length;
        InputStream inStream = ByteArrayInputStream(binaryData);
        setContent(inStream);
        setContentLength(length);
    }

     void putBucketLoggingRequestBodyMarshall(String targetBucketName, String targetPrefix)  {
        StringBuffer xmlBody = StringBuffer();
        xmlBody.write("<BucketLoggingStatus>");
        if (targetBucketName != null) {
            xmlBody.write("<LoggingEnabled><TargetBucket>" + targetBucketName + "</TargetBucket>");
            if (targetPrefix != null) {
                xmlBody.write("<TargetPrefix>" + targetPrefix + "</TargetPrefix>");
            }
            xmlBody.write("</LoggingEnabled>");
        }

        xmlBody.write("</BucketLoggingStatus>");

        List<int> binaryData = xmlBody.toString().getBytes(OSSConstants.defaultCharsetName);
        int length = binaryData.length;
        InputStream inStream = ByteArrayInputStream(binaryData);
        setContent(inStream);
        setContentLength(length);
    }

     void putBucketLifecycleRequestBodyMarshall(ArrayList<BucketLifecycleRule> lifecycleRules)  {
        StringBuffer xmlBody = StringBuffer();
        xmlBody.write("<LifecycleConfiguration>");
        for (BucketLifecycleRule rule : lifecycleRules) {
            xmlBody.write("<Rule>");
            if (rule.getIdentifier() != null) {
                xmlBody.write("<ID>" + rule.getIdentifier() + "</ID>");
            }
            if (rule.getPrefix() != null) {
                xmlBody.write("<Prefix>" + rule.getPrefix() + "</Prefix>");
            }
            xmlBody.write("<Status>" + (rule.getStatus() ? "Enabled": "Disabled") + "</Status>");
            if (rule.getDays() != null) {
                xmlBody.write("<Days>" + rule.getDays() + "</Days>");
            } else if (rule.getExpireDate() != null) {
                xmlBody.write("<Date>" + rule.getExpireDate() + "</Date>");
            }

            if (rule.getMultipartDays() != null) {
                xmlBody.write("<AbortMultipartUpload><Days>" + rule.getMultipartDays() + "</Days></AbortMultipartUpload>");
            } else if (rule.getMultipartExpireDate() != null) {
                xmlBody.write("<AbortMultipartUpload><Date>" + rule.getMultipartDays() + "</Date></AbortMultipartUpload>");
            }

            if (rule.getIADays() != null) {
                xmlBody.write("<Transition><Days>" + rule.getIADays() + "</Days><StorageClass>IA</StorageClass></Transition>");
            } else if (rule.getIAExpireDate() != null) {
                xmlBody.write("<Transition><Date>" + rule.getIAExpireDate() + "</Date><StorageClass>IA</StorageClass></Transition>");
            } else if (rule.getArchiveDays() != null) {
                xmlBody.write("<Transition><Days>" + rule.getArchiveDays() + "</Days><StorageClass>Archive</StorageClass></Transition>");
            } else if (rule.getArchiveExpireDate() != null) {
                xmlBody.write("<Transition><Date>" + rule.getArchiveExpireDate() + "</Date><StorageClass>Archive</StorageClass></Transition>");
            }

            xmlBody.write("</Rule>");
        }

        xmlBody.write("</LifecycleConfiguration>");

        List<int> binaryData = xmlBody.toString().getBytes(OSSConstants.defaultCharsetName);
        int length = binaryData.length;
        InputStream inStream = ByteArrayInputStream(binaryData);
        setContent(inStream);
        setContentLength(length);
    }

     List<int> deleteMultipleObjectRequestBodyMarshall(List<String> objectKeys, bool isQuiet)  {
        StringBuffer xmlBody = StringBuffer();
        xmlBody.write("<Delete>");
        if (isQuiet) {
            xmlBody.write("<Quiet>true</Quiet>");
        } else {
            xmlBody.write("<Quiet>false</Quiet>");
        }
        for (String key : objectKeys) {
            xmlBody.write("<Object>");
            xmlBody.write("<Key>").write(key).write("</Key>");
            xmlBody.write("</Object>");
        }
        xmlBody.write("</Delete>");
        List<int> binaryData = xmlBody.toString().getBytes(OSSConstants.defaultCharsetName);
        int length = binaryData.length;
        InputStream inStream = ByteArrayInputStream(binaryData);
        setContent(inStream);
        setContentLength(length);
        return binaryData;
    }

     String buildOSSServiceURL() {
        OSSUtils.assertTrue(service != null, "Service haven't been set!");
        String originHost = service.getHost();
        String scheme = service.getScheme();

        String urlHost = null;
        if (isHttpDnsEnable() && scheme.equalsIgnoreCase("http")) {
            urlHost = HttpdnsMini.getInstance().getIpByHostAsync(originHost);
        } else {
            OSSLog.logDebug("[buildOSSServiceURL], disable httpdns or http is not need httpdns");
        }
        if (urlHost == null) {
            urlHost = originHost;
        }

        getHeaders()[OSSHeaders.HOST] = originHost;

        String baseURL = scheme + "://" + urlHost;
        String queryString = OSSUtils.paramToQueryString(this.parameters, OSSConstants.defaultCharsetName);

        if (OSSUtils.isEmptyString(queryString)) {
            return baseURL;
        } else {
            return baseURL + "?" + queryString;
        }
    }

     String buildCanonicalURL()  {
        OSSUtils.assertTrue(endpoint != null, "Endpoint haven't been set!");

        String scheme = endpoint.getScheme();
        String originHost = endpoint.getHost();
        String portString = null;
        String path = endpoint.getPath();

        int port = endpoint.getPort();
        if (port != -1) {
            portString = String.valueOf(port);
        }

        if (TextUtils.isEmpty(originHost)){
            String url = endpoint.toString();
            OSSLog.logDebug("endpoint url : " + url);
//            originHost = url.substring((scheme + "://").length(),url.length());
        }

        OSSLog.logDebug(" scheme : " + scheme);
        OSSLog.logDebug(" originHost : " + originHost);
        OSSLog.logDebug(" port : " + portString);

        bool isPathStyle = false;

        String baseURL = scheme + "://" + originHost;
        if(!TextUtils.isEmpty(portString)){
            baseURL += (":" + portString);
        }

        if (!TextUtils.isEmpty(bucketName)) {
            if (OSSUtils.isOssOriginHost(originHost)) {
                // official endpoint
                originHost = bucketName + "." + originHost;
                String urlHost = null;
                if (isHttpDnsEnable()) {
                    urlHost = HttpdnsMini.getInstance().getIpByHostAsync(originHost);
                } else {
                    OSSLog.logDebug("[buildCannonicalURL], disable httpdns");
                }
                addHeader(OSSHeaders.HOST, originHost);

                if (!TextUtils.isEmpty(urlHost)) {
                    baseURL = scheme + "://" + urlHost;
                } else {
                    baseURL = scheme + "://" + originHost;
                }
            } else if (isInCustomCnameExcludeList) {
                if (pathStyleAccessEnable) {
                    isPathStyle = true;
                } else {
                    baseURL = scheme + "://" + bucketName + "." + originHost;
                }
            } else if (OSSUtils.isValidateIP(originHost)) {
                // ip address
                if (OSSUtils.isEmptyString(ipWithHeader)) {
                    isPathStyle = true;
                } else {
                    addHeader(OSSHeaders.HOST, getIpWithHeader());
                }
            }
        }

        if (customPathPrefixEnable && path != null) {
            baseURL += path;
        }

        if (isPathStyle) {
            baseURL += ("/" + bucketName);
        }

        if (!TextUtils.isEmpty(objectKey)) {
            baseURL += "/" + HttpUtil.urlEncode(objectKey, OSSConstants.defaultCharsetName);
        }

        String queryString = OSSUtils.paramToQueryString(this.parameters, OSSConstants.defaultCharsetName);

        //输入请求信息日志
        StringBuffer printReq = StringBuffer();
        printReq.write("request---------------------\n");
        printReq.write("request url=" + baseURL + "\n");
        printReq.write("request params=" + queryString + "\n");
        for (String key : getHeaders().keySet()) {
            printReq.write("requestHeader [" + key + "]: ").write(getHeaders().get(key) + "\n");
        }
        OSSLog.logDebug(printReq.toString());

        if (OSSUtils.isEmptyString(queryString)) {
            return baseURL;
        } else {
            return baseURL + "?" + queryString;
        }
    }
}
