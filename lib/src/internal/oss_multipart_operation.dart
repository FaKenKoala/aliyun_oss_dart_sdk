
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/service_client.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_multipart_upload_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';

import 'oss_operation.dart';

/**
 * Multipart operation.
 */
 class OSSMultipartOperation extends OSSOperation {

     static final int LIST_PART_MAX_RETURNS = 1000;
     static final int LIST_UPLOAD_MAX_RETURNS = 1000;
     static final int MAX_PART_NUMBER = 10000;

     OSSMultipartOperation(ServiceClient client, CredentialsProvider credsProvider) {
        super(client, credsProvider);
    }

    @override
    protected bool isRetryablePostRequest(WebServiceRequest request) {
        if (request is InitiateMultipartUploadRequest) {
            return true;
        }
        return super.isRetryablePostRequest(request);
    }

    /**
     * Abort multipart upload.
     */
     VoidResult abortMultipartUpload(AbortMultipartUploadRequest abortMultipartUploadRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(abortMultipartUploadRequest, "abortMultipartUploadRequest");

        String key = abortMultipartUploadRequest.getKey();
        String bucketName = abortMultipartUploadRequest.getBucketName();
        String uploadId = abortMultipartUploadRequest.getUploadId();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertStringNotNullOrEmpty(uploadId, "uploadId");

        Map<String, String> parameters = <String, String>{};
        parameters.PUT(UPLOAD_ID, uploadId);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, abortMultipartUploadRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(abortMultipartUploadRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(parameters)
                .setOriginalRequest(abortMultipartUploadRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, key);
    }

    /**
     * Complete multipart upload.
     */
     CompleteMultipartUploadResult completeMultipartUpload(
            CompleteMultipartUploadRequest completeMultipartUploadRequest) throws OSSException, ClientException {

        assertParameterNotNull(completeMultipartUploadRequest, "completeMultipartUploadRequest");

        String key = completeMultipartUploadRequest.getKey();
        String bucketName = completeMultipartUploadRequest.getBucketName();
        String uploadId = completeMultipartUploadRequest.getUploadId();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertStringNotNullOrEmpty(uploadId, "uploadId");
        ensureCallbackValid(completeMultipartUploadRequest.getCallback());

        Map<String, String> headers = <String, String>{};
        populateCompleteMultipartUploadOptionalHeaders(completeMultipartUploadRequest, headers);
        populateRequestCallback(headers, completeMultipartUploadRequest.getCallback());

        populateRequestPayerHeader(headers, completeMultipartUploadRequest.getRequestPayer());

        Map<String, String> parameters = <String, String>{};
        parameters.PUT(UPLOAD_ID, uploadId);

        List<PartETag> partETags = completeMultipartUploadRequest.getPartETags();
        FixedLengthInputStream requestInstream;
        if (partETags != null) {
            Collections.sort(partETags, new Comparator<PartETag>() {
                @override
                 int compare(PartETag p1, PartETag p2) {
                    return p1.getPartNumber() - p2.getPartNumber();
                }
            });
            requestInstream = completeMultipartUploadRequestMarshaller.marshall(completeMultipartUploadRequest);
        } else {
            requestInstream = new FixedLengthInputStream(new ByteArrayInputStream("".getBytes()), 0);
        }

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(completeMultipartUploadRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(key).setHeaders(headers)
                .setParameters(parameters)
                .setInputStreamWithLength(requestInstream)
                .setOriginalRequest(completeMultipartUploadRequest).build();

        List<ResponseHandler> reponseHandlers = [];
        reponseHandlers.add(new OSSCallbackErrorResponseHandler());

        CompleteMultipartUploadResult result = null;
        if (!isNeedReturnResponse(completeMultipartUploadRequest)) {
            result = doOperation(request, completeMultipartUploadResponseParser, bucketName, key, true);
        } else {
            result = doOperation(request, completeMultipartUploadProcessResponseParser, bucketName, key, true, null,
                    reponseHandlers);
        }

        if (partETags != null) {
            result.setClientCRC(calcObjectCRCFromParts(partETags));
        }
        if (getInnerClient().getClientConfiguration().isCrcCheckEnabled()) {
            OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
        }

        return result;
    }

    /**
     * Initiate multipart upload.
     */
     InitiateMultipartUploadResult initiateMultipartUpload(
            InitiateMultipartUploadRequest initiateMultipartUploadRequest) throws OSSException, ClientException {

        assertParameterNotNull(initiateMultipartUploadRequest, "initiateMultipartUploadRequest");

        String key = initiateMultipartUploadRequest.getKey();
        String bucketName = initiateMultipartUploadRequest.getBucketName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);

        Map<String, String> headers = <String, String>{};
        if (initiateMultipartUploadRequest.getObjectMetadata() != null) {
            populateRequestMetadata(headers, initiateMultipartUploadRequest.getObjectMetadata());
        }

        populateRequestPayerHeader(headers, initiateMultipartUploadRequest.getRequestPayer());

        // Be careful that we don't send the object's total size as the content
        // length for the InitiateMultipartUpload request.
        removeHeader(headers, OSSHeaders.CONTENT_LENGTH);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_UPLOADS, null);

        bool sequentialMode = initiateMultipartUploadRequest.getSequentialMode();
        if (sequentialMode != null && sequentialMode.equals(true)) {
            params.PUT(SEQUENTIAL, null);
        }

        // Set the request content to be empty (but not null) to avoid putting
        // parameters
        // to request body. Set HttpRequestFactory#createHttpRequest for
        // details.
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(initiateMultipartUploadRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setInputStream(new ByteArrayInputStream(new byte[0])).setInputSize(0)
                .setOriginalRequest(initiateMultipartUploadRequest).build();

        return doOperation(request, initiateMultipartUploadResponseParser, bucketName, key, true);
    }

    /**
     * List multipart uploads.
     */
     MultipartUploadListing listMultipartUploads(ListMultipartUploadsRequest listMultipartUploadsRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(listMultipartUploadsRequest, "listMultipartUploadsRequest");

        String bucketName = listMultipartUploadsRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        // Use a LinkedHashMap to preserve the insertion order.
        Map<String, String> params = new LinkedHashMap<String, String>();
        populateListMultipartUploadsRequestParameters(listMultipartUploadsRequest, params);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, listMultipartUploadsRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listMultipartUploadsRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setHeaders(headers).setParameters(params)
                .setOriginalRequest(listMultipartUploadsRequest).build();

        return doOperation(request, listMultipartUploadsResponseParser, bucketName, null, true);
    }

    /**
     * List parts.
     */
     PartListing listParts(ListPartsRequest listPartsRequest) throws OSSException, ClientException {

        assertParameterNotNull(listPartsRequest, "listPartsRequest");

        String key = listPartsRequest.getKey();
        String bucketName = listPartsRequest.getBucketName();
        String uploadId = listPartsRequest.getUploadId();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertStringNotNullOrEmpty(uploadId, "uploadId");

        // Use a LinkedHashMap to preserve the insertion order.
        Map<String, String> params = new LinkedHashMap<String, String>();
        populateListPartsRequestParameters(listPartsRequest, params);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, listPartsRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listPartsRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setOriginalRequest(listPartsRequest).build();

        return doOperation(request, listPartsResponseParser, bucketName, key, true);
    }

    /**
     * Upload part.
     */
     UploadPartResult uploadPart(UploadPartRequest uploadPartRequest) throws OSSException, ClientException {

        assertParameterNotNull(uploadPartRequest, "uploadPartRequest");

        String key = uploadPartRequest.getKey();
        String bucketName = uploadPartRequest.getBucketName();
        String uploadId = uploadPartRequest.getUploadId();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertStringNotNullOrEmpty(uploadId, "uploadId");

        if (uploadPartRequest.getInputStream() == null) {
            throw ArgumentError(OSS_RESOURCE_MANAGER.getString("MustSetContentStream"));
        }

        InputStream repeatableInputStream = null;
        try {
            repeatableInputStream = newRepeatableInputStream(uploadPartRequest.buildPartialStream());
        } catch (IOException ex) {
            logException("Cannot wrap to repeatable input stream: ", ex);
            throw new ClientException("Cannot wrap to repeatable input stream: ", ex);
        }

        int partNumber = uploadPartRequest.getPartNumber();
        if (!checkParamRange(partNumber, 0, false, MAX_PART_NUMBER, true)) {
            throw ArgumentError(OSS_RESOURCE_MANAGER.getString("PartNumberOutOfRange"));
        }

        Map<String, String> headers = <String, String>{};
        populateUploadPartOptionalHeaders(uploadPartRequest, headers);

        populateRequestPayerHeader(headers, uploadPartRequest.getRequestPayer());
        populateTrafficLimitHeader(headers, uploadPartRequest.getTrafficLimit());

        // Use a LinkedHashMap to preserve the insertion order.
        Map<String, String> params = new LinkedHashMap<String, String>();
        params.PUT(PART_NUMBER, Integer.toString(partNumber));
        params.PUT(UPLOAD_ID, uploadId);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(uploadPartRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setKey(key).setParameters(params).setHeaders(headers)
                .setInputStream(repeatableInputStream).setInputSize(uploadPartRequest.getPartSize())
                .setUseChunkEncoding(uploadPartRequest.isUseChunkEncoding()).setOriginalRequest(uploadPartRequest)
                .build();

        final ProgressListener listener = uploadPartRequest.getProgressListener();
        ResponseMessage response = null;
        try {
            publishProgress(listener, ProgressEventType.TRANSFER_PART_STARTED_EVENT);
            response = doOperation(request, emptyResponseParser, bucketName, key);
            publishProgress(listener, ProgressEventType.TRANSFER_PART_COMPLETED_EVENT);
        } catch (RuntimeException e) {
            publishProgress(listener, ProgressEventType.TRANSFER_PART_FAILED_EVENT);
            throw e;
        }

        UploadPartResult result = new UploadPartResult();
        result.setPartNumber(partNumber);
        result.setETag(trimQuotes(response.getHeaders().GET(OSSHeaders.ETAG)));
        result.setRequestId(response.getRequestId());
        result.setPartSize(uploadPartRequest.getPartSize());
        result.setResponse(response);
        ResponseParsers.setCRC(result, response);

        if (getInnerClient().getClientConfiguration().isCrcCheckEnabled()) {
            OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
        }

        return result;
    }

    /**
     * Upload part copy.
     */
     UploadPartCopyResult uploadPartCopy(UploadPartCopyRequest uploadPartCopyRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(uploadPartCopyRequest, "uploadPartCopyRequest");

        String key = uploadPartCopyRequest.getKey();
        String bucketName = uploadPartCopyRequest.getBucketName();
        String uploadId = uploadPartCopyRequest.getUploadId();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertStringNotNullOrEmpty(uploadId, "uploadId");

        Long partSize = uploadPartCopyRequest.getPartSize();
        if (partSize != null) {
            if (!checkParamRange(partSize, 0, true, DEFAULT_FILE_SIZE_LIMIT, true)) {
                throw ArgumentError(OSS_RESOURCE_MANAGER.getString("FileSizeOutOfRange"));
            }
        }

        int partNumber = uploadPartCopyRequest.getPartNumber();
        if (!checkParamRange(partNumber, 0, false, MAX_PART_NUMBER, true)) {
            throw ArgumentError(OSS_RESOURCE_MANAGER.getString("PartNumberOutOfRange"));
        }

        Map<String, String> headers = <String, String>{};
        populateCopyPartRequestHeaders(uploadPartCopyRequest, headers);

        // Use a LinkedHashMap to preserve the insertion order.
        Map<String, String> params = new LinkedHashMap<String, String>();
        params.PUT(PART_NUMBER, Integer.toString(partNumber));
        params.PUT(UPLOAD_ID, uploadId);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(uploadPartCopyRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setKey(key).setParameters(params).setHeaders(headers)
                .setOriginalRequest(uploadPartCopyRequest).build();

        return doOperation(request, new UploadPartCopyResponseParser(partNumber), bucketName, key, true);
    }

     static void populateListMultipartUploadsRequestParameters(
            ListMultipartUploadsRequest listMultipartUploadsRequest, Map<String, String> params) {

        // Make sure 'uploads' be the first parameter.
        params.PUT(SUBRESOURCE_UPLOADS, null);

        if (listMultipartUploadsRequest.getDelimiter() != null) {
            params.PUT(DELIMITER, listMultipartUploadsRequest.getDelimiter());
        }

        if (listMultipartUploadsRequest.getKeyMarker() != null) {
            params.PUT(KEY_MARKER, listMultipartUploadsRequest.getKeyMarker());
        }

        Integer maxUploads = listMultipartUploadsRequest.getMaxUploads();
        if (maxUploads != null) {
            if (!checkParamRange(maxUploads, 0, true, LIST_UPLOAD_MAX_RETURNS, true)) {
                throw ArgumentError(
                        OSS_RESOURCE_MANAGER.getFormattedString("MaxUploadsOutOfRange", LIST_UPLOAD_MAX_RETURNS));
            }
            params.PUT(MAX_UPLOADS, listMultipartUploadsRequest.getMaxUploads().toString());
        }

        if (listMultipartUploadsRequest.getPrefix() != null) {
            params.PUT(PREFIX, listMultipartUploadsRequest.getPrefix());
        }

        if (listMultipartUploadsRequest.getUploadIdMarker() != null) {
            params.PUT(UPLOAD_ID_MARKER, listMultipartUploadsRequest.getUploadIdMarker());
        }

        if (listMultipartUploadsRequest.getEncodingType() != null) {
            params.PUT(ENCODING_TYPE, listMultipartUploadsRequest.getEncodingType());
        }
    }

     static void populateListPartsRequestParameters(ListPartsRequest listPartsRequest,
            Map<String, String> params) {

        params.PUT(UPLOAD_ID, listPartsRequest.getUploadId());

        Integer maxParts = listPartsRequest.getMaxParts();
        if (maxParts != null) {
            if (!checkParamRange(maxParts, 0, true, LIST_PART_MAX_RETURNS, true)) {
                throw ArgumentError(
                        OSS_RESOURCE_MANAGER.getFormattedString("MaxPartsOutOfRange", LIST_PART_MAX_RETURNS));
            }
            params.PUT(MAX_PARTS, maxParts.toString());
        }

        Integer partNumberMarker = listPartsRequest.getPartNumberMarker();
        if (partNumberMarker != null) {
            if (!checkParamRange(partNumberMarker, 0, false, MAX_PART_NUMBER, true)) {
                throw ArgumentError(OSS_RESOURCE_MANAGER.getString("PartNumberMarkerOutOfRange"));
            }
            params.PUT(PART_NUMBER_MARKER, partNumberMarker.toString());
        }

        if (listPartsRequest.getEncodingType() != null) {
            params.PUT(ENCODING_TYPE, listPartsRequest.getEncodingType());
        }
    }

     static void populateCopyPartRequestHeaders(UploadPartCopyRequest uploadPartCopyRequest,
            Map<String, String> headers) {

        if (uploadPartCopyRequest.getPartSize() != null) {
            headers.PUT(OSSHeaders.CONTENT_LENGTH, Long.toString(uploadPartCopyRequest.getPartSize()));
        }

        if (uploadPartCopyRequest.getMd5Digest() != null) {
            headers.PUT(OSSHeaders.CONTENT_MD5, uploadPartCopyRequest.getMd5Digest());
        }

        String copySource = "/" + uploadPartCopyRequest.getSourceBucketName() + "/"
                + HttpUtil.urlEncode(uploadPartCopyRequest.getSourceKey(), DEFAULT_CHARSET_NAME);
        if (uploadPartCopyRequest.getSourceVersionId() != null) {
            copySource += "?versionId=" + uploadPartCopyRequest.getSourceVersionId();
        }
        headers.PUT(OSSHeaders.COPY_OBJECT_SOURCE, copySource);

        if (uploadPartCopyRequest.getBeginIndex() != null && uploadPartCopyRequest.getPartSize() != null) {
            String range = "bytes=" + uploadPartCopyRequest.getBeginIndex() + "-"
                    + Long.toString(uploadPartCopyRequest.getBeginIndex() + uploadPartCopyRequest.getPartSize() - 1);
            headers.PUT(OSSHeaders.COPY_SOURCE_RANGE, range);
        }

        if (uploadPartCopyRequest.getRequestPayer() != null) {
            headers.PUT(OSSHeaders.OSS_REQUEST_PAYER, uploadPartCopyRequest.getRequestPayer().toString().toLowerCase());
        }

        addDateHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_MODIFIED_SINCE,
                uploadPartCopyRequest.getModifiedSinceConstraint());
        addDateHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_UNMODIFIED_SINCE,
                uploadPartCopyRequest.getUnmodifiedSinceConstraint());

        addStringListHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_MATCH,
                uploadPartCopyRequest.getMatchingETagConstraints());
        addStringListHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_NONE_MATCH,
                uploadPartCopyRequest.getNonmatchingEtagConstraints());
    }

     static void populateUploadPartOptionalHeaders(UploadPartRequest uploadPartRequest,
            Map<String, String> headers) {

        if (!uploadPartRequest.isUseChunkEncoding()) {
            long partSize = uploadPartRequest.getPartSize();
            if (!checkParamRange(partSize, 0, true, DEFAULT_FILE_SIZE_LIMIT, true)) {
                throw ArgumentError(OSS_RESOURCE_MANAGER.getString("FileSizeOutOfRange"));
            }

            headers.PUT(OSSHeaders.CONTENT_LENGTH, Long.toString(partSize));
        }

        if (uploadPartRequest.getMd5Digest() != null) {
            headers.PUT(OSSHeaders.CONTENT_MD5, uploadPartRequest.getMd5Digest());
        }
    }

     static void populateCompleteMultipartUploadOptionalHeaders(
            CompleteMultipartUploadRequest completeMultipartUploadRequest, Map<String, String> headers) {

        CannedAccessControlList cannedACL = completeMultipartUploadRequest.getObjectACL();
        if (cannedACL != null) {
            headers.PUT(OSSHeaders.OSS_OBJECT_ACL, cannedACL.toString());
        }
    }

     static void populateRequestPayerHeader (Map<String, String> headers, Payer payer) {
        if (payer != null && payer.equals(Payer.Requester)) {
            headers.PUT(OSSHeaders.OSS_REQUEST_PAYER, payer.toString().toLowerCase());
        }
    }

     static void populateTrafficLimitHeader(Map<String, String> headers, int limit) {
        if (limit > 0) {
            headers.PUT(OSSHeaders.OSS_HEADER_TRAFFIC_LIMIT, String.valueOf(limit));
        }
    }

     static Long calcObjectCRCFromParts(List<PartETag> partETags) {
        long crc = 0;
        for (PartETag partETag : partETags) {
            if (partETag.getPartCRC() == null || partETag.getPartSize() <= 0) {
                return null;
            }
            crc = CRC64.combine(crc, partETag.getPartCRC(), partETag.getPartSize());
        }
        return new Long(crc);
    }

     static bool isNeedReturnResponse(CompleteMultipartUploadRequest completeMultipartUploadRequest) {
        if (completeMultipartUploadRequest.getCallback() != null
                || completeMultipartUploadRequest.getProcess() != null) {
            return true;
        }
        return false;
    }
}
