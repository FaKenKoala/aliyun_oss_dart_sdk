import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class BinaryUtil {
  static String toBase64String(List<int> binaryData) {
    return base64.encode(binaryData).trim();
  }

  /// decode base64 string
  static List<int> fromBase64String(String base64String) {
    return base64.decode(base64String);
  }

  /// calculate md5 for bytes
  static List<int> calculateMd5(List<int> binaryData) {
    return md5.convert(binaryData).bytes;
  }

  /// calculate md5 for local file
  static List<int> calculateMd5FromFile(String filePath) {
    if (!File(filePath).existsSync()) {
      return [];
    }

    List<int> bytes = _getFileHash(md5, filePath);
    return bytes;
  }

  /// calculate md5 for bytes and string back
  static String calculateMd5Str(List<int> binaryData) {
    return getMd5Str(calculateMd5(binaryData));
  }

  static String calculateMd5StrFromStr(String binaryData) {
    return getMd5Str(calculateMd5(utf8.encode(binaryData)));
  }

  /// calculate md5 for file and string back
  static String calculateMd5StrFromPath(String filePath) {
    return getMd5Str(calculateMd5FromFile(filePath));
  }

  /// calculate md5 for bytes and base64 string back
  static String calculateBase64Md5(List<int> binaryData) {
    return toBase64String(calculateMd5(binaryData));
  }

  /// calculate md5 for local file and base64 string back
  static String calculateBase64Md5FromPath(String filePath) {
    return toBase64String(calculateMd5FromFile(filePath));
  }

  /// MD5sum for string
  static String getMd5Str(List<int>? md5bytes) {
    return md5bytes?.map((e) => e.toRadixString(16).padLeft(2, '0')).join() ??
        '';
  }

  /// Get the sha1 value of the filepath specified file
  ///
  /// @param filePath The filepath of the file
  /// @return The sha1 value
  static String? fileToSHA1(String filePath) {
    if (!File(filePath).existsSync()) {
      return null;
    }

    List<int> bytes = _getFileHash(sha1, filePath);
    return convertHashToString(bytes);
  }

  static List<int> _getFileHash(Hash hash, String filePath) {
    RandomAccessFile accessFile = File(filePath).openSync();
    final output = AccumulatorSink<Digest>();
    final input = hash.startChunkedConversion(output);

    int fileLength = accessFile.lengthSync();

    /// 块大小为8KB比较合适: https://docs.oracle.com/cd/E19253-01/817-5093/fsfilesysappx-9/index.html
    int blockSize = 8 * 1024;
    while (accessFile.positionSync() < fileLength) {
      input.add(accessFile.readSync(blockSize));
    }
    input.close();
    List<int> bytes = output.events.single.bytes;
    output.close();
    return bytes;
  }

  /// Convert the hash bytes to hex digits string
  static String convertHashToString(List<int> hashBytes) {
    return hashBytes
        .map((e) => ((e & 0xff) + 0x100).toRadixString(16).substring(1))
        .join()
        .toLowerCase();
  }
}
