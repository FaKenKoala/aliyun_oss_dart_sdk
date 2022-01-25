import 'oss_request.dart';

class AbortMultipartUploadRequest extends OSSRequest {
  /// The name of the bucket containing the multipart upload to abort
  String bucketName;

  /// The objectKey of the multipart upload to abort
  String objectKey;

  /// The ID of the multipart upload to abort
  String uploadId;

  /// The constructor of AbortMultipartUploadRequest
  ///
  /// @param bucketName Bucket name
  /// @param objectKey  Object object key
  /// @param uploadId   Upload id of a Multipart upload
  AbortMultipartUploadRequest(this.bucketName, this.objectKey, this.uploadId);

}
