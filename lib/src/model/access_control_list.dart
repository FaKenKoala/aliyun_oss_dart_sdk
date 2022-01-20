import 'canned_access_control_list.dart';
import 'generic_result.dart';
import 'grant.dart';
import 'grantee.dart';
import 'owner.dart';
import 'permission.dart';

/// The class encapsulates the access control list (ACL) information of OSS. It
/// includes an owner and a group of &lt;{@link Grantee},{@link Permission}&gt; pair.
class AccessControlList extends GenericResult {
  Set<Grant> grants = {};
  CannedAccessControlList? cannedACL;
  Owner? owner;

  void grantPermission(Grantee? grantee, Permission? permission) {
    if (grantee == null || permission == null) {
      throw NullThrownError();
    }

    grants.add(Grant(grantee, permission));
  }

  void revokeAllPermissions(Grantee? grantee) {
    if (grantee == null) {
      throw NullThrownError();
    }

    List<Grant> grantsToRemove = [];
    for (Grant g in grants) {
      if (g.grantee == grantee) {
        grantsToRemove.add(g);
      }
    }
    grants.removeAll(grantsToRemove);
  }

  @override
  String toString() {
    return "AccessControlList [owner=$owner, ACL=$cannedACL]";
  }
}
