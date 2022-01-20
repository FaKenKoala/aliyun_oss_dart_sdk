import 'generic_request.dart';

/// The request class which is used to abort a multipart upload.
class AbortMultipartUploadRequest extends GenericRequest {
  /// The ID of the multipart upload to abort
  String uploadId;

  AbortMultipartUploadRequest(String bucketName, String key, this.uploadId)
      : super(bucketName: bucketName, key: key);
}
