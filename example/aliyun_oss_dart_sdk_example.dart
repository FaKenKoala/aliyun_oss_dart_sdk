import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/aliyun_oss_dart_sdk.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

void main() {
  print(DateUtil.currentFixedSkewedTimeInRFC822Format());
}
