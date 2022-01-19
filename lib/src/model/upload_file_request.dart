import 'callback.dart';
import 'generic_request.dart';
import 'object_metadata.dart';

/// The file upload request to start a multipart upload.
class UploadFileRequest extends GenericRequest {
  UploadFileRequest(
    String? bucketName,
    String? key, [
    this.uploadFile,
    this._partSize = -1,
    this._taskNum = 0,
    this.enableCheckpoint = false,
    this.checkpointFile,
  ]) : super(bucketName: bucketName, key: key);

  int getPartSize() {
    return _partSize;
  }

  void setPartSize(int partSize) {
    if (partSize < 1024 * 100) {
      _partSize = 1024 * 100;
    } else {
      _partSize = partSize;
    }
  }

  int getTaskNum() {
    return _taskNum;
  }

  void setTaskNum(int taskNum) {
    _taskNum = taskNum.clamp(1, 1000);
  }

  // Part size, by default it's 100KB.
  int _partSize = 1024 * 100;
  // Concurrent parts upload thread count. By default it's 1.
  int _taskNum = 1;
  // The local file path to upload.
  String? uploadFile;
  // Enable the checkpoint
  bool enableCheckpoint = false;
  // The checkpoint file's local path.
  String? checkpointFile;
  // The metadata of the target file.
  ObjectMetadata? objectMetadata;
  // callback entry.
  Callback? callback;
  // Traffic limit speed, its uint is bit/s
  int trafficLimit = 0;
  // Is Sequential mode or not.
  bool? sequentialMode;
}
