import 'oss_request.dart';

class ListBucketsRequest extends OSSRequest {
  static final int MAX_RETURNED_KEYS_LIMIT = 1000;

  // prefix filter
  String? prefix;

  // maker filter--the returned bucket' keys must be greater than this value in lexicographic order.
  String? marker;

  // the max keys to return--by default it's 100
  int? maxKeys;

  ListBucketsRequest([this.prefix, this.marker, this.maxKeys]);
}
