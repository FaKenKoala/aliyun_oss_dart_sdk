import 'generic_request.dart';

class DeleteVersionRequest extends GenericRequest {
  DeleteVersionRequest(String bucketName, String key, String versionId)
      : super(bucketName: bucketName, key: key, versionId: versionId);
}
