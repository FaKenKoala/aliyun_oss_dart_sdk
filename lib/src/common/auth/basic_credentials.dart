import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';

import 'credentials.dart';

class BasicCredentials implements Credentials {
  BasicCredentials(this.accessKeyId, this.accessKeySecret,
      [this.securityToken, this.expiredDurationSeconds = 0])
      : startedTimeInMilliSeconds = DateTime.now().millisecondsSinceEpoch;

  @override
  String getAccessKeyId() {
    return accessKeyId;
  }

  @override
  String getSecretAccessKey() {
    return accessKeySecret;
  }

  @override
  String? getSecurityToken() {
    return securityToken;
  }

  @override
  bool useSecurityToken() {
    return securityToken != null;
  }

  bool willSoonExpire() {
    if (expiredDurationSeconds == 0) {
      return false;
    }
    int now = DateTime.now().millisecondsSinceEpoch;
    return expiredDurationSeconds * expiredFactor <
        (now - startedTimeInMilliSeconds) / 1000.0;
  }

  final String accessKeyId;
  final String accessKeySecret;
  final String? securityToken;

  int expiredDurationSeconds = 0;
  int startedTimeInMilliSeconds = 0;
  double expiredFactor = AuthUtils.DEFAULT_EXPIRED_FACTOR;
}
