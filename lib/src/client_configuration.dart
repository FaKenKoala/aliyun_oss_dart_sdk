import 'dart:collection';

/// Client configuration for access to Ali cloud services
class ClientConfiguration {
  ClientConfiguration();

  static const int defaultMaxRetries = 2;
  int maxConcurrentRequest = 5;
  int socketTimeout = 60 * 1000;
  int connectionTimeout = 60 * 1000;
  int maxLogSize = 5 * 1024 * 1024;
  int maxErrorRetry = defaultMaxRetries;
  final List<String> _customCnameExcludeList = [];
  String? proxyHost;
  int proxyPort = 0;
  String? userAgentMark;
  bool httpDnsEnable = true;
  bool checkCRC64 = false; //crc64 default false
  String? ipWithHeader;
  bool pathStyleAccessEnable = false;
  bool customPathPrefixEnable = false;

  /// Gets the default configuration instance
  static ClientConfiguration getDefaultConf() {
    return ClientConfiguration();
  }

  /// Gets the immutable CName excluded list. The element in this list will skip the CName resolution.
  ///
  /// @return CNAME excluded list.
  List<String> get customCnameExcludeList =>
      UnmodifiableListView(_customCnameExcludeList);

  /// Sets CNAME excluded list
  ///
  /// @param customCnameExcludeList CNAME excluded list
  set customCnameExcludeList(List<String> customCnameExcludeList) {
    if (customCnameExcludeList.isEmpty) {
      throw ArgumentError("cname exclude list should not be null.");
    }

    _customCnameExcludeList.clear();
    for (String host in customCnameExcludeList) {
      if (host.contains("://")) {
        _customCnameExcludeList.add(host.substring(host.indexOf("://") + 3));
      } else {
        _customCnameExcludeList.add(host);
      }
    }
  }
}
