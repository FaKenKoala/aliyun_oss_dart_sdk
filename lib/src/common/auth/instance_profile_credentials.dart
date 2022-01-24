import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';

import 'basic_credentials.dart';

class InstanceProfileCredentials extends BasicCredentials {
  InstanceProfileCredentials(String accessKeyId, String accessKeySecret,
      String? sessionToken, String expiration)
      : super(accessKeyId, accessKeySecret, sessionToken,
            AuthUtils.DEFAULT_ECS_SESSION_TOKEN_DURATION_SECONDS) {
    try {
      expirationInMilliseconds =
          DateTime.parse(expiration).millisecondsSinceEpoch;
    } catch (e) {
      throw ArgumentError(
          "Failed to get valid expiration time from ECS Metadata service.");
    }
  }

  @override
  bool willSoonExpire() {
    int now = DateTime.now().millisecondsSinceEpoch;
    return expiredDurationSeconds * (1.0 - expiredFactor) >
        (expirationInMilliseconds - now) / 1000.0;
  }

  bool isExpired() {
    int now = DateTime.now().millisecondsSinceEpoch;
    return now >= expirationInMilliseconds - refreshIntervalInMillSeconds;
  }

  bool shouldRefresh() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastFailedRefreshTime > refreshIntervalInMillSeconds) {
      return true;
    } else {
      return false;
    }
  }

  void setLastFailedRefreshTime() {
    lastFailedRefreshTime = DateTime.now().millisecondsSinceEpoch;
  }

  int expirationInMilliseconds = 0;
  final int refreshIntervalInMillSeconds = 10000;
  int lastFailedRefreshTime = 0;
}
