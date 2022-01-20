import 'generic_request.dart';

class DeleteDirectoryRequest extends GenericRequest {
  bool deleteRecursive = false;
  String? nextDeleteToken;

  DeleteDirectoryRequest(String bucketName, String directoryName,
      [this.deleteRecursive = false, this.nextDeleteToken])
      : super(bucketName: bucketName, key: directoryName);

  void setDirectoryName(String directoryName) {
    key = directoryName;
  }

  String? getDirectoryName() {
    return key;
  }
}
