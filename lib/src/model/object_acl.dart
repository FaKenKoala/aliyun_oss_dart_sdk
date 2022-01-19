import 'generic_result.dart';
import 'object_permission.dart';
import 'owner.dart';

/// OSS Object ACL。
class ObjectAcl extends GenericResult {
  Owner? owner;
  ObjectPermission? permission;
  String? versionId;

  @override
  String toString() {
    return "AccessControlList [owner=$owner, permission=$permission]";
  }
}
