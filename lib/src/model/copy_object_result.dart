import 'generic_result.dart';

/// The result of copying an existing OSS object.
class CopyObjectResult extends GenericResult {
  // Target object's ETag
  String? etag;

  // Target object's last modified time.
  DateTime? lastModified;

  // The version ID of the new, copied object. This field will only be present
  // if object versioning has been enabled for the bucket to which the object
  // was copied.
  String? versionId;
}
