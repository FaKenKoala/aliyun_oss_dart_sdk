import 'oss_request.dart';

class GetBucketInfoRequest extends OSSRequest {
  String bucketName;

  GetBucketInfoRequest(this.bucketName);
}
