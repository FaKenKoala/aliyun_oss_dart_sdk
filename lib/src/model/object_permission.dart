///  The enum of {@link OSSObject}'s access control permission.
// ignore_for_file: constant_identifier_names

enum ObjectPermission {
  /// Private object. Only the owner has the full control of the object. Other
  /// users don't have access permission unless they're explicitly granted with
  /// some permission.

  private,

  /// Owner has the full control of the object. Other users only have read
  /// access.

  publicRead,

  /// The object is public to everyone and all users have read write
  /// permission.

  publicReadWrite,

  /// The object's ACL inherits the bucket's ACL. For example, if the bucket is
  /// private, then the object is also private.

  $default,

  /// The object's ACL is unknown, which indicates something not right about
  /// the object. Please contact OSS support for more information when this
  /// happens.

  unknown,
}

extension ObjectPermissionX on ObjectPermission {
  String get customName {
    switch (this) {
      case ObjectPermission.private:
        return "private";
      case ObjectPermission.publicRead:
        return "public-read";
      case ObjectPermission.publicReadWrite:
        return "public-read-write";
      case ObjectPermission.$default:
        return "default";
      case ObjectPermission.unknown:
      default:
        return "";
    }
  }

  static ObjectPermission parsePermission(String str) {
    final List<ObjectPermission> knownPermissions = [
      ObjectPermission.private,
      ObjectPermission.publicRead,
      ObjectPermission.publicReadWrite,
      ObjectPermission.$default
    ];
    for (ObjectPermission permission in knownPermissions) {
      if (permission.customName == str) {
        return permission;
      }
    }

    return ObjectPermission.unknown;
  }
}
