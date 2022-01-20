import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/model/abort_multipart_upload_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/complete_multipart_upload_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/complete_multipart_upload_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_object_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_multipart_upload_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_multipart_upload_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_object.dart';
import 'package:aliyun_oss_dart_sdk/src/model/pub_object_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/put_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/upload_part_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/upload_part_result.dart';

/// Used to provide direct access to the underlying/original OSS client methods
/// free of any added cryptographic functionalities.
abstract class OSSDirect {
  ClientConfiguration getInnerClientConfiguration();

  PutObjectResult putObject(PutObjectRequest putObjectRequest);

  OSSObject getObject(GetObjectRequest getObjectRequest);

  void abortMultipartUpload(AbortMultipartUploadRequest request);

  CompleteMultipartUploadResult completeMultipartUpload(
      CompleteMultipartUploadRequest request);

  InitiateMultipartUploadResult initiateMultipartUpload(
      InitiateMultipartUploadRequest request);

  UploadPartResult uploadPart(UploadPartRequest request);
}
