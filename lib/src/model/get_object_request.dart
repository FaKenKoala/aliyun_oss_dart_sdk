import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';
import 'oss_request.dart';
import 'range.dart';

class GetObjectRequest extends OSSRequest {
  //  Object bucket's name
  String bucketName;

  // Object Key
  String objectKey;

  // Gets the range of the object to return (starting from 0 to the object length -1)
  Range? range;

  // image processing parameters
  String? xOssProcess;

  // progress callback run with not ui thread
  OSSProgressCallback? progressListener;

  // request headers
  Map<String, String>? requestHeaders;

  GetObjectRequest(this.bucketName, this.objectKey);
}
