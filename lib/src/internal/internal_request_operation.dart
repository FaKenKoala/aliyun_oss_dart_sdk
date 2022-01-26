 import 'package:aliyun_oss_dart_sdk/src/common/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_constants.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/oss_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/response_parser.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/response_parsers.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/put_object_result.dart';

class InternalRequestOperation {

     static final int LIST_PART_MAX_RETURNS = 1000;
     static final int MAX_PART_NUMBER = 10000;
     static ExecutorService executorService =
            Executors.newFixedThreadPool(OSSConstants.DEFAULT_BASE_THREAD_POOL_SIZE, ThreadFactory() {
                @override
                 Thread newThread(Runnable r) {
                    return Thread(r, "oss-android-api-thread");
                }
            });
      URI endpoint;
     URI service;
     OkHttpClient innerClient;
     Context applicationContext;
     OSSCredentialProvider credentialProvider;
     int maxRetryCount = OSSConstants.defaultRetryCount;
     ClientConfiguration conf;

     InternalRequestOperation(Context context, final URI endpoint, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        this.applicationContext = context;
        this.endpoint = endpoint;
        this.credentialProvider = credentialProvider;
        this.conf = conf;

        OkHttpClient.Builder builder = OkHttpClient.Builder()
                .followRedirects(false)
                .followSslRedirects(false)
                .retryOnConnectionFailure(false)
                .cache(null)
                .hostnameVerifier(HostnameVerifier() {
                    @override
                     bool verify(String hostname, SSLSession session) {
                        return HttpsURLConnection.getDefaultHostnameVerifier().verify(endpoint.getHost(), session);
                    }
                });

        if (conf != null) {
            Dispatcher dispatcher = Dispatcher();
            dispatcher.setMaxRequests(conf.getMaxConcurrentRequest());

            builder.connectTimeout(conf.getConnectionTimeout(), TimeUnit.MILLISECONDS)
                    .readTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .writeTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .dispatcher(dispatcher);

            if (conf.getProxyHost() != null && conf.getProxyPort() != 0) {
                builder.proxy(Proxy(Proxy.Type.HTTP, new InetSocketAddress(conf.getProxyHost(), conf.getProxyPort())));
            }

            this.maxRetryCount = conf.getMaxErrorRetry();
        }
        this.innerClient = builder.build();
    }

     InternalRequestOperation(Context context, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        try {
            service = URI("http://oss.aliyuncs.com");
            endpoint = URI("http://127.0.0.1"); //构造假的endpoint
        } catch ( e) {
            throw ArgumentError("Endpoint must be a string like 'http://oss-cn-****.aliyuncs.com'," +
                    "or your cname like 'http://image.cnamedomain.com'!");
        }
        this.applicationContext = context;
        this.credentialProvider = credentialProvider;
        this.conf = conf;
        OkHttpClient.Builder builder = OkHttpClient.Builder()
                .followRedirects(false)
                .followSslRedirects(false)
                .retryOnConnectionFailure(false)
                .cache(null)
                .hostnameVerifier(HostnameVerifier() {
                    @override
                     bool verify(String hostname, SSLSession session) {
                        return HttpsURLConnection.getDefaultHostnameVerifier().verify(service.getHost(), session);
                    }
                });

        if (conf != null) {
            Dispatcher dispatcher = Dispatcher();
            dispatcher.setMaxRequests(conf.getMaxConcurrentRequest());

            builder.connectTimeout(conf.getConnectionTimeout(), TimeUnit.MILLISECONDS)
                    .readTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .writeTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .dispatcher(dispatcher);

            if (conf.getProxyHost() != null && conf.getProxyPort() != 0) {
                builder.proxy(Proxy(Proxy.Type.HTTP, new InetSocketAddress(conf.getProxyHost(), conf.getProxyPort())));
            }

            this.maxRetryCount = conf.getMaxErrorRetry();
        }
        this.innerClient = builder.build();
    }

