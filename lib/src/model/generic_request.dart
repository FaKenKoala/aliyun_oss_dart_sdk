import 'payer.dart';

class GenericRequest {
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
