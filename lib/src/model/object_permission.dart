/// 表示OSSObject访问控制权限。
enum ObjectPermission {
  /// 表明某个Object是私有资源，即只有该Object的Owner拥有该Object的读写权限，
  /// 其他的用户没有权限操作该Object。
  Private,

  /// 表明某个Object是公共读资源，即非Object Owner只有该Object的读权限，
  /// 而Object Owner拥有该Object的读写权限
  PublicRead,

  /// 表明某个Object是公共读写资源，即所有用户拥有对该Object的读写权限。
  PublicReadWrite,

  /// 表明该Object ACL遵循Bucket ACL。即：如果Bucket是private的，则该object也是private的；
  /// 如果该object是public-read-write的，则该object也是public-read-write的。
  Default,

  /// 表明该Object ACL为未知类型，当出现该类型时，请联系OSS管理员获取更多信息。
  Unknown,
}

extension ObjectPermissionX on ObjectPermission {
  String get customName {
    switch (this) {
      case ObjectPermission.Private:
        return 'private';
      case ObjectPermission.PublicRead:
        return 'public-read';
      case ObjectPermission.PublicReadWrite:
        return 'public-read-write';
      case ObjectPermission.Default:
        return 'default';
      case ObjectPermission.Unknown:
      default:
        return '';
    }
  }

  static ObjectPermission parsePermission(String str) {
    final List<ObjectPermission> knownPermissions = [
      ObjectPermission.Private,
      ObjectPermission.PublicRead,
      ObjectPermission.PublicReadWrite,
      ObjectPermission.Default
    ];
    for (ObjectPermission permission in knownPermissions) {
      if (permission.customName == str) {
        return permission;
      }
    }

    return ObjectPermission.Unknown;
  }
}
