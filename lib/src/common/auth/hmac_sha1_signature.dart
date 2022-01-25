import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/binary_util.dart';
import 'package:crypto/crypto.dart';

/// Hmac-SHA1 signature
class HmacSHA1Signature {
  String? computeSignature(String key, String data) {
    OSSLog.logDebug('HmacSHA1', write2local: false);
    String? sign;
    try {
      OSSLog.logDebug("sign start");
      List<int> signData =
          Hmac(sha1, utf8.encode(key)).convert(utf8.encode(data)).bytes;
      OSSLog.logDebug("base64 start");
      sign = BinaryUtil.toBase64String(signData);
    } catch (ex) {
      throw Exception("Unsupported algorithm");
    }
    return sign;
  }
}