     PutObjectResult syncPutObject(
            PutObjectRequest request)  {
        PutObjectResult result = putObject(request, null).getResult();
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<PutObjectResult> putObject(
            PutObjectRequest request, final OSSCompletedCallback<PutObjectRequest, PutObjectResult> completedCallback) {
        OSSLog.logDebug(" Internal putObject Start ");
        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        if (request.getUploadData() != null) {
            requestMessage.setUploadData(request.getUploadData());
        }
        if (request.getUploadFilePath() != null) {
            requestMessage.setUploadFilePath(request.getUploadFilePath());
        }
        if (request.getUploadUri() != null) {
            requestMessage.setUploadUri(request.getUploadUri());
        }
        if (request.getCallbackParam() != null) {
            requestMessage.getHeaders()["x-oss-callback"] = OSSUtils.populateMapToBase64JsonString(request.getCallbackParam());
        }
        if (request.getCallbackVars() != null) {
            requestMessage.getHeaders()["x-oss-callback-var"] = OSSUtils.populateMapToBase64JsonString(request.getCallbackVars());
        }
        OSSLog.logDebug(" populateRequestMetadata ");
        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());
        OSSLog.logDebug(" canonicalizeRequestMessage ");
        canonicalizeRequestMessage(requestMessage, request);
        OSSLog.logDebug(" ExecutionContext ");
        ExecutionContext<PutObjectRequest, PutObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(OSSCompletedCallback<PutObjectRequest, PutObjectResult>() {
                @override
                 void onSuccess(PutObjectRequest request, PutObjectResult result) {
                    checkCRC64(request, result, completedCallback);
                }

                @override
                 void onFailure(PutObjectRequest request, OSSClientException clientException, OSSServiceException serviceException) {
                    completedCallback.onFailure(request, clientException, serviceException);
                }
            });
        }

        if (request.getRetryCallback() != null) {
            executionContext.setRetryCallback(request.getRetryCallback());
        }

        executionContext.setProgressCallback(request.getProgressCallback());
        ResponseParser<PutObjectResult> parser = ResponseParsers.PutObjectResponseParser();

