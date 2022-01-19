import 'generic_result.dart';
import 'part_e_tag.dart';

class UploadPartResult extends GenericResult {
  int partNumber = 0;
  int partSize = 0;
  String? eTag;

  PartETag getPartETag() {
    return PartETag(partNumber, eTag, partSize, clientCRC);
  }
}
