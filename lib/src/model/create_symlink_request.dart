import 'generic_request.dart';
import 'object_metadata.dart';

/// The request class that is used to create symlink on an object.
class CreateSymlinkRequest extends GenericRequest {
  CreateSymlinkRequest(String bucketName, String symlink, this.target)
      : super(bucketName: bucketName, key: symlink);

  String? getSymlink() {
    return key;
  }

  void setSymlink(String symlink) {
    key = symlink;
  }

  // Target file.
  String? target;

  // symlink file's metadata.
  ObjectMetadata? metadata;
}