        Callable<PutObjectResult> callable = OSSRequestTask<PutObjectResult>(requestMessage, parser, executionContext, maxRetryCount);
        OSSLog.logDebug(" call OSSRequestTask ");
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<CreateBucketResult> createBucket(
            CreateBucketRequest request, OSSCompletedCallback<CreateBucketRequest, CreateBucketResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        if (request.getBucketACL() != null) {
            requestMessage.getHeaders()[OSSHeaders.OSS_CANNED_ACL] = request.getBucketACL().toString();
        }
        try {
            Map<String, String> configures = HashMap<String, String>();
            if (request.getLocationConstraint() != null) {
                configures[CreateBucketRequest.TAB_LOCATIONCONSTRAINT] = request.getLocationConstraint();
            }
            configures[CreateBucketRequest.TAB_STORAGECLASS] = request.getBucketStorageClass().toString();
            requestMessage.createBucketRequestBodyMarshall(configures);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<CreateBucketRequest, CreateBucketResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<CreateBucketResult> parser = ResponseParsers.CreateBucketResponseParser();

        Callable<CreateBucketResult> callable = OSSRequestTask<CreateBucketResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketResult> deleteBucket(
            DeleteBucketRequest request, OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketRequest, DeleteBucketResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteBucketResult> parser = ResponseParsers.DeleteBucketResponseParser();
        Callable<DeleteBucketResult> callable = OSSRequestTask<DeleteBucketResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketInfoResult> getBucketInfo(
            GetBucketInfoRequest request, OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["bucketInfo"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketInfoRequest, GetBucketInfoResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketInfoResult> parser = ResponseParsers.GetBucketInfoResponseParser();
        Callable<GetBucketInfoResult> callable = OSSRequestTask<GetBucketInfoResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketACLResult> getBucketACL(
            GetBucketACLRequest request, OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["acl"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketACLRequest, GetBucketACLResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketACLResult> parser = ResponseParsers.GetBucketACLResponseParser();
        Callable<GetBucketACLResult> callable = OSSRequestTask<GetBucketACLResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketRefererResult> putBucketReferer(
            PutBucketRefererRequest request, OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["referer"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);

        try {
            requestMessage.putBucketRefererRequestBodyMarshall(request.getReferers(), request.isAllowEmpty());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutBucketRefererRequest, PutBucketRefererResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutBucketRefererResult> parser = ResponseParsers.PutBucketRefererResponseParser();
        Callable<PutBucketRefererResult> callable = OSSRequestTask<PutBucketRefererResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketRefererResult> getBucketReferer(
            GetBucketRefererRequest request, OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["referer"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketRefererRequest, GetBucketRefererResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketRefererResult> parser = ResponseParsers.GetBucketRefererResponseParser();
        Callable<GetBucketRefererResult> callable = OSSRequestTask<GetBucketRefererResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketLoggingResult> putBucketLogging(
            PutBucketLoggingRequest request, OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["logging"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);

        try {
            requestMessage.putBucketLoggingRequestBodyMarshall(request.getTargetBucketName(), request.getTargetPrefix());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutBucketLoggingRequest, PutBucketLoggingResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutBucketLoggingResult> parser = ResponseParsers.PutBucketLoggingResponseParser();
        Callable<PutBucketLoggingResult> callable = OSSRequestTask<PutBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketLoggingResult> getBucketLogging(
            GetBucketLoggingRequest request, OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["logging"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketLoggingRequest, GetBucketLoggingResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketLoggingResult> parser = ResponseParsers.GetBucketLoggingResponseParser();
        Callable<GetBucketLoggingResult> callable = OSSRequestTask<GetBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketLoggingResult> deleteBucketLogging(
            DeleteBucketLoggingRequest request, OSSCompletedCallback<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["logging"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteBucketLoggingResult> parser = ResponseParsers.DeleteBucketLoggingResponseParser();
        Callable<DeleteBucketLoggingResult> callable = OSSRequestTask<DeleteBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketLifecycleResult> putBucketLifecycle(
            PutBucketLifecycleRequest request, OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["lifecycle"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);

        try {
            requestMessage.putBucketLifecycleRequestBodyMarshall(request.getLifecycleRules());
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutBucketLifecycleRequest, PutBucketLifecycleResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutBucketLifecycleResult> parser = ResponseParsers.PutBucketLifecycleResponseParser();
        Callable<PutBucketLifecycleResult> callable = OSSRequestTask<PutBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketLifecycleResult> getBucketLifecycle(
            GetBucketLifecycleRequest request, OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["lifecycle"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketLifecycleRequest, GetBucketLifecycleResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketLifecycleResult> parser = ResponseParsers.GetBucketLifecycleResponseParser();
        Callable<GetBucketLifecycleResult> callable = OSSRequestTask<GetBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketLifecycleResult> deleteBucketLifecycle(
            DeleteBucketLifecycleRequest request, OSSCompletedCallback<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["lifecycle"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteBucketLifecycleResult> parser = ResponseParsers.DeleteBucketLifecycleResponseParser();
        Callable<DeleteBucketLifecycleResult> callable = OSSRequestTask<DeleteBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     AppendObjectResult syncAppendObject(
            AppendObjectRequest request)  {
        AppendObjectResult result = appendObject(request, null).getResult();
        bool checkCRC = request.getCRC64() == OSSRequest.CRC64Config.YES ? true : false;
        if (request.getInitCRC64() != null && checkCRC) {
            result.setClientCRC(CRC64.combine(request.getInitCRC64(), result.getClientCRC(),
                    (result.getNextPosition() - request.getPosition())));
        }
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<AppendObjectResult> appendObject(
            AppendObjectRequest request, final OSSCompletedCallback<AppendObjectRequest, AppendObjectResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        if (request.getUploadData() != null) {
            requestMessage.setUploadData(request.getUploadData());
        }
        if (request.getUploadFilePath() != null) {
            requestMessage.setUploadFilePath(request.getUploadFilePath());
        }
        if (request.getUploadUri() != null) {
            requestMessage.setUploadUri(request.getUploadUri());
        }
        requestMessage.getParameters()[RequestParameters.SUBRESOURCE_APPEND] = "";
        requestMessage.getParameters()[RequestParameters.POSITION] = String.valueOf(request.getPosition());

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<AppendObjectRequest, AppendObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(OSSCompletedCallback<AppendObjectRequest, AppendObjectResult>() {
                @override
                 void onSuccess(AppendObjectRequest request, AppendObjectResult result) {
                    bool checkCRC = request.getCRC64() == OSSRequest.CRC64Config.YES ? true : false;
                    if (request.getInitCRC64() != null && checkCRC) {
                        result.setClientCRC(CRC64.combine(request.getInitCRC64(), result.getClientCRC(),
                                (result.getNextPosition() - request.getPosition())));
                    }
                    checkCRC64(request, result, completedCallback);
                }

                @override
                 void onFailure(AppendObjectRequest request, OSSClientException clientException, OSSServiceException serviceException) {
                    completedCallback.onFailure(request, clientException, serviceException);
                }
            });
        }
        executionContext.setProgressCallback(request.getProgressCallback());
        ResponseParser<AppendObjectResult> parser = ResponseParsers.AppendObjectResponseParser();

        Callable<AppendObjectResult> callable = OSSRequestTask<AppendObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<HeadObjectResult> headObject(
            HeadObjectRequest request, OSSCompletedCallback<HeadObjectRequest, HeadObjectResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.HEAD);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<HeadObjectRequest, HeadObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<HeadObjectResult> parser = ResponseParsers.HeadObjectResponseParser();

        Callable<HeadObjectResult> callable = OSSRequestTask<HeadObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetObjectResult> getObject(
            GetObjectRequest request, OSSCompletedCallback<GetObjectRequest, GetObjectResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        if (request.getRange() != null) {
            requestMessage.getHeaders()[OSSHeaders.RANGE] = request.getRange().toString();
        }

        if (request.getxOssProcess() != null) {
            requestMessage.getParameters()[RequestParameters.X_OSS_PROCESS] = request.getxOssProcess();
        }

        canonicalizeRequestMessage(requestMessage, request);

        if (request.getRequestHeaders() != null) {
            for (Map.Entry<String, String> entry : request.getRequestHeaders().entrySet()) {
                requestMessage.getHeaders()[entry.getKey()] = entry.getValue();
            }
        }

        ExecutionContext<GetObjectRequest, GetObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        executionContext.setProgressCallback(request.getProgressListener());
        ResponseParser<GetObjectResult> parser = ResponseParsers.GetObjectResponseParser();

        Callable<GetObjectResult> callable = OSSRequestTask<GetObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetObjectACLResult> getObjectACL(GetObjectACLRequest request, OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["acl"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setParameters(query);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<GetObjectACLRequest, GetObjectACLResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetObjectACLResult> parser = ResponseParsers.GetObjectACLResponseParser();

        Callable<GetObjectACLResult> callable = OSSRequestTask<GetObjectACLResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<CopyObjectResult> copyObject(
            CopyObjectRequest request, OSSCompletedCallback<CopyObjectRequest, CopyObjectResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getDestinationBucketName());
        requestMessage.setObjectKey(request.getDestinationKey());

        OSSUtils.populateCopyObjectHeaders(request, requestMessage.getHeaders());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<CopyObjectRequest, CopyObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<CopyObjectResult> parser = ResponseParsers.CopyObjectResponseParser();

        Callable<CopyObjectResult> callable = OSSRequestTask<CopyObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteObjectResult> deleteObject(
            DeleteObjectRequest request, OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<DeleteObjectRequest, DeleteObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteObjectResult> parser = ResponseParsers.DeleteObjectResponseParser();

        Callable<DeleteObjectResult> callable = OSSRequestTask<DeleteObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteMultipleObjectResult> deleteMultipleObject(
            DeleteMultipleObjectRequest request, OSSCompletedCallback<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query["delete"] = "";

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        try {
            List<int> bodyBytes = requestMessage.deleteMultipleObjectRequestBodyMarshall(request.getObjectKeys(), request.getQuiet());
            if (bodyBytes != null && bodyBytes.length > 0) {
                requestMessage.getHeaders()[OSSHeaders.CONTENT_MD5] = BinaryUtil.calculateBase64Md5(bodyBytes);
                requestMessage.getHeaders()[OSSHeaders.CONTENT_LENGTH] = String.valueOf(bodyBytes.length);
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteMultipleObjectResult> parser = ResponseParsers.DeleteMultipleObjectResponseParser();

        Callable<DeleteMultipleObjectResult> callable = OSSRequestTask<DeleteMultipleObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);


    }

     OSSAsyncTask<ListBucketsResult> listBuckets(
            ListBucketsRequest request, OSSCompletedCallback<ListBucketsRequest, ListBucketsResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setService(service);
        requestMessage.setEndpoint(endpoint); //设置假Endpoint

        canonicalizeRequestMessage(requestMessage, request);

        OSSUtils.populateListBucketRequestParameters(request, requestMessage.getParameters());
        ExecutionContext<ListBucketsRequest, ListBucketsResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListBucketsResult> parser = ResponseParsers.ListBucketResponseParser();
        Callable<ListBucketsResult> callable = OSSRequestTask<ListBucketsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListObjectsResult> listObjects(
            ListObjectsRequest request, OSSCompletedCallback<ListObjectsRequest, ListObjectsResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());

        canonicalizeRequestMessage(requestMessage, request);

        OSSUtils.populateListObjectsRequestParameters(request, requestMessage.getParameters());

        ExecutionContext<ListObjectsRequest, ListObjectsResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListObjectsResult> parser = ResponseParsers.ListObjectsResponseParser();

        Callable<ListObjectsResult> callable = OSSRequestTask<ListObjectsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<InitiateMultipartUploadResult> initMultipartUpload(
            InitiateMultipartUploadRequest request, OSSCompletedCallback<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters()[RequestParameters.SUBRESOURCE_UPLOADS] = "";
        if (request.isSequential) {
            requestMessage.getParameters()[RequestParameters.SUBRESOURCE_SEQUENTIAL] = "";
        }

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<InitiateMultipartUploadResult> parser = ResponseParsers.InitMultipartResponseParser();

        Callable<InitiateMultipartUploadResult> callable = OSSRequestTask<InitiateMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     UploadPartResult syncUploadPart(
            UploadPartRequest request)  {
        UploadPartResult result = uploadPart(request, null).getResult();
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<UploadPartResult> uploadPart(
            UploadPartRequest request, final OSSCompletedCallback<UploadPartRequest, UploadPartResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters()[RequestParameters.UPLOAD_ID] = request.getUploadId();
        requestMessage.getParameters()[RequestParameters.PART_NUMBER] = String.valueOf(request.getPartNumber());
        requestMessage.setUploadData(request.getPartContent());
        if (request.getMd5Digest() != null) {
            requestMessage.getHeaders()[OSSHeaders.CONTENT_MD5] = request.getMd5Digest();
        }

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<UploadPartRequest, UploadPartResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(OSSCompletedCallback<UploadPartRequest, UploadPartResult>() {
                @override
                 void onSuccess(UploadPartRequest request, UploadPartResult result) {
                    checkCRC64(request, result, completedCallback);
                }

                @override
                 void onFailure(UploadPartRequest request, OSSClientException clientException, OSSServiceException serviceException) {
                    completedCallback.onFailure(request, clientException, serviceException);
                }
            });
        }
        executionContext.setProgressCallback(request.getProgressCallback());
        ResponseParser<UploadPartResult> parser = ResponseParsers.UploadPartResponseParser();

        Callable<UploadPartResult> callable = OSSRequestTask<UploadPartResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     CompleteMultipartUploadResult syncCompleteMultipartUpload(
            CompleteMultipartUploadRequest request)  {
        CompleteMultipartUploadResult result = completeMultipartUpload(request, null).getResult();
        if (result.getServerCRC() != null) {
            int crc64 = calcObjectCRCFromParts(request.getPartETags());
            result.setClientCRC(crc64);
        }
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<CompleteMultipartUploadResult> completeMultipartUpload(
            CompleteMultipartUploadRequest request, final OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setStringBody(OSSUtils.buildXMLFromPartEtagList(request.getPartETags()));

        requestMessage.getParameters()[RequestParameters.UPLOAD_ID] = request.getUploadId();

        if (request.getCallbackParam() != null) {
            requestMessage.getHeaders()["x-oss-callback"] = OSSUtils.populateMapToBase64JsonString(request.getCallbackParam());
        }
        if (request.getCallbackVars() != null) {
            requestMessage.getHeaders()["x-oss-callback-var"] = OSSUtils.populateMapToBase64JsonString(request.getCallbackVars());
        }

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult>() {
                @override
                 void onSuccess(CompleteMultipartUploadRequest request, CompleteMultipartUploadResult result) {
                    if (result.getServerCRC() != null) {
                        int crc64 = calcObjectCRCFromParts(request.getPartETags());
                        result.setClientCRC(crc64);
                    }
                    checkCRC64(request, result, completedCallback);
                }

                @override
                 void onFailure(CompleteMultipartUploadRequest request, OSSClientException clientException, OSSServiceException serviceException) {
                    completedCallback.onFailure(request, clientException, serviceException);
                }
            });
        }
        ResponseParser<CompleteMultipartUploadResult> parser = ResponseParsers.CompleteMultipartUploadResponseParser();

        Callable<CompleteMultipartUploadResult> callable = OSSRequestTask<CompleteMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<AbortMultipartUploadResult> abortMultipartUpload(
            AbortMultipartUploadRequest request, OSSCompletedCallback<AbortMultipartUploadRequest, AbortMultipartUploadResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters()[RequestParameters.UPLOAD_ID] = request.getUploadId();

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<AbortMultipartUploadRequest, AbortMultipartUploadResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<AbortMultipartUploadResult> parser = ResponseParsers.AbortMultipartUploadResponseParser();

        Callable<AbortMultipartUploadResult> callable = OSSRequestTask<AbortMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListPartsResult> listParts(
            ListPartsRequest request, OSSCompletedCallback<ListPartsRequest, ListPartsResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters()[RequestParameters.UPLOAD_ID] = request.getUploadId();

        Integer maxParts = request.getMaxParts();
        if (maxParts != null) {
            if (!OSSUtils.checkParamRange(maxParts, 0, true, LIST_PART_MAX_RETURNS, true)) {
                throw ArgumentError("MaxPartsOutOfRange: " + LIST_PART_MAX_RETURNS);
            }
            requestMessage.getParameters()[RequestParameters.MAX_PARTS] = maxParts.toString();
        }

        Integer partNumberMarker = request.getPartNumberMarker();
        if (partNumberMarker != null) {
            if (!OSSUtils.checkParamRange(partNumberMarker, 0, false, MAX_PART_NUMBER, true)) {
                throw ArgumentError("PartNumberMarkerOutOfRange: " + MAX_PART_NUMBER);
            }
            requestMessage.getParameters()[RequestParameters.PART_NUMBER_MARKER] = partNumberMarker.toString();
        }

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<ListPartsRequest, ListPartsResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListPartsResult> parser = ResponseParsers.ListPartsResponseParser();

        Callable<ListPartsResult> callable = OSSRequestTask<ListPartsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListMultipartUploadsResult> listMultipartUploads(
            ListMultipartUploadsRequest request, OSSCompletedCallback<ListMultipartUploadsRequest, ListMultipartUploadsResult> completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());

        requestMessage.getParameters()[RequestParameters.SUBRESOURCE_UPLOADS] = "";

        OSSUtils.populateListMultipartUploadsRequestParameters(request, requestMessage.getParameters());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<ListMultipartUploadsRequest, ListMultipartUploadsResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListMultipartUploadsResult> parser = ResponseParsers.ListMultipartUploadsResponseParser();

        Callable<ListMultipartUploadsResult> callable = OSSRequestTask<ListMultipartUploadsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     bool checkIfHttpDnsAvailable(bool httpDnsEnable) {
        if (httpDnsEnable) {
            if (applicationContext == null) {
                return false;
            }

            bool IS_ICS_OR_LATER = Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH;

            String proxyHost;

            if (IS_ICS_OR_LATER) {
                proxyHost = System.getProperty("http.proxyHost");
            } else {
                proxyHost = android.net.Proxy.getHost(applicationContext);
            }

            String confProxyHost = conf.getProxyHost();
            if (confProxyHost).notNullOrEmpty {
                proxyHost = confProxyHost;
            }
return proxyHost.nullOrEmpty;
        }
        return false;
    }

     OkHttpClient getInnerClient() {
        return innerClient;
    }

     void canonicalizeRequestMessage(RequestMessage message, OSSRequest request) {
        Map<String, String> header = message.getHeaders();

        if (header.get(OSSHeaders.DATE) == null) {
            header[OSSHeaders.DATE] = DateUtil.currentFixedSkewedTimeInRFC822Format();
        }

        if (message.getMethod() == HttpMethod.post || message.getMethod() == HttpMethod.put) {
            if (OSSUtils.isEmptyString(header.get(OSSHeaders.CONTENT_TYPE))) {
                String determineContentType = OSSUtils.determineContentType(null,
                        message.getUploadFilePath(), message.getObjectKey());
                header[OSSHeaders.CONTENT_TYPE] = determineContentType;
            }
        }

        // When the HTTP proxy is set, httpDNS is not enabled.
        message.setHttpDnsEnable(checkIfHttpDnsAvailable(conf.isHttpDnsEnable()));
        message.setCredentialProvider(credentialProvider);
        message.setPathStyleAccessEnable(conf.isPathStyleAccessEnable());
        message.setCustomPathPrefixEnable(conf.isCustomPathPrefixEnable());

        // set ip with header
        message.setIpWithHeader(conf.getIpWithHeader());

        message.getHeaders()[HttpHeaders.USER_AGENT] = VersionInfoUtils.getUserAgent(conf.getCustomUserMark());

        if (message.getHeaders().containsKey(OSSHeaders.RANGE) || message.getParameters().containsKey(RequestParameters.X_OSS_PROCESS)) {
            //if contain range or x-oss-process , then don't crc64
            message.setCheckCRC64(false);
        }

        //  cloud user could have special endpoint and we need to differentiate it with the CName here.
        message.setIsInCustomCnameExcludeList(OSSUtils.isInCustomCnameExcludeList(this.endpoint.getHost(), this.conf.getCustomCnameExcludeList()));

        bool checkCRC64 = request.getCRC64() != OSSRequest.CRC64Config.NULL
                ? (request.getCRC64() == OSSRequest.CRC64Config.YES ? true : false) : conf.isCheckCRC64();
        message.setCheckCRC64(checkCRC64);
        request.setCRC64(checkCRC64 ? OSSRequest.CRC64Config.YES : OSSRequest.CRC64Config.NO);
    }

     void setCredentialProvider(OSSCredentialProvider credentialProvider) {
        this.credentialProvider = credentialProvider;
    }

     <Request extends OSSRequest, Result extends OSSResult> void checkCRC64(Request request
            , Result result)  {
        if (request.getCRC64() == OSSRequest.CRC64Config.YES ? true : false) {
            try {
                OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
            } catch (InconsistentException e) {
                throw OSSClientException(e.getMessage(), e);
            }
        }
    }

     <Request extends OSSRequest, Result extends OSSResult> void checkCRC64(Request request
            , Result result, OSSCompletedCallback<Request, Result> completedCallback) {
        try {
            checkCRC64(request, result);
            if (completedCallback != null) {
                completedCallback.onSuccess(request, result);
            }
        } catch (OSSClientException e) {
            if (completedCallback != null) {
                completedCallback.onFailure(request, e, null);
            }
        }
    }

     int calcObjectCRCFromParts(List<PartETag> partETags) {
        int crc = 0;
        for (PartETag partETag : partETags) {
            if (partETag.getCRC64() == 0 || partETag.getPartSize() <= 0) {
                return 0;
            }
            crc = CRC64.combine(crc, partETag.getCRC64(), partETag.getPartSize());
        }
        return crc;
    }

     Context getApplicationContext() {
        return applicationContext;
    }

     ClientConfiguration getConf() {
        return conf;
    }

     OSSAsyncTask<TriggerCallbackResult> triggerCallback(TriggerCallbackRequest request, OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query[RequestParameters.X_OSS_PROCESS] = "";

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        String bodyString = OSSUtils.buildTriggerCallbackBody(request.getCallbackParam(), request.getCallbackVars());
        requestMessage.setStringBody(bodyString);

        String md5String = BinaryUtil.calculateBase64Md5(bodyString.getBytes());
        requestMessage.getHeaders()[HttpHeaders.CONTENT_MD5] = md5String;

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<TriggerCallbackRequest, TriggerCallbackResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<TriggerCallbackResult> parser = ResponseParsers.TriggerCallbackResponseParser();
        Callable<TriggerCallbackResult> callable = OSSRequestTask<TriggerCallbackResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     TriggerCallbackResult asyncTriggerCallback(TriggerCallbackRequest request)  {
        return triggerCallback(request, null).getResult();
    }

     OSSAsyncTask<ImagePersistResult> imageActionPersist(ImagePersistRequest request, OSSCompletedCallback<ImagePersistRequest, ImagePersistResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query[RequestParameters.X_OSS_PROCESS] = "";

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.mFromBucket);
        requestMessage.setObjectKey(request.mFromObjectkey);
        requestMessage.setParameters(query);

        String bodyString = OSSUtils.buildImagePersistentBody(request.mToBucketName, request.mToObjectKey, request.mAction);
        requestMessage.setStringBody(bodyString);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<ImagePersistRequest, ImagePersistResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ImagePersistResult> parser = ResponseParsers.ImagePersistResponseParser();
        Callable<ImagePersistResult> callable = OSSRequestTask<ImagePersistResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     PutSymlinkResult syncPutSymlink(PutSymlinkRequest request)  {
        return putSymlink(request, null).getResult();
    }

    ;

     OSSAsyncTask<PutSymlinkResult> putSymlink(PutSymlinkRequest request, OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query[RequestParameters.X_OSS_SYMLINK] = "";

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        if (!OSSUtils.isEmptyString(request.getTargetObjectName())) {
            String targetObjectName = HttpUtil.urlEncode(request.getTargetObjectName(), OSSConstants.defaultCharsetName);
            requestMessage.getHeaders()[OSSHeaders.OSS_HEADER_SYMLINK_TARGET] = targetObjectName;
        }

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutSymlinkRequest, PutSymlinkResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutSymlinkResult> parser = ResponseParsers.PutSymlinkResponseParser();
        Callable<PutSymlinkResult> callable = OSSRequestTask<PutSymlinkResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     GetSymlinkResult syncGetSymlink(GetSymlinkRequest request)  {
        return getSymlink(request, null).getResult();
    }

     OSSAsyncTask<GetSymlinkResult> getSymlink(GetSymlinkRequest request, OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query[RequestParameters.X_OSS_SYMLINK] = "";

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetSymlinkRequest, GetSymlinkResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetSymlinkResult> parser = ResponseParsers.GetSymlinkResponseParser();
        Callable<GetSymlinkResult> callable = OSSRequestTask<GetSymlinkResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     RestoreObjectResult syncRestoreObject(RestoreObjectRequest request)  {
        return restoreObject(request, null).getResult();
    }

     OSSAsyncTask<RestoreObjectResult> restoreObject(RestoreObjectRequest request, OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult> completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = LinkedHashMap<String, String>();
        query[RequestParameters.X_OSS_RESTORE] = "";

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<RestoreObjectRequest, RestoreObjectResult> executionContext = ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<RestoreObjectResult> parser = ResponseParsers.RestoreObjectResponseParser();
        Callable<RestoreObjectResult> callable = OSSRequestTask<RestoreObjectResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }
}