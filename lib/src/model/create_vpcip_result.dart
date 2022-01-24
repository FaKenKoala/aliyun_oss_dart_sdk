import 'generic_result.dart';
import 'vpc_ip.dart';

class CreateVpcipResult extends GenericResult {
  Vpcip? vpcip;

  @override
  String toString() {
    return "CreateVpcipResult [vpcip=$vpcip]";
  }
}
