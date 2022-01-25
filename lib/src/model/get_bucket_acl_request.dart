import 'oss_request.dart';

class GetBucketACLRequest extends OSSRequest {
  String bucketName;

  GetBucketACLRequest(this.bucketName);

}
