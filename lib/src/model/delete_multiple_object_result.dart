import 'oss_result.dart';

class DeleteMultipleObjectResult extends OSSResult {
  List<String>? deletedObjects;
  List<String>? failedObjects;
  bool isQuiet = false;

  void clear() {
    deletedObjects?.clear();
    failedObjects?.clear();
  }

  void addDeletedObject(String object) {
    deletedObjects ??= [];
    deletedObjects!.add(object);
  }

  void addFailedObjects(String object) {
    failedObjects ??= [];
    failedObjects!.add(object);
  }

  List<String>? getDeletedObjects() {
    return deletedObjects;
  }

  List<String>? getFailedObjects() {
    return failedObjects;
  }
}
