package com.alibaba.sdk.android.oss.common.auth;


import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.DateUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
 * @author zhouzhuo
 *         Mar 26, 2015
 */
 class OSSFederationToken {
     String tempAk;
     String tempSk;
     String securityToken;
     int expiration;

    /**
     * Creates a new instance of OSSFederationToken
     *
     * @param tempAK        AccessKeyId returned from STS
     * @param tempSK        AccessKeySecret returned from STS
     * @param securityToken SecurityToken returned from STS
     * @param expiration    The expiration time in seconds from STS, in the Unix Epoch format.
     */
     OSSFederationToken(String tempAK, String tempSK, String securityToken, int expiration) {
        setTempAk(tempAK);
        setTempSk(tempSK);
        setSecurityToken(securityToken);
        this.setExpiration(expiration);
    }

    /**
     * Creates a new instance of OSSFederationToken
     *
     * @param tempAK                AccessKeyId returned from STS
     * @param tempSK                AccessKeySecret returned from STS
     * @param securityToken         SecurityToken returned from STS
     * @param expirationInGMTFormat The expiration time in seconds from STS, in the GMT format.
     */
     OSSFederationToken(String tempAK, String tempSK, String securityToken, String expirationInGMTFormat) {
        setTempAk(tempAK);
        setTempSk(tempSK);
        setSecurityToken(securityToken);
        setExpirationInGMTFormat(expirationInGMTFormat);
    }

    @override
     String toString() {
        return "OSSFederationToken [tempAk=" + tempAk + ", tempSk=" + tempSk + ", securityToken="
                + securityToken + ", expiration=" + expiration + "]";
    }

     String getTempAK() {
        return tempAk;
    }

     String getTempSK() {
        return tempSk;
    }

     String getSecurityToken() {
        return securityToken;
    }

     void setSecurityToken(String securityToken) {
        this.securityToken = securityToken;
    }

     void setTempAk(String tempAk) {
        this.tempAk = tempAk;
    }

     void setTempSk(String tempSk) {
        this.tempSk = tempSk;
    }

    // Gets the expiration time in seconds in Unix Epoch format.
     int getExpiration() {
        return expiration;
    }

    // Sets the expiration time in seconds in Unix Epoch format.
     void setExpiration(int expiration) {
        this.expiration = expiration;
    }

    // Sets the expiration time according to the value from STS. The time is in GMT format which is the original format returned from STS.
     void setExpirationInGMTFormat(String expirationInGMTFormat) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
            Date date = sdf.parse(expirationInGMTFormat);
            this.expiration = date.getTime() / 1000;
        } catch (ParseException e) {
            if (OSSLog.isEnableLog()) {
                e.printStackTrace();
            }
            this.expiration = DateUtil.getFixedSkewedTimeMillis() / 1000 + 30;
        }
    }
}
