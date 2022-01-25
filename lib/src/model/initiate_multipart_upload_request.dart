import 'object_metadata.dart';
import 'oss_request.dart';

class InitiateMultipartUploadRequest extends OSSRequest {
  bool isSequential = false;
  String bucketName;
  String objectKey;
  ObjectMetadata? metadata;

  InitiateMultipartUploadRequest(this.bucketName, this.objectKey,
      [this.metadata]);
}
