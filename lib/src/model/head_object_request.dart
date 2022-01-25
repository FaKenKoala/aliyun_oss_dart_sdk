import 'oss_request.dart';

class HeadObjectRequest extends OSSRequest {
  String bucketName;

  String objectKey;

  HeadObjectRequest(this.bucketName, this.objectKey);

}
