import 'generic_result.dart';
import 'multipart_upload.dart';

/// The entity class that wraps all information about multipart upload.
class MultipartUploadListing extends GenericResult {
  String? bucketName;

  String? keyMarker;

  String? delimiter;

  String? prefix;

  String? uploadIdMarker;

  int maxUploads = 0;

  bool isTruncated = false;

  String? nextKeyMarker;

  String? nextUploadIdMarker;

  final List<MultipartUpload> _multipartUploads = [];

  final List<String> _commonPrefixes = [];

  MultipartUploadListing([this.bucketName]);

  List<MultipartUpload> getMultipartUploads() {
    return _multipartUploads;
  }

  void setMultipartUploads(List<MultipartUpload>? multipartUploads) {
    _multipartUploads
      ..clear()
      ..addAll(multipartUploads ?? []);
  }

  void addMultipartUpload(MultipartUpload multipartUpload) {
    _multipartUploads.add(multipartUpload);
  }

  List<String> getCommonPrefixes() {
    return _commonPrefixes;
  }

  void setCommonPrefixes(List<String>? commonPrefixes) {
    _commonPrefixes
      ..clear()
      ..addAll(commonPrefixes ?? []);
  }

  void addCommonPrefix(String commonPrefix) {
    _commonPrefixes.add(commonPrefix);
  }
}
