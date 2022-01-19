import 'grantee.dart';
import 'permission.dart';

/// ACL's permission grant information.
class Grant {
  Grant(this.grantee, this.permission);

  final Grantee grantee;
  final Permission permission;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Grant &&
            other.grantee == grantee &&
            other.permission == permission;
  }

  @override
  int get hashCode {
    return (grantee.getIdentifier() + ":" + permission.toString()).hashCode;
  }

  @override
  String toString() {
    return "Grant [grantee=$grantee,permission=permission ";
  }
}
