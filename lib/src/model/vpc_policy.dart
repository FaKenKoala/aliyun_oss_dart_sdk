import 'generic_request.dart';

class VpcPolicy extends GenericRequest {
  @override
  String toString() {
    return "VpcPolicy [region=$region, vpcId=$vpcId, vip=$vip]";
  }

  String? region;
  String? vpcId;
  String? vip;
}
