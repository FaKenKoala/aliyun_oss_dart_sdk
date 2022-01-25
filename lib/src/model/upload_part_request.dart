import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';

import 'oss_request.dart';

/// The uploading part request class definition
class UploadPartRequest extends OSSRequest {
  String? bucketName;

  String? objectKey;

  String? uploadId;

  int partNumber;

  List<int> partContent = [];

  //run with not ui thread
  OSSProgressCallback<UploadPartRequest>? progressCallback;

  String? md5Digest;

  /// Constructor
  UploadPartRequest(
      [this.bucketName, this.objectKey, this.uploadId, this.partNumber = -1]);

}
