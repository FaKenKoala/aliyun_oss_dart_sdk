import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/model/object_metadata.dart';

import 'pub_object_request.dart';

class AppendObjectRequest extends PutObjectRequest {
  int? position;
  int? initCRC;

  // Traffic limit speed, its uint is bit/s
  int trafficLimit = 0;

  AppendObjectRequest(
    String bucketName,
    String key,
    File file, {
    ObjectMetadata? metadata,
    InputStream? input,
  }) : super(
          bucketName,
          key,
          file: file,
          metadata: metadata,
          inputStream: input,
        );
}
