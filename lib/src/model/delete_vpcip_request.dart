import 'generic_request.dart';
import 'vpc_policy.dart';

class DeleteVpcipRequest extends GenericRequest {
  @override
  String toString() {
    return "DeleteVpcipRequest [vpcPolicy=$vpcPolicy]";
  }

  VpcPolicy? vpcPolicy;
}
