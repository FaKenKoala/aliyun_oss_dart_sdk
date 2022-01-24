import 'package:aliyun_oss_dart_sdk/src/model/generic_result.dart';

class Vpcip extends GenericResult {
  String? region;
  String? vpcId;
  String? vip;
  String? label;

  @override
  String toString() {
    return "Vpcip [region=$region, vpcId=$vpcId, vip=$vip , label=$label ]";
  }
}
