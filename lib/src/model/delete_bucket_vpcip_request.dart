import 'generic_request.dart';
import 'vpc_policy.dart';

class DeleteBucketVpcipRequest extends GenericRequest {
  @override
  String toString() {
    return "DeleteBucketVpcipRequest [vpcPolicy=$vpcPolicy]";
  }

  VpcPolicy? vpcPolicy;
}
