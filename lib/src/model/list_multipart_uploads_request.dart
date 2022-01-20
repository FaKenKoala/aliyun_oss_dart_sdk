import 'generic_request.dart';

/// This is the request class to list executing multipart uploads under a bucket.
class ListMultipartUploadsRequest extends GenericRequest {
  String? delimiter;

  String? prefix;

  int? maxUploads;

  String? keyMarker;

  String? uploadIdMarker;

  String? encodingType;

  ListMultipartUploadsRequest(String bucketName)
      : super(bucketName: bucketName);
}
