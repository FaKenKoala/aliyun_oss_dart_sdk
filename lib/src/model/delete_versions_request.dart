import 'generic_request.dart';

/// Provides options for deleting multiple objects in a specified bucket. Once
/// deleted, the object(s) can only be restored if versioning was enabled when
/// the object(s) was deleted.
class DeleteVersionsRequest extends GenericRequest {
  bool quiet = false;

  final List<KeyVersion> _keys = [];

  DeleteVersionsRequest(String bucketName) : super(bucketName: bucketName);

  void setKeys(List<KeyVersion> keys) {
    _keys
      ..clear()
      ..addAll(keys);
  }

  List<KeyVersion> getKeys() {
    return _keys;
  }
}

/// A key to delete, with an optional version attribute.
class KeyVersion {
  final String key;
  final String? version;

  KeyVersion(this.key, [this.version]);
}
