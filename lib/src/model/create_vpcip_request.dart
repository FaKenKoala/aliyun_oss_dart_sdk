import 'generic_request.dart';

class CreateVpcipRequest extends GenericRequest {
  @override
  String toString() {
    return "CreateVpcipRequest [region=$region, vSwitchId=$vSwitchId, labal=$label]";
  }

  String? region;
  String? vSwitchId;
  String? label;
}
