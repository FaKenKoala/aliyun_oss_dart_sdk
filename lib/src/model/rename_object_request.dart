import 'generic_request.dart';

class RenameObjectRequest extends GenericRequest {
  String? sourceObjectName;

  RenameObjectRequest(
      String? bucketName, this.sourceObjectName, String? destinationObjectName)
      : super(bucketName: bucketName, key: destinationObjectName);

  String? get destinationObjectName {
    return key;
  }

  set destinationObjectName(String? destinationObjectName) {
    key = destinationObjectName;
  }
}
