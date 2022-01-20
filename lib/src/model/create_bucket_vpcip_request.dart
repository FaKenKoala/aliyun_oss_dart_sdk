import 'generic_request.dart';
import 'vpc_policy.dart';

class CreateBucketVpcipRequest extends GenericRequest {
  @override
  String toString() {
    return "CreateBucketVpcipRequest [vpcPolicy=$vpcPolicy]";
  }

  VpcPolicy? vpcPolicy;
}
