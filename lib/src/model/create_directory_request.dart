import 'generic_request.dart';

class CreateDirectoryRequest extends GenericRequest {
  CreateDirectoryRequest(String bucketName, String directoryName)
      : super(bucketName: bucketName, key: directoryName);

  void setDirectoryName(String directoryName) {
    key = directoryName;
  }

  String? getDirectoryName() {
    return key;
  }
}
