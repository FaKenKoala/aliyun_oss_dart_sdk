import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'callback.dart';
import 'generic_request.dart';
import 'object_metadata.dart';

class PutObjectRequest extends GenericRequest {
  File? file;
  InputStream? inputStream;

  ObjectMetadata? metadata;

  Callback? callback;
  String? process;

  // Traffic limit speed, its uint is bit/s
  int trafficLimit = 0;

  PutObjectRequest(
    String? bucketName,
    String? key, {
    this.file,
    this.inputStream,
    this.metadata,
  }) : super(
          bucketName: bucketName,
          key: key,
        );
}
