import 'dart:collection';

import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/service_client.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/coding_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';

import 'oss_constants.dart';

/// HTTP request message builder.
class OSSRequestMessageBuilder {
  Uri? endpoint;
  HttpMethod method = HttpMethod.GET;
  String? bucket;
  String? key;
  Map<String, String> headers = <String, String>{};
  Map<String, String> parameters = <String, String>{};
  InputStream? inputStream;
  int inputSize = 0;
  ServiceClient innerClient;
  bool useChunkEncoding = false;

  WebServiceRequest? originalRequest;

  OSSRequestMessageBuilder(this.innerClient);

  OSSRequestMessageBuilder addHeader(String key, String value) {
    headers[key] = value;
    return this;
  }

  Map<String, String> getParameters() {
    return UnmodifiableMapView(parameters);
  }

  OSSRequestMessageBuilder addParameter(String key, String value) {
    parameters[key] = value;
    return this;
  }

  OSSRequestMessageBuilder setInputStreamWithLength(
      FixedLengthInputStream instream) {
    CodingUtils.assertParameterInRange(
        inputSize, -1, OSSConstants.DEFAULT_FILE_SIZE_LIMIT);
    inputStream = instream;
    inputSize = instream.length;
    return this;
  }

  int getInputSize() {
    return inputSize;
  }

  OSSRequestMessageBuilder setInputSize(int inputSize) {
    CodingUtils.assertParameterInRange(
        inputSize, -1, OSSConstants.DEFAULT_FILE_SIZE_LIMIT);
    this.inputSize = inputSize;
    return this;
  }

  bool isUseChunkEncoding() {
    return useChunkEncoding;
  }

  RequestMessage build() {
    ClientConfiguration clientCofig = innerClient.getClientConfiguration();
    Map<String, String> sentHeaders = Map.from(headers);
    Map<String, String> sentParameters = Map.from(parameters);
    DateTime now = DateTime.now();
    if (clientCofig.getTickOffset() != 0) {
      now.setTime(now.getTime() + clientCofig.getTickOffset());
    }
    sentHeaders[HttpHeaders.DATE] = DateUtil.formatRfc822Date(now);

    RequestMessage request = RequestMessage(bucket, key, originalRequest);
    request.bucket = bucket;
    request.key = key;
    request.endpoint = OSSUtils.determineFinalEndpoint(endpoint, bucket, clientCofig);
    request.resourcePath = 
        OSSUtils.determineResourcePath(bucket, key, clientCofig.isSLDEnabled());
    request.headers = sentHeaders;
    request.parameters = sentParameters;
    request.method = method;
    request.content = inputStream;
    request.contentLength = inputSize;
    request.useChunkEncoding = inputSize == -1 ? true : useChunkEncoding;

    return request;
  }
}
