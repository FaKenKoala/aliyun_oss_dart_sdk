import 'oss_request.dart';

class ListPartsRequest extends OSSRequest {
  String bucketName;

  String objectKey;

  String uploadId;

  int maxParts = 0;

  int partNumberMarker = 0;

  ListPartsRequest(this.bucketName, this.objectKey, this.uploadId);
}
