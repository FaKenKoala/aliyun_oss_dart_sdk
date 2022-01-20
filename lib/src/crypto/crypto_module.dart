import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/model/get_object_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_multipart_upload_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_multipart_upload_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/object_metadata.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_object.dart';
import 'package:aliyun_oss_dart_sdk/src/model/pub_object_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/put_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/upload_part_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/upload_part_result.dart';

/// An interafce used to implements different crypto module.
 abstract class  CryptoModule {
 
     PutObjectResult putObjectSecurely(PutObjectRequest req);

     OSSObject getObjectSecurely(GetObjectRequest req);
    
     ObjectMetadata getObjectSecurelyWithFile(GetObjectRequest req, File file);

     InitiateMultipartUploadResult initiateMultipartUploadSecurely(InitiateMultipartUploadRequest request, MultipartUploadCryptoContext context);

     UploadPartResult uploadPartSecurely(UploadPartRequest request, MultipartUploadCryptoContext context);
}