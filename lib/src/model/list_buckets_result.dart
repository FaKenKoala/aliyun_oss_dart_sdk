import 'oss_bucket_summary.dart';
import 'oss_result.dart';

class ListBucketsResult extends OSSResult {
  String? prefix;

  String? marker;

  int maxKeys = 0;

  bool isTruncated = false;

  String? nextMarker;

  String? ownerId;

  String? ownerDisplayName;

  List<OSSBucketSummary> buckets = [];

  void addBucket(OSSBucketSummary bucket) {
    buckets.add(bucket);
  }

  void clearBucketList() {
    buckets.clear();
  }
}
