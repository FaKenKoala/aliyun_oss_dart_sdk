import 'generic_request.dart';

class PutBucketImageRequest extends GenericRequest {
  // String bucketName;
  bool isForbidOrigPicAccess = false;
  bool isUseStyleOnly = false;
  bool isAutoSetContentType = false;
  bool isUseSrcFormat = false;
  bool isSetAttachName = false;
  String default404Pic = "";
  String styleDelimiters = "!"; // /,-,_,!

  PutBucketImageRequest(String bucketName) : super(bucketName: bucketName);
}
