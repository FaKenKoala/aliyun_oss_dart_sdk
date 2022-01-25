import 'canned_access_control_list.dart';
import 'oss_result.dart';
import 'owner.dart';

class GetBucketACLResult extends OSSResult {
  // bucket owner
  late Owner bucketOwner;

  // bucket's ACL
  CannedAccessControlList? bucketACL;

  GetBucketACLResult() {
    bucketOwner = Owner();
  }

  String? getBucketOwner() {
    return bucketOwner.displayName;
  }

  void setBucketOwner(String ownerName) {
    bucketOwner.displayName = ownerName;
  }

  String? getBucketOwnerID() {
    return bucketOwner.id;
  }

  void setBucketOwnerID(String id) {
    bucketOwner.id = id;
  }

  String? getBucketACL() {
    String? acl;
    if (bucketACL != null) {
      acl = bucketACL.toString();
    }
    return acl;
  }

  void setBucketACL(String bucketACL) {
    this.bucketACL = parseACL(bucketACL);
  }
}
