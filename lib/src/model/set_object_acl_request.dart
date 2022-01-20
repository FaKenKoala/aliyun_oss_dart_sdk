import 'canned_access_control_list.dart';
import 'generic_request.dart';

class SetObjectAclRequest extends GenericRequest {
  CannedAccessControlList? cannedACL;

  SetObjectAclRequest(String bucketName, String key,
      {String? veresionId, this.cannedACL})
      : super(bucketName: bucketName, key: key, versionId: veresionId);
}
