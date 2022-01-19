import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'udf_generic_request.dart';

/// This is the request class to upload the UDF image.
/// UDF Image有格式要求，详见API说明。
class UploadUdfImageRequest extends UdfGenericRequest {
  UploadUdfImageRequest(
    String udfName,
    this.udfImage, [
    this.udfImageDesc,
  ]) : super(udfName);

  InputStream udfImage;

  String? udfImageDesc;
}
