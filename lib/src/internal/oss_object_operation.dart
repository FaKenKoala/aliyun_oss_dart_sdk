
import 'oss_operation.dart';

/**
 * Object operation.
 */
 class OSSObjectOperation extends OSSOperation {

     OSSObjectOperation(ServiceClient client, CredentialsProvider credsProvider) {
        super(client, credsProvider);
    }

    /**
     * Upload input stream or file to oss.
     */
     PutObjectResult putObject(PutObjectRequest putObjectRequest) throws OSSException, ClientException {

        assertParameterNotNull(putObjectRequest, "putObjectRequest");

        PutObjectResult result = null;

        if (!isNeedReturnResponse(putObjectRequest)) {
            result = writeObjectInternal(WriteMode.OVERWRITE, putObjectRequest, putObjectReponseParser);
        } else {
            result = writeObjectInternal(WriteMode.OVERWRITE, putObjectRequest, putObjectProcessReponseParser);
        }

        if (isCrcCheckEnabled()) {
            OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
        }

        return result;
    }

    /**
     * Upload input stream to oss by using Uri signature.
     */
     PutObjectResult putObject(Uri signedUri, InputStream requestContent, long contentLength,
            Map<String, String> requestHeaders, bool useChunkEncoding) throws OSSException, ClientException {

        assertParameterNotNull(signedUri, "signedUri");
        assertParameterNotNull(requestContent, "requestContent");

        if (requestHeaders == null) {
            requestHeaders = <String, String>{};
        }

        RequestMessage request = new RequestMessage(null, null);
        request.setMethod(HttpMethod.PUT);
        request.setAbsoluteUri(signedUri);
        request.setUseUriSignature(true);
        request.setContent(requestContent);
        request.setContentLength(determineInputStreamLength(requestContent, contentLength, useChunkEncoding));
        request.setHeaders(requestHeaders);
        request.setUseChunkEncoding(useChunkEncoding);

        PutObjectResult result = null;
        if (requestHeaders.GET(OSSHeaders.OSS_HEADER_CALLBACK) == null) {
            result = doOperation(request, putObjectReponseParser, null, null, true);
        } else {
            result = doOperation(request, putObjectProcessReponseParser, null, null, true);
        }

        if (isCrcCheckEnabled()) {
            OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
        }

        return result;
    }

    /**
     * Upload input stream or file to oss by append mode.
     */
     AppendObjectResult appendObject(AppendObjectRequest appendObjectRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(appendObjectRequest, "appendObjectRequest");

        AppendObjectResult result = writeObjectInternal(WriteMode.APPEND, appendObjectRequest,
                appendObjectResponseParser);

        if (appendObjectRequest.getInitCRC() != null && result.getClientCRC() != null) {
            result.setClientCRC(CRC64.combine(appendObjectRequest.getInitCRC(), result.getClientCRC(),
                    (result.getNextPosition() - appendObjectRequest.getPosition())));
        }

        if (isCrcCheckEnabled() && appendObjectRequest.getInitCRC() != null) {
            OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
        }

        return result;
    }

     SelectObjectMetadata createSelectObjectMetadata(CreateSelectObjectMetadataRequest createSelectObjectMetadataRequest) throws OSSException, ClientException {
        String process = createSelectObjectMetadataRequest.getProcess();
        assertParameterNotNull(process, "process");

        GenericRequest genericRequest = new GenericRequest(
                createSelectObjectMetadataRequest.getBucketName(), createSelectObjectMetadataRequest.getKey());
        genericRequest.getParameters().PUT(RequestParameters.SUBRESOURCE_PROCESS, process);

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, createSelectObjectMetadataRequest.getRequestPayer());

        byte[] content = createSelectObjectMetadataRequestMarshaller.marshall(createSelectObjectMetadataRequest);
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(createSelectObjectMetadataRequest))
                .setMethod(HttpMethod.POST).setInputSize(content.length).setInputStream(new ByteArrayInputStream(content))
                .setBucket(bucketName).setKey(key).setHeaders(headers).setOriginalRequest(genericRequest)
                .build();

        //create meta progress listener(scanned bytes)
        final ProgressListener selectProgressListener = createSelectObjectMetadataRequest.getSelectProgressListener();
        try {
            OSSObject ossObject = doOperation(request, new GetObjectResponseParser(bucketName, key), bucketName, key, true);
            publishProgress(selectProgressListener, ProgressEventType.SELECT_STARTED_EVENT);
            SelectObjectMetadata selectObjectMetadata = new SelectObjectMetadata(ossObject.getObjectMetadata());
            SelectObjectMetadata.SelectContentMetadataBase selectContentMetadataBase;
            if (createSelectObjectMetadataRequest.getInputSerialization().getSelectContentFormat() == SelectContentFormat.CSV) {
                selectObjectMetadata.setCsvObjectMetadata(new SelectObjectMetadata.CSVObjectMetadata());
                selectContentMetadataBase = selectObjectMetadata.getCsvObjectMetadata();
            } else {
                selectObjectMetadata.setJsonObjectMetadata(new SelectObjectMetadata.JsonObjectMetadata());
                selectContentMetadataBase = selectObjectMetadata.getJsonObjectMetadata();
            }
            InputStream in = ossObject.getObjectContent();
            CreateSelectMetaInputStream warppedStream = new CreateSelectMetaInputStream(in, selectContentMetadataBase, selectProgressListener);
            warppedStream.setRequestId(ossObject.getRequestId());
            while (warppedStream.read() != -1) {
                //read until eof
            }
            return selectObjectMetadata;
        } catch (IOException e) {
            publishProgress(selectProgressListener, ProgressEventType.SELECT_FAILED_EVENT);
            throw new RuntimeException(e);
        } catch (RuntimeException e) {
            publishProgress(selectProgressListener, ProgressEventType.SELECT_FAILED_EVENT);
            throw e;
        }
    }

    /**
     * Select an object from oss.
     */
     OSSObject selectObject(SelectObjectRequest selectObjectRequest) throws OSSException, ClientException {
        assertParameterNotNull(selectObjectRequest, "selectObjectRequest");
        String bucketName = selectObjectRequest.getBucketName();
        String key = selectObjectRequest.getKey();
        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);
        Map<String, String> headers = <String, String>{};
        populateGetObjectRequestHeaders(selectObjectRequest, headers);

        populateRequestPayerHeader(headers, selectObjectRequest.getRequestPayer());

        Map<String, String> params = <String, String>{};
        populateResponseHeaderParameters(params, selectObjectRequest.getResponseHeaders());
        String process = selectObjectRequest.getProcess();
        assertParameterNotNull(process, "process");

        params.PUT(RequestParameters.SUBRESOURCE_PROCESS, process);

        SelectObjectRequest.ExpressionType expressionType = selectObjectRequest.getExpressionType();
        if (expressionType != SelectObjectRequest.ExpressionType.SQL) {
            throw ArgumentError("Select object only support sql expression");
        }
        if (selectObjectRequest.getExpression() == null) {
            throw ArgumentError("Select expression is null");
        }
        if (selectObjectRequest.getLineRange() != null && selectObjectRequest.getSplitRange() != null) {
            throw ArgumentError("Line range and split range of select request should not both set");
        }

        byte[] content = selectObjectRequestMarshaller.marshall(selectObjectRequest);

        headers.PUT(HttpHeaders.CONTENT_MD5, BinaryUtil.toBase64String(BinaryUtil.calculateMd5(content)));
        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(selectObjectRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(key).setHeaders(headers)
                .setInputSize(content.length).setInputStream(new ByteArrayInputStream(content))
                .setParameters(params).setOriginalRequest(selectObjectRequest).build();
        //select progress listener(scanned bytes)
        final ProgressListener selectProgressListener = selectObjectRequest.getSelectProgressListener();
        try {
            OSSObject ossObject = doOperation(request, new GetObjectResponseParser(bucketName, key), bucketName, key, true);
            publishProgress(selectProgressListener, ProgressEventType.SELECT_STARTED_EVENT);
            InputStream inputStream = ossObject.getObjectContent();
            if (!bool.parsebool(ossObject.getObjectMetadata().getRawMetadata().GET(OSS_SELECT_OUTPUT_RAW).toString())) {
                SelectInputStream selectInputStream = new SelectInputStream(inputStream, selectProgressListener,
                        selectObjectRequest.getOutputSerialization().isPayloadCrcEnabled());
                selectInputStream.setRequestId(ossObject.getRequestId());
                ossObject.setObjectContent(selectInputStream);
            }
            return ossObject;
        } catch (RuntimeException e) {
            publishProgress(selectProgressListener, ProgressEventType.SELECT_FAILED_EVENT);
            throw e;
        }
    }

    /**
     * Pull an object from oss.
     */
     OSSObject getObject(GetObjectRequest getObjectRequest) throws OSSException, ClientException {

        assertParameterNotNull(getObjectRequest, "getObjectRequest");

        String bucketName = null;
        String key = null;
        RequestMessage request = null;

        if (!getObjectRequest.isUseUriSignature()) {
            assertParameterNotNull(getObjectRequest, "getObjectRequest");

            bucketName = getObjectRequest.getBucketName();
            key = getObjectRequest.getKey();

            assertParameterNotNull(bucketName, "bucketName");
            assertParameterNotNull(key, "key");
            ensureBucketNameValid(bucketName);
            ensureObjectKeyValid(key);

            Map<String, String> headers = <String, String>{};
            populateGetObjectRequestHeaders(getObjectRequest, headers);

            Map<String, String> params = <String, String>{};
            populateResponseHeaderParameters(params, getObjectRequest.getResponseHeaders());

            String versionId = getObjectRequest.getVersionId();
            if (versionId != null) {
                params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, versionId);
            }
            
            String process = getObjectRequest.getProcess();
            if (process != null) {
                params.PUT(RequestParameters.SUBRESOURCE_PROCESS, process);
            }

            request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(getObjectRequest))
                    .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(key).setHeaders(headers)
                    .setParameters(params).setOriginalRequest(getObjectRequest).build();
        } else {
            request = new RequestMessage(getObjectRequest, bucketName, key);
            request.setMethod(HttpMethod.GET);
            request.setAbsoluteUri(getObjectRequest.getAbsoluteUri());
            request.setUseUriSignature(true);
            request.setHeaders(getObjectRequest.getHeaders());
        }

        final ProgressListener listener = getObjectRequest.getProgressListener();
        OSSObject ossObject = null;
        try {
            publishProgress(listener, ProgressEventType.TRANSFER_STARTED_EVENT);
            ossObject = doOperation(request, new GetObjectResponseParser(bucketName, key), bucketName, key, true);
            InputStream instream = ossObject.getObjectContent();
            ProgressInputStream progressInputStream = new ProgressInputStream(instream, listener) {
                @override
                protected void onEOF() {
                    publishProgress(getListener(), ProgressEventType.TRANSFER_COMPLETED_EVENT);
                };
            };
            CRC64 crc = new CRC64();
            CheckedInputStream checkedInputstream = new CheckedInputStream(progressInputStream, crc);
            ossObject.setObjectContent(checkedInputstream);
        } catch (RuntimeException e) {
            publishProgress(listener, ProgressEventType.TRANSFER_FAILED_EVENT);
            throw e;
        }

        return ossObject;
    }

    /**
     * Populate a local file with the specified object.
     */
     ObjectMetadata getObject(GetObjectRequest getObjectRequest, File file) throws OSSException, ClientException {

        assertParameterNotNull(file, "file");

        OSSObject ossObject = getObject(getObjectRequest);

        OutputStream outputStream = null;
        try {
            outputStream = new BufferedOutputStream(new FileOutputStream(file));
            byte[] buffer = new byte[DEFAULT_BUFFER_SIZE];
            int bytesRead;
            while ((bytesRead = IOUtils.readNBytes(ossObject.getObjectContent(), buffer, 0, buffer.length)) > 0) {
                outputStream.write(buffer, 0, bytesRead);
            }

            if (isCrcCheckEnabled() && !hasRangeInRequest(getObjectRequest)) {
                Long clientCRC = IOUtils.getCRCValue(ossObject.getObjectContent());
                OSSUtils.checkChecksum(clientCRC, ossObject.getServerCRC(), ossObject.getRequestId());
            }

            return ossObject.getObjectMetadata();
        } catch (IOException ex) {
            logException("Cannot read object content stream: ", ex);
            throw new ClientException(OSS_RESOURCE_MANAGER.getString("CannotReadContentStream"), ex);
        } finally {
            safeClose(outputStream);
            safeClose(ossObject.getObjectContent());
        }
    }
    
    /**
     * Get simplified object meta.
     */
     SimplifiedObjectMeta getSimplifiedObjectMeta(GenericRequest genericRequest) {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_OBJECTMETA, null);
        if (genericRequest.getVersionId() != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID,
                    genericRequest.getVersionId());
        }

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.HEAD).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getSimplifiedObjectMetaResponseParser, bucketName, key);
    }

    /**
     * Get object matadata.
     */
     ObjectMetadata getObjectMetadata(GenericRequest genericRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);

        Map<String, String> params = <String, String>{};
        if (genericRequest.getVersionId() != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, genericRequest.getVersionId());
        }

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.HEAD).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getObjectMetadataResponseParser, bucketName, key);
    }

    /**
     * Copy an existing object to another one.
     */
     CopyObjectResult copyObject(CopyObjectRequest copyObjectRequest) throws OSSException, ClientException {

        assertParameterNotNull(copyObjectRequest, "copyObjectRequest");

        Map<String, String> headers = <String, String>{};
        populateCopyObjectHeaders(copyObjectRequest, headers);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(copyObjectRequest))
                .setMethod(HttpMethod.PUT).setBucket(copyObjectRequest.getDestinationBucketName())
                .setKey(copyObjectRequest.getDestinationKey()).setHeaders(headers).setOriginalRequest(copyObjectRequest)
                .build();

        return doOperation(request, copyObjectResponseParser, copyObjectRequest.getDestinationBucketName(),
                copyObjectRequest.getDestinationKey(), true);
    }

    /**
     * Delete an object.
     */
     VoidResult deleteObject(GenericRequest genericRequest) throws OSSException, ClientException {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setKey(key).setHeaders(headers).setOriginalRequest(genericRequest)
                .build();

        return doOperation(request, requestIdResponseParser, bucketName, key);
    }

    /**
     * Delete an object version.
     */
     VoidResult deleteVersion(DeleteVersionRequest deleteVersionRequest) throws OSSException, ClientException {

        assertParameterNotNull(deleteVersionRequest, "deleteVersionRequest");

        String bucketName = deleteVersionRequest.getBucketName();
        String key = deleteVersionRequest.getKey();
        String versionId = deleteVersionRequest.getVersionId();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertParameterNotNull(versionId, "versionId");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, versionId);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, deleteVersionRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteVersionRequest))
            .setMethod(HttpMethod.DELETE).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
            .setOriginalRequest(deleteVersionRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, key);
    }

    /**
     * Delete multiple objects.
     */
     DeleteObjectsResult deleteObjects(DeleteObjectsRequest deleteObjectsRequest) {

        assertParameterNotNull(deleteObjectsRequest, "deleteObjectsRequest");

        String bucketName = deleteObjectsRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_DELETE, null);

        byte[] rawContent = deleteObjectsRequestMarshaller.marshall(deleteObjectsRequest);
        Map<String, String> headers = <String, String>{};
        addDeleteObjectsRequiredHeaders(headers, rawContent);
        addDeleteObjectsOptionalHeaders(headers, deleteObjectsRequest);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteObjectsRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(deleteObjectsRequest).build();

        return doOperation(request, deleteObjectsResponseParser, bucketName, null, true);
    }
    
    /**
     * Delete multiple versions.
     */
     DeleteVersionsResult deleteVersions(DeleteVersionsRequest deleteVersionsRequest)
        throws OSSException, ClientException {

        assertParameterNotNull(deleteVersionsRequest, "deleteObjectsRequest");

        String bucketName = deleteVersionsRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_DELETE, null);

        byte[] rawContent = deleteVersionsRequestMarshaller.marshall(deleteVersionsRequest);
        Map<String, String> headers = <String, String>{};
        addDeleteVersionsRequiredHeaders(headers, rawContent);

        populateRequestPayerHeader(headers, deleteVersionsRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteVersionsRequest))
            .setMethod(HttpMethod.POST).setBucket(bucketName).setParameters(params).setHeaders(headers)
            .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
            .setOriginalRequest(deleteVersionsRequest).build();

        return doOperation(request, deleteVersionsResponseParser, bucketName, null, true);
    }

    /**
     * Get head information.
     */
     ObjectMetadata headObject(HeadObjectRequest headObjectRequest) throws OSSException, ClientException {

        assertParameterNotNull(headObjectRequest, "headObjectRequest");

        String bucketName = headObjectRequest.getBucketName();
        String key = headObjectRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);

        Map<String, String> headers = <String, String>{};
        addDateHeader(headers, OSSHeaders.HEAD_OBJECT_IF_MODIFIED_SINCE,
                headObjectRequest.getModifiedSinceConstraint());
        addDateHeader(headers, OSSHeaders.HEAD_OBJECT_IF_UNMODIFIED_SINCE,
                headObjectRequest.getUnmodifiedSinceConstraint());

        addStringListHeader(headers, OSSHeaders.HEAD_OBJECT_IF_MATCH, headObjectRequest.getMatchingETagConstraints());
        addStringListHeader(headers, OSSHeaders.HEAD_OBJECT_IF_NONE_MATCH,
                headObjectRequest.getNonmatchingETagConstraints());

        populateRequestPayerHeader(headers, headObjectRequest.getRequestPayer());

        Map<String, String> params = <String, String>{};
        if (headObjectRequest.getVersionId() != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, headObjectRequest.getVersionId());
        }

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(headObjectRequest))
                .setMethod(HttpMethod.HEAD).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setOriginalRequest(headObjectRequest).build();

        return doOperation(request, headObjectResponseParser, bucketName, key);
    }

     VoidResult setObjectAcl(SetObjectAclRequest setObjectAclRequest) throws OSSException, ClientException {

        assertParameterNotNull(setObjectAclRequest, "setObjectAclRequest");

        String bucketName = setObjectAclRequest.getBucketName();
        String key = setObjectAclRequest.getKey();
        CannedAccessControlList cannedAcl = setObjectAclRequest.getCannedACL();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertParameterNotNull(cannedAcl, "cannedAcl");

        Map<String, String> headers = <String, String>{};
        headers.PUT(OSSHeaders.OSS_OBJECT_ACL, cannedAcl.toString());

        populateRequestPayerHeader(headers, setObjectAclRequest.getRequestPayer());

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ACL, null);
        if (setObjectAclRequest.getVersionId() != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, setObjectAclRequest.getVersionId());
        }

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setObjectAclRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setKey(key).setParameters(params).setHeaders(headers)
                .setOriginalRequest(setObjectAclRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, key);
    }

     ObjectAcl getObjectAcl(GenericRequest genericRequest) throws OSSException, ClientException {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_ACL, null);
        if (genericRequest.getVersionId() != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, genericRequest.getVersionId());
        }

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, getObjectAclResponseParser, bucketName, key, true);
    }

     RestoreObjectResult restoreObject(GenericRequest genericRequest) throws OSSException, ClientException {

        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();
        String versionId = genericRequest.getVersionId();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);

        byte[] content = new byte[0];
        if (genericRequest is RestoreObjectRequest) {
            RestoreObjectRequest restoreObjectRequest = (RestoreObjectRequest) genericRequest;
            if (restoreObjectRequest.getRestoreConfiguration() != null) {
                content = restoreObjectRequestMarshaller.marshall(restoreObjectRequest);
            }
        }

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_RESTORE, null);
        if (versionId != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, versionId);
        }

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setInputStream(new ByteArrayInputStream(content)).setInputSize(content.length)
                .setOriginalRequest(genericRequest).build();

        return doOperation(request, ResponseParsers.restoreObjectResponseParser, bucketName, key);
    }
    
     VoidResult setObjectTagging(SetObjectTaggingRequest setObjectTaggingRequest) throws OSSException, ClientException {
        assertParameterNotNull(setObjectTaggingRequest, "setBucketTaggingRequest");

        String bucketName = setObjectTaggingRequest.getBucketName();
        String key = setObjectTaggingRequest.getKey();
        String versionId = setObjectTaggingRequest.getVersionId();
        
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TAGGING, null);
        if (versionId != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, versionId);
        }

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, setObjectTaggingRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setObjectTaggingRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setInputStreamWithLength(setBucketTaggingRequestMarshaller.marshall(setObjectTaggingRequest))
                .setOriginalRequest(setObjectTaggingRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, key);
    }

     TagSet getObjectTagging(GenericRequest genericRequest) throws OSSException, ClientException {
        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();
        String versionId = genericRequest.getVersionId();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TAGGING, null);
        if (versionId != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, versionId);
        }

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setOriginalRequest(genericRequest).build();
        
        return doOperation(request, getTaggingResponseParser, bucketName, key, true);
    }

     VoidResult deleteObjectTagging(GenericRequest genericRequest) throws OSSException, ClientException {
        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String key = genericRequest.getKey();
        String versionId = genericRequest.getVersionId();
        
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        
        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_TAGGING, null);
        if (versionId != null) {
            params.PUT(RequestParameters.SUBRESOURCE_VRESION_ID, versionId);
        }

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
            .setMethod(HttpMethod.DELETE).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
            .setOriginalRequest(genericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, key);
    }

     OSSSymlink getSymlink(GenericRequest genericRequest) throws OSSException, ClientException {
        assertParameterNotNull(genericRequest, "genericRequest");

        String bucketName = genericRequest.getBucketName();
        String symlink = genericRequest.getKey();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(symlink, "symlink");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(symlink);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_SYMLINK, null);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, genericRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(genericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(symlink).setHeaders(headers).setParameters(params)
                .setOriginalRequest(genericRequest).build();

        OSSSymlink symbolicLink = doOperation(request, getSymbolicLinkResponseParser, bucketName, symlink, true);

        if (symbolicLink != null) {
            symbolicLink.setSymlink(new String(symlink));
        }

        return symbolicLink;
    }

     VoidResult createSymlink(CreateSymlinkRequest createSymlinkRequest) throws OSSException, ClientException {

        assertParameterNotNull(createSymlinkRequest, "createSymlinkRequest");

        String bucketName = createSymlinkRequest.getBucketName();
        String symlink = createSymlinkRequest.getSymlink();
        String target = createSymlinkRequest.getTarget();

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(symlink, "symlink");
        assertParameterNotNull(target, "target");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(symlink);
        ensureObjectKeyValid(target);

        ObjectMetadata metadata = createSymlinkRequest.getMetadata();
        if (metadata == null) {
            metadata = new ObjectMetadata();
        }

        // 设置链接的目标文件
        String encodeTargetObject = HttpUtil.UriEncode(target, DEFAULT_CHARSET_NAME);
        metadata.setHeader(OSSHeaders.OSS_HEADER_SYMLINK_TARGET, encodeTargetObject);
        // 设置链接文件的ContentType，目标文件优先，然后是链接文件
        if (metadata.getContentType() == null) {
            metadata.setContentType(Mimetypes.getInstance().getMimetype(target, symlink));
        }

        Map<String, String> headers = <String, String>{};
        populateRequestMetadata(headers, metadata);

        populateRequestPayerHeader(headers, createSymlinkRequest.getRequestPayer());

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_SYMLINK, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(createSymlinkRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setKey(symlink).setHeaders(headers)
                .setParameters(params).setOriginalRequest(createSymlinkRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, symlink);
    }

     GenericResult processObject(ProcessObjectRequest processObjectRequest) throws OSSException, ClientException {

        assertParameterNotNull(processObjectRequest, "genericRequest");

        String bucketName = processObjectRequest.getBucketName();
        String key = processObjectRequest.getKey();
        String process = processObjectRequest.getProcess();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(key, "key");
        ensureObjectKeyValid(key);
        assertStringNotNullOrEmpty(process, "process");

        Map<String, String> params = <String, String>{};
        params.PUT(RequestParameters.SUBRESOURCE_PROCESS, null);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, processObjectRequest.getRequestPayer());

        byte[] rawContent = processObjectRequestMarshaller.marshall(processObjectRequest);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(processObjectRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(key).setHeaders(headers).setParameters(params)
                .setInputSize(rawContent.length).setInputStream(new ByteArrayInputStream(rawContent))
                .setOriginalRequest(processObjectRequest).build();

        return doOperation(request, ResponseParsers.processObjectResponseParser, bucketName, key, true);
    }

     bool doesObjectExist(GenericRequest genericRequest) throws OSSException, ClientException {
        try {
            this.getSimplifiedObjectMeta(genericRequest);
            return true;
        } catch (OSSException e) {
            if (e.getErrorCode().equals(OSSErrorCode.NO_SUCH_BUCKET)
                    || e.getErrorCode().equals(OSSErrorCode.NO_SUCH_KEY)) {
                return false;
            }
            throw e;
        }
    }

     bool doesObjectExistWithRedirect(GenericRequest genericRequest) throws OSSException, ClientException {
        OSSObject ossObject = null;
        try {
            String bucketName = genericRequest.getBucketName();
            String key = genericRequest.getKey();
            Payer payer = genericRequest.getRequestPayer();

            GetObjectRequest getObjectRequest = new GetObjectRequest(bucketName, key);
            if (payer != null) {
                getObjectRequest.setRequestPayer(payer);
            }
            ossObject = this.getObject(getObjectRequest);
            return true;
        } catch (OSSException e) {
            if (e.getErrorCode().equals(OSSErrorCode.NO_SUCH_BUCKET) || e.getErrorCode().equals(OSSErrorCode.NO_SUCH_KEY)) {
                return false;
            }
            throw e;
        } finally {
            if (ossObject != null) {
                try {
                    ossObject.forcedClose();
                } catch (IOException e) {
                    logException("Forced close failed: ", e);
                }
            }
        }
    }

     VoidResult createDirectory(CreateDirectoryRequest createDirectoryRequest) throws OSSException, ClientException {
        assertParameterNotNull(createDirectoryRequest, "createDirectoryRequest");
        String bucketName = createDirectoryRequest.getBucketName();
        String directory = createDirectoryRequest.getDirectoryName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(directory, "directory");
        ensureObjectKeyValid(directory);

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_DIR, null);

        Map<String, String> headers = <String, String>{};
        populateRequestPayerHeader(headers, createDirectoryRequest.getRequestPayer());

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(createDirectoryRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(directory).setParameters(params).setHeaders(headers)
                .setInputStream(new ByteArrayInputStream(new byte[0])).setInputSize(0)
                .setOriginalRequest(createDirectoryRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, directory);
    }

     DeleteDirectoryResult deleteDirectory(DeleteDirectoryRequest deleteDirectoryRequest) throws OSSException, ClientException {
        assertParameterNotNull(deleteDirectoryRequest, "deleteDirectoryRequest");
        String bucketName = deleteDirectoryRequest.getBucketName();
        String directoryName = deleteDirectoryRequest.getDirectoryName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(directoryName, "directoryName");
        ensureObjectKeyValid(directoryName);

        Map<String, String> headers = <String, String>{};
        populateDeleteDirectoryRequestHeaders(headers, deleteDirectoryRequest);
        populateRequestPayerHeader(headers, deleteDirectoryRequest.getRequestPayer());

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_DIR_DELETE, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(deleteDirectoryRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(directoryName).setParameters(params).setHeaders(headers)
                .setInputStream(new ByteArrayInputStream(new byte[0])).setInputSize(0)
                .setOriginalRequest(deleteDirectoryRequest).build();

         return doOperation(request, deleteDirectoryResponseParser, bucketName, directoryName, true);
    }

     VoidResult renameObject(RenameObjectRequest renameObjectRequest) throws OSSException, ClientException {
        assertParameterNotNull(renameObjectRequest, "renameObjectRequest");
        String bucketName = renameObjectRequest.getBucketName();
        String destObject = renameObjectRequest.getDestinationObjectName();
        String srcObject = renameObjectRequest.getSourceObjectName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(destObject, "dstObject");
        assertParameterNotNull(srcObject, "srcObject");
        ensureObjectKeyValid(destObject);
        ensureObjectKeyValid(srcObject);

        Map<String, String> headers = <String, String>{};
        headers.PUT(OSSHeaders.OSS_RENAME_SOURCE, HttpUtil.UriEncode(srcObject, DEFAULT_CHARSET_NAME));
        populateRequestPayerHeader(headers, renameObjectRequest.getRequestPayer());

        Map<String, String> params = <String, String>{};
        params.PUT(SUBRESOURCE_RENAME, null);

        RequestMessage request = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(renameObjectRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(destObject).setParameters(params).setHeaders(headers)
                .setInputStream(new ByteArrayInputStream(new byte[0])).setInputSize(0)
                .setOriginalRequest(renameObjectRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, destObject);
    }

     static enum MetadataDirective {

        /* Copy metadata from source object */
        COPY("COPY"),

        /* Replace metadata with newly metadata */
        REPLACE("REPLACE");

         final String directiveAsString;

         MetadataDirective(String directiveAsString) {
            this.directiveAsString = directiveAsString;
        }

        @override
         String toString() {
            return this.directiveAsString;
        }
    }

    /**
     * An enum to represent different modes the client may specify to upload
     * specified file or inputstream.
     */
     static enum WriteMode {

        /*
         * If object already not exists, create it. otherwise, append it with
         * the new input
         */
        APPEND("APPEND"),

        /*
         * No matter object exists or not, just overwrite it with the new input
         */
        OVERWRITE("OVERWRITE");

         final String modeAsString;

         WriteMode(String modeAsString) {
            this.modeAsString = modeAsString;
        }

        @override
         String toString() {
            return this.modeAsString;
        }

         static HttpMethod getMappingMethod(WriteMode mode) {
            switch (mode) {
            case APPEND:
                return HttpMethod.POST;

            case OVERWRITE:
                return HttpMethod.PUT;

            default:
                throw ArgumentError("Unsuported write mode" + mode.toString());
            }
        }
    }

     <RequestType extends PutObjectRequest, ResponseType> ResponseType writeObjectInternal(WriteMode mode,
            RequestType originalRequest, ResponseParser<ResponseType> responseParser) {

        final String bucketName = originalRequest.getBucketName();
        final String key = originalRequest.getKey();
        InputStream originalInputStream = originalRequest.getInputStream();
        ObjectMetadata metadata = originalRequest.getMetadata();
        if (metadata == null) {
            metadata = new ObjectMetadata();
        }

        assertParameterNotNull(bucketName, "bucketName");
        assertParameterNotNull(key, "key");
        ensureBucketNameValid(bucketName);
        ensureObjectKeyValid(key);
        ensureCallbackValid(originalRequest.getCallback());

        InputStream repeatableInputStream = null;
        if (originalRequest.getFile() != null) {
            File toUpload = originalRequest.getFile();

            if (!checkFile(toUpload)) {
                getLog().info("Illegal file path: " + toUpload.getPath());
                throw new ClientException("Illegal file path: " + toUpload.getPath());
            }

            metadata.setContentLength(toUpload.length());
            if (metadata.getContentType() == null) {
                metadata.setContentType(Mimetypes.getInstance().getMimetype(toUpload, key));
            }

            try {
                repeatableInputStream = new RepeatableFileInputStream(toUpload);
            } catch (IOException ex) {
                logException("Cannot locate file to upload: ", ex);
                throw new ClientException("Cannot locate file to upload: ", ex);
            }
        } else {
            assertTrue(originalInputStream != null, "Please specify input stream or file to upload");

            if (metadata.getContentType() == null) {
                metadata.setContentType(Mimetypes.getInstance().getMimetype(key));
            }

            try {
                repeatableInputStream = newRepeatableInputStream(originalInputStream);
            } catch (IOException ex) {
                logException("Cannot wrap to repeatable input stream: ", ex);
                throw new ClientException("Cannot wrap to repeatable input stream: ", ex);
            }
        }

        Map<String, String> headers = <String, String>{};
        populateRequestMetadata(headers, metadata);
        populateRequestCallback(headers, originalRequest.getCallback());
        populateRequestPayerHeader(headers, originalRequest.getRequestPayer());
        populateTrafficLimitHeader(headers, originalRequest.getTrafficLimit());

        Map<String, String> params = new LinkedHashMap<String, String>();
        populateWriteObjectParams(mode, originalRequest, params);

        RequestMessage httpRequest = new OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(originalRequest))
                .setMethod(WriteMode.getMappingMethod(mode)).setBucket(bucketName).setKey(key).setHeaders(headers)
                .setParameters(params).setInputStream(repeatableInputStream)
                .setInputSize(determineInputStreamLength(repeatableInputStream, metadata.getContentLength()))
                .setOriginalRequest(originalRequest).build();

        List<ResponseHandler> reponseHandlers = [];
        reponseHandlers.add(new OSSCallbackErrorResponseHandler());

        final ProgressListener listener = originalRequest.getProgressListener();
        ResponseType result = null;
        try {
            publishProgress(listener, ProgressEventType.TRANSFER_STARTED_EVENT);
            if (originalRequest.getCallback() == null) {
                result = doOperation(httpRequest, responseParser, bucketName, key, true);
            } else {
                result = doOperation(httpRequest, responseParser, bucketName, key, true, null, reponseHandlers);
            }
            publishProgress(listener, ProgressEventType.TRANSFER_COMPLETED_EVENT);
        } catch (RuntimeException e) {
            publishProgress(listener, ProgressEventType.TRANSFER_FAILED_EVENT);
            throw e;
        }
        return result;
    }

     bool isCrcCheckEnabled() {
        return getInnerClient().getClientConfiguration().isCrcCheckEnabled();
    }

     bool hasRangeInRequest(GetObjectRequest getObjectRequest) {
        return getObjectRequest.getHeaders().GET(OSSHeaders.RANGE) != null;
    }

     static void populateCopyObjectHeaders(CopyObjectRequest copyObjectRequest, Map<String, String> headers) {

        String copySourceHeader = "/" + copyObjectRequest.getSourceBucketName() + "/"
                + HttpUtil.UriEncode(copyObjectRequest.getSourceKey(), DEFAULT_CHARSET_NAME);
        if (copyObjectRequest.getSourceVersionId() != null) {
            copySourceHeader += "?versionId=" + copyObjectRequest.getSourceVersionId();
        }

        headers.PUT(OSSHeaders.COPY_OBJECT_SOURCE, copySourceHeader);

        addDateHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_MODIFIED_SINCE,
                copyObjectRequest.getModifiedSinceConstraint());
        addDateHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_UNMODIFIED_SINCE,
                copyObjectRequest.getUnmodifiedSinceConstraint());

        addStringListHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_MATCH,
                copyObjectRequest.getMatchingETagConstraints());
        addStringListHeader(headers, OSSHeaders.COPY_OBJECT_SOURCE_IF_NONE_MATCH,
                copyObjectRequest.getNonmatchingEtagConstraints());

        addHeader(headers, OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION, copyObjectRequest.getServerSideEncryption());
        addHeader(headers, OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION_KEY_ID, copyObjectRequest.getServerSideEncryptionKeyId());

        ObjectMetadata newObjectMetadata = copyObjectRequest.getNewObjectMetadata();
        if (newObjectMetadata != null) {
            headers.PUT(OSSHeaders.COPY_OBJECT_METADATA_DIRECTIVE, MetadataDirective.REPLACE.toString());
            if (newObjectMetadata.getRawMetadata().GET(OSSHeaders.OSS_TAGGING) != null) {
            	headers.PUT(OSSHeaders.COPY_OBJECT_TAGGING_DIRECTIVE, MetadataDirective.REPLACE.toString());
            }
            populateRequestMetadata(headers, newObjectMetadata);
        }

        populateRequestPayerHeader(headers, copyObjectRequest.getRequestPayer());

        // The header of Content-Length should not be specified on copying an
        // object.
        removeHeader(headers, HttpHeaders.CONTENT_LENGTH);
    }

     static void populateGetObjectRequestHeaders(GetObjectRequest getObjectRequest,
            Map<String, String> headers) {

        if (getObjectRequest.getRange() != null) {
            addGetObjectRangeHeader(getObjectRequest.getRange(), headers);
        }

        if (getObjectRequest.getModifiedSinceConstraint() != null) {
            headers.PUT(OSSHeaders.GET_OBJECT_IF_MODIFIED_SINCE,
                    DateUtil.formatRfc822Date(getObjectRequest.getModifiedSinceConstraint()));
        }

        if (getObjectRequest.getUnmodifiedSinceConstraint() != null) {
            headers.PUT(OSSHeaders.GET_OBJECT_IF_UNMODIFIED_SINCE,
                    DateUtil.formatRfc822Date(getObjectRequest.getUnmodifiedSinceConstraint()));
        }

        if (getObjectRequest.getMatchingETagConstraints().size() > 0) {
            headers.PUT(OSSHeaders.GET_OBJECT_IF_MATCH, joinETags(getObjectRequest.getMatchingETagConstraints()));
        }

        if (getObjectRequest.getNonmatchingETagConstraints().size() > 0) {
            headers.PUT(OSSHeaders.GET_OBJECT_IF_NONE_MATCH,
                    joinETags(getObjectRequest.getNonmatchingETagConstraints()));
        }

        populateRequestPayerHeader(headers, getObjectRequest.getRequestPayer());
        populateTrafficLimitHeader(headers, getObjectRequest.getTrafficLimit());
    }

     static void addDeleteObjectsRequiredHeaders(Map<String, String> headers, byte[] rawContent) {
        headers.PUT(HttpHeaders.CONTENT_LENGTH, String.valueOf(rawContent.length));

        byte[] md5 = BinaryUtil.calculateMd5(rawContent);
        String md5Base64 = BinaryUtil.toBase64String(md5);
        headers.PUT(HttpHeaders.CONTENT_MD5, md5Base64);
    }
    
     static void addDeleteVersionsRequiredHeaders(Map<String, String> headers, byte[] rawContent) {
        addDeleteObjectsRequiredHeaders(headers, rawContent);
        headers.PUT(ENCODING_TYPE, OSSConstants.Uri_ENCODING);
    }

     static void addDeleteObjectsOptionalHeaders(Map<String, String> headers, DeleteObjectsRequest request) {
        if (request.getEncodingType() != null) {
            headers.PUT(ENCODING_TYPE, request.getEncodingType());
        }

        populateRequestPayerHeader(headers, request.getRequestPayer());
    }

     static void addGetObjectRangeHeader(long[] range, Map<String, String> headers) {
        RangeSpec rangeSpec = RangeSpec.parse(RANGE);
        headers.PUT(OSSHeaders.RANGE, rangeSpec.toString());
    }

     static void populateRequestPayerHeader(Map<String, String> headers, Payer payer) {
        if (payer != null && payer.equals(Payer.Requester)) {
            headers.PUT(OSSHeaders.OSS_REQUEST_PAYER, payer.toString().toLowerCase());
        }
    }

     static void populateTrafficLimitHeader(Map<String, String> headers, int limit) {
        if (limit > 0) {
            headers.PUT(OSSHeaders.OSS_HEADER_TRAFFIC_LIMIT, String.valueOf(limit));
        }
    }

     static void populateWriteObjectParams(WriteMode mode, PutObjectRequest originalRequest,
            Map<String, String> params) {

        if (mode == WriteMode.OVERWRITE) {
            return;
        }

        assert (originalRequest is AppendObjectRequest);
        params.PUT(RequestParameters.SUBRESOURCE_APPEND, null);
        AppendObjectRequest appendObjectRequest = (AppendObjectRequest) originalRequest;
        if (appendObjectRequest.getPosition() != null) {
            params.PUT(RequestParameters.POSITION, String.valueOf(appendObjectRequest.getPosition()));
        }
    }

     static bool isNeedReturnResponse(PutObjectRequest putObjectRequest) {
        if (putObjectRequest.getCallback() != null || putObjectRequest.getProcess() != null) {
            return true;
        }
        return false;
    }

     static void populateDeleteDirectoryRequestHeaders(Map<String, String> headers, DeleteDirectoryRequest deleteDirectoryRequest) {
        if (deleteDirectoryRequest.isDeleteRecursive()) {
            headers.PUT(OSSHeaders.OSS_DELETE_RECURSIVE, deleteDirectoryRequest.isDeleteRecursive().toString());
        }
        if (deleteDirectoryRequest.getNextDeleteToken() != null && !deleteDirectoryRequest.getNextDeleteToken().isEmpty()) {
            headers.PUT(OSSHeaders.OSS_DELETE_TOKEN, deleteDirectoryRequest.getNextDeleteToken());
        }
    }

}