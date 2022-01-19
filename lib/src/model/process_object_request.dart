import 'generic_request.dart';

class ProcessObjectRequest extends GenericRequest {
  ProcessObjectRequest(String bucketName, String key, this.process)
      : super(bucketName: bucketName, key: key);

  String process;
}
