import 'package:aliyun_oss_dart_sdk/src/internal/request_parameters.dart';

import 'head_object_request.dart';
import 'input_serialization.dart';
import 'select_content_format.dart';

class CreateSelectObjectMetadataRequest extends HeadObjectRequest {
  String process;
  InputSerialization _inputSerialization = InputSerialization();
  bool overwrite = false;
  bool selectProgressListener = false;

  CreateSelectObjectMetadataRequest(String bucketName, String key)
      : process = RequestParameters.SUBRESOURCE_CSV_META,
        super(bucketName, key);

  InputSerialization getInputSerialization() {
    return _inputSerialization;
  }

  void setInputSerialization(InputSerialization inputSerialization) {
    process = inputSerialization.selectContentFormat == SelectContentFormat.CSV
        ? RequestParameters.SUBRESOURCE_CSV_META
        : RequestParameters.SUBRESOURCE_JSON_META;
    this._inputSerialization = inputSerialization;
  }
}
