import 'canned_access_control_list.dart';
import 'owner.dart';

class OSSBucketSummary {
  // Bucket name
  String? name;

  // Bucket owner
  Owner? owner;

  // Created date.
  DateTime? createDate;

  // Bucket location
  String? location;

  // External endpoint.It could be accessed from anywhere.
  String? extranetEndpoint;

  // Internal endpoint. It could be accessed within AliCloud under the same
  // location.
  String? intranetEndpoint;

  // Storage class (Standard, IA, Archive)
  String? storageClass;

  CannedAccessControlList? acl;

  String? getAcl() {
    String? bucketAcl;
    if (acl != null) {
      bucketAcl = acl.toString();
    }
    return bucketAcl;
  }

  void setAcl(String aclString) {
    acl = parseACL(aclString);
  }

  @override
  String toString() {
    if (storageClass == null) {
      return "OSSBucket [name=$name"
          ", creationDate=$createDate"
          ", owner=$owner"
          ", location=$location"
          "]";
    } else {
      return "OSSBucket [name=$name"
          ", creationDate=$createDate"
          ", owner=$owner"
          ", location=$location"
          ", storageClass=$storageClass"
          "]";
    }
  }
}
