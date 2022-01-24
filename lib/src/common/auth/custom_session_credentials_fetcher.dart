import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';

import '../../client_exception.dart';
import 'basic_credentials.dart';
import 'credentials.dart';
import 'http_credentials_fetcher.dart';
import 'instance_profile_credentials.dart';

class CustomSessionCredentialsFetcher extends HttpCredentialsFetcher {
  CustomSessionCredentialsFetcher(this.ossAuthServerHost);

  @override
  Uri buildUrl() {
    try {
      return Uri.parse(ossAuthServerHost);
    } catch (e) {
      throw ArgumentError(e.toString());
    }
  }

  @override
  Credentials parse(HttpResponse response) {
    String jsonContent = String(response.getHttpContent());

    try {
      JSONObject jsonObject = JSONObject(jsonContent);

      if (!jsonObject.has("StatusCode")) {
        throw ClientException(
            "Invalid json " + jsonContent + " got from oss auth server.");
      }

      if ("200" != (jsonObject.get("StatusCode"))) {
        throw ClientException("Failed to get credentials from oss auth server");
      }

      if (!jsonObject.has("AccessKeyId") ||
          !jsonObject.has("AccessKeySecret")) {
        throw ClientException(
            "Invalid json " + jsonContent + " got from oss auth server.");
      }

      String? securityToken;
      if (jsonObject.has("SecurityToken")) {
        securityToken = jsonObject.getString("SecurityToken");
      }

      if (jsonObject.has("Expiration")) {
        return InstanceProfileCredentials(
            jsonObject.getString("AccessKeyId"),
            jsonObject.getString("AccessKeySecret"),
            securityToken,
            jsonObject.getString("Expiration"))
          ..expiredDurationSeconds =
              AuthUtils.DEFAULT_STS_SESSION_TOKEN_DURATION_SECONDS;
      }

      return BasicCredentials(jsonObject.getString("AccessKeyId"),
          jsonObject.getString("AccessKeySecret"), securityToken);
    } catch (e) {
      throw ClientException(
          "CustomSessionCredentialsFetcher.parse [$jsonContent] exception:$e");
    }
  }

  String ossAuthServerHost;
}
