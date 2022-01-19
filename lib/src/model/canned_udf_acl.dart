enum CannedUdfAcl {
  /// Only the owner has the access. It's the default Acl.
  private,

  /// All users have the access, not recommended.
  public,
}

extension CannedUdfAclX on CannedUdfAcl {
  static CannedUdfAcl parse(String acl) {
    for (CannedUdfAcl cacl in CannedUdfAcl.values) {
      if (cacl.name == acl) {
        return cacl;
      }
    }

    throw ArgumentError("Unable to parse the provided acl $acl");
  }
}
