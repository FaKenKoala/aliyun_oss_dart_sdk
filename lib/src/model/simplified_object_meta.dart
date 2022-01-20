import 'generic_result.dart';

/// The simplified metadata information of an OSS object. It includes ETag, size,
/// last modified.
class SimplifiedObjectMeta extends GenericResult {
  String? eTag;
  int size = 0;
  DateTime? lastModified;
  String? versionId;

  @override
  String toString() {
    return "ObjectMeta [ETag=$eTag, Size=$size, LastModified=$lastModified]";
  }
}
