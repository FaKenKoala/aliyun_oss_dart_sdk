import 'package:aliyun_oss_dart_sdk/src/model/generic_result.dart';

class VpcIp extends GenericResult {
  String? region;
  String? vpcId;
  String? vip;
  String? label;

  @override
  String toString() {
    return "VpcIp [region=$region, vpcId=$vpcId, vip=$vip , label=$label ]";
  }
}
