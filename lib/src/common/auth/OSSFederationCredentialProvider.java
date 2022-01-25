package com.alibaba.sdk.android.oss.common.auth;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.DateUtil;

/**
 * Created by zhouzhuo on 11/4/15.
 */
 abstract class OSSFederationCredentialProvider implements OSSCredentialProvider {

     volatile OSSFederationToken cachedToken;

    /**
     * Gets the valid STS token. The subclass needs to implement this function.
     *
     * @return The valid STS Token
     */
     abstract OSSFederationToken getFederationToken() throws OSSClientException;

     synchronized OSSFederationToken getValidFederationToken() throws OSSClientException {
        // Checks if the STS token is expired. To avoid returning staled data, here we pre-fetch the token 5 minutes a head of the real expiration.
        // The minimal expiration time is 15 minutes
        if (cachedToken == null
                || DateUtil.getFixedSkewedTimeMillis() / 1000 > cachedToken.getExpiration() - 5 * 60) {

            if (cachedToken != null) {
                OSSLog.logDebug("token expired! current time: " + DateUtil.getFixedSkewedTimeMillis() / 1000 + " token expired: " + cachedToken.getExpiration());
            }
            cachedToken = getFederationToken();
        }

        return cachedToken;
    }

     OSSFederationToken getCachedToken() {
        return cachedToken;
    }
}
