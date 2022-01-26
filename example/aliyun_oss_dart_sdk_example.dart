import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/aliyun_oss_dart_sdk.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:crclib/catalog.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

void main() {
  print(Crc64Xz()
      .convert(utf8.encode('hello'))
      .toBigInt()
      .toRadixString(16)
      .toUpperCase());
  String expect = '9B1EDAE5DBB937B1';
  String actual = Crc64Xz()
      .convert(utf8.encode('hello'))
      .toBigInt()
      .toRadixString(16)
      .toUpperCase();
  int expectInt = -7269132067760687183;
  int actualInt = Crc64Xz().convert(utf8.encode('hello')).toBigInt().toInt();
  Crc64Xz().convert(utf8.encode('hello'));
  print(actualInt);
  print('相等吗: ${expect == actual}');
}

/// -7269132067760687183