import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/service_client.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/coding_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/model/cors_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generic_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/options_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/set_bucket_cors_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/void_result.dart';

import 'oss_headers.dart';
import 'oss_operation.dart';
import 'oss_request_message_builder.dart';

class CORSOperation extends OSSOperation {
  static final String SUBRESOURCE_CORS = "cors";

  CORSOperation(ServiceClient client, CredentialsProvider credsProvider)
      : super(client, credsProvider);

  /// Set bucket cors.
  VoidResult setBucketCORS(SetBucketCORSRequest setBucketCORSRequest) {
    checkSetBucketCORSRequestValidity(setBucketCORSRequest);

    Map<String, String> parameters = <String, String>{};
    parameters.put(SUBRESOURCE_CORS, null);

    RequestMessage request = OSSRequestMessageBuilder(getInnerClient())
        .setEndpoint(getEndpoint(setBucketCORSRequest))
        .setMethod(HttpMethod.put)
        .setBucket(setBucketCORSRequest.bucketName)
        .setParameters(parameters)
        .setInputStreamWithLength(
            setBucketCORSRequestMarshaller.marshall(setBucketCORSRequest))
        .setOriginalRequest(setBucketCORSRequest)
        .build();

    return doOperation(request, requestIdResponseParser,
        setBucketCORSRequest.bucketName, null);
  }

  /**
     * Return the CORS configuration of the specified bucket.
     */
  CORSConfiguration getBucketCORS(GenericRequest genericRequest) {
    assertParameterNotNull(genericRequest, "genericRequest");

    String bucketName = genericRequest.bucketName;
    assertParameterNotNull(bucketName, "bucketName");
    ensureBucketNameValid(bucketName);

    Map<String, String> parameters = LinkedHashMap<String, String>();
    parameters.put(SUBRESOURCE_CORS, null);

    RequestMessage request = OSSRequestMessageBuilder(getInnerClient())
        .setEndpoint(getEndpoint(genericRequest))
        .setMethod(HttpMethod.get)
        .setParameters(parameters)
        .setBucket(bucketName)
        .setOriginalRequest(genericRequest)
        .build();

    return doOperation(
        request, getBucketCorsResponseParser, bucketName, null, true);
  }

  /**
     * Delete bucket cors.
     */
  VoidResult deleteBucketCORS(GenericRequest genericRequest) {
    assertParameterNotNull(genericRequest, "genericRequest");

    String bucketName = genericRequest.getBucketName();
    assertParameterNotNull(bucketName, "bucketName");
    ensureBucketNameValid(bucketName);

    Map<String, String> parameters = LinkedHashMap<String, String>();
    parameters.put(SUBRESOURCE_CORS, null);

    RequestMessage request = OSSRequestMessageBuilder(getInnerClient())
        .setEndpoint(getEndpoint(genericRequest))
        .setMethod(HttpMethod.delete)
        .setParameters(parameters)
        .setBucket(bucketName)
        .setOriginalRequest(genericRequest)
        .build();

    return doOperation(request, requestIdResponseParser, bucketName, null);
  }

  ResponseMessage optionsObject(OptionsRequest optionsRequest) {
    assertParameterNotNull(optionsRequest, "optionsRequest");

    String? bucketName = optionsRequest.bucketName;
    assertParameterNotNull(bucketName, "bucketName");
    ensureBucketNameValid(bucketName);

    RequestMessage request = OSSRequestMessageBuilder(getInnerClient())
        .setEndpoint(getEndpoint(optionsRequest))
        .setMethod(HttpMethod.options)
        .setBucket(bucketName)
        .setKey(optionsRequest.getObjectName())
        .addHeader(OSSHeaders.origin, optionsRequest.origin)
        .addHeader(OSSHeaders.accessControlRequestMethod,
            optionsRequest.requestMethod.name)
        .addHeader(OSSHeaders.accessControlRequestHeader,
            optionsRequest.requestHeaders)
        .setOriginalRequest(optionsRequest)
        .build();

    return doOperation(request, emptyResponseParser, bucketName, null);
  }

  static void checkSetBucketCORSRequestValidity(
      SetBucketCORSRequest setBucketCORSRequest) {
    CodingUtils.assertParameterNotNull(
        setBucketCORSRequest, "setBucketCORSRequest");

    String? bucketName = setBucketCORSRequest.bucketName;
    CodingUtils.assertStringNotNullOrEmpty(bucketName, "bucketName");
    OSSUtils.ensureBucketNameValid(bucketName);

    List<CORSRule> corsRules = setBucketCORSRequest.getCorsRules();
    CodingUtils.assertListNotNullOrEmpty(corsRules, "corsRules");
    for (CORSRule rule in setBucketCORSRequest.getCorsRules()) {
      CodingUtils.assertListNotNullOrEmpty(
          rule.getAllowedOrigins(), "allowedOrigin");
      CodingUtils.assertListNotNullOrEmpty(
          rule.getAllowedMethods(), "allowedMethod");
    }
  }
}
