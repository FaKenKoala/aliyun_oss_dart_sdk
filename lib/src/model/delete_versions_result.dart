import 'generic_result.dart';

/// Successful response to {@link com.aliyun.oss.OSS#deleteObjects(DeleteObjectsRequest)}.
class DeleteVersionsResult extends GenericResult {
  final List<DeletedVersion> _deletedVersions = [];

  DeleteVersionsResult(List<DeletedVersion> deletedVersions) {
    _deletedVersions.addAll(deletedVersions);
  }

  List<DeletedVersion> getDeletedVersions() {
    return _deletedVersions;
  }
}

/// A successfully deleted object.
class DeletedVersion {
  String? key;
  String? versionId;
  bool? deleteMarker;
  String? deleteMarkerVersionId;
}
