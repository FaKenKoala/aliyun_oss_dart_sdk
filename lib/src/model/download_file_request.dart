import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/common/utils/binary_util.dart';

import 'generic_request.dart';
import 'response_header_overrides.dart';

/// The request class that is to download file with multiple parts download.
class DownloadFileRequest extends GenericRequest {
  DownloadFileRequest(
    String bucketName,
    String key, [
    this.downloadFile = "",
    this.partSize = 0,
    this.taskNum = 0,
    this.enableCheckpoint = false,
    this.checkpointFile,
  ]) : super(bucketName: bucketName, key: key);

  String getTempDownloadFile() {
    if (versionId != null) {
      return downloadFile +
          "." +
          BinaryUtil.encodeMD5(utf8.encode(versionId!)) +
          ".tmp";
    } else {
      return downloadFile + ".tmp";
    }
  }

  List<String> getMatchingETagConstraints() {
    return _matchingETagConstraints;
  }

  void setMatchingETagConstraints(List<String>? eTagList) {
    _matchingETagConstraints
      ..clear()
      ..addAll(eTagList ?? []);
  }

  void clearMatchingETagConstraints() {
    _matchingETagConstraints.clear();
  }

  List<String> getNonmatchingETagConstraints() {
    return _nonmatchingEtagConstraints;
  }

  void setNonmatchingETagConstraints(List<String>? eTagList) {
    _nonmatchingEtagConstraints
      ..clear
      ..addAll(eTagList ?? []);
  }

  void clearNonmatchingETagConstraints() {
    _nonmatchingEtagConstraints.clear();
  }

  List<int> getRange() {
    return _range;
  }

  void setRange(int start, int end) {
    _range = [start, end];
  }

  // Part size in byte, by default it's 100KB.
  int partSize = 1024 * 100;
  // Thread count for downloading parts, by default it's 1.
  int taskNum = 1;
  // The local file path for the download.
  String downloadFile = "";
  // Flag of enabling checkpoint.
  bool enableCheckpoint = false;
  // The local file path of the checkpoint file
  String? checkpointFile;

  // The matching ETag constraints
  final List<String> _matchingETagConstraints = [];
  // The non-matching ETag constraints.
  final List<String> _nonmatchingEtagConstraints = [];
  // The unmodified since constraint.
  DateTime? unmodifiedSinceConstraint;
  // The modified since constraints.
  DateTime? modifiedSinceConstraint;
  // The response headers to override.
  ResponseHeaderOverrides? responseHeaders;

  // Traffic limit speed, its uint is bit/s
  int trafficLimit = 0;

  List<int> _range = [0, 0];
}
