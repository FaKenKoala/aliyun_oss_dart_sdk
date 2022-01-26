import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/aliyun_oss_dart_sdk.dart';
import 'package:crypto/crypto.dart';

void main() {
  final result = md5.convert(utf8.encode('hello')).bytes;
  print('dart结果: ${result}');
}
