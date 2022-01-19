import 'generic_result.dart';

class OSSSymlink extends GenericResult {
  OSSSymlink(this.symlink, this.target);

  @override
  String toString() {
    return "OSSSymlink [symlink=$symlink, target=$target]";
  }

  // symlink file key
  String symlink;

  // The original file's key
  String target;

  // The symlink file's metadata.
  ObjectMetadata? metadata;
}
