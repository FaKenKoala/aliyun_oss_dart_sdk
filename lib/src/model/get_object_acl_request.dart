import 'oss_request.dart';

class GetObjectACLRequest extends OSSRequest {
  String bucketName;
  String objectKey;

  GetObjectACLRequest(this.bucketName, this.objectKey);
}
