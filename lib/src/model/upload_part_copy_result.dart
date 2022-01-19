import 'generic_result.dart';
import 'part_e_tag.dart';

class UploadPartCopyResult extends GenericResult {
  /// Gets the part ETag.
  PartETag getPartETag() {
    return PartETag(partNumber, eTag);
  }

  int partNumber = 0;
  String? eTag;
}
