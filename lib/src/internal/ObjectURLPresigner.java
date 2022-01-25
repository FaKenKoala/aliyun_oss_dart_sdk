package com.alibaba.sdk.android.oss.internal;

import android.text.TextUtils;

import com.alibaba.sdk.android.oss.ClientConfiguration;
import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.common.HttpMethod;
import com.alibaba.sdk.android.oss.common.OSSConstants;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.RequestParameters;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSCustomSignerCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSFederationCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSFederationToken;
import com.alibaba.sdk.android.oss.common.auth.OSSPlainTextAKSKCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSStsTokenCredentialProvider;
import com.alibaba.sdk.android.oss.common.utils.DateUtil;
import com.alibaba.sdk.android.oss.common.utils.HttpHeaders;
import com.alibaba.sdk.android.oss.common.utils.HttpUtil;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.model.GeneratePresignedUrlRequest;

import java.net.URI;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Created by zhouzhuo on 11/29/15.
 */
 class ObjectURLPresigner {

     URI endpoint;
     OSSCredentialProvider credentialProvider;
     ClientConfiguration conf;

     ObjectURLPresigner(URI endpoint, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        this.endpoint = endpoint;
        this.credentialProvider = credentialProvider;
        this.conf = conf;
    }

     String presignConstrainedURL(GeneratePresignedUrlRequest request)  {

        String bucketName = request.getBucketName();
        String objectKey = request.getKey();
        String expires = String.valueOf(DateUtil.getFixedSkewedTimeMillis() / 1000 + request.getExpiration());
        HttpMethod method = request.getMethod() != null ? request.getMethod() : HttpMethod.GET;

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(method);
        requestMessage.setBucketName(bucketName);
        requestMessage.setObjectKey(objectKey);

        requestMessage.getHeaders()[HttpHeaders.DATE] = expires;

        if (request.getContentType() != null && !request.getContentType().trim().equals("")) {
            requestMessage.getHeaders()[HttpHeaders.CONTENT_TYPE] = request.getContentType();
        }
        if (request.getContentMD5() != null && !request.getContentMD5().trim().equals("")) {
            requestMessage.getHeaders()[HttpHeaders.CONTENT_MD5] = request.getContentMD5();
        }

        if (request.getQueryParameter() != null && request.getQueryParameter().size() > 0) {
            for (Map.Entry<String, String> entry : request.getQueryParameter().entrySet()) {
                requestMessage.getParameters()[entry.getKey()] = entry.getValue();
            }
        }
        //process img
        if (request.getProcess() != null && !request.getProcess().trim().equals("")) {
            requestMessage.getParameters()[RequestParameters.X_OSS_PROCESS] = request.getProcess();
        }

        OSSFederationToken token = null;

        if (credentialProvider instanceof OSSFederationCredentialProvider) {
            token = ((OSSFederationCredentialProvider) credentialProvider).getValidFederationToken();
            requestMessage.getParameters()[RequestParameters.SECURITY_TOKEN] = token.getSecurityToken();
            if (token == null) {
                throw OSSClientException("Can not get a federation token!");
            }
        } else if (credentialProvider instanceof OSSStsTokenCredentialProvider) {
            token = ((OSSStsTokenCredentialProvider) credentialProvider).getFederationToken();
            requestMessage.getParameters()[RequestParameters.SECURITY_TOKEN] = token.getSecurityToken();
        }

        String contentToSign = OSSUtils.buildCanonicalString(requestMessage);

        String signature;

        if (credentialProvider instanceof OSSFederationCredentialProvider
                || credentialProvider instanceof OSSStsTokenCredentialProvider) {
            signature = OSSUtils.sign(token.getTempAK(), token.getTempSK(), contentToSign);
        } else if (credentialProvider instanceof OSSPlainTextAKSKCredentialProvider) {
            signature = OSSUtils.sign(((OSSPlainTextAKSKCredentialProvider) credentialProvider).getAccessKeyId(),
                    ((OSSPlainTextAKSKCredentialProvider) credentialProvider).getAccessKeySecret(), contentToSign);
        } else if (credentialProvider instanceof OSSCustomSignerCredentialProvider) {
            signature = ((OSSCustomSignerCredentialProvider) credentialProvider).signContent(contentToSign);
        } else {
            throw OSSClientException("Unknown credentialProvider!");
        }

        String accessKey = signature.split(":")[0].substring(4);
        signature = signature.split(":")[1];

        String host = buildCanonicalHost(endpoint, bucketName, conf);

        Map<String, String> params = LinkedHashMap<String, String>();
        params[HttpHeaders.EXPIRES] = expires;
        params[RequestParameters.OSS_ACCESS_KEY_ID] = accessKey;
        params[RequestParameters.SIGNATURE] = signature;
        params.putAll(requestMessage.getParameters());
        String queryString = HttpUtil.paramToQueryString(params, "utf-8");

        String url = endpoint.getScheme() + "://" + host + "/" + HttpUtil.urlEncode(objectKey, OSSConstants.defaultCharsetName)
                + "?" + queryString;

        return url;
    }

     String presignConstrainedURL(String bucketName, String objectKey, int expiredTimeInSeconds)
             {
        GeneratePresignedUrlRequest presignedUrlRequest = GeneratePresignedUrlRequest(bucketName, objectKey);
        presignedUrlRequest.setExpiration(expiredTimeInSeconds);
        return presignConstrainedURL(presignedUrlRequest);
    }

     String presignURL(String bucketName, String objectKey) {
        String host = buildCanonicalHost(endpoint, bucketName, conf);
        return endpoint.getScheme() + "://" + host + "/" + HttpUtil.urlEncode(objectKey, OSSConstants.defaultCharsetName);
    }

     String buildCanonicalHost(URI endpoint, String bucketName, ClientConfiguration config) {
        String originHost = endpoint.getHost();
        String portString = null;
        String path = endpoint.getPath();

        int port = endpoint.getPort();
        if (port != -1) {
            portString = String.valueOf(port);
        }

        bool isPathStyle = false;

        String host = originHost;
        if(portString).notNullOrEmpty{
            host += (":" + portString);
        }

        if (bucketName).notNullOrEmpty {
            if (OSSUtils.isOssOriginHost(originHost)) {
                // official endpoint
                host = bucketName + "." + originHost;
            } else if (OSSUtils.isInCustomCnameExcludeList(originHost, config.getCustomCnameExcludeList())) {
                if (config.isPathStyleAccessEnable()) {
                    isPathStyle = true;
                } else {
                    host = bucketName + "." + originHost;
                }
            } else {
                try {
                    if (OSSUtils.isValidateIP(originHost)) {
                        // ip address
                        isPathStyle = true;
                    }
                } catch ( e) {
                    e.printStackTrace();
                }
            }
        }

        if (config.isCustomPathPrefixEnable() && path != null) {
            host += path;
        }

        if (isPathStyle) {
            host += ("/" + bucketName);
        }

        return host;
    }
}
