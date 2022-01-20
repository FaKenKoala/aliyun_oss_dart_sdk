import 'generic_request.dart';

class DeleteBucketCnameRequest extends GenericRequest {
  String? domain;

  DeleteBucketCnameRequest(String bucketName, [this.domain])
      : super(bucketName: bucketName);
}
