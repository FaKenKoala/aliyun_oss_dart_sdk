import 'object_metadata.dart';
import 'oss_request.dart';
import 'part_e_tag.dart';

class CompleteMultipartUploadRequest extends OSSRequest {
  /// The name of the bucket containing the multipart upload to complete
  String bucketName;

  /// The objectKey of the multipart upload to complete
  String objectKey;

  /// The ID of the multipart upload to complete
  String uploadId;

  /// The list of part numbers and ETags to use when completing the multipart upload
  List<PartETag> partETags = [];

  Map<String, String>? callbackParam;

  Map<String, String>? callbackVars;

  ObjectMetadata? metadata;

  CompleteMultipartUploadRequest(
      this.bucketName, this.objectKey, this.uploadId, this.partETags);
}
