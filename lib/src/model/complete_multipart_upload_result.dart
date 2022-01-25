 import 'oss_result.dart';

class CompleteMultipartUploadResult extends OSSResult {

    /// The name of the bucket containing the completed multipart upload.
     String? bucketName;

    /// The objectKey by which the object is stored.
     String? objectKey;

    /// The URL identifying the multipart object.
     String? location;

     String? eTag;

     String? serverCallbackReturnBody;

}
