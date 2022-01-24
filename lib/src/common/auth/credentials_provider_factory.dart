import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/crypto/kms_encryption_materials.dart';

import 'basic_credentials.dart';
import 'custom_session_credentials_provider.dart';
import 'default_credential_provider.dart';
import 'environment_variable_credentials_provider.dart';
import 'instance_profile_credentials_provider.dart';
import 'key_pair_credentials.dart';
import 'sts_assume_role_session_credentials_provider.dart';
import 'sts_key_pair_session_credentials_provider.dart';
import 'system_properties_credentials_provider.dart';

/// Credentials provider factory to share providers across potentially many
/// clients.
class CredentialsProviderFactory {

  /// Create an instance of DefaultCredentialProvider.
  ///
  /// @param accessKeyId
  ///            Access Key ID.
  /// @param secretAccessKey
  ///            Secret Access Key.
  /// @param securityToken
  ///            Security Token from STS.
  /// @return A {@link DefaultCredentialProvider} instance.
  DefaultCredentialProvider newDefaultCredentialProvider(
      String accessKeyId, String secretAccessKey, [String? securityToken]) {
    return DefaultCredentialProvider(
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        securityToken: securityToken);
  }

  /// Create an instance of EnvironmentVariableCredentialsProvider by reading
  /// the environment variable to obtain the ak/sk, such as OSS_ACCESS_KEY_ID
  /// and OSS_ACCESS_KEY_SECRET
  ///
  /// @return A {@link EnvironmentVariableCredentialsProvider} instance.
  /// @throws ClientException
  ///             OSS Client side exception.
  static EnvironmentVariableCredentialsProvider
      newEnvironmentVariableCredentialsProvider() {
    return EnvironmentVariableCredentialsProvider();
  }

  /// Create an instance of EnvironmentVariableCredentialsProvider by reading
  /// the java system property used when starting up the JVM to enable the
  /// default metrics collected by the OSS SDK, such as -Doss.accessKeyId and
  /// -Doss.accessKeySecret.
  ///
  /// @return A {@link SystemPropertiesCredentialsProvider} instance.
  /// @throws ClientException
  ///             OSS Client side exception.
  static SystemPropertiesCredentialsProvider
      newSystemPropertiesCredentialsProvider() {
    return SystemPropertiesCredentialsProvider();
  }

  /// Create a new STSAssumeRoleSessionCredentialsProvider, which makes a
  /// request to the Aliyun Security Token Service (STS), uses the provided
  /// roleArn to assume a role and then request short lived session
  /// credentials, which will then be returned by the credentials provider's
  /// {@link CredentialsProvider#getCredentials()} method.
  ///
  /// @param regionId
  ///            RAM's available area, for more information about regionId, see
  ///            <a href="https://help.aliyun.com/document_detail/40654.html">
  ///            RegionIdList</a>.
  /// @param accessKeyId
  ///            Access Key ID of the child user.
  /// @param accessKeySecret
  ///            Secret Access Key of the child user.
  /// @param roleArn
  ///            The ARN of the Role to be assumed.
  /// @return A {@link STSAssumeRoleSessionCredentialsProvider} instance.
  /// @throws ClientException
  ///             OSS Client side exception.
  static STSAssumeRoleSessionCredentialsProvider
      newSTSAssumeRoleSessionCredentialsProvider(String regionId,
          String accessKeyId, String accessKeySecret, String roleArn) {
    DefaultProfile profile = DefaultProfile.getProfile(regionId);
    BasicCredentials basicCredentials =
        BasicCredentials(accessKeyId, accessKeySecret);
    return STSAssumeRoleSessionCredentialsProvider(
        basicCredentials, roleArn, profile);
  }

  /// Create an instance of InstanceProfileCredentialsProvider obtained the
  /// ak/sk by ECS Metadata Service.
  ///
  /// @param roleName
  ///            Role name of the ECS binding, NOT ROLE ARN.
  /// @return A {@link InstanceProfileCredentialsProvider} instance.
  /// @throws ClientException
  ///             OSS Client side exception.
  static InstanceProfileCredentialsProvider
      newInstanceProfileCredentialsProvider(String roleName) {
    return InstanceProfileCredentialsProvider(roleName);
  }

  /// Create an instance of InstanceProfileCredentialsProvider based on RSA key
  /// pair.
  ///
  /// @param regionId
  ///            RAM's available area, for more information about regionId, see
  ///            <a href="https://help.aliyun.com/document_detail/40654.html">
  ///            RegionIdList</a>.
  /// @param KeyId
  ///             Key ID.
  /// @param Key
  ///             Key.
  /// @return A {@link STSKeyPairSessionCredentialsProvider} instance.
  /// @throws ClientException
  ///             OSS Client side exception.
  static STSKeyPairSessionCredentialsProvider
      newSTSKeyPairSessionCredentialsProvider(
          String regionId, String keyId, String key) {
    DefaultProfile profile = DefaultProfile.getProfile(regionId);
    KeyPairCredentials keyPairCredentials = KeyPairCredentials(keyId, key);
    return STSKeyPairSessionCredentialsProvider(keyPairCredentials, profile);
  }

  /// Create an instance of InstanceProfileCredentialsProvider obtained the
  /// ak/sk by the authorization server defined by the OSS. The protocol format
  /// of the authorized service is as follows:
  /// <p>
  /// {
  ///     "StatusCode":"200",
  ///     "AccessKeyId":"STS.3p******gdasdg",
  ///     "AccessKeySecret":"rpnwO9******rddgsR2YrTtI",
  ///     "SecurityToken":"CAES......zZGstZGVtbzI=",
  ///     "Expiration":"2017-11-06T09:16:56Z"
  /// }
  /// </p>
  /// An example of the authorized service to see
  /// <a href="https://help.aliyun.com/document_detail/31926.html">
  /// AuthorizedService</a>.
  ///
  /// @param ossAuthServerHost
  ///            The host of the authorized server, such as
  ///            http://192.168.1.11:9090/sts/getsts.
  /// @return A {@link CustomSessionCredentialsProvider} instance.
  /// @throws ClientException
  static CustomSessionCredentialsProvider newCustomSessionCredentialsProvider(
      String ossAuthServerHost) {
    return CustomSessionCredentialsProvider(ossAuthServerHost);
  }
}
