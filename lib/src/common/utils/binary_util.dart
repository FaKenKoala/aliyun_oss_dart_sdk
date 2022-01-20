import 'dart:convert';
import 'package:crypto/crypto.dart';

class BinaryUtil {
  static final List<String> HEX_DIGITS = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ];

  static String toBase64String(List<int> binaryData) {
    return base64.encode(binaryData);
  }

  static List<int> fromBase64String(String base64String) {
    return base64.decode(base64String).toList();
  }

  static List<int> calculateMd5(List<int> binaryData) {
    return md5.convert(binaryData).bytes;
  }

  static String encodeMD5(List<int> binaryData) {
    List<int> md5Bytes = calculateMd5(binaryData);
    int len = md5Bytes.length;
    List<String> buf = List.filled(len * 2, '');
    for (int i = 0; i < len; i++) {
      buf[i * 2] = HEX_DIGITS[(md5Bytes[i] >>> 4) & 0x0f];
      buf[i * 2 + 1] = HEX_DIGITS[md5Bytes[i] & 0x0f];
    }
    return buf.join();
  }
}
