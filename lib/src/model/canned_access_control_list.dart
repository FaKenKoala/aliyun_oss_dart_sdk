enum CannedAccessControlList {
  Private,

  PublicRead,

  PublicReadWrite,

  Default,
}

extension on CannedAccessControlList {
  String get customName {
    switch (this) {
      case CannedAccessControlList.Private:
        return 'private';
      case CannedAccessControlList.PublicRead:
        return 'public-read';
      case CannedAccessControlList.PublicReadWrite:
        return 'public-read-write';
      case CannedAccessControlList.Default:
      default:
        return 'default';
    }
  }
}

CannedAccessControlList? parseACL(String aclStr) {
  CannedAccessControlList? currentAcl;
  for (CannedAccessControlList acl in CannedAccessControlList.values) {
    if (acl.customName == aclStr) {
      currentAcl = acl;
      break;
    }
  }
  return currentAcl;
}
