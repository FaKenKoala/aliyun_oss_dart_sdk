import 'oss_request.dart';

class DeleteObjectRequest extends OSSRequest {
  String bucketName;

  String objectKey;

  DeleteObjectRequest(this.bucketName, this.objectKey);
}
