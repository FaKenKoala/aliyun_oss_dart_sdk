import 'oss_result.dart';

class CopyObjectResult extends OSSResult {
  // Target object's ETag
  String? etag;

  // Target Object's last modified time
  DateTime? lastModified;
}
