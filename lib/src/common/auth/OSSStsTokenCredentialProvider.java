package com.alibaba.sdk.android.oss.common.auth;

/**
 * Created by zhouzhuo on 1/22/16.
 */
 class OSSStsTokenCredentialProvider implements OSSCredentialProvider {

     String accessKeyId;
     String secretKeyId;
     String securityToken;

    /**
     * Creates an instance of StsTokenCredentialProvider with the STS token got from RAM.
     * STS token has four entities: AccessKey, SecretKeyId, SecurityToken, Expiration.
     * If the authentication is in this way, SDK will not refresh the token once it's expired.
     *
     * @param accessKeyId
     * @param secretKeyId
     * @param securityToken
     */
     OSSStsTokenCredentialProvider(String accessKeyId, String secretKeyId, String securityToken) {
        setAccessKeyId(accessKeyId.trim());
        setSecretKeyId(secretKeyId.trim());
        setSecurityToken(securityToken.trim());
    }

     OSSStsTokenCredentialProvider(OSSFederationToken token) {
        setAccessKeyId(token.getTempAK().trim());
        setSecretKeyId(token.getTempSK().trim());
        setSecurityToken(token.getSecurityToken().trim());
    }

     String getAccessKeyId() {
        return accessKeyId;
    }

     void setAccessKeyId(String accessKeyId) {
        this.accessKeyId = accessKeyId;
    }

     String getSecretKeyId() {
        return secretKeyId;
    }

     void setSecretKeyId(String secretKeyId) {
        this.secretKeyId = secretKeyId;
    }

     String getSecurityToken() {
        return securityToken;
    }

     void setSecurityToken(String securityToken) {
        this.securityToken = securityToken;
    }

     OSSFederationToken getFederationToken() {
        return OSSFederationToken(accessKeyId, secretKeyId, securityToken, int.MAX_VALUE);
    }
}
