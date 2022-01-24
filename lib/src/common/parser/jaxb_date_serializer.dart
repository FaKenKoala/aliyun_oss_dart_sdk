import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';

class JaxbDateSerializer extends XmlAdapter<String, DateTime> {
  @override
  String marshal(DateTime date) {
    return DateUtil.formatRfc822Date(date);
  }

  @override
  DateTime unmarshal(String date) {
    return DateUtil.parseRfc822Date(date);
  }
}
