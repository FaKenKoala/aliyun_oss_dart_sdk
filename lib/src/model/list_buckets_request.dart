import 'web_service_request.dart';

class ListBucketsRequest extends WebServiceRequest {
  static const int maxReturnedKeys = 1000;

  // The prefix filter for the buckets to return. In the other words, all
  // buckets returned must start with this prefix.
  String? prefix;

  // The maker filter for the buckets to return. In the other words, all
  // buckets returned must be greater than the marker
  // in the lexicographical order.
  String? marker;

  // The max number of buckets to return.By default it's 100.
  int? _maxKeys;

  // The OSS's Bid is 26842.
  String? bid;

  // The tag key.
  String? tagKey;

  // The tag value.
  String? tagValue;

  // The resouce group id
  String? resouceGroupId;

  ListBucketsRequest({this.prefix, this.marker, int? maxKeys}) {
    if (maxKeys != null) {
      setMaxKeys(maxKeys);
    }
  }

  int? get maxKeys => _maxKeys;

  void setMaxKeys(int maxKeys) {
    int tmp = maxKeys;
    if (tmp < 0 || tmp > maxReturnedKeys) {
      throw ArgumentError(
          OSSUtils.OSS_RESOURCE_MANAGER.getString("MaxKeysOutOfRange"));
    }
    _maxKeys = maxKeys;
  }
}
