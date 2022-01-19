/// 包含通过Multipart上传模式上传的Part的摘要信息。 The summary information of the part in a
/// multipart upload.
///
class PartSummary {
  int partNumber = 0;

  DateTime? lastModified;

  String? eTag;

  int size = 0;
}
