import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';

import 'object_metadata.dart';
import 'oss_request.dart';

class MultipartUploadRequest
    extends OSSRequest {
  String bucketName;
  String objectKey;
  String? uploadId;

  String? uploadFilePath;
  Uri? uploadUri;
  int partSize = 256 * 1024;

  ObjectMetadata? metadata;

  Map<String, String>? callbackParam;
  Map<String, String>? callbackVars;

  OSSProgressCallback<MultipartUploadRequest>? progressCallback;

  MultipartUploadRequest(this.bucketName, this.objectKey,
      {this.uploadFilePath, this.metadata, this.uploadUri});
}
