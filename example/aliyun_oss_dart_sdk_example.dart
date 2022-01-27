import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crclib/catalog.dart';
import 'package:crclib/crclib.dart';
import 'package:crypto/crypto.dart';

void main() {
  String? test = '10';
  print(test.applyNotNull((p0) {
     p0 + "20";
  }));
  // String path = '/Users/wombat/Downloads/flutter_macos_2.5.1-stable.zip';
  // // calculate(sha1, path, expectSha1);
  // // calculate(md5, path, expectMd5);
  // calculateCRC64(path, expectCRC64);
}

// SHA-1结果: 9e3aaac669b4949cbf4a45459ada3520d61a17b0
// SHA-1历时: 4004 ms
// MD5结果: b7cb91dfde2cac6ca6063507d25610f3
// MD5历时: 3761 ms
String expectSha1 = '9e3aaac669b4949cbf4a45459ada3520d61a17b0';
String expectMd5 = 'b7cb91dfde2cac6ca6063507d25610f3';
String expectCRC64 = '2b47be352fd70dd1';

calculate(Hash hash, String path, String expect) {
  int start = DateTime.now().millisecondsSinceEpoch;
  final bytes = getFileHash(hash, path);

  int elapse = DateTime.now().millisecondsSinceEpoch - start;
  print('耗时$hash: $elapse ms');

  String result = convertHashToString(bytes);
  print('结果$hash: $result, ${expect == result}');
}

calculateCRC64(String filePath, String expect) {
  int start = DateTime.now().millisecondsSinceEpoch;

  RandomAccessFile accessFile = File(filePath).openSync();
  final output = AccumulatorSink<CrcValue>();
  final input = Crc64Xz().startChunkedConversion(output);

  int fileLength = accessFile.lengthSync();

  /// 块大小为8KB比较合适: https://docs.oracle.com/cd/E19253-01/817-5093/fsfilesysappx-9/index.html
  int blockSize = 8 * 1024;
  while (accessFile.positionSync() < fileLength) {
    input.add(accessFile.readSync(blockSize));
  }
  input.close();
  BigInt bytes = output.events.single.toBigInt();
  output.close();

  int elapse = DateTime.now().millisecondsSinceEpoch - start;
  print('耗时crc64: $elapse ms');
  String result = bytes.toRadixString(16);
  BigInt result11 = BigInt.parse(result, radix: 16);
  print('${result11.toString()}');

  print('结果crc64: $result, ${expect == result}');
}

// 5c98a324e82c7e001791732658c73b8c52b513e3
List<int> getFileHash(Hash hash, String filePath) {
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
String convertHashToString(List<int> hashBytes) {
  return hashBytes
      .map((e) => ((e & 0xff) + 0x100).toRadixString(16).substring(1))
      .join()
      .toLowerCase();
}

extension on Object? {
  applyNotNull(Function(dynamic) func) {
    if (this != null) {
      return func(this);
    }
  }
}
