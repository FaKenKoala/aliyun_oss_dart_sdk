import 'oss_result.dart';

class GetBucketLoggingResult extends OSSResult {
  String? targetBucketName;
  String? targetPrefix;
  bool loggingEnabled = false;
}
