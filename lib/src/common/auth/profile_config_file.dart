import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/utils/log_utils.dart';

import 'default_credentials.dart';
import 'profile_config_loader.dart';
import 'system_properties_credentials_provider.dart';

/// Loads the local OSS credential profiles from the standard location
/// (~/.oss/credentials), which can be easily overridden through the
/// <code>OSS_CREDENTIAL_PROFILES_FILE</code> environment variable or by
/// specifying an alternate credentials file location through this class'
/// constructor.
/// <p>
/// The OSS credentials file format allows you to specify multiple profiles, each
/// with their own set of OSS security credentials:
///
/// <pre>
/// [default]
/// oss_access_key_id=testAccessKey
/// oss_secret_access_key=testSecretKey
/// oss_session_token=testSessionToken
/// </pre>
///
/// <p>
/// These credential profiles allow you to share multiple sets of OSS security
/// credentails between different tools such as the OSS SDK for Java and the OSS
/// CLI.
class ProfileConfigFile {
  /// Loads the OSS credential profiles from the file. The reference to the
  /// file is specified as a parameter to the constructor.
  ProfileConfigFile(this.profileFile, [ProfileConfigLoader? profileLoader])
      : profileLoader = profileLoader ?? ProfileConfigLoader(),
        _profileFileLastModified = profileFile.lastModifiedSync();

  /// Returns the OSS credentials for the specified profile.
  Credentials getCredentials() {
    refresh();
    return credentials!;
  }

  /// Reread data from disk.
  void refresh() {
    if (credentials == null ||
        profileFile.lastModifiedSync().isAfter(_profileFileLastModified)) {
      _profileFileLastModified = profileFile.lastModifiedSync();

      Map<String, String> profileProperties;
      try {
        profileProperties = profileLoader.loadProfile(profileFile);
      } catch (e) {
        LogUtils.logException("ProfilesConfigFile.refresh Exception:", e);
        return;
      }

      String? accessKeyId =
          StringUtils.trim(profileProperties[AuthUtils.OSS_ACCESS_KEY_ID]);
      String? secretAccessKey =
          StringUtils.trim(profileProperties[AuthUtils.OSS_SECRET_ACCESS_KEY]);
      String? sessionToken =
          StringUtils.trim(profileProperties[AuthUtils.OSS_SESSION_TOKEN]);

      if (StringUtils.isNullOrEmpty(accessKeyId)) {
        throw InvalidCredentialsException(
            "Access key id should not be null or empty.");
      }
      if (StringUtils.isNullOrEmpty(secretAccessKey)) {
        throw InvalidCredentialsException(
            "Secret access key should not be null or empty.");
      }

      credentials =
          DefaultCredentials(accessKeyId!, secretAccessKey!, sessionToken);
    }
  }

  final File profileFile;
  final ProfileConfigLoader profileLoader;
  DateTime _profileFileLastModified;
  DefaultCredentials? credentials;
}
