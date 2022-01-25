import 'oss_request.dart';

class DeleteMultipleObjectRequest extends OSSRequest {
  String bucketName;
  List<String> objectKeys;
  bool isQuiet;

  DeleteMultipleObjectRequest(this.bucketName, this.objectKeys, this.isQuiet);
}
