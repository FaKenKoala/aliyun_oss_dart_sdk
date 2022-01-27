import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';
import 'object_metadata.dart';
import 'oss_request.dart';

class AppendObjectRequest extends OSSRequest {
  String bucketName;
  String objectKey;

  String? uploadFilePath;

  List<int>? uploadData;

  Uri? uploadUri;

  ObjectMetadata? metadata;

  OSSProgressCallback<AppendObjectRequest>? progressCallback;

  int position = -1;

  String? initCRC64;

  AppendObjectRequest(
    this.bucketName,
    this.objectKey, {
    this.uploadFilePath,
    this.metadata,
    this.uploadData,
    this.uploadUri,
  });
}
