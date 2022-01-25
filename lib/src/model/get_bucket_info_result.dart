import 'oss_bucket_summary.dart';
import 'oss_result.dart';

class GetBucketInfoResult extends OSSResult {
  OSSBucketSummary? bucket;

  @override
  String toString() {
    return "GetBucketInfoResult<${super.toString()}>:\n bucket:${bucket?.toString()}";
  }
}
