import 'generic_result.dart';
import 'object_metadata.dart';

class OSSSymlink extends GenericResult {
  OSSSymlink(this.symlink, this.target);

  // symlink file key
  String symlink;

  // The original file's key
  String target;

  // The symlink file's metadata.
  ObjectMetadata? metadata;

  @override
  String toString() {
    return "OSSSymlink [symlink=$symlink, target=$target]";
  }
}
