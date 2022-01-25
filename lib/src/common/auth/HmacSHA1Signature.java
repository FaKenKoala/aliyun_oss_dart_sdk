/**
 * Copyright (C) Alibaba Cloud Computing, 2015
 * All rights reserved.
 * <p>
 * 版权所有 （C）阿里巴巴云计算，2015
 */

package com.alibaba.sdk.android.oss.common.auth;

import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.BinaryUtil;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * Hmac-SHA1 signature
 */
 class HmacSHA1Signature {
     static final String defaultEncoding = "UTF-8"; // Default encoding
     static final String ALGORITHM = "HmacSHA1"; // Signature method.
     static final String VERSION = "1"; // Signature version.
     static final Object LOCK = Object();
     static Mac macInstance; // Prototype of the Mac instance.

     HmacSHA1Signature() {
    }

     String getAlgorithm() {
        return ALGORITHM;
    }

     String getVersion() {
        return VERSION;
    }

     String computeSignature(String key, String data) {
        OSSLog.logDebug(getAlgorithm(), false);
        OSSLog.logDebug(getVersion(), false);
        String sign = null;
        try {
            OSSLog.logDebug("sign start");
            byte[] signData = sign(
                    key.getBytes(defaultEncoding),
                    data.getBytes(defaultEncoding));
            OSSLog.logDebug("base64 start");
            sign = BinaryUtil.toBase64String(signData);
        } catch (UnsupportedEncodingException ex) {
            throw RuntimeException("Unsupported algorithm: " + defaultEncoding);
        }
        return sign;
    }


     byte[] sign(byte[] key, byte[] data) {
        byte[] sign = null;
        try {
            // Because Mac.getInstance(String) calls a synchronized method,
            // it could block on invoked concurrently.
            // SO use prototype pattern to improve perf.
            if (macInstance == null) {
                synchronized (LOCK) {
                    if (macInstance == null) {
                        macInstance = Mac.getInstance(getAlgorithm());
                    }
                }
            }

            Mac mac;
            try {
                mac = (Mac) macInstance.clone();
            } catch (CloneNotSupportedException e) {
                // If it is not clonable, create a one.
                mac = Mac.getInstance(getAlgorithm());
            }
            mac.init(SecretKeySpec(key, getAlgorithm()));
            sign = mac.doFinal(data);
        } catch (NoSuchAlgorithmException ex) {
            throw RuntimeException("Unsupported algorithm: " + ALGORITHM);
        } catch (InvalidKeyException ex) {
            throw RuntimeException("key must not be null");
        }
        return sign;
    }
}