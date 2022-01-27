import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'multipart_upload_request.dart';
import 'object_metadata.dart';

class ResumableUploadRequest extends MultipartUploadRequest {
  bool deleteUploadOnCancelling = true;
  String? _recordDirectory;

  ResumableUploadRequest(String bucketName, String objectKey,
      {String? uploadFilePath,
      ObjectMetadata? metadata,
      String? recordDirectory,
      Uri? uploadUri})
      : super(bucketName, objectKey,
            uploadFilePath: uploadFilePath,
            metadata: metadata,
            uploadUri: uploadUri) {
    this.recordDirectory = recordDirectory;
  }

  String? getRecordDirectory() {
    return _recordDirectory;
  }

  /// Sets the checkpoint files' directory (the directory must exist and is absolute directory path)
  set recordDirectory(String? recordDirectory) {
    if (recordDirectory.notNullOrEmpty) {
      Directory directory = Directory(recordDirectory!);
      if (!directory.existsSync()) {
        throw ArgumentError(
            "Record directory must exist, and it should be a directory!");
      }
    }
    this.recordDirectory = recordDirectory;
  }
}
