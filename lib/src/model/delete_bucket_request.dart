import 'oss_request.dart';

class DeleteBucketRequest extends OSSRequest {
  String bucketName;

  DeleteBucketRequest(this.bucketName);
}
