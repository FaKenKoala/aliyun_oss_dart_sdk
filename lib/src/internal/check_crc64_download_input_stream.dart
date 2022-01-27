
import 'package:aliyun_oss_dart_sdk/src/common/utils/crc64.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/oss_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/http_message.dart';

class CheckCRC64DownloadInputStream extends CheckedInputStream {
  int totalBytesRead = 0;
  int totalLength;
  String? serverCRC64;
  String? requestId;
  String? _clientCRC64;

  CheckCRC64DownloadInputStream(InputStream inStream, OSSCRC64 csum,
      this.totalLength, this.serverCRC64, this.requestId)
      : super(inStream, csum);

  @override
  int read() {
    int read = super.read();
    checkCRC64(read);
    return read;
  }

  @override
  int read(List<int> buffer, int byteOffset, int byteCount) {
    int read = super.read(buffer, byteOffset, byteCount);
    checkCRC64(read);
    return read;
  }

  void checkCRC64(int byteRead) {
    totalBytesRead += byteRead;
    if (totalBytesRead >= totalLength) {
      _clientCRC64 = checksum.value;
      OSSUtils.checkChecksum(_clientCRC64, serverCRC64, requestId);
    }
  }

  String? get clientCRC64 {
    return _clientCRC64;
  }
}

class CheckedInputStream extends InputStream {
  final InputStream? inStream;
  final OSSCRC64 checksum;
  CheckedInputStream(this.inStream, this.checksum);
}


