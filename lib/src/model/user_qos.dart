import 'generic_result.dart';

class UserQos extends GenericResult {
  UserQos([this.storageCapacity]);

  int? storageCapacity;

  bool hasStorageCapacity() {
    return storageCapacity != null;
  }
}
