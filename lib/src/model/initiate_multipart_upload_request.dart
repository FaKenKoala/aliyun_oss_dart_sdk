import 'generic_request.dart';
import 'object_metadata.dart';

/// This is the request that is used to initiate a multipart upload.
class InitiateMultipartUploadRequest extends GenericRequest {
  ObjectMetadata? objectMetadata;
  bool? sequentialMode;

  InitiateMultipartUploadRequest(String bucketName, String key,
      [this.objectMetadata])
      : super(bucketName: bucketName, key: key);
}
