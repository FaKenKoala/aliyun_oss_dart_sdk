import 'bucket_lifecycle_rule.dart';
import 'oss_result.dart';

class GetBucketLifecycleResult extends OSSResult {
  List<BucketLifecycleRule>? lifecycleRules;

  void addLifecycleRule(BucketLifecycleRule? lifecycleRule) {
    lifecycleRules ??= [];
    if (lifecycleRule != null) {
      lifecycleRules!.add(lifecycleRule);
    }
  }
}
