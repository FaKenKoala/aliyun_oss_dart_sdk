import 'package:aliyun_oss_dart_sdk/src/model/sse_algorithm.dart';

/// Describes the default server-side encryption to apply to new objects in the bucket.
/// If Put Object request does not specify any
/// server-side encryption, this default encryption will be applied.
class ServerSideEncryptionByDefault {
  String? sseAlgorithm;
  String? kmsMasterKeyID;
  String? kmsDataEncryption;
  ServerSideEncryptionByDefault({String? sseAlgorithm, SSEAlgorithm? algorithm})
      : sseAlgorithm = sseAlgorithm ?? algorithm?.name;
}
