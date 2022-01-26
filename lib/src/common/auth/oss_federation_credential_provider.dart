import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';

import 'oss_credential_provider.dart';
import 'oss_federation_token.dart';

abstract class OSSFederationCredentialProvider
    implements OSSCredentialProvider {
  OSSFederationToken? _cachedToken;

  Future<OSSFederationToken?> getValidFederationToken() async {
    // Checks if the STS token is expired. To avoid returning staled data, here we pre-fetch the token 5 minutes a head of the real expiration.
    // The minimal expiration time is 15 minutes
    final nowSecond = DateUtil.getFixedSkewedTimeMillis() / 1000;
    if (_cachedToken == null || nowSecond > _cachedToken!.expiration - 5 * 60) {
      if (_cachedToken != null) {
        OSSLog.logDebug(
            "token expired! current time: $nowSecond token expired: ${_cachedToken!.expiration}");
      }
      _cachedToken = await getFederationToken();
    }

    return _cachedToken;
  }

  OSSFederationToken? get cachedToken {
    return _cachedToken;
  }
}
