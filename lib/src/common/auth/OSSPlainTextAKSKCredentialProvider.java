package com.alibaba.sdk.android.oss.common.auth;

/**
 * Created by zhouzhuo on 11/4/15.
 * Edited by zhuoqin on 7/12/17.
 * Mobile devices are not the trusted environment. It's very risky to save the AccessKeyId and AccessKeySecret in mobile devices for accessing OSS.
 * We recommend to use STS authentication or custom authentication.
 */
@Deprecated
 class OSSPlainTextAKSKCredentialProvider implements OSSCredentialProvider {
     String accessKeyId;
     String accessKeySecret;

    /**
     * 用阿里云提供的AccessKeyId， AccessKeySecret构造一个凭证提供器
     *
     * @param accessKeyId
     * @param accessKeySecret
     */
     OSSPlainTextAKSKCredentialProvider(String accessKeyId, String accessKeySecret) {
        setAccessKeyId(accessKeyId.trim());
        setAccessKeySecret(accessKeySecret.trim());
    }

     String getAccessKeyId() {
        return accessKeyId;
    }

     void setAccessKeyId(String accessKeyId) {
        this.accessKeyId = accessKeyId;
    }

     String getAccessKeySecret() {
        return accessKeySecret;
    }

     void setAccessKeySecret(String accessKeySecret) {
        this.accessKeySecret = accessKeySecret;
    }

    @override
     OSSFederationToken getFederationToken() {
        return null;
    }
}
