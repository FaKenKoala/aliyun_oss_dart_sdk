import 'generic_result.dart';

/// Successful response for deleting multiple objects.
class DeleteObjectsResult extends GenericResult {
  /* Successfully deleted objects */
  final List<String> _deletedObjects = [];

  /* User specified encoding method to be applied on the response. */
  String? encodingType;

  DeleteObjectsResult([List<String>? deletedObjects]) {
    _deletedObjects.addAll(deletedObjects ?? []);
  }

  List<String> getDeletedObjects() {
    return _deletedObjects;
  }

  void setDeletedObjects(List<String> deletedObjects) {
    _deletedObjects
      ..clear()
      ..addAll(deletedObjects);
  }
}
