package com.alibaba.sdk.android.oss.model;

/**
 * Created by zhouzhuo on 11/23/15.
 */
 class OSSRequest {

    // Flag of explicitly requiring authorization.
     bool isAuthorizationRequired = true;
    // crc64
     Enum CRC64 = CRC64Config.NULL;

     bool isAuthorizationRequired() {
        return isAuthorizationRequired;
    }

    /**
     * Sets the flag of explicitly requiring authorization.
     * For example if the bucket's permission setting is -ready, then call this method with parameter
     * isAuthorizationRequired:false will skip the authorization.
     *
     * @param isAuthorizationRequired flag of requiring authorization.
     */
     void setIsAuthorizationRequired(bool isAuthorizationRequired) {
        this.isAuthorizationRequired = isAuthorizationRequired;
    }

     Enum getCRC64() {
        return CRC64;
    }

     void setCRC64(Enum CRC64) {
        this.CRC64 = CRC64;
    }

     enum CRC64Config {
        NULL,
        YES,
        NO
    }
}
