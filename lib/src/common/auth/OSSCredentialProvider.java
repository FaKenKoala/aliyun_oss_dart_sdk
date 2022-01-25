package com.alibaba.sdk.android.oss.common.auth;

import com.alibaba.sdk.android.oss.OSSClientException;

/**
 * Created by zhouzhuo on 11/4/15.
 */
 abstract class OSSCredentialProvider {

    /**
     * get OSSFederationToken instance
     *
     * @return
     */
    OSSFederationToken getFederationToken() throws OSSClientException;
}
