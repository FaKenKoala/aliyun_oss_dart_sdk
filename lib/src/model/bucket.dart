import 'generic_result.dart';
import 'owner.dart';
import 'storage_class.dart';

class Bucket extends GenericResult {
  // Bucket name
  String? name;

  // Bucket owner
  Owner? owner;

  // Bucket location
  String? location;

  // Created DateTime.
  DateTime? creationDateTime;

  // Storage class (Standard, IA, Archive)
  StorageClass? storageClass = StorageClass.Standard;

  // External endpoint.It could be accessed from anywhere.
  String? extranetEndpoint;

  // Internal endpoint. It could be accessed within AliCloud under the same
  // location.
  String? intranetEndpoint;

  // Region
  String? region;

  // Hierarchical namespace status, Enabled means support directory tree.
  String? hnsStatus;

  // The id of resource group.
  String? resourceGroupId;

  Bucket([this.name, String? requestId]) {
    this.requestId = requestId;
  }

  /// The override of toString(). Returns the bucket name, creation DateTime, owner
  /// and location, with optional storage class.
  ///
  @override
  String toString() {
    if (storageClass == null) {
      return "OSSBucket [name=$name, creationDateTime=$creationDateTime, owner=$owner, location=$location]";
    } else {
      return "OSSBucket [name=$name, creationDateTime=$creationDateTime, owner=$owner, location=$location, storageClass=$storageClass]";
    }
  }
}
