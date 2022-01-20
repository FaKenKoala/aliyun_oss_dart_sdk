import 'canned_access_control_list.dart';
import 'generic_request.dart';

class SetBucketAclRequest extends GenericRequest {
  CannedAccessControlList? cannedACL;

  SetBucketAclRequest(String bucketName, [this.cannedACL])
      : super(bucketName: bucketName);
}
