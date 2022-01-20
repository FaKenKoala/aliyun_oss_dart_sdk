import 'certificate_configuration.dart';
import 'generic_request.dart';

class AddBucketCnameRequest extends GenericRequest {
  String? domain;
  CertificateConfiguration? certificateConfiguration;

  AddBucketCnameRequest(String bucketName) : super(bucketName: bucketName);
}
