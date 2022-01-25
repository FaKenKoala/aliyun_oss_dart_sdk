import 'complete_multipart_upload_result.dart';

class ResumableUploadResult extends CompleteMultipartUploadResult {
  ResumableUploadResult(CompleteMultipartUploadResult completeResult) {
    requestId = completeResult.requestId;
    responseHeader = completeResult.responseHeader;
    statusCode = completeResult.statusCode;
    clientCRC = completeResult.clientCRC;
    serverCRC = completeResult.serverCRC;
    bucketName = completeResult.bucketName;
    objectKey = completeResult.objectKey;
    eTag = completeResult.eTag;
    location = completeResult.location;
    serverCallbackReturnBody = completeResult.serverCallbackReturnBody;
  }
}
