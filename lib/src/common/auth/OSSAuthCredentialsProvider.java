package com.alibaba.sdk.android.oss.common.auth;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.common.OSSConstants;
import com.alibaba.sdk.android.oss.common.utils.IOUtils;

import org.json.JSONObject;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by jingdan on 2017/11/15.
 * Authentication server issued under the agreement of the official website agreement, you can directly use the provider
 */

 class OSSAuthCredentialsProvider extends OSSFederationCredentialProvider {

     String mAuthServerUrl;
     AuthDecoder mDecoder;

     OSSAuthCredentialsProvider(String authServerUrl) {
        this.mAuthServerUrl = authServerUrl;
    }

    /**
     * set auth server url
     *
     * @param authServerUrl
     */
     void setAuthServerUrl(String authServerUrl) {
        this.mAuthServerUrl = authServerUrl;
    }

    /**
     * set response data decoder
     *
     * @param decoder
     */
     void setDecoder(AuthDecoder decoder) {
        this.mDecoder = decoder;
    }

    @override
     OSSFederationToken getFederationToken() throws OSSClientException {
        OSSFederationToken authToken;
        String authData;
        try {
            URL stsUrl = URL(mAuthServerUrl);
            HttpURLConnection conn = (HttpURLConnection) stsUrl.openConnection();
            conn.setConnectTimeout(10000);
            InputStream input = conn.getInputStream();
            authData = IOUtils.readStreamAsString(input, OSSConstants.DEFAULT_CHARSET_NAME);
            if (mDecoder != null) {
                authData = mDecoder.decode(authData);
            }
            JSONObject jsonObj = JSONObject(authData);
            int statusCode = jsonObj.getInt("StatusCode");
            if (statusCode == 200) {
                String ak = jsonObj.getString("AccessKeyId");
                String sk = jsonObj.getString("AccessKeySecret");
                String token = jsonObj.getString("SecurityToken");
                String expiration = jsonObj.getString("Expiration");
                authToken = OSSFederationToken(ak, sk, token, expiration);
            } else {
                String errorCode = jsonObj.getString("ErrorCode");
                String errorMessage = jsonObj.getString("ErrorMessage");
                throw OSSClientException("ErrorCode: " + errorCode + "| ErrorMessage: " + errorMessage);
            }
            return authToken;
        } catch (Exception e) {
            throw OSSClientException(e);
        }
    }

     abstract class AuthDecoder {
        String decode(String data);
    }
}
