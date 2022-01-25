import 'oss_request.dart';

class ListMultipartUploadsRequest extends OSSRequest {
  String bucketName;

  String? delimiter;

  String? prefix;

  int? maxUploads;

  String? keyMarker;

  String? uploadIdMarker;

  String? encodingType;

  ListMultipartUploadsRequest(this.bucketName);
}
