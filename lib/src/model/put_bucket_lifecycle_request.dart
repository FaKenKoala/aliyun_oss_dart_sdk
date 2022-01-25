import 'bucket_lifecycle_rule.dart';
import 'oss_request.dart';

class PutBucketLifecycleRequest extends OSSRequest {
  String? bucketName;
  List<BucketLifecycleRule>? lifecycleRules;
}
