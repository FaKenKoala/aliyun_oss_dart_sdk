import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';

import 'credentials.dart';
import 'credentials_provider.dart';
import 'profile_config_file.dart';

/// Credentials provider based on OSS configuration profiles. This provider vends
/// Credentials from the profile configuration file for the default profile, or
/// for a specific, named profile. The OSS credentials file locates at
/// ~/.oss/credentials on Linux, macOS, or Unix, or at C:\Users\USERNAME
/// \.oss\credentials on Windows. This file can contain multiple named profiles
/// in addition to a default profile.
class ProfileCredentialsProvider implements CredentialsProvider {
  /// Different between millisecond and nanosecond.
  static final int DIFF_MILLI_AND_NANO = 1000 * 1000;

  /// Default refresh interval
  static final int DEFAULT_REFRESH_INTERVAL_NANOS = 5 * 60 * 1000 * 1000 * 1000;

  /// Default force reload interval
  static final int DEFAULT_FORCE_RELOAD_INTERVAL_NANOS =
      2 * DEFAULT_REFRESH_INTERVAL_NANOS;

  /// The credential profiles file from which this provider loads the security
  /// credentials. Lazily loaded by the double-check idiom.
  ProfileConfigFile? profilesConfigFile;

  /// When the profiles file was last refreshed.
  int lastRefreshed;

  /// The name of the credential profile
  late String profileName;

  /// Used to have only one thread block on refresh, for applications making at
  /// least one call every REFRESH_INTERVAL_NANOS.
  final Semaphore refreshSemaphore = Semaphore(1);

  /// Refresh interval. Defaults to {@link #DEFAULT_REFRESH_INTERVAL_NANOS}
  int refreshIntervalNanos = DEFAULT_REFRESH_INTERVAL_NANOS;

  /// Force reload interval. Defaults to
  /// {@link #DEFAULT_FORCE_RELOAD_INTERVAL_NANOS}
  int refreshForceIntervalNanos = DEFAULT_FORCE_RELOAD_INTERVAL_NANOS;

  /// Creates a new profile credentials provider that returns the OSS security
  /// credentials for the specified profiles configuration file and profile
  /// name.
  ///
  /// @param profilesConfigFile
  ///            The profile configuration file containing the profiles used by
  ///            this credentials provider or null to defer load to first use.
  /// @param profileName
  ///            The name of a configuration profile in the specified
  ///            configuration file.
  ProfileCredentialsProvider(
      {String? profilesConfigFilePath,
      ProfileConfigFile? profilesConfigFile,
      String? profileName}) {
    this.profilesConfigFile = profilesConfigFile ??
        (profilesConfigFilePath != null
            ? ProfileConfigFile(File(profilesConfigFilePath))
            : null);
    if (profilesConfigFile != null) {
      lastRefreshed = System.nanoTime();
    }
    if (profileName == null) {
      this.profileName = AuthUtils.DEFAULT_PROFILE_PATH;
    } else {
      this.profileName = profileName;
    }
  }

  @override
  void setCredentials(Credentials creds) {}

  @override
  Credentials getCredentials() {
    if (profilesConfigFile == null) {
      profilesConfigFile = ProfileConfigFile(profileName);
      lastRefreshed = System.nanoTime();
    }

    // Periodically check if the file on disk has been modified
    // since we last read it.
    //
    // For active applications, only have one thread block.
    // For applications that use this method in bursts, ensure the
    // credentials are never too stale.
    int now = System.nanoTime();
    int age = now - lastRefreshed;
    if (age > refreshForceIntervalNanos) {
      refresh();
    } else if (age > refreshIntervalNanos) {
      if (refreshSemaphore.tryAcquire()) {
        try {
          refresh();
        } finally {
          refreshSemaphore.release();
        }
      }
    }

    return profilesConfigFile.credentials;
  }

  void refresh() {
    if (profilesConfigFile != null) {
      profilesConfigFile.refresh();
      lastRefreshed = System.nanoTime();
    }
  }

  /// Gets the refresh interval in milliseconds.
  ///
  /// @return milliseconds
  int getRefreshIntervalMillis() {
    return refreshIntervalNanos / DIFF_MILLI_AND_NANO;
  }

  /// Sets the refresh interval in milliseconds.
  ///
  /// @param refreshIntervalMillis milliseconds.
  void setRefreshIntervalNanos(int refreshIntervalMillis) {
    refreshIntervalNanos = refreshIntervalMillis * DIFF_MILLI_AND_NANO;
  }

  /// Gets the forced refresh interval in milliseconds.
  ///
  /// @return milliseconds.
  int getRefreshForceIntervalMillis() {
    return refreshForceIntervalNanos / DIFF_MILLI_AND_NANO;
  }

  /// Sets the forced refresh interval in milliseconds.
  ///
  /// @param refreshForceIntervalMillis milliseconds.
  void setRefreshForceIntervalMillis(int refreshForceIntervalMillis) {
    refreshForceIntervalNanos =
        refreshForceIntervalMillis * DIFF_MILLI_AND_NANO;
  }
}
