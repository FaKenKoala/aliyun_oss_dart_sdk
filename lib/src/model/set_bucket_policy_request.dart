import 'generic_request.dart';

class SetBucketPolicyRequest extends GenericRequest {
  String? policyText;

  SetBucketPolicyRequest(String bucketName, [this.policyText])
      : super(bucketName: bucketName);

}
