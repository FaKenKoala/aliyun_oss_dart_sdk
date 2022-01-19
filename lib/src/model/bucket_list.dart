import 'bucket.dart';
import 'generic_result.dart';

class BucketList extends GenericResult {
  final List<Bucket> _buckets = [];

  String? prefix;

  String? marker;

  int? maxKeys;

  bool isTruncated = false;

  String? nextMarker;

  List<Bucket> getBucketList() {
    return _buckets;
  }

  void setBucketList(List<Bucket>? buckets) {
    _buckets
      ..clear()
      ..addAll(buckets ?? []);
  }

  void clearBucketList() {
    _buckets.clear();
  }
}
