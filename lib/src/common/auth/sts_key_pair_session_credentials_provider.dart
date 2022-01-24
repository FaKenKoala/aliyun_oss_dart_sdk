import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';

import 'basic_credentials.dart';
import 'credentials.dart';
import 'credentials_provider.dart';

/// STSKeyPairSessionCredentialsProvider implementation that uses the RSA key
/// pair to create temporary, short-lived sessions to use for authentication.
 class STSKeyPairSessionCredentialsProvider implements CredentialsProvider {

     STSKeyPairSessionCredentialsProvider(KeyPairCredentials keyPairCredentials, IClientProfile profile) {
        this.keyPairCredentials = keyPairCredentials;
        this.ramClient = DefaultAcsClient(profile, keyPairCredentials);
    }

     STSKeyPairSessionCredentialsProvider withExpiredDuration(long expiredDurationSeconds) {
        this.expiredDurationSeconds = expiredDurationSeconds;
        return this;
    }

     STSKeyPairSessionCredentialsProvider withExpiredFactor(double expiredFactor) {
        this.expiredFactor = expiredFactor;
        return this;
    }

    @override
     void setCredentials(Credentials creds) {

    }

    @override
     Credentials getCredentials() {
        if (sessionCredentials == null || sessionCredentials.willSoonExpire()) {
            sessionCredentials = getNewSessionCredentials();
        }
        return sessionCredentials;
    }

     BasicCredentials getNewSessionCredentials() {
        GetSessionAccessKeyRequest request = GetSessionAccessKeyRequest();
        request.setKeyId(keyPairCredentials.getAccessKeyId());
        request.setDurationSeconds((int) expiredDurationSeconds);
        request.setSysProtocol(ProtocolType.HTTPS);

        GenerateSessionAccessKeyResponse response = null;
        try {
            response = this.ramClient.getAcsResponse(request);
        } catch (ClientException e) {
            LogUtils.logException("RamClient.getAcsResponse Exception:", e);
            return null;
        }

        return BasicCredentials(response.getSessionAccessKey().getSessionAccessKeyId(),
                response.getSessionAccessKey().getSessionAccessKeySecert(), null, expiredDurationSeconds)
                        .withExpiredFactor(expiredFactor);
    }

     DefaultAcsClient ramClient;
     KeyPairCredentials keyPairCredentials;
     BasicCredentials sessionCredentials;

     int expiredDurationSeconds = AuthUtils.DEFAULT_EXPIRED_DURATION_SECONDS;
     double expiredFactor = AuthUtils.DEFAULT_EXPIRED_FACTOR;

}