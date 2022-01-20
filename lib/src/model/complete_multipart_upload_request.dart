import 'callback.dart';
import 'canned_access_control_list.dart';
import 'generic_request.dart';
import 'part_e_tag.dart';

/// The request class that is used to complete a multipart upload. It wraps all
/// parameters needed to complete a multipart upload.
class CompleteMultipartUploadRequest extends GenericRequest {
  /// The ID of the multipart upload to complete
  String uploadId;

  /// The list of part numbers and ETags to use when completing the multipart
  /// upload
  List<PartETag> partETags = [];

  /// The access control list for multipart uploaded object
  CannedAccessControlList? cannedACL;

  /// callback
  Callback? callback;

  /// process
  String? process;

  CompleteMultipartUploadRequest(
      String bucketName, String key, this.uploadId, this.partETags)
      : super(bucketName: bucketName, key: key);
}
