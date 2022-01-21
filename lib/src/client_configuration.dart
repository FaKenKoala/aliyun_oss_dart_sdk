/// Client configurations for accessing to OSS services.
import 'dart:collection';

import 'package:encrypt/encrypt.dart';

import 'common/auth/request_signer.dart';
import 'common/comm/protocol.dart';
import 'common/comm/retry_strategy.dart';
import 'common/comm/sign_version.dart';
import 'common/utils/version_info_utils.dart';

class ClientConfiguration {
  static final String DEFAULT_USER_AGENT =
      VersionInfoUtils.getDefaultUserAgent();

  static final int DEFAULT_MAX_RETRIES = 3;

  static final int DEFAULT_CONNECTION_REQUEST_TIMEOUT = -1;
  static final int DEFAULT_CONNECTION_TIMEOUT = 50 * 1000;
  static final int DEFAULT_SOCKET_TIMEOUT = 50 * 1000;
  static final int DEFAULT_MAX_CONNECTIONS = 1024;
  static final int DEFAULT_CONNECTION_TTL = -1;
  static final int DEFAULT_IDLE_CONNECTION_TIME = 60 * 1000;
  static final int DEFAULT_VALIDATE_AFTER_INACTIVITY = 2 * 1000;
  static final int DEFAULT_THREAD_POOL_WAIT_TIME = 60 * 1000;
  static final int DEFAULT_REQUEST_TIMEOUT = 5 * 60 * 1000;
  static final int DEFAULT_SLOW_REQUESTS_THRESHOLD = 5 * 60 * 1000;

  static final bool DEFAULT_USE_REAPER = true;

  static final String DEFAULT_CNAME_EXCLUDE_LIST =
      "aliyuncs.com,aliyun-inc.com,aliyun.com";

  static final SignVersion DEFAULT_SIGNATURE_VERSION = SignVersion.v1;

  String userAgent = DEFAULT_USER_AGENT;
  int maxErrorRetry = DEFAULT_MAX_RETRIES;
  int connectionRequestTimeout = DEFAULT_CONNECTION_REQUEST_TIMEOUT;
  int connectionTimeout = DEFAULT_CONNECTION_TIMEOUT;
  int socketTimeout = DEFAULT_SOCKET_TIMEOUT;
  int maxConnections = DEFAULT_MAX_CONNECTIONS;
  int connectionTTL = DEFAULT_CONNECTION_TTL;
  bool useReaper = DEFAULT_USE_REAPER;
  int idleConnectionTime = DEFAULT_IDLE_CONNECTION_TIME;

  Protocol protocol = Protocol.http;

  String? proxyHost;
  int proxyPort = -1;
  String? proxyUsername;
  String? proxyPassword;
  String? proxyDomain;
  String? proxyWorkstation;

  bool supportCname = true;
  final List<String> _cnameExcludeList = [];

  bool sldEnabled = false;

  int requestTimeout = DEFAULT_REQUEST_TIMEOUT;
  bool requestTimeoutEnabled = false;
  int slowRequestsThreshold = DEFAULT_SLOW_REQUESTS_THRESHOLD;

  Map<String, String> defaultHeaders = <String, String>{};

  bool crcCheckEnabled = true;

  List<RequestSigner> signerHandlers = [];

  SignVersion signatureVersion = DEFAULT_SIGNATURE_VERSION;

  int _tickOffset = 0;

  RetryStrategy? retryStrategy;

  bool redirectEnable = true;

  bool verifySSLEnable = true;
  List<KeyManager>? keyManagers;
  List<X509TrustManager>? x509TrustManagers;
  SecureRandom? secureRandom;
  HostnameVerifier? hostnameVerifier;

  bool logConnectionPoolStats = false;

  bool useSystemPropertyValues = false;

  ClientConfiguration() {
    appendDefaultExcludeList(_cnameExcludeList);
  }

  List<String> getCnameExcludeList() {
    return UnmodifiableListView(_cnameExcludeList);
  }

  /// Sets the immutable excluded CName list----any domain ends with an item in
  /// this list will not do Cname resolution.
  void setCnameExcludeList(List<String> cnameExcludeList) {
    _cnameExcludeList.clear();
    for (String excl in cnameExcludeList) {
      if (excl.trim().isNotEmpty) {
        _cnameExcludeList.add(excl);
      }
    }

    appendDefaultExcludeList(_cnameExcludeList);
  }

  static void appendDefaultExcludeList(List<String> excludeList) {
    List<String> excludes = DEFAULT_CNAME_EXCLUDE_LIST.split(",");
    for (String excl in excludes) {
      if (excl.trim().isNotEmpty && !excludeList.contains(excl)) {
        excludeList.add(excl.trim().toLowerCase());
      }
    }
  }

  /// The connection idle time threshold in millisecond that triggers the
  /// validation. By default it's 2000.
  int getValidateAfterInactivity() {
    return DEFAULT_VALIDATE_AFTER_INACTIVITY;
  }

  void addDefaultHeader(String key, String value) {
    defaultHeaders[key] = value;
  }

  /// Gets the difference between customized epoch time and local time, in millisecond.
  int getTickOffset() {
    return _tickOffset;
  }

  /// Sets the custom base time.
  /// OSS's token validation logic depends on the time.
  /// It requires that there's no more than 15 min time difference between client and OSS server.
  /// This API calculates the difference between local time to epoch time.
  /// Later one other APIs use this difference to offset the local time before sending request to OSS.
  ///
  /// @param epochTicks
  ///             Custom Epoch ticks (in millisecond).
  void setTickOffset(int epochTicks) {
    int localTime = DateTime.now().millisecondsSinceEpoch;
    _tickOffset = epochTicks - localTime;
  }
}
