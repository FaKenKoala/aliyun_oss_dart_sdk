import 'oss_request.dart';

class ListObjectsRequest extends OSSRequest {
  static final int MAX_RETURNED_KEYS_LIMIT = 1000;

  // bucket name
  String? bucketName;

  // prefix filter
  String? prefix;

  // maker filter--the returned objects' keys must be greater than this value in lexicographic order.
  String? marker;

  // the max keys to return--by default it's 100
  int _maxKeys = 100;

  // delimiter for grouping object keys.
  String? delimiter;

  String? encodingType;

  ListObjectsRequest(
      [this.bucketName,
      this.prefix,
      this.marker,
      this.delimiter,
      int maxKeys = 100]) {
    maxKeys = maxKeys;
  }

  int get maxKeys {
    return _maxKeys;
  }

  set maxKeys(int maxKeys) {
    if (maxKeys < 0 || maxKeys > MAX_RETURNED_KEYS_LIMIT) {
      throw ArgumentError("Maxkeys should less can not exceed 1000.");
    }

    _maxKeys = maxKeys;
  }
}
