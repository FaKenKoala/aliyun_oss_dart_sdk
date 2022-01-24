import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/common/utils/binary_util.dart';
import 'package:crypto/crypto.dart';

import 'service_signature.dart';

/// Used for computing Hmac-SHA256 signature.
class HmacSHA256Signature extends ServiceSignature {
  @override
  Hash getAlgorithm() {
    return sha256;
  }

  @override
  String computeSignature(String key, String data) {
    try {
      return BinaryUtil.toBase64String(
          sign(utf8.encode(key), utf8.encode(data), getAlgorithm()));
    } catch (ex) {
      throw Exception("Unsupported algorithm: ${getAlgorithm()}, $ex");
    }
  }
}
