import 'object_metadata.dart';
import 'oss_request.dart';

class PutSymlinkRequest extends OSSRequest {
  String? bucketName;
  String? objectKey;
  String? targetObjectName;
  ObjectMetadata? metadata;
}
