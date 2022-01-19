import 'generic_request.dart';
import 'restore_configuration.dart';

class RestoreObjectRequest extends GenericRequest {
  RestoreObjectRequest(String bucketName, String key,
      [this.restoreConfiguration])
      : super(bucketName: bucketName, key: key);

  RestoreConfiguration? restoreConfiguration;
}
