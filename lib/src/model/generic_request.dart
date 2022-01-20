import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';

import 'payer.dart';

class GenericRequest extends WebServiceRequest{
  GenericRequest({
    this.bucketName,
    this.key,
    this.versionId,
  });
  
  String? bucketName;
  String? key;
  String? versionId;

  Payer? payer;
}
