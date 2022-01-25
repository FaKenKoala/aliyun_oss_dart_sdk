import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/callback/oss_retry_callback.dart';

import 'object_metadata.dart';
import 'oss_request.dart';

class PutObjectRequest extends OSSRequest {
  String bucketName;
  String objectKey;

  String? uploadFilePath;

  List<int>? uploadData;

  Uri? uploadUri;

  ObjectMetadata? metadata;

  Map<String, String>? callbackParam;

  Map<String, String>? callbackVars;

  // run with not ui thread
  OSSProgressCallback<PutObjectRequest>? progressCallback;

  // run with not ui thread
  OSSRetryCallback? retryCallback;

  PutObjectRequest(this.bucketName, this.objectKey,
      {this.uploadFilePath, this.metadata, this.uploadUri, this.uploadData});
}
