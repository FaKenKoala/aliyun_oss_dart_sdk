/// The predefined Access Control List (ACL)

enum CannedAccessControlList {
  /// This is only for object, means the permission inherits the bucket's
  /// permission.
  $default,

  /// The owner has the {@link Permission#FullControl}, other
  /// {@link GroupGrantee#AllUsers} does not have access.
  private,

  /// The owner has the {@link Permission#FullControl}, other
  /// {@link GroupGrantee#AllUsers} have read-only access.
  publicRead,

  /// Both the owner and {@link GroupGrantee#AllUsers} have
  /// {@link Permission#FullControl}. It's not safe and thus not recommended.
  publicReadWrite,
}

extension CannedAccessControlListX on CannedAccessControlList {
  String get customName {
    switch (this) {
      case CannedAccessControlList.private:
        return "private";
      case CannedAccessControlList.publicRead:
        return "public-read";
      case CannedAccessControlList.publicReadWrite:
        return "public-read-write";
      case CannedAccessControlList.$default:
      default:
        return "default";
    }
  }

  static CannedAccessControlList parse(String acl) {
    for (CannedAccessControlList cacl in CannedAccessControlList.values) {
      if (cacl.customName == acl) {
        return cacl;
      }
    }

    throw ArgumentError("Unable to parse the provided acl $acl");
  }
}
