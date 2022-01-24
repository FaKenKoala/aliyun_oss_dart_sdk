import 'package:aliyun_oss_dart_sdk/src/common/utils/crc64.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_upload_operation.dart';

import 'request_handler.dart';
import 'request_message.dart';

class RequestChecksumHanlder implements RequestHandler {
  @override
  void handle(RequestMessage request) {
    InputStream? originalInputStream = request.content;
    if (originalInputStream == null) {
      return;
    }

    CRC64 crc = CRC64();
    CheckedInputStream checkedInputstream =
        CheckedInputStream(originalInputStream, crc);
    request.content = checkedInputstream;
  }
}
