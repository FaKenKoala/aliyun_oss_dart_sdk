import 'oss_request.dart';

class PutBucketRefererRequest extends OSSRequest {
  String? bucketName;
  bool allowEmpty = true;
  List<String>? referers;
}
