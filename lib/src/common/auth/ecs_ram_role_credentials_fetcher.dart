import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';

import 'basic_credentials.dart';
import 'credentials.dart';
import 'http_credentials_fetcher.dart';
import 'instance_profile_credentials.dart';

class EcsRamRoleCredentialsFetcher extends HttpCredentialsFetcher {
  EcsRamRoleCredentialsFetcher(this.ossAuthServerHost);

  @override
  Uri buildUrl() {
    try {
      return Uri.parse(ossAuthServerHost);
    } catch (e) {
      throw ArgumentError(e.toString());
    }
  }

  Credentials parse(HttpResponse response) {
    String jsonContent = String(response.getHttpContent());

    try {
      JSONObject jsonObject = JSONObject(jsonContent);

      if (!jsonObject.has("Code")) {
        throw ClientException(
            "Invalid json " + jsonContent + " got from ecs metadata server.");
      }

      if ("Success" != jsonObject.get("Code")) {
        throw ClientException(
            "Failed to get credentials from ecs metadata server");
      }

      if (!jsonObject.has("AccessKeyId") ||
          !jsonObject.has("AccessKeySecret")) {
        throw ClientException(
            "Invalid json " + jsonContent + " got from ecs metadata server.");
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
              AuthUtils.DEFAULT_ECS_SESSION_TOKEN_DURATION_SECONDS
          ..expiredFactor = 0.85;
      }

      return BasicCredentials(jsonObject.getString("AccessKeyId"),
          jsonObject.getString("AccessKeySecret"), securityToken);
    } catch (e) {
      throw ClientException(
          "EcsRamRoleCredentialsFetcher.parse [$jsonContent] exception:$e");
    }
  }

  String ossAuthServerHost;
}
