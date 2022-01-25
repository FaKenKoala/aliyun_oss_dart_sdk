import 'canned_access_control_list.dart';
import 'oss_result.dart';
import 'owner.dart';

class GetObjectACLResult extends OSSResult {
  // object owner
  late Owner objectOwner;

  // object's ACL
  CannedAccessControlList? objectACL;

  GetObjectACLResult() {
    objectOwner = Owner();
  }

  String? getObjectOwner() {
    return objectOwner.displayName;
  }

  void setObjectOwner(String ownerName) {
    objectOwner.displayName = ownerName;
  }

  String? getObjectOwnerID() {
    return objectOwner.id;
  }

  void setObjectOwnerID(String id) {
    objectOwner.id = id;
  }

  String? getObjectACL() {
    String? acl;
    if (objectACL != null) {
      acl = objectACL.toString();
    }
    return acl;
  }

  void setObjectACL(String objectACL) {
    this.objectACL = parseACL(objectACL);
  }
}
