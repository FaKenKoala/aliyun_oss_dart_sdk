
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/service_client.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/binary_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/model/create_live_channel_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/create_live_channel_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generate_rtmp_uri_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/live_channel_generic_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/set_live_channel_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/void_result.dart';

import 'oss_callback_error_response_handler.dart';
import 'oss_operation.dart';
import 'oss_request_message_builder.dart';
import 'oss_utils.dart';
import 'request_parameters.dart';

/// Live channel operation.
 class LiveChannelOperation extends OSSOperation {

     LiveChannelOperation(ServiceClient client, CredentialsProvider credsProvider) :
        super(client, credsProvider);
    

     CreateLiveChannelResult createLiveChannel(CreateLiveChannelRequest createLiveChannelRequest)
             {
        assertParameterNotNull(createLiveChannelRequest, "createLiveChannelRequest");

        String bucketName = createLiveChannelRequest.bucketName;
        String liveChannelName = createLiveChannelRequest.liveChannelName;

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);

        Map<String, String?> parameters = <String, String?>{};
        parameters[RequestParameters.SUBRESOURCE_LIVE]= null;

        List<int> rawContent = createLiveChannelRequestMarshaller.marshall(createLiveChannelRequest);
        Map<String, String> headers = <String, String>{};
        addRequestRequiredHeaders(headers, rawContent);

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient())..endpoint(getEndpoint(createLiveChannelRequest))
                .setMethod(HttpMethod.PUT).setBucket(bucketName).setKey(liveChannelName).setParameters(parameters)
                .setHeaders(headers).setInputSize(rawContent.length)
                .setInputStream(ByteArrayInputStream(rawContent)).setOriginalRequest(createLiveChannelRequest)
                .build();

        List<ResponseHandler> reponseHandlers = [];
        reponseHandlers.add(OSSCallbackErrorResponseHandler());

        return doOperation(request, createLiveChannelResponseParser, bucketName, liveChannelName, true);
    }

     VoidResult setLiveChannelStatus(SetLiveChannelRequest setLiveChannelRequest) {

        assertParameterNotNull(setLiveChannelRequest, "setLiveChannelRequest");

        String bucketName = setLiveChannelRequest.bucketName;
        String liveChannelName = setLiveChannelRequest.liveChannelName;

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);

        Map<String, String?> parameters = <String, String?>{};
        parameters[RequestParameters.SUBRESOURCE_LIVE] =  null;
        parameters[RequestParameters.SUBRESOURCE_STATUS] =  setLiveChannelRequest.status.toString();

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(setLiveChannelRequest))
                .setMethod(HttpMethod.put).setBucket(bucketName).setKey(liveChannelName).setParameters(parameters)
                .setOriginalRequest(setLiveChannelRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, liveChannelName);
    }

     LiveChannelInfo getLiveChannelInfo(LiveChannelGenericRequest liveChannelGenericRequest)
             {

        assertParameterNotNull(liveChannelGenericRequest, "liveChannelGenericRequest");

        String bucketName = liveChannelGenericRequest.getBucketName();
        String liveChannelName = liveChannelGenericRequest.getLiveChannelName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);

        Map<String, String> parameters = HashMap<String, String>();
        parameters[RequestParameters.SUBRESOURCE_LIVE, null)

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(liveChannelGenericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(liveChannelName).setParameters(parameters)
                .setOriginalRequest(liveChannelGenericRequest).build();

        return doOperation(request, getLiveChannelInfoResponseParser, bucketName, liveChannelName, true);
    }

     LiveChannelStat getLiveChannelStat(LiveChannelGenericRequest liveChannelGenericRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(liveChannelGenericRequest, "liveChannelGenericRequest");

        String bucketName = liveChannelGenericRequest.getBucketName();
        String liveChannelName = liveChannelGenericRequest.getLiveChannelName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);

        Map<String, String> parameters = HashMap<String, String>();
        parameters[RequestParameters.SUBRESOURCE_LIVE, null)
        parameters[RequestParameters.SUBRESOURCE_COMP, RequestParameters.STAT)

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(liveChannelGenericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(liveChannelName).setParameters(parameters)
                .setOriginalRequest(liveChannelGenericRequest).build();

        return doOperation(request, getLiveChannelStatResponseParser, bucketName, liveChannelName, true);
    }

     VoidResult deleteLiveChannel(LiveChannelGenericRequest liveChannelGenericRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(liveChannelGenericRequest, "liveChannelGenericRequest");

        String bucketName = liveChannelGenericRequest.getBucketName();
        String liveChannelName = liveChannelGenericRequest.getLiveChannelName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);

        Map<String, String> parameters = HashMap<String, String>();
        parameters[RequestParameters.SUBRESOURCE_LIVE, null)

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(liveChannelGenericRequest))
                .setMethod(HttpMethod.DELETE).setBucket(bucketName).setKey(liveChannelName).setParameters(parameters)
                .setOriginalRequest(liveChannelGenericRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, liveChannelName);
    }

    /**
     * List all live channels.
     */
     List<LiveChannel> listLiveChannels(String bucketName) throws OSSException, ClientException {
        LiveChannelListing liveChannelListing = listLiveChannels(ListLiveChannelsRequest(bucketName));
        List<LiveChannel> liveChannels = liveChannelListing.getLiveChannels();
        while (liveChannelListing.isTruncated()) {
            liveChannelListing = listLiveChannels(
                    ListLiveChannelsRequest(bucketName, "", liveChannelListing.getNextMarker()));
            liveChannels.addAll(liveChannelListing.getLiveChannels());
        }
        return liveChannels;
    }

    /**
     * List live channels.
     */
     LiveChannelListing listLiveChannels(ListLiveChannelsRequest listLiveChannelRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(listLiveChannelRequest, "listObjectsRequest");

        String bucketName = listLiveChannelRequest.getBucketName();
        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);

        Map<String, String> parameters = LinkedHashMap<String, String>();
        parameters[RequestParameters.SUBRESOURCE_LIVE, null)
        populateListLiveChannelsRequestParameters(listLiveChannelRequest, parameters);

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(listLiveChannelRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setParameters(parameters)
                .setOriginalRequest(listLiveChannelRequest).build();

        return doOperation(request, listLiveChannelsReponseParser, bucketName, null, true);
    }

     List<LiveRecord> getLiveChannelHistory(LiveChannelGenericRequest liveChannelGenericRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(liveChannelGenericRequest, "liveChannelGenericRequest");

        String bucketName = liveChannelGenericRequest.getBucketName();
        String liveChannelName = liveChannelGenericRequest.getLiveChannelName();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);

        Map<String, String> parameters = HashMap<String, String>();
        parameters[RequestParameters.SUBRESOURCE_LIVE, null)
        parameters[RequestParameters.SUBRESOURCE_COMP, RequestParameters.HISTORY)

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(liveChannelGenericRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(liveChannelName).setParameters(parameters)
                .setOriginalRequest(liveChannelGenericRequest).build();

        return doOperation(request, getLiveChannelHistoryResponseParser, bucketName, liveChannelName, true);
    }

     VoidResult generateVodPlaylist(GenerateVodPlaylistRequest generateVodPlaylistRequest)
            throws OSSException, ClientException {

        assertParameterNotNull(generateVodPlaylistRequest, "generateVodPlaylistRequest");

        String bucketName = generateVodPlaylistRequest.getBucketName();
        String liveChannelName = generateVodPlaylistRequest.getLiveChannelName();
        String playlistName = generateVodPlaylistRequest.getPlaylistName();
        Long startTime = generateVodPlaylistRequest.getStartTime();
        Long endTime = generateVodPlaylistRequest.getEndTime();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);
        assertParameterNotNull(playlistName, "playlistName");
        assertParameterNotNull(startTime, "startTime");
        assertParameterNotNull(endTime, "endTime");

        Map<String, String> parameters = HashMap<String, String>();
        parameters[RequestParameters.SUBRESOURCE_VOD, null)
        parameters[RequestParameters.SUBRESOURCE_START_TIME, startTime.toString())
        parameters[RequestParameters.SUBRESOURCE_END_TIME, endTime.toString())

        String key = liveChannelName + "/" + playlistName;
        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(generateVodPlaylistRequest))
                .setMethod(HttpMethod.POST).setBucket(bucketName).setKey(key).setParameters(parameters)
                .setInputStream(ByteArrayInputStream(byte[0])).setInputSize(0)
                .setOriginalRequest(generateVodPlaylistRequest).build();

        return doOperation(request, requestIdResponseParser, bucketName, key);
    }

     OSSObject getVodPlaylist(GetVodPlaylistRequest getVodPlaylistRequest) throws OSSException, ClientException {

        assertParameterNotNull(getVodPlaylistRequest, "getVodPlaylistRequest");

        String bucketName = getVodPlaylistRequest.getBucketName();
        String liveChannelName = getVodPlaylistRequest.getLiveChannelName();
        Long startTime = getVodPlaylistRequest.getStartTime();
        Long endTime = getVodPlaylistRequest.getEndTime();

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);
        assertParameterNotNull(startTime, "startTime");
        assertParameterNotNull(endTime, "endTime");

        Map<String, String> parameters = HashMap<String, String>();
        parameters[RequestParameters.SUBRESOURCE_VOD, null)
        parameters[RequestParameters.SUBRESOURCE_START_TIME, startTime.toString())
        parameters[RequestParameters.SUBRESOURCE_END_TIME, endTime.toString())

        RequestMessage request = OSSRequestMessageBuilder(getInnerClient()).setEndpoint(getEndpoint(getVodPlaylistRequest))
                .setMethod(HttpMethod.GET).setBucket(bucketName).setKey(liveChannelName).setParameters(parameters)
                .setOriginalRequest(getVodPlaylistRequest).build();

        return doOperation(request, GetObjectResponseParser(bucketName, liveChannelName), bucketName, liveChannelName, true);
    }

     String generateRtmpUri(GenerateRtmpUriRequest request) {

        assertParameterNotNull(request, "request");

        String bucketName = request.bucketName;
        String liveChannelName = request.liveChannelName;
        String playlistName = request.playlistName;
        int expires = request.expires;

        assertParameterNotNull(bucketName, "bucketName");
        ensureBucketNameValid(bucketName);
        assertParameterNotNull(liveChannelName, "liveChannelName");
        ensureLiveChannelNameValid(liveChannelName);
        assertParameterNotNull(playlistName, "playlistName");
        assertParameterNotNull(expires, "expires");

        Credentials currentCreds = credsProvider.getCredentials();
        String accessId = currentCreds.getAccessKeyId();
        String accessKey = currentCreds.getSecretAccessKey();
        bool useSecurityToken = currentCreds.useSecurityToken();

        // Endpoint
        RequestMessage requestMessage = RequestMessage(bucketName, liveChannelName);
        ClientConfiguration config = client.getClientConfiguration();
        requestMessage.endpoint = OSSUtils.determineFinalEndpoint(endpoint, bucketName, config);

        // Headers
        requestMessage.addHeader(HttpHeaders.DATE, expires.toString());

        // Parameters
        requestMessage.addParameter(RequestParameters.PLAYLIST_NAME, playlistName);

        if (useSecurityToken) {
            requestMessage.addParameter(SECURITY_TOKEN, currentCreds.getSecurityToken()!);
        }

        // Signature
        String canonicalResource = "/" + bucketName + "/" + liveChannelName;
        String canonicalString = SignUtils.buildRtmpCanonicalString(canonicalResource, requestMessage,
                expires.toString());
        String signature = ServiceSignature.create().computeSignature(accessKey, canonicalString);

        // Build query string
        Map<String, String> params = <String, String>{};
        params[HttpHeaders.EXPIRES] =  expires.toString();
        params[OSS_ACCESS_KEY_ID, accessId)
        params[SIGNATURE, signature)
        params.putAll(requestMessage.getParameters());

        String queryString = HttpUtil.paramToQueryString(params, DEFAULT_CHARSET_NAME);

        // Compose rtmp request uri
        String uri = requestMessage.getEndpoint().toString();
        String livChan = RequestParameters.SUBRESOURCE_LIVE + "/" + liveChannelName;

        if (uri.startsWith(OSSConstants.PROTOCOL_HTTP)) {
            uri = uri.replaceFirst(OSSConstants.PROTOCOL_HTTP, OSSConstants.PROTOCOL_RTMP);
        } else if (uri.startsWith(OSSConstants.PROTOCOL_HTTPS)) {
            uri = uri.replaceFirst(OSSConstants.PROTOCOL_HTTPS, OSSConstants.PROTOCOL_RTMP);
        } else if (!uri.startsWith(OSSConstants.PROTOCOL_RTMP)) {
            uri = OSSConstants.PROTOCOL_RTMP + uri;
        }

        if (!uri.endsWith("/")) {
            uri += "/";
        }
        uri += livChan + "?" + queryString;

        return uri;
    }

     static void populateListLiveChannelsRequestParameters(ListLiveChannelsRequest listLiveChannelRequest,
            Map<String, String> params) {

        if (listLiveChannelRequest.getPrefix() != null) {
            params[RequestParameters.PREFIX]= listLiveChannelRequest.getPrefix();
        }

        if (listLiveChannelRequest.getMarker() != null) {
            params[RequestParameters.MARKER]= listLiveChannelRequest.getMarker();
        }

        if (listLiveChannelRequest.getMaxKeys() != null) {
            params[RequestParameters.MAX_KEYS] = '${listLiveChannelRequest.getMaxKeys()}';
        }
    }

     static void addRequestRequiredHeaders(Map<String, String> headers, List<int> rawContent) {
        headers[HttpHeaders.contentLength] =  '${rawContent.length}';

        List<int> md5 = BinaryUtil.calculateMd5(rawContent);
        String md5Base64 = BinaryUtil.toBase64String(md5);
        headers[HttpHeaders.CONTENT_MD5] = md5Base64;
    }

}
