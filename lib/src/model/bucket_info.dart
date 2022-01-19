import 'bucket.dart';
import 'canned_access_control_list.dart';
import 'data_redundancy_type.dart';
import 'generic_result.dart';
import 'grant.dart';
import 'grantee.dart';
import 'permission.dart';
import 'server_side_encryption_configuration.dart';

/// Bucket info
class BucketInfo extends GenericResult {
  void grantPermission(Grantee? grantee, Permission? permission) {
    if (grantee == null || permission == null) {
      throw NullThrownError();
    }

    grants.add(Grant(grantee, permission));
  }

  Bucket? bucket;
  String? comment;
  DataRedundancyType? dataRedundancyType;
  Set<Grant?> grants = {};
  CannedAccessControlList? cannedACL;
  ServerSideEncryptionConfiguration? sseConfig;
}
