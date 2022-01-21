 import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/coding_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/model/set_bucket_cors_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/void_result.dart';

import 'oss_operation.dart';

class CORSOperation extends OSSOperation {

     static final String SUBRESOURCE_CORS = "cors";

     CORSOperation(ServiceClient client, CredentialsProvider credsProvider) {
        super(client, credsProvider);
    }

    /// Set bucket cors.
     VoidResult setBucketCORS(SetBucketCORSRequest setBucketCORSRequest) {

        checkSetBucketCORSRequestValidity(setBucketCORSRequest);

        Map<String, String> parameters = LinkedHashMap<String, String>();
        parameters.put(SUBRESOURCE_CORS, null);

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketCORSRequest))
                .setMethod(HttpMethod.PUT).setBucket(setBucketCORSRequest.getBucketName()).setParameters(parameters)
                .setInputStreamWithLength(setBucketCORSRequestMarshaller.marshall(setBucketCORSRequest))
                .setOriginalRequest(setBucketCORSRequest).build();

        return doOperation(request, requestIdResponseParser, setBucketCORSRequest.getBucketName(), null);
    }

    /**
     * Return the CORS configuration of the specified bucket.
     */
     CORSConfiguration getBucketCORS(GenericRequest genericRequest) {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> parameters = LinkedHashMap<String, String>();
        parameters.put(SUBRESOURCE_CORS, null);

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setParameters(parameters).setBucket(bucketName)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketCorsResponseParser, bucketName, null, true);
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

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setParameters(parameters).setBucket(bucketName)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Options object.
     */
     ResponseMessage optionsObject(OptionsRequest optionsRequest) {

        assertParameterNotNull(optionsRequest, "optionsRequest");

        String bucketName = optionsRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(optionsRequest))
                .setMethod(HttpMethod.OPTIONS).setBucket(bucketName).setKey(optionsRequest.getObjectName())
                .addHeader(OSSHeaders.ORIGIN, optionsRequest.getOrigin())
                .addHeader(OSSHeaders.ACCESS_CONTROL_REQUEST_METHOD, optionsRequest.getRequestMethod().name())
                .addHeader(OSSHeaders.ACCESS_CONTROL_REQUEST_HEADER, optionsRequest.getRequestHeaders())
                .setOriginalRequest(optionsRequest).build();

        return doOperation(request, emptyResponseParser, bucketName, null);
    }

     static void checkSetBucketCORSRequestValidity(SetBucketCORSRequest setBucketCORSRequest) {

        CodingUtils.assertParameterNotNull(setBucketCORSRequest, "setBucketCORSRequest");

        String? bucketName = setBucketCORSRequest.bucketName;
        CodingUtils.assertStringNotNullOrEmpty(bucketName, "bucketName");
        OSSUtils.ensureBucketNameValid(bucketName);

        List<CORSRule> corsRules = setBucketCORSRequest.getCorsRules();
        CodingUtils.assertListNotNullOrEmpty(corsRules, "corsRules");
        for (CORSRule rule in setBucketCORSRequest.getCorsRules()) {
            CodingUtils.assertListNotNullOrEmpty(rule.getAllowedOrigins(), "allowedOrigin");
            CodingUtils.assertListNotNullOrEmpty(rule.getAllowedMethods(), "allowedMethod");
        }
    }

}
