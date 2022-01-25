import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/model/range.dart';

import 'oss_request.dart';

class ResumableDownloadRequest extends OSSRequest {
  //  Object bucket's name
  String bucketName;

  // Object Key
  String objectKey;

  // Gets the range of the object to return (starting from 0 to the object length -1)
  Range? range;

  // progress callback run with not ui thread
  OSSProgressCallback? progressListener;

  String downloadToFilePath;

  bool enableCheckPoint = false;
  String? checkPointFilePath;

  int partSize = 256 * 1024;

  Map<String, String>? requestHeader;

  ResumableDownloadRequest(
      this.bucketName, this.objectKey, this.downloadToFilePath,
      {this.checkPointFilePath});

  String getTempFilePath() {
    return downloadToFilePath + ".tmp";
  }
}
