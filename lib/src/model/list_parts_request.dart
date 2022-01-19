import 'generic_request.dart';

/// This is the request class to list parts of a ongoing multipart upload.
class ListPartsRequest extends GenericRequest {
  String? uploadId;

  int? maxParts;

  int? partNumberMarker;

  String? encodingType;

  ListPartsRequest([
    String? bucketName,
    String? key,
    this.uploadId,
  ]) : super(bucketName: bucketName, key: key);
}
