import 'package:aliyun_oss_dart_sdk/src/internal/oss_utils.dart';

import 'generic_request.dart';

/// This is the request class to list objects under a bucket.
class ListObjectsRequest extends GenericRequest {
  static final int MAX_RETURNED_KEYS_LIMIT = 1000;

  // The prefix filter----objects returned whose key must start with this
  // prefix.
  String? prefix;

  // The marker filter----objects returned whose key must be greater than the
  // maker in lexicographical order.
  String? marker;

  // The max objects to return---By default it's 100.
  int? _maxKeys;

  // The delimiters of object names returned.
  String? delimiter;

  /// The encoding type of object name in the response body. Currently object
  /// name allow any unicode character. However the XML 1.0 could not parse
  /// some Unicode character such as ASCII character 0 to 10. For these XMl 1.0
  /// non-supported characters, we can use the encoding type to encode the
  /// object name.
  String? encodingType;

  ListObjectsRequest(
      [String? bucketName,
      this.prefix,
      this.marker,
      this.delimiter,
      int? maxKeys])
      : super(bucketName: bucketName) {
    if (maxKeys != null) {
      this.maxKeys = maxKeys;
    }
  }

  int? get maxKeys {
    return _maxKeys;
  }

  set maxKeys(int? maxKeys) {
    if (maxKeys == 0 || maxKeys! < 0 || maxKeys > MAX_RETURNED_KEYS_LIMIT) {
      throw ArgumentError(
          OSSUtils.OSS_RESOURCE_MANAGER.getString("MaxKeysOutOfRange"));
    }

    _maxKeys = maxKeys;
  }
}
