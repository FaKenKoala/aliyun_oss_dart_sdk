import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'generic_request.dart';

/// This is the request class to upload a file part in a multipart upload.
class UploadPartRequest extends GenericRequest {
  String? uploadId;

  int partNumber = 0;

  int partSize = -1;

  String? md5Digest;

  InputStream? inputStream;

  bool useChunkEncoding = false;

  // Traffic limit speed, its uint is bit/s
  int trafficLimit = 0;

  UploadPartRequest(
      [String? bucketName,
      String? key,
      this.uploadId,
      this.partNumber = 0,
      this.inputStream,
      this.partSize = -1])
      : super(bucketName: bucketName, key: key);

  /// Gets the flag of using chunked transfer encoding.
  bool isUseChunkEncoding() {
    return useChunkEncoding || (partSize == -1);
  }

  /// TODO: wombat
  BoundedInputStream buildPartialStream() {
    return BoundedInputStream(inputStream!, partSize);
  }
}
