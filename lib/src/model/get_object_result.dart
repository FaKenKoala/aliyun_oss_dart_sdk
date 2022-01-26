import 'package:aliyun_oss_dart_sdk/src/internal/check_crc64_download_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/http_message.dart';

import 'object_metadata.dart';
import 'oss_result.dart';

class GetObjectResult extends OSSResult {
  // object metadata
  ObjectMetadata metadata = ObjectMetadata();

  // content length
  int contentLength = 0;

  // object's content
  InputStream? objectContent;

  @override
  int get clientCRC {
    if (objectContent != null &&
        (objectContent is CheckCRC64DownloadInputStream)) {
      return objectContent.getClientCRC64();
    }
    return super.clientCRC;
  }
}