import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/model/access_control_list.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket.dart';
import 'package:aliyun_oss_dart_sdk/src/model/create_bucket_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generic_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/pub_bucket_image_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/put_image_style_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/set_bucket_referer_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/void_result.dart';

import '../http_method.dart';
import 'oss_request_message_builder.dart';
import 'response_parsers.dart';

/// Bucket operation.
 class OSSBucketOperation extends OSSOperation {

     OSSBucketOperation(ServiceClient client, CredentialsProvider credsProvider) {
        super(client, credsProvider);
    }

    /**
     * Create a bucket.
     */
     Bucket createBucket(CreateBucketRequest createBucketRequest) {

        assertParameterNotNull(createBucketRequest, "createBucketRequest");

        String bucketName = createBucketRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameCreationValid(bucketName);

        Map<String, String> headers = <String, String>{};
        addOptionalACLHeader(headers, createBucketRequest.getCannedACL());
        addOptionalHnsHeader(headers, createBucketRequest.getHnsStatus());
        addOptionalResourceGroupIdHeader(headers, createBucketRequest.getResourceGroupId());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(createBucketRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setHeaders(headers)
                .setInputStreamWithLength(createBucketRequestMarshaller.marshall(createBucketRequest))
                .setOriginalRequest(createBucketRequest).build();

        ResponseMessage result = doOperation(request, emptyResponseParser, bucketName, null);
        return new Bucket(bucketName, result.getRequestId());
    }

    /**
     * Delete a bucket.
     */
     VoidResult deleteBucket(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * List all my buckets.
     */
     List<Bucket> listBuckets() 
        BucketList bucketList = listBuckets(new ListBucketsRequest(null, null, null));
        List<Bucket> buckets = bucketList.getBucketList();
        while (bucketList.isTruncated()) {
            bucketList = listBuckets(new ListBucketsRequest(null, bucketList.getNextMarker(), null));
            buckets.addAll(bucketList.getBucketList());
        }
        return buckets;
    }

    /**
     * List all my buckets.
     */
     BucketList listBuckets(ListBucketsRequest listBucketRequest) 

        assertParameterNotNull(listBucketRequest, "listBucketRequest");

        Map<String, String> params = new LinkedHashMap<String, String>();
        if (listBucketRequest.getPrefix() != null) {
            params.PUT(PREFIX, listBucketRequest.getPrefix());
        }
        if (listBucketRequest.getMarker() != null) {
            params.PUT(MARKER, listBucketRequest.getMarker());
        }
        if (listBucketRequest.getMaxKeys() != null) {
            params.PUT(MAX_KEYS, Integer.toString(listBucketRequest.getMaxKeys()));
        }
        if (listBucketRequest.getBid() != null) {
            params.PUT(BID, listBucketRequest.getBid());
        }

        if (listBucketRequest.getTagKey() != null && listBucketRequest.getTagValue() != null) {
            params.PUT(TAG_KEY, listBucketRequest.getTagKey());
            params.PUT(TAG_VALUE, listBucketRequest.getTagValue());
        }

        Map<String, String> headers = <String, String>{};
        addOptionalResourceGroupIdHeader(headers, listBucketRequest.getResourceGroupId());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listBucketRequest))
                .setMethod(HttpMethod.GET).setHeaders(headers).setParameters(params).setOriginalRequest(listBucketRequest).build();

        return doOperation(request, listBucketResponseParser, null, null, true);
    }

    /**
     * Set bucket's canned ACL.
     */
     VoidResult setBucketAcl(SetBucketAclRequest setBucketAclRequest) {

        assertParameterNotNull(setBucketAclRequest, "setBucketAclRequest");

        String bucketName = setBucketAclRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> headers = <String, String>{};
        addOptionalACLHeader(headers, setBucketAclRequest.getCannedACL());

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ACL, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketAclRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setHeaders(headers).setParameters(params)
                .setOriginalRequest(setBucketAclRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket's ACL.
     */
     AccessControlList getBucketAcl(GenericRequest genericRequest){

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ACL, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketAclResponseParser, bucketName, null, true);
    }

     BucketMetadata getBucketMetadata(GenericRequest genericRequest) {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.HEAD).setBucket(bucketName).setOriginalRequest(genericRequest).build();

        List<ResponseHandler> reponseHandlers = [];
        reponseHandlers.add(new ResponseHandler() {
            @override
             void handle(ResponseMessage response) 
                if (response.getStatusCode() == HttpStatus.SC_NOT_FOUND) {
                    safeCloseResponse(response);
                    throw ExceptionFactory.createOSSException(
                            response.getHeaders().get(OSSHeaders.OSS_HEADER_REQUEST_ID), OSSErrorCode.NO_SUCH_BUCKET,
                            OSS_RESOURCE_MANAGER.getString("NoSuchBucket"));
                }
            }
        });

        return doOperation(request, ResponseParsers.getBucketMetadataResponseParser, bucketName, null, true, null,
                reponseHandlers);
    }

    /**
     * Set bucket referer.
     */
     VoidResult setBucketReferer(SetBucketRefererRequest setBucketRefererRequest) {

        String bucketName = setBucketRefererRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        BucketReferer referer = setBucketRefererRequest.getReferer();
        if (referer == null) {
            referer = new BucketReferer();
        }

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_REFERER, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketRefererRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setInputStreamWithLength(bucketRefererMarshaller.marshall(referer))
                .setOriginalRequest(setBucketRefererRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket referer.
     */
     BucketReferer getBucketReferer(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_REFERER, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketRefererResponseParser, bucketName, null, true);
    }

    /**
     * Get bucket location.
     */
     String getBucketLocation(GenericRequest genericRequest) {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_LOCATION, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketLocationResponseParser, bucketName, null, true);
    }

    /**
     * Determine whether a bucket exists or not.
     */
     bool doesBucketExists(GenericRequest genericRequest) {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        try {
            getBucketAcl(new GenericRequest(bucketName));
        } catch (OSSException oe) {
            if (oe.getErrorCode().equals(OSSErrorCode.NO_SUCH_BUCKET)) {
                return false;
            }
        }
        return true;
    }

    /**
     * List objects under the specified bucket.
     */
     ObjectListing listObjects(ListObjectsRequest listObjectsRequest) {

        assertParameterNotNull(listObjectsRequest, "listObjectsRequest");

        String bucketName = listObjectsRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = new LinkedHashMap<String, String>();
        populateListObjectsRequestParameters(listObjectsRequest, params);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, listObjectsRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listObjectsRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setHeaders(headers).setParameters(params)
                .setOriginalRequest(listObjectsRequest).build();

        return doOperation(request, listObjectsReponseParser, bucketName, null, true);
    }

    /**
     * List objects under the specified bucket.
     */
     ListObjectsV2Result listObjectsV2(ListObjectsV2Request listObjectsV2Request) 

        assertParameterNotNull(listObjectsV2Request, "listObjectsRequest");

        String bucketName = listObjectsV2Request.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = new LinkedHashMap<String, String>();
        populateListObjectsV2RequestParameters(listObjectsV2Request, params);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, listObjectsV2Request.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listObjectsV2Request))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setHeaders(headers).setParameters(params)
                .setOriginalRequest(listObjectsV2Request).build();

        return doOperation(request, listObjectsV2ResponseParser, bucketName, null, true);
    }

    /**
     * List versions under the specified bucket.
     */
     VersionListing listVersions(ListVersionsRequest listVersionsRequest) 

        assertParameterNotNull(listVersionsRequest, "listVersionsRequest");

        String bucketName = listVersionsRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = new LinkedHashMap<String, String>();
        populateListVersionsRequestParameters(listVersionsRequest, params);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, listVersionsRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listVersionsRequest))
            .setMethod(HttpMethod.GET).setBucket(bucketName).setHeaders(headers).setParameters(params)
            .setOriginalRequest(listVersionsRequest).build();

        return doOperation(request, listVersionsReponseParser, bucketName, null, true);
    }

    /**
     * Set bucket logging.
     */
     VoidResult setBucketLogging(SetBucketLoggingRequest setBucketLoggingRequest) 

        assertParameterNotNull(setBucketLoggingRequest, "setBucketLoggingRequest");

        String bucketName = setBucketLoggingRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_LOGGING, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketLoggingRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setInputStreamWithLength(setBucketLoggingRequestMarshaller.marshall(setBucketLoggingRequest))
                .setOriginalRequest(setBucketLoggingRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Put bucket image
     */
     VoidResult putBucketImage(PutBucketImageRequest putBucketImageRequest) {
        assertParameterNotNull(putBucketImageRequest, "putBucketImageRequest");
        String bucketName = putBucketImageRequest.GetBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_IMG, null);
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(putBucketImageRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(putBucketImageRequest)
                .setInputStreamWithLength(putBucketImageRequestMarshaller.marshall(putBucketImageRequest)).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket image
     */
     GetBucketImageResult getBucketImage(String bucketName, GenericRequest genericRequest) {
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_IMG, null);
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();
        return doOperation(request, getBucketImageResponseParser, bucketName, null, true);
    }

    /**
     * Delete bucket image attributes.
     */
     VoidResult deleteBucketImage(String bucketName, GenericRequest genericRequest)
            
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_IMG, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * put image style
     */
     VoidResult putImageStyle(PutImageStyleRequest putImageStyleRequest) 
        assertParameterNotNull(putImageStyleRequest, "putImageStyleRequest");
        String bucketName = putImageStyleRequest.GetBucketName();
        String styleName = putImageStyleRequest.GetStyleName();
        assertParameterNotNull(styleName, "styleName");
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_STYLE, null);
        params.PUT(STYLE_NAME, styleName);
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(putImageStyleRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(putImageStyleRequest)
                .setInputStreamWithLength(putImageStyleRequestMarshaller.marshall(putImageStyleRequest)).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     VoidResult deleteImageStyle(String bucketName, String styleName, GenericRequest genericRequest)
            
        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(styleName, "styleName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_STYLE, null);
        params.PUT(STYLE_NAME, styleName);
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     GetImageStyleResult getImageStyle(String bucketName, String styleName, GenericRequest genericRequest)
            
        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(styleName, "styleName");
        ensureBucketNameValid(bucketName);
        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_STYLE, null);
        params.PUT(STYLE_NAME, styleName);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getImageStyleResponseParser, bucketName, null, true);
    }

    /**
     * List image style.
     */
     List<Style> listImageStyle(String bucketName, GenericRequest genericRequest)
            

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_STYLE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, listImageStyleResponseParser, bucketName, null, true);
    }

     VoidResult setBucketProcess(SetBucketProcessRequest setBucketProcessRequest) 

        assertParameterNotNull(setBucketProcessRequest, "setBucketProcessRequest");

        ImageProcess imageProcessConf = setBucketProcessRequest.getImageProcess();
        assertParameterNotNull(imageProcessConf, "imageProcessConf");

        String bucketName = setBucketProcessRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_PROCESS_CONF, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketProcessRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setInputStreamWithLength(bucketImageProcessConfMarshaller.marshall(imageProcessConf))
                .setOriginalRequest(setBucketProcessRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     BucketProcess getBucketProcess(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_PROCESS_CONF, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketImageProcessConfResponseParser, bucketName, null, true);
    }

    /**
     * Get bucket logging.
     */
     BucketLoggingResult getBucketLogging(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_LOGGING, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketLoggingResponseParser, bucketName, null, true);
    }

    /**
     * Delete bucket logging.
     */
     VoidResult deleteBucketLogging(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_LOGGING, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Set bucket website.
     */
     VoidResult setBucketWebsite(SetBucketWebsiteRequest setBucketWebSiteRequest) 

        assertParameterNotNull(setBucketWebSiteRequest, "setBucketWebSiteRequest");

        String bucketName = setBucketWebSiteRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        if (setBucketWebSiteRequest.getIndexDocument() == null && setBucketWebSiteRequest.getErrorDocument() == null
                && setBucketWebSiteRequest.getRoutingRules().size() == 0) {
            throw ArgumentError(String.format("IndexDocument/ErrorDocument/RoutingRules must have one"));
        }

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WEBSITE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketWebSiteRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setInputStreamWithLength(setBucketWebsiteRequestMarshaller.marshall(setBucketWebSiteRequest))
                .setOriginalRequest(setBucketWebSiteRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket website.
     */
     BucketWebsiteResult getBucketWebsite(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WEBSITE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketWebsiteResponseParser, bucketName, null, true);
    }

    /**
     * Delete bucket website.
     */
     VoidResult deleteBucketWebsite(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WEBSITE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Set bucket lifecycle.
     */
     VoidResult setBucketLifecycle(SetBucketLifecycleRequest setBucketLifecycleRequest)
            

        assertParameterNotNull(setBucketLifecycleRequest, "setBucketLifecycleRequest");

        String bucketName = setBucketLifecycleRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_LIFECYCLE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketLifecycleRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setInputStreamWithLength(setBucketLifecycleRequestMarshaller.marshall(setBucketLifecycleRequest))
                .setOriginalRequest(setBucketLifecycleRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket lifecycle.
     */
     List<LifecycleRule> getBucketLifecycle(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_LIFECYCLE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketLifecycleResponseParser, bucketName, null, true);
    }

    /**
     * Delete bucket lifecycle.
     */
     VoidResult deleteBucketLifecycle(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_LIFECYCLE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Set bucket tagging.
     */
     VoidResult setBucketTagging(SetBucketTaggingRequest setBucketTaggingRequest) 

        assertParameterNotNull(setBucketTaggingRequest, "setBucketTaggingRequest");

        String bucketName = setBucketTaggingRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TAGGING, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketTaggingRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setInputStreamWithLength(setBucketTaggingRequestMarshaller.marshall(setBucketTaggingRequest))
                .setOriginalRequest(setBucketTaggingRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket tagging.
     */
     TagSet getBucketTagging(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TAGGING, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getTaggingResponseParser, bucketName, null, true);
    }

    /**
     * Delete bucket tagging.
     */
     VoidResult deleteBucketTagging(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TAGGING, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket versioning.
     */
     BucketVersioningConfiguration getBucketVersioning(GenericRequest genericRequest)
        

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_VRESIONING, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
            .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
            .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketVersioningResponseParser, bucketName, null, true);
    }

    /**
     * Set bucket versioning.
     */
     VoidResult setBucketVersioning(SetBucketVersioningRequest setBucketVersioningRequest)
        
        assertParameterNotNull(setBucketVersioningRequest, "setBucketVersioningRequest");
        assertParameterNotNull(setBucketVersioningRequest.getVersioningConfiguration(), "versioningConfiguration");

        String bucketName = setBucketVersioningRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_VRESIONING, null);

        byte[] rawContent = setBucketVersioningRequestMarshaller.marshall(setBucketVersioningRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketVersioningRequest))
            .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params).setHeaders(headers)
            .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
            .setOriginalRequest(setBucketVersioningRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Add bucket replication.
     */
     VoidResult addBucketReplication(AddBucketReplicationRequest addBucketReplicationRequest)
            

        assertParameterNotNull(addBucketReplicationRequest, "addBucketReplicationRequest");
        assertParameterNotNull(addBucketReplicationRequest.getTargetBucketName(), "targetBucketName");

        String bucketName = addBucketReplicationRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = new LinkedHashMap<String, String>();
        params.PUT(RequestParameters.SUBRESOURCE_REPLICATION, null);
        params.PUT(RequestParameters.SUBRESOURCE_COMP, RequestParameters.COMP_ADD);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(addBucketReplicationRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params)
                .setInputStreamWithLength(addBucketReplicationRequestMarshaller.marshall(addBucketReplicationRequest))
                .setOriginalRequest(addBucketReplicationRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * Get bucket replication.
     */
     List<ReplicationRule> getBucketReplication(GenericRequest genericRequest)
            

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_REPLICATION, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketReplicationResponseParser, bucketName, null, true);
    }

    /**
     * Delete bucket replication.
     */
     VoidResult deleteBucketReplication(DeleteBucketReplicationRequest deleteBucketReplicationRequest)
            

        assertParameterNotNull(deleteBucketReplicationRequest, "deleteBucketReplicationRequest");
        assertParameterNotNull(deleteBucketReplicationRequest.getReplicationRuleID(), "replicationRuleID");

        String bucketName = deleteBucketReplicationRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = new LinkedHashMap<String, String>();
        params.PUT(RequestParameters.SUBRESOURCE_REPLICATION, null);
        params.PUT(RequestParameters.SUBRESOURCE_COMP, RequestParameters.COMP_DELETE);

        byte[] rawContent = deleteBucketReplicationRequestMarshaller.marshall(deleteBucketReplicationRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteBucketReplicationRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(deleteBucketReplicationRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     static void addRequestRequiredHeaders(Map<String, String> headers, byte[] rawContent) {
        headers.PUT(HttpHeaders.CONTENT_LENGTH, String.valueOf(rawContent.length));

        byte[] md5 = BinaryUtil.calculateMd5(rawContent);
        String md5Base64 = BinaryUtil.toBase64String(md5);
        headers.PUT(HttpHeaders.CONTENT_MD5, md5Base64);
    }

    /**
     * Get bucket replication progress.
     */
     BucketReplicationProgress getBucketReplicationProgress(
            GetBucketReplicationProgressRequest getBucketReplicationProgressRequest)
            

        assertParameterNotNull(getBucketReplicationProgressRequest, "getBucketReplicationProgressRequest");
        assertParameterNotNull(getBucketReplicationProgressRequest.getReplicationRuleID(), "replicationRuleID");

        String bucketName = getBucketReplicationProgressRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_REPLICATION_PROGRESS, null);
        params.PUT(RequestParameters.RULE_ID, getBucketReplicationProgressRequest.getReplicationRuleID());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(getBucketReplicationProgressRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(getBucketReplicationProgressRequest).build();

        return doOperation(request, getBucketReplicationProgressResponseParser, bucketName, null, true);
    }

    /**
     * Get bucket replication progress.
     */
     List<String> getBucketReplicationLocation(GenericRequest genericRequest)
            

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_REPLICATION_LOCATION, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketReplicationLocationResponseParser, bucketName, null, true);
    }

     AddBucketCnameResult addBucketCname(AddBucketCnameRequest addBucketCnameRequest) 

        assertParameterNotNull(addBucketCnameRequest, "addBucketCnameRequest");
        assertParameterNotNull(addBucketCnameRequest.getDomain(), "addBucketCnameRequest.domain");

        String bucketName = addBucketCnameRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_CNAME, null);
        params.PUT(RequestParameters.SUBRESOURCE_COMP, RequestParameters.COMP_ADD);

        byte[] rawContent = addBucketCnameRequestMarshaller.marshall(addBucketCnameRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(addBucketCnameRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(addBucketCnameRequest).build();

        return doOperation(request, addBucketCnameResponseParser, bucketName, null);
    }

     List<CnameConfiguration> getBucketCname(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_CNAME, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketCnameResponseParser, bucketName, null, true);
    }

     VoidResult deleteBucketCname(DeleteBucketCnameRequest deleteBucketCnameRequest)
            

        assertParameterNotNull(deleteBucketCnameRequest, "deleteBucketCnameRequest");
        assertParameterNotNull(deleteBucketCnameRequest.getDomain(), "deleteBucketCnameRequest.domain");

        String bucketName = deleteBucketCnameRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_CNAME, null);
        params.PUT(RequestParameters.SUBRESOURCE_COMP, RequestParameters.COMP_DELETE);

        byte[] rawContent = deleteBucketCnameRequestMarshaller.marshall(deleteBucketCnameRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteBucketCnameRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(deleteBucketCnameRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     BucketInfo getBucketInfo(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_BUCKET_INFO, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketInfoResponseParser, bucketName, null, true);
    }

     BucketStat getBucketStat(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_STAT, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketStatResponseParser, bucketName, null, true);
    }

     VoidResult setBucketStorageCapacity(SetBucketStorageCapacityRequest setBucketStorageCapacityRequest)
            

        assertParameterNotNull(setBucketStorageCapacityRequest, "setBucketStorageCapacityRequest");
        assertParameterNotNull(setBucketStorageCapacityRequest.getUserQos(), "setBucketStorageCapacityRequest.userQos");

        String bucketName = setBucketStorageCapacityRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        UserQos userQos = setBucketStorageCapacityRequest.getUserQos();
        assertParameterNotNull(userQos.getStorageCapacity(), "StorageCapacity");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_QOS, null);

        byte[] rawContent = setBucketQosRequestMarshaller.marshall(userQos);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketStorageCapacityRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(setBucketStorageCapacityRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     UserQos getBucketStorageCapacity(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_QOS, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketQosResponseParser, bucketName, null, true);

    }
    
    /**
     * Set bucket encryption.
     */
     VoidResult setBucketEncryption(SetBucketEncryptionRequest setBucketEncryptionRequest)
        

        assertParameterNotNull(setBucketEncryptionRequest, "setBucketEncryptionRequest");

        String bucketName = setBucketEncryptionRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ENCRYPTION, null);

        byte[] rawContent = setBucketEncryptionRequestMarshaller.marshall(setBucketEncryptionRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketEncryptionRequest))
            .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
            .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
            .setOriginalRequest(setBucketEncryptionRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

    /**
     * get bucket encryption.
     */
     ServerSideEncryptionConfiguration getBucketEncryption(GenericRequest genericRequest)
        

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ENCRYPTION, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
            .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
            .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketEncryptionResponseParser, bucketName, null, true);
    }

    /**
     * Delete bucket encryption.
     */
     VoidResult deleteBucketEncryption(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ENCRYPTION, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
            .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
            .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     VoidResult setBucketPolicy(SetBucketPolicyRequest setBucketPolicyRequest) 

        assertParameterNotNull(setBucketPolicyRequest, "setBucketPolicyRequest");

        String bucketName = setBucketPolicyRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
     	Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_POLICY, null);

        byte[] rawContent = setBucketPolicyRequestMarshaller.marshall(setBucketPolicyRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketPolicyRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(setBucketPolicyRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     GetBucketPolicyResult getBucketPolicy(GenericRequest genericRequest) 
    	assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_POLICY, null);
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();
        return doOperation(request, getBucketPolicyResponseParser, bucketName, null, true);
    }
    
     VoidResult deleteBucketPolicy(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_POLICY, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     VoidResult setBucketRequestPayment(SetBucketRequestPaymentRequest setBucketRequestPaymentRequest)
            

        assertParameterNotNull(setBucketRequestPaymentRequest, "setBucketRequestPaymentRequest");
        assertParameterNotNull(setBucketRequestPaymentRequest.getPayer(), "setBucketRequestPaymentRequest.payer");

        String bucketName = setBucketRequestPaymentRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_REQUEST_PAYMENT, null);

        Payer payer = setBucketRequestPaymentRequest.getPayer();
        byte[] rawContent = setBucketRequestPaymentRequestMarshaller.marshall(payer.toString());
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketRequestPaymentRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(setBucketRequestPaymentRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     GetBucketRequestPaymentResult getBucketRequestPayment(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_REQUEST_PAYMENT, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketRequestPaymentResponseParser, bucketName, null, true);
    }

     VoidResult setBucketQosInfo(SetBucketQosInfoRequest setBucketQosInfoRequest) 

        assertParameterNotNull(setBucketQosInfoRequest, "setBucketQosInfoRequest");
        assertParameterNotNull(setBucketQosInfoRequest.getBucketQosInfo(), "setBucketQosInfoRequest.getBucketQosInfo");

        String bucketName = setBucketQosInfoRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_QOS_INFO, null);

        byte[] rawContent = setBucketQosInfoRequestMarshaller.marshall(setBucketQosInfoRequest.getBucketQosInfo());
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketQosInfoRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(setBucketQosInfoRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     BucketQosInfo getBucketQosInfo(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_QOS_INFO, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketQosInfoResponseParser, bucketName, null, true);
    }

     VoidResult deleteBucketQosInfo(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_QOS_INFO, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     UserQosInfo getUserQosInfo() 

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_QOS_INFO, null);

        GenericRequest gGenericRequest = new GenericRequest();

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint())
                .setMethod(HttpMethod.GET).setParameters(params).setOriginalRequest(gGenericRequest).build();

        return doOperation(request, getUSerQosInfoResponseParser, null, null, true);
    }

     SetAsyncFetchTaskResult setAsyncFetchTask(SetAsyncFetchTaskRequest setAsyncFetchTaskRequest)
            
        assertParameterNotNull(setAsyncFetchTaskRequest, "setAsyncFetchTaskRequest");

        String bucketName = setAsyncFetchTaskRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        AsyncFetchTaskConfiguration taskConfiguration = setAsyncFetchTaskRequest.getAsyncFetchTaskConfiguration();
        assertParameterNotNull(taskConfiguration, "taskConfiguration");

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ASYNC_FETCH, null);

        byte[] rawContent = setAsyncFetchTaskRequestMarshaller.marshall(setAsyncFetchTaskRequest.getAsyncFetchTaskConfiguration());
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setAsyncFetchTaskRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(setAsyncFetchTaskRequest).build();

        return doOperation(request, setAsyncFetchTaskResponseParser, bucketName, null, true);
    }

     GetAsyncFetchTaskResult getAsyncFetchTask(GetAsyncFetchTaskRequest getAsyncFetchTaskRequest)
            
        assertParameterNotNull(getAsyncFetchTaskRequest, "getAsyncFetchTaskInfoRequest");

        String bucketName = getAsyncFetchTaskRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        String taskId = getAsyncFetchTaskRequest.getTaskId();
        assertParameterNotNull(taskId, "taskId");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_ASYNC_FETCH, null);

        Map<String, String> headers = <String, String>{};
        headers.PUT(OSSHeaders.OSS_HEADER_TASK_ID, taskId);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(getAsyncFetchTaskRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setHeaders(headers).setParameters(params)
                .setOriginalRequest(getAsyncFetchTaskRequest).build();

        return doOperation(request, getAsyncFetchTaskResponseParser, bucketName, null, true);
    }

     CreateVpcipResult createVpcip(CreateVpcipRequest createVpcipRequest) throws OSSException, ClientException{

        assertParameterNotNull(createVpcipRequest, "createVpcipRequest");
        String region = createVpcipRequest.getRegion();
        String vSwitchId = createVpcipRequest.getVSwitchId();

        assertParameterNotNull(region, "region");
        assertParameterNotNull(vSwitchId, "vSwitchId");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.VPCIP, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(createVpcipRequest)).setParameters(params)
                .setMethod(HttpMethod.POST).setInputStreamWithLength(createVpcipRequestMarshaller.marshall(createVpcipRequest))
                .setOriginalRequest(createVpcipRequest).build();

        CreateVpcipResult createVpcipResult = new CreateVpcipResult();
        Vpcip vpcip = doOperation(request, createVpcipResultResponseParser, null, null, true);
        createVpcipResult.setVpcip(vpcip);
        return createVpcipResult;
    }

     List<Vpcip> listVpcip() {

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.VPCIP, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint())
                .setMethod(HttpMethod.GET).setParameters(params).build();

        return doOperation(request, listVpcipResultResponseParser, null, null,true);
    }

     VoidResult deleteVpcip(DeleteVpcipRequest deleteVpcipRequest) {

        assertParameterNotNull(deleteVpcipRequest, "deleteVpcipRequest");
        VpcPolicy vpcPolicy = deleteVpcipRequest.getVpcPolicy();
        String region = vpcPolicy.getRegion();
        String vpcId = vpcPolicy.getVpcId();
        String vip = vpcPolicy.getVip();

        assertParameterNotNull(region, "region");
        assertParameterNotNull(vpcId, "vpcId");
        assertParameterNotNull(vip, "vip");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.VPCIP, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteVpcipRequest))
                .setParameters(params).setMethod(HttpMethod.DELETE)
                .setInputStreamWithLength(deleteVpcipRequestMarshaller.marshall(deleteVpcipRequest))
                .setOriginalRequest(deleteVpcipRequest).build();

        return doOperation(request, requestIdResponseParser, null, null);
    }

     VoidResult createBucketVpcip(CreateBucketVpcipRequest createBucketVpcipRequest) {

        String bucketName = createBucketVpcipRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(createBucketVpcipRequest, "createBucketVpcipRequest");
        VpcPolicy vpcPolicy = createBucketVpcipRequest.getVpcPolicy();
        String region = vpcPolicy.getRegion();
        String vpcId = vpcPolicy.getVpcId();
        String vip = vpcPolicy.getVip();

        assertParameterNotNull(region, "region");
        assertParameterNotNull(vpcId, "vpcId");
        assertParameterNotNull(vip, "vip");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.VIP, null);
        params.PUT(RequestParameters.SUBRESOURCE_COMP, RequestParameters.COMP_ADD);


        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(createBucketVpcipRequest))
                .setMethod(HttpMethod.POST).setParameters(params).setBucket(bucketName)
                .setInputStreamWithLength(createBucketVpcipRequestMarshaller.marshall(createBucketVpcipRequest))
                .setOriginalRequest(createBucketVpcipRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     VoidResult deleteBucketVpcip(DeleteBucketVpcipRequest deleteBucketVpcipRequest) {

        String bucketName = deleteBucketVpcipRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(deleteBucketVpcipRequest, "deleteBucketVpcipRequest");
        VpcPolicy vpcPolicy = deleteBucketVpcipRequest.getVpcPolicy();
        String region = vpcPolicy.getRegion();
        String vpcId = vpcPolicy.getVpcId();
        String vip = vpcPolicy.getVip();

        assertParameterNotNull(region, "region");
        assertParameterNotNull(vpcId, "vpcId");
        assertParameterNotNull(vip, "vip");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.VIP, null);
        params.PUT(RequestParameters.SUBRESOURCE_COMP, RequestParameters.COMP_DELETE);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteBucketVpcipRequest))
                .setMethod(HttpMethod.POST).setParameters(params).setBucket(bucketName)
                .setInputStreamWithLength(deleteBucketVpcipRequestMarshaller.marshall(vpcPolicy))
                .setOriginalRequest(vpcPolicy).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     List<VpcPolicy> getBucketVpcip(GenericRequest genericRequest) {

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.VIP, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params).build();

        return doOperation(request, listVpcPolicyResultResponseParser, bucketName, null,true);
    }

     VoidResult setBucketInventoryConfiguration(SetBucketInventoryConfigurationRequest
            setBucketInventoryConfigurationRequest) 
        assertParameterNotNull(setBucketInventoryConfigurationRequest, "SetBucketInventoryConfigurationRequest");
        String bucketName = setBucketInventoryConfigurationRequest.getBucketName();
        String inventoryId = setBucketInventoryConfigurationRequest.getInventoryConfiguration().getInventoryId();
        assertParameterNotNull(inventoryId, "inventory configuration id");
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        byte[] rawContent = setBucketInventoryRequestMarshaller.marshall(
                setBucketInventoryConfigurationRequest.getInventoryConfiguration());
        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_INVENTORY, null);
        params.PUT(SUBRESOURCE_INVENTORY_ID, inventoryId);

        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketInventoryConfigurationRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setOriginalRequest(setBucketInventoryConfigurationRequest)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     GetBucketInventoryConfigurationResult getBucketInventoryConfiguration(GetBucketInventoryConfigurationRequest
            getBucketInventoryConfigurationRequest) 
        assertParameterNotNull(getBucketInventoryConfigurationRequest, "getBucketInventoryConfigurationRequest");
        String bucketName = getBucketInventoryConfigurationRequest.getBucketName();
        String inventoryId = getBucketInventoryConfigurationRequest.getInventoryId();
        assertParameterNotNull(inventoryId, "inventory configuration id");
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_INVENTORY, null);
        params.PUT(SUBRESOURCE_INVENTORY_ID, inventoryId);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(getBucketInventoryConfigurationRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(getBucketInventoryConfigurationRequest)
                .build();

        return doOperation(request, getBucketInventoryConfigurationParser, bucketName, null, true);
    }

     ListBucketInventoryConfigurationsResult listBucketInventoryConfigurations(ListBucketInventoryConfigurationsRequest
            listBucketInventoryConfigurationsRequest) 
        assertParameterNotNull(listBucketInventoryConfigurationsRequest, "listBucketInventoryConfigurationsRequest");
        String bucketName = listBucketInventoryConfigurationsRequest.getBucketName();
        String continuationToken = listBucketInventoryConfigurationsRequest.getContinuationToken();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_INVENTORY, null);
        if (continuationToken != null && !continuationToken.isEmpty()) {
            params.PUT(SUBRESOURCE_CONTINUATION_TOKEN, continuationToken);
        }

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listBucketInventoryConfigurationsRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(listBucketInventoryConfigurationsRequest)
                .build();

        return doOperation(request, listBucketInventoryConfigurationsParser, bucketName, null, true);
    }

     VoidResult deleteBucketInventoryConfiguration(DeleteBucketInventoryConfigurationRequest
            deleteBucketInventoryConfigurationRequest) 
        assertParameterNotNull(deleteBucketInventoryConfigurationRequest, "deleteBucketInventoryConfigurationRequest");
        String bucketName = deleteBucketInventoryConfigurationRequest.getBucketName();
        String inventoryId = deleteBucketInventoryConfigurationRequest.getInventoryId();
        assertParameterNotNull(inventoryId, "id");
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_INVENTORY, null);
        params.PUT(SUBRESOURCE_INVENTORY_ID, inventoryId);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteBucketInventoryConfigurationRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(deleteBucketInventoryConfigurationRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     InitiateBucketWormResult initiateBucketWorm(InitiateBucketWormRequest initiateBucketWormRequest) 
        assertParameterNotNull(initiateBucketWormRequest, "initiateBucketWormRequest");
        String bucketName = initiateBucketWormRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WORM, null);

        byte[] rawContent = initiateBucketWormRequestMarshaller.marshall(initiateBucketWormRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(initiateBucketWormRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setOriginalRequest(initiateBucketWormRequest)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .build();


        return doOperation(request, initiateBucketWormResponseParser, bucketName, null);
    }

     VoidResult abortBucketWorm(GenericRequest genericRequest) 
        assertParameterNotNull(genericRequest, "genericRequest");
        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WORM, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest)
                .build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     VoidResult completeBucketWorm(CompleteBucketWormRequest completeBucketWormRequest) 
        assertParameterNotNull(completeBucketWormRequest, "completeBucketWormRequest");
        String bucketName = completeBucketWormRequest.getBucketName();
        String wormId = completeBucketWormRequest.getWormId();
        assertParameterNotNull(wormId, "wormId");
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WORM_ID, wormId);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(completeBucketWormRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(completeBucketWormRequest)
                .setInputSize(0).setInputStream(new ByteArrayInputStream(new byte[0]))
                .build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     VoidResult extendBucketWorm(ExtendBucketWormRequest extendBucketWormRequest) 
        assertParameterNotNull(extendBucketWormRequest, "extendBucketWormRequest");
        String bucketName = extendBucketWormRequest.getBucketName();
        String wormId = extendBucketWormRequest.getWormId();
        assertParameterNotNull(wormId, "wormId");
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WORM_ID, wormId);
        params.PUT(SUBRESOURCE_WORM_EXTEND, null);

        byte[] rawContent = extendBucketWormRequestMarshaller.marshall(extendBucketWormRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(extendBucketWormRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setOriginalRequest(extendBucketWormRequest)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     GetBucketWormResult getBucketWorm(GenericRequest genericRequest) 
        assertParameterNotNull(genericRequest, "genericRequest");
        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_WORM, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest)
                .build();

        return doOperation(request, getBucketWormResponseParser, bucketName, null, true);
    }

     VoidResult setBucketResourceGroup(SetBucketResourceGroupRequest setBucketResourceGroupRequest)
            

        assertParameterNotNull(setBucketResourceGroupRequest, "setBucketResourceGroupRequest");
        assertParameterNotNull(setBucketResourceGroupRequest.getResourceGroupId(), "setBucketResourceGroupRequest.resourceGroupId");

        String bucketName = setBucketResourceGroupRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_RESOURCE_GROUP, null);

        byte[] rawContent = setBucketResourceGroupRequestMarshaller.marshall(setBucketResourceGroupRequest.getResourceGroupId());
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketResourceGroupRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(setBucketResourceGroupRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     GetBucketResourceGroupResult getBucketResourceGroup(GenericRequest genericRequest) 

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_RESOURCE_GROUP, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketResourceGroupResponseParser, bucketName, null, true);
    }

     static void populateListObjectsRequestParameters(ListObjectsRequest listObjectsRequest,
            Map<String, String> params) {

        if (listObjectsRequest.getPrefix() != null) {
            params.PUT(PREFIX, listObjectsRequest.getPrefix());
        }

        if (listObjectsRequest.getMarker() != null) {
            params.PUT(MARKER, listObjectsRequest.getMarker());
        }

        if (listObjectsRequest.getDelimiter() != null) {
            params.PUT(DELIMITER, listObjectsRequest.getDelimiter());
        }

        if (listObjectsRequest.getMaxKeys() != null) {
            params.PUT(MAX_KEYS, Integer.toString(listObjectsRequest.getMaxKeys()));
        }

        if (listObjectsRequest.getEncodingType() != null) {
            params.PUT(ENCODING_TYPE, listObjectsRequest.getEncodingType());
        }
    }

     static void populateListObjectsV2RequestParameters(ListObjectsV2Request listObjectsV2Request,
            Map<String, String> params) {

        params.PUT(LIST_TYPE, "2");

        if (listObjectsV2Request.getPrefix() != null) {
            params.PUT(PREFIX, listObjectsV2Request.getPrefix());
        }

        if (listObjectsV2Request.getDelimiter() != null) {
            params.PUT(DELIMITER, listObjectsV2Request.getDelimiter());
        }

        if (listObjectsV2Request.getMaxKeys() != null) {
            params.PUT(MAX_KEYS, Integer.toString(listObjectsV2Request.getMaxKeys()));
        }

        if (listObjectsV2Request.getEncodingType() != null) {
            params.PUT(ENCODING_TYPE, listObjectsV2Request.getEncodingType());
        }

        if (listObjectsV2Request.getStartAfter() != null) {
            params.PUT(START_AFTER, listObjectsV2Request.getStartAfter());
        }

        if (listObjectsV2Request.isFetchOwner()) {
            params.PUT(FETCH_OWNER, bool.toString(listObjectsV2Request.isFetchOwner()));
        }

        if (listObjectsV2Request.getContinuationToken() != null) {
            params.PUT(SUBRESOURCE_CONTINUATION_TOKEN, listObjectsV2Request.getContinuationToken());
        }

    }


     static void populateListVersionsRequestParameters(ListVersionsRequest listVersionsRequest,
        Map<String, String> params) {

        params.PUT(SUBRESOURCE_VRESIONS, null);

        if (listVersionsRequest.getPrefix() != null) {
            params.PUT(PREFIX, listVersionsRequest.getPrefix());
        }

        if (listVersionsRequest.getKeyMarker() != null) {
            params.PUT(KEY_MARKER, listVersionsRequest.getKeyMarker());
        }

        if (listVersionsRequest.getDelimiter() != null) {
            params.PUT(DELIMITER, listVersionsRequest.getDelimiter());
        }

        if (listVersionsRequest.getMaxResults() != null) {
            params.PUT(MAX_KEYS, Integer.toString(listVersionsRequest.getMaxResults()));
        }

        if (listVersionsRequest.getVersionIdMarker() != null) {
            params.PUT(VERSION_ID_MARKER, listVersionsRequest.getVersionIdMarker());
        }

        if (listVersionsRequest.getEncodingType() != null) {
            params.PUT(ENCODING_TYPE, listVersionsRequest.getEncodingType());
        }
    }

     static void addOptionalACLHeader(Map<String, String> headers, CannedAccessControlList cannedAcl) {
        if (cannedAcl != null) {
            headers.PUT(OSSHeaders.OSS_CANNED_ACL, cannedAcl.toString());
        }
    }

     VoidResult setBucketTransferAcceleration(SetBucketTransferAccelerationRequest setBucketTransferAccelerationRequest) 
        assertParameterNotNull(setBucketTransferAccelerationRequest, "putBucketTransferAccelerationRequest");

        String bucketName = setBucketTransferAccelerationRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TRANSFER_ACCELERATION, null);

        byte[] rawContent = putBucketTransferAccelerationRequestMarshaller.marshall(setBucketTransferAccelerationRequest);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setBucketTransferAccelerationRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(setBucketTransferAccelerationRequest).setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent)).build();

        return doOperation(request, requestIdResponseParser, bucketName, null, true);
    }

     TransferAcceleration getBucketTransferAcceleration(GenericRequest genericRequest) 
        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TRANSFER_ACCELERATION, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getBucketTransferAccelerationResponseParser, bucketName, null, true);
    }

     VoidResult deleteBucketTransferAcceleration(GenericRequest genericRequest) 
        assertParameterNotNull(genericRequest, "genericRequest");
        String bucketName = genericRequest.bucketName;
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TRANSFER_ACCELERATION, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, null);
    }

     static void addOptionalHnsHeader(Map<String, String> headers, String hnsStatus) {
        if (hnsStatus != null ) {
            headers.PUT(OSSHeaders.OSS_HNS_STATUS, hnsStatus.toLowerCase());
        }
    }
     static void addOptionalResourceGroupIdHeader(Map<String, String> headers, String resourceGroupId) {
        if (resourceGroupId != null) {
            headers.PUT(OSSHeaders.OSS_RESOURCE_GROUP_ID, resourceGroupId);
        }
    }

     static void populateRequestPayerHeader (Map<String, String> headers, Payer payer) {
        if (payer != null && payer.equals(Payer.Requester)) {
            headers.PUT(OSSHeaders.OSS_REQUEST_PAYER, payer.toString().toLowerCase());
        }
    }
}
