import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/callback/oss_completed_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';
import 'lib_internal.dart';

class InternalRequestOperation {

     static final int LIST_PART_MAX_RETURNS = 1000;
     static final int MAX_PART_NUMBER = 10000;
     static ExecutorService executorService =
            Executors.newFixedThreadPool(OSSConstants.defaultBaseThreadPoolSize, ThreadFactory() {
                @override
                 Thread newThread(Runnable r) {
                    return Thread(r, "oss-android-api-thread");
                }
            });
      Uri endpoint;
     Uri service;
     OSSCredentialProvider credentialProvider;
     int maxRetryCount = OSSConstants.defaultRetryCount;
     ClientConfiguration conf;

     InternalRequestOperation.endpoint(this.endpoint, this.credentialProvider, this.conf) {
        OkHttpClient.Builder builder = OkHttpClient.Builder()
                .followRedirects(false)
                .followSslRedirects(false)
                .retryOnConnectionFailure(false)
                .cache(null)
                .hostnameVerifier(HostnameVerifier() {
                    @override
                     bool verify(String hostname, SSLSession session) {
                        return HttpsURLConnection.getDefaultHostnameVerifier().verify(endpoint.host, session);
                    }
                });

        if (conf != null) {
            Dispatcher dispatcher = Dispatcher();
            dispatcher.setMaxRequests(conf.getMaxConcurrentRequest());

            builder.connectTimeout(conf.getConnectionTimeout(), TimeUnit.MILLISECONDS)
                    .readTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .writeTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .dispatcher(dispatcher);

            if (conf.proxyHost != null && conf.proxyPort != 0) {
                builder.proxy(Proxy(Proxy.Type.HTTP, InetSocketAddress(conf.proxyHost, conf.proxyPort)));
            }

            maxRetryCount = conf.maxErrorRetry;
        }
        innerClient = builder.build();
    }

     InternalRequestOperation(this.credentialProvider, this.conf) {
        try {
            service = Uri.parse("http://oss.aliyuncs.com");
            endpoint = Uri.parse("http://127.0.0.1"); //构造假的endpoint
        } catch ( e) {
            throw ArgumentError("Endpoint must be a string like 'http://oss-cn-****.aliyuncs.com'," +
                    "or your cname like 'http://image.cnamedomain.com'!");
        }
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

            if (conf.proxyHost != null && conf.proxyPort != 0) {
                builder.proxy(Proxy(Proxy.Type.HTTP, InetSocketAddress(conf.proxyHost, conf.proxyPort)));
            }

            maxRetryCount = conf.maxErrorRetry;
        }
        innerClient = builder.build();
    }

     Future<PutObjectResult> syncPutObject(
            PutObjectRequest request)  async{
        PutObjectResult result = await putObject(request, null).getResult();
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<PutObjectResult> putObject(
            PutObjectRequest request, final OSSCompletedCallback<PutObjectRequest, PutObjectResult>? completedCallback) {
        OSSLog.logDebug(" Internal putObject Start ");
        RequestMessage requestMessage = RequestMessage();
        requestMessage..isAuthorizationRequired = request.isAuthorizationRequired
        ..endpoint = endpoint

        ..method = HttpMethod.put
        ..bucketName = request.bucketName
        ..objectKey = request.objectKey;
        request.uploadData.apply((p0) => requestMessage.uploadData = p0);
        request.uploadFilePath.apply((str) => requestMessage.uploadFilePath = str);
        request.uploadUri.apply((p0) => requestMessage.uploadUri = p0);
        request.callbackParam.apply((p0) => 
            requestMessage.headers["x-oss-callback"] = OSSUtils.populateMapToBase64JsonString(p0));
        request.callbackVars.apply((p0) => requestMessage.headers["x-oss-callback-var"] = OSSUtils.populateMapToBase64JsonString(p0));

        OSSLog.logDebug(" populateRequestMetadata ");
        OSSUtils.populateRequestMetadata(requestMessage.headers, request.metadata);
        OSSLog.logDebug(" canonicalizeRequestMessage ");
        canonicalizeRequestMessage(requestMessage, request);
        OSSLog.logDebug(" ExecutionContext ");
        
        ExecutionContext<PutObjectRequest, PutObjectResult> executionContext = ExecutionContext(request);


        if (completedCallback != null) {
            executionContext.completedCallback = _OSSCompletedCallback(checkCRC64(request, result));
        }

        if (request.getRetryCallback() != null) {
            executionContext.setRetryCallback(request.getRetryCallback());
        }

        executionContext.progressCallback = request.progressCallback;
        ResponseParser<PutObjectResult> parser = PutObjectResponseParser();

        Callable<PutObjectResult> callable = OSSRequestTask<PutObjectResult>(requestMessage, parser, executionContext, maxRetryCount);
        OSSLog.logDebug(" call OSSRequestTask ");
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<CreateBucketResult>? createBucket(
            CreateBucketRequest request, OSSCompletedCallback<CreateBucketRequest, CreateBucketResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.put;
        requestMessage.bucketName = request.bucketName;
        if (request.bucketACL != null) {
            requestMessage.headers[OSSHeaders.OSS_CANNED_ACL] = request.getBucketACL().toString();
        }
        try {
            Map<String, String> configures = <String,String>{};
            request.locationConstraint.apply((p0) => configures[CreateBucketRequest.TAB_LOCATIONCONSTRAINT] = p0);
            configures[CreateBucketRequest.TAB_STORAGECLASS] = request.bucketStorageClass.toString();
            requestMessage.createBucketRequestBodyMarshall(configures);
        } on UnsupportedEncodingException catch ( e) {
            e.printStackTrace();
            return null;
        }
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<CreateBucketRequest, CreateBucketResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<CreateBucketResult> parser = CreateBucketResponseParser();

        Callable<CreateBucketResult> callable = OSSRequestTask<CreateBucketResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketResult> deleteBucket(
            DeleteBucketRequest request, OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.delete;
        requestMessage.bucketName = request.bucketName;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketRequest, DeleteBucketResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<DeleteBucketResult> parser = DeleteBucketResponseParser();
        Callable<DeleteBucketResult> callable = OSSRequestTask<DeleteBucketResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketInfoResult> getBucketInfo(
            GetBucketInfoRequest request, OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["bucketInfo"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketInfoRequest, GetBucketInfoResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<GetBucketInfoResult> parser = GetBucketInfoResponseParser();
        Callable<GetBucketInfoResult> callable = OSSRequestTask<GetBucketInfoResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketACLResult> getBucketACL(
            GetBucketACLRequest request, OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["acl"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketACLRequest, GetBucketACLResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<GetBucketACLResult> parser = GetBucketACLResponseParser();
        Callable<GetBucketACLResult> callable = OSSRequestTask<GetBucketACLResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketRefererResult>? putBucketReferer(
            PutBucketRefererRequest request, OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["referer"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.put;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;

        try {
            requestMessage.putBucketRefererRequestBodyMarshall(request.referers, request.allowEmpty);
        } on UnsupportedEncodingException catch ( e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutBucketRefererRequest, PutBucketRefererResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<PutBucketRefererResult> parser = PutBucketRefererResponseParser();
        Callable<PutBucketRefererResult> callable = OSSRequestTask<PutBucketRefererResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketRefererResult> getBucketReferer(
            GetBucketRefererRequest request, OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["referer"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketRefererRequest, GetBucketRefererResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<GetBucketRefererResult> parser = GetBucketRefererResponseParser();
        Callable<GetBucketRefererResult> callable = OSSRequestTask<GetBucketRefererResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketLoggingResult>? putBucketLogging(
            PutBucketLoggingRequest request, OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["logging"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.put;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;

        try {
            requestMessage.putBucketLoggingRequestBodyMarshall(request.targetBucketName, request.targetPrefix);
        } on UnsupportedEncodingException catch ( e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutBucketLoggingRequest, PutBucketLoggingResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<PutBucketLoggingResult> parser = PutBucketLoggingResponseParser();
        Callable<PutBucketLoggingResult> callable = OSSRequestTask<PutBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketLoggingResult> getBucketLogging(
            GetBucketLoggingRequest request, OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["logging"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketLoggingRequest, GetBucketLoggingResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<GetBucketLoggingResult> parser = GetBucketLoggingResponseParser();
        Callable<GetBucketLoggingResult> callable = OSSRequestTask<GetBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketLoggingResult> deleteBucketLogging(
            DeleteBucketLoggingRequest request, OSSCompletedCallback<DeleteBucketLoggingRequest, DeleteBucketLoggingResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["logging"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.delete;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<DeleteBucketLoggingResult> parser = DeleteBucketLoggingResponseParser();
        Callable<DeleteBucketLoggingResult> callable = OSSRequestTask<DeleteBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketLifecycleResult>? putBucketLifecycle(
            PutBucketLifecycleRequest request, OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["lifecycle"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.put;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;

        try {
            requestMessage.putBucketLifecycleRequestBodyMarshall(request.lifecycleRules ?? []);
        } on UnsupportedEncodingException catch ( e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutBucketLifecycleRequest, PutBucketLifecycleResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<PutBucketLifecycleResult> parser = PutBucketLifecycleResponseParser();
        Callable<PutBucketLifecycleResult> callable = OSSRequestTask<PutBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketLifecycleResult> getBucketLifecycle(
            GetBucketLifecycleRequest request, OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["lifecycle"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketLifecycleRequest, GetBucketLifecycleResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<GetBucketLifecycleResult> parser = GetBucketLifecycleResponseParser();
        Callable<GetBucketLifecycleResult> callable = OSSRequestTask<GetBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketLifecycleResult> deleteBucketLifecycle(
            DeleteBucketLifecycleRequest request, OSSCompletedCallback<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["lifecycle"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.delete;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<DeleteBucketLifecycleResult> parser = DeleteBucketLifecycleResponseParser();
        Callable<DeleteBucketLifecycleResult> callable = OSSRequestTask<DeleteBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     Future<AppendObjectResult> syncAppendObject(
            AppendObjectRequest request)  async{
        AppendObjectResult result = await appendObject(request, null).getResult();
        bool checkCRC = request.crc64Config == CRC64Config.yes ;
        if (request.initCRC64 != null && checkCRC) {

            result.clientCRC = CRC64.combine(request.initCRC64, result.clientCRC,
                    (result.nextPosition - request.position));
        }
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<AppendObjectResult> appendObject(
            AppendObjectRequest request, final OSSCompletedCallback<AppendObjectRequest, AppendObjectResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.post;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

      request.uploadData.apply((p0) => requestMessage.uploadData = p0);
      request.uploadFilePath.apply((p0) => requestMessage.uploadFilePath = p0);
      request.uploadUri.apply((p0) => requestMessage.uploadUri = p0);
        requestMessage.parameters[RequestParameters.subresourceAppend] = "";
        requestMessage.parameters[RequestParameters.position] = request.position.toString();

        OSSUtils.populateRequestMetadata(requestMessage.headers, request.metadata);

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<AppendObjectRequest, AppendObjectResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = _OSSCompletedCallback3(completedCallback);
        }
        executionContext.progressCallback = request.progressCallback;
        ResponseParser<AppendObjectResult> parser = AppendObjectResponseParser();

        Callable<AppendObjectResult> callable = OSSRequestTask<AppendObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<HeadObjectResult> headObject(
            HeadObjectRequest request, OSSCompletedCallback<HeadObjectRequest, HeadObjectResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.HEAD;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<HeadObjectRequest, HeadObjectResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<HeadObjectResult> parser = HeadObjectResponseParser();

        Callable<HeadObjectResult> callable = OSSRequestTask<HeadObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetObjectResult> getObject(
            GetObjectRequest request, OSSCompletedCallback<GetObjectRequest, GetObjectResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        if (request.getRange() != null) {
            requestMessage.headers[OSSHeaders.RANGE] = request.getRange().toString();
        }

        if (request.getxOssProcess() != null) {
            requestMessage.parameters[RequestParameters.xOSSProcess] = request.getxOssProcess();
        }

        canonicalizeRequestMessage(requestMessage, request);

        if (request.getRequestHeaders() != null) {
            for (Map.Entry<String, String> entry : request.getRequestHeaders().entrySet()) {
                requestMessage.headers[entry.getKey()] = entry.getValue();
            }
        }

        ExecutionContext<GetObjectRequest, GetObjectResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        executionContext.progressCallback = request.getProgressListener();
        ResponseParser<GetObjectResult> parser = GetObjectResponseParser();

        Callable<GetObjectResult> callable = OSSRequestTask<GetObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetObjectACLResult> getObjectACL(GetObjectACLRequest request, OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["acl"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.parameters = query;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<GetObjectACLRequest, GetObjectACLResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<GetObjectACLResult> parser = GetObjectACLResponseParser();

        Callable<GetObjectACLResult> callable = OSSRequestTask<GetObjectACLResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<CopyObjectResult> copyObject(
            CopyObjectRequest request, OSSCompletedCallback<CopyObjectRequest, CopyObjectResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.put;
        requestMessage.bucketName(request.getDestinationBucketName());
        requestMessage.setObjectKey(request.getDestinationKey());

        OSSUtils.populateCopyObjectHeaders(request, requestMessage.headers);

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<CopyObjectRequest, CopyObjectResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<CopyObjectResult> parser = CopyObjectResponseParser();

        Callable<CopyObjectResult> callable = OSSRequestTask<CopyObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteObjectResult> deleteObject(
            DeleteObjectRequest request, OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.delete;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<DeleteObjectRequest, DeleteObjectResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<DeleteObjectResult> parser = DeleteObjectResponseParser();

        Callable<DeleteObjectResult> callable = OSSRequestTask<DeleteObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteMultipleObjectResult> deleteMultipleObject(
            DeleteMultipleObjectRequest request, OSSCompletedCallback<DeleteMultipleObjectRequest, DeleteMultipleObjectResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query["delete"] = "";

        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.post;
        requestMessage.bucketName = request.bucketName;
        requestMessage.parameters = query;
        try {
            List<int> bodyBytes = requestMessage.deleteMultipleObjectRequestBodyMarshall(request.getObjectKeys(), request.getQuiet());
            if (bodyBytes != null && bodyBytes.length > 0) {
                requestMessage.headers[OSSHeaders.contentMd5] = BinaryUtil.calculateBase64Md5(bodyBytes);
                requestMessage.headers[OSSHeaders.CONTENT_LENGTH] = String.valueOf(bodyBytes.length);
            }
        } on UnsupportedEncodingException catch ( e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<DeleteMultipleObjectResult> parser = DeleteMultipleObjectResponseParser();

        Callable<DeleteMultipleObjectResult> callable = OSSRequestTask<DeleteMultipleObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);


    }

     OSSAsyncTask<ListBucketsResult> listBuckets(
            ListBucketsRequest request, OSSCompletedCallback<ListBucketsRequest, ListBucketsResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.method = HttpMethod.get;
        requestMessage.setService(service);
        requestMessage.endpoint = endpoint; //设置假Endpoint

        canonicalizeRequestMessage(requestMessage, request);

        OSSUtils.populateListBucketRequestParameters(request, requestMessage.parameters);
        ExecutionContext<ListBucketsRequest, ListBucketsResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<ListBucketsResult> parser = ListBucketResponseParser();
        Callable<ListBucketsResult> callable = OSSRequestTask<ListBucketsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListObjectsResult> listObjects(
            ListObjectsRequest request, OSSCompletedCallback<ListObjectsRequest, ListObjectsResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;

        canonicalizeRequestMessage(requestMessage, request);

        OSSUtils.populateListObjectsRequestParameters(request, requestMessage.parameters);

        ExecutionContext<ListObjectsRequest, ListObjectsResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<ListObjectsResult> parser = ListObjectsResponseParser();

        Callable<ListObjectsResult> callable = OSSRequestTask<ListObjectsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<InitiateMultipartUploadResult> initMultipartUpload(
            InitiateMultipartUploadRequest request, OSSCompletedCallback<InitiateMultipartUploadRequest, InitiateMultipartUploadResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.post;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        requestMessage.parameters[RequestParameters.subresourceUploads] = "";
        if (request.isSequential) {
            requestMessage.parameters[RequestParameters.subresourceSequential] = "";
        }

        OSSUtils.populateRequestMetadata(requestMessage.headers, request.metadata);

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<InitiateMultipartUploadResult> parser = InitMultipartResponseParser();

        Callable<InitiateMultipartUploadResult> callable = OSSRequestTask<InitiateMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     Future<UploadPartResult> syncUploadPart(
            UploadPartRequest request)  async{
        UploadPartResult result = await uploadPart(request, null).getResult();
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<UploadPartResult> uploadPart(
            UploadPartRequest request, final OSSCompletedCallback<UploadPartRequest, UploadPartResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.put;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        requestMessage.parameters[RequestParameters.uploadId] = request.uploadId ?? '';
        requestMessage.parameters[RequestParameters.partNumber] = request.partNumber.toString();
        requestMessage.uploadData = request.partContent;

          request.md5Digest.apply((p0) => 
            requestMessage.headers[HttpHeaders.contentMd5] = p0
          );

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<UploadPartRequest, UploadPartResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = 
            _OSSCompletedCallback(completedCallback);
        }
        executionContext.progressCallback = request.progressCallback;
        ResponseParser<UploadPartResult> parser = UploadPartResponseParser();

        Callable<UploadPartResult> callable = OSSRequestTask<UploadPartResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     Future<CompleteMultipartUploadResult> syncCompleteMultipartUpload(
            CompleteMultipartUploadRequest request) async {
        CompleteMultipartUploadResult result = await completeMultipartUpload(request, null).getResult();
        if (result.serverCRC != null) {
            int crc64 = calcObjectCRCFromParts(request.partETags);
            result.clientCRC = crc64;
        }
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<CompleteMultipartUploadResult> completeMultipartUpload(
            CompleteMultipartUploadRequest request, final OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.post;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;
        requestMessage.stringBody = OSSUtils.buildXMLFromPartEtagList(request.partETags);

        requestMessage.parameters[RequestParameters.uploadId] = request.uploadId;

        if (request.callbackParam != null) {
            requestMessage.headers["x-oss-callback"] = OSSUtils.populateMapToBase64JsonString(request.callbackParam ?? {});
        }
        if (request.callbackVars != null) {
            requestMessage.headers["x-oss-callback-var"] = OSSUtils.populateMapToBase64JsonString(request.callbackVars ?? {});
        }

        OSSUtils.populateRequestMetadata(requestMessage.headers, request.metadata);

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = 
        }
        ResponseParser<CompleteMultipartUploadResult> parser = CompleteMultipartUploadResponseParser();

        Callable<CompleteMultipartUploadResult> callable = OSSRequestTask<CompleteMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<AbortMultipartUploadResult> abortMultipartUpload(
            AbortMultipartUploadRequest request, OSSCompletedCallback<AbortMultipartUploadRequest, AbortMultipartUploadResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.delete;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        requestMessage.parameters[RequestParameters.uploadId] = request.uploadId;

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<AbortMultipartUploadRequest, AbortMultipartUploadResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<AbortMultipartUploadResult> parser = AbortMultipartUploadResponseParser();

        Callable<AbortMultipartUploadResult> callable = OSSRequestTask<AbortMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListPartsResult> listParts(
            ListPartsRequest request, OSSCompletedCallback<ListPartsRequest, ListPartsResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;

        requestMessage.parameters[RequestParameters.uploadId] = request.uploadId;

        Integer maxParts = request.getMaxParts();
        if (maxParts != null) {
            if (!OSSUtils.checkParamRange(maxParts, 0, true, LIST_PART_MAX_RETURNS, true)) {
                throw ArgumentError("MaxPartsOutOfRange: " + LIST_PART_MAX_RETURNS);
            }
            requestMessage.parameters[RequestParameters.MAX_PARTS] = maxParts.toString();
        }

        Integer partNumberMarker = request.getPartNumberMarker();
        if (partNumberMarker != null) {
            if (!OSSUtils.checkParamRange(partNumberMarker, 0, false, MAX_PART_NUMBER, true)) {
                throw ArgumentError("PartNumberMarkerOutOfRange: " + MAX_PART_NUMBER);
            }
            requestMessage.parameters[RequestParameters.PART_NUMBER_MARKER] = partNumberMarker.toString();
        }

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<ListPartsRequest, ListPartsResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<ListPartsResult> parser = ListPartsResponseParser();

        Callable<ListPartsResult> callable = OSSRequestTask<ListPartsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListMultipartUploadsResult> listMultipartUploads(
            ListMultipartUploadsRequest request, OSSCompletedCallback<ListMultipartUploadsRequest, ListMultipartUploadsResult>? completedCallback) {

        RequestMessage requestMessage = RequestMessage();
        requestMessage.isAuthorizationRequired=request.isAuthorizationRequired;
        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;

        requestMessage.parameters[RequestParameters.SUBRESOURCE_UPLOADS] = "";

        OSSUtils.populateListMultipartUploadsRequestParameters(request, requestMessage.parameters);

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<ListMultipartUploadsRequest, ListMultipartUploadsResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<ListMultipartUploadsResult> parser = ListMultipartUploadsResponseParser();

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

            String confProxyHost = conf.proxyHost;
            if (confProxyHost).notNullOrEmpty {
                proxyHost = confProxyHost;
            }
return proxyHost.nullOrEmpty;
        }
        return false;
    }

     void canonicalizeRequestMessage(RequestMessage message, OSSRequest request) {
        Map<String, String> header = message.headers;

        if (header[HttpHeaders.date] == null) {
            header[HttpHeaders.date] = DateUtil.currentFixedSkewedTimeInRFC822Format();
        }

        if (message.getMethod() == HttpMethod.post || message.getMethod() == HttpMethod.put) {
            if (header[HttpHeaders.contentType].nullOrEmpty) {
                String determineContentType = OSSUtils.determineContentType(null,
                        message.getUploadFilePath(), message.objectKey);
                header[HttpHeaders.contentType] = determineContentType;
            }
        }

        // When the HTTP proxy is set, httpDNS is not enabled.
        message.setHttpDnsEnable(checkIfHttpDnsAvailable(conf.isHttpDnsEnable()));
        message.setCredentialProvider(credentialProvider);
        message.setPathStyleAccessEnable(conf.isPathStyleAccessEnable());
        message.setCustomPathPrefixEnable(conf.isCustomPathPrefixEnable());

        // set ip with header
        message.setIpWithHeader(conf.getIpWithHeader());

        message.headers[HttpHeaders.userAgent] = VersionInfoUtils.getUserAgent(conf.getCustomUserMark());

        if (message.headers.containsKey(HttpHeaders.range) || messageparameters.containsKey(RequestParameters.xOSSProcess)) {
            //if contain range or x-oss-process , then don't crc64
            message.setCheckCRC64(false);
        }

        //  cloud user could have special endpoint and we need to differentiate it with the CName here.
        message.setIsInCustomCnameExcludeList(OSSUtils.isInCustomCnameExcludeList(endpoint.getHost(), conf.getCustomCnameExcludeList()));

        bool checkCRC64 = request.getCRC64() != OSSRequest.CRC64Config.NULL
                ? (request.getCRC64() == OSSRequest.CRC64Config.YES ? true : false) : conf.isCheckCRC64();
        message.setCheckCRC64(checkCRC64);
        request.setCRC64(checkCRC64 ? OSSRequest.CRC64Config.YES : OSSRequest.CRC64Config.NO);
    }

      

    

     OSSAsyncTask<TriggerCallbackResult> triggerCallback(TriggerCallbackRequest request, OSSCompletedCallback<TriggerCallbackRequest, TriggerCallbackResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String, String>{};
        query[RequestParameters.xOSSProcess] = "";

        requestMessage..endpoint = endpoint
        ..method = HttpMethod.post
        ..bucketName = request.bucketName
        ..objectKey = request.objectKey
        ..parameters = query;

        String bodyString = OSSUtils.buildTriggerCallbackBody(request.callbackParam, request.callbackVars);
        requestMessage.stringBody = bodyString;

        String md5String = BinaryUtil.calculateBase64Md5(utf8.encode(bodyString));
        requestMessage.headers[HttpHeaders.contentMd5] = md5String;

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<TriggerCallbackRequest, TriggerCallbackResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<TriggerCallbackResult> parser = TriggerCallbackResponseParser();
        Callable<TriggerCallbackResult> callable = OSSRequestTask<TriggerCallbackResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     Future<TriggerCallbackResult> asyncTriggerCallback(TriggerCallbackRequest request)  {
        return triggerCallback(request, null).getResult();
    }

     OSSAsyncTask<ImagePersistResult> imageActionPersist(ImagePersistRequest request, OSSCompletedCallback<ImagePersistRequest, ImagePersistResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query[RequestParameters.xOSSProcess] = "";

        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.post;
        requestMessage.bucketName = request.fromBucket;
        requestMessage.objectKey = request.fromObjectKey;
        requestMessage.parameters = query;

        String bodyString = OSSUtils.buildImagePersistentBody(request.toBucketName, request.toObjectKey, request.action);
        requestMessage.stringBody = bodyString;

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<ImagePersistRequest, ImagePersistResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<ImagePersistResult> parser = ImagePersistResponseParser();
        Callable<ImagePersistResult> callable = OSSRequestTask<ImagePersistResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     Future<PutSymlinkResult> syncPutSymlink(PutSymlinkRequest request)  {
        return putSymlink(request, null).getResult();
    }


     OSSAsyncTask<PutSymlinkResult> putSymlink(PutSymlinkRequest request, OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query[RequestParameters.xOSSSymlink] = "";

        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.put;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;
        requestMessage.parameters = query;

        if (request.targetObjectName.notNullOrEmpty) {
            String targetObjectName = HttpUtil.urlEncode(request.targetObjectName);
            requestMessage.headers[OSSHeaders.ossHeaderSymlinkTarget] = targetObjectName;
        }

        OSSUtils.populateRequestMetadata(requestMessage.headers, request.metadata);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutSymlinkRequest, PutSymlinkResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<PutSymlinkResult> parser = PutSymlinkResponseParser();
        Callable<PutSymlinkResult> callable = OSSRequestTask<PutSymlinkResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     Future<GetSymlinkResult> syncGetSymlink(GetSymlinkRequest request)  {
        return getSymlink(request, null).getResult();
    }

     OSSAsyncTask<GetSymlinkResult> getSymlink(GetSymlinkRequest request, OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String,String>{};
        query[RequestParameters.xOSSSymlink] = "";

        requestMessage.endpoint = endpoint;
        requestMessage.method = HttpMethod.get;
        requestMessage.bucketName = request.bucketName;
        requestMessage.objectKey = request.objectKey;
        requestMessage.parameters = query;

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetSymlinkRequest, GetSymlinkResult> executionContext = ExecutionContext(request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<GetSymlinkResult> parser = GetSymlinkResponseParser();
        Callable<GetSymlinkResult> callable = OSSRequestTask<GetSymlinkResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     Future<RestoreObjectResult> syncRestoreObject(RestoreObjectRequest request)  {
        return restoreObject(request, null).getResult();
    }

     OSSAsyncTask<RestoreObjectResult> restoreObject(RestoreObjectRequest request, OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult>? completedCallback) {
        RequestMessage requestMessage = RequestMessage();
        Map<String, String> query = <String, String>{};
        query[RequestParameters.xOSSRestore] = "";

        requestMessage..endpoint = endpoint
        ..method = HttpMethod.post
        ..bucketName = request.bucketName
        ..objectKey = request.objectKey
        ..parameters = query;

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<RestoreObjectRequest, RestoreObjectResult> executionContext = ExecutionContext( request);
        if (completedCallback != null) {
            executionContext.completedCallback = completedCallback;
        }
        ResponseParser<RestoreObjectResult> parser = RestoreObjectResponseParser();
        Callable<RestoreObjectResult> callable = OSSRequestTask<RestoreObjectResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }
}


class _OSSCompletedCallback extends OSSCompletedCallback<PutObjectRequest, PutObjectResult> {
      
      _OSSCompletedCallback(this.completedCallback);
      final OSSCompletedCallback completedCallback;

                @override
                 void onSuccess(PutObjectRequest request, PutObjectResult result) {
                    checkCRC64WithCallback(request, result, completedCallback);
                }

                @override
                 void onFailure(PutObjectRequest request, OSSClientException? clientException, OSSServiceException? serviceException) {
                    completedCallback.onFailure(request, clientException, serviceException);
                }
            }

   class _OSSCompletedCallback2 extends OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> {
              _OSSCompletedCallback2(this.completedCallback);

      final OSSCompletedCallback completedCallback;

               
                @override
                 void onSuccess(CompleteMultipartUploadRequest request, CompleteMultipartUploadResult result) {
                    if (result.serverCRC != null) {
                        String?  crc64 = calcObjectCRCFromParts(request.partETags);
                        result.clientCRC = crc64;
                    }
                    checkCRC64WithCallback(request, result, completedCallback);
                }

                @override
                 void onFailure(CompleteMultipartUploadRequest request, OSSClientException? clientException, OSSServiceException? serviceException) {
                    completedCallback.onFailure(request, clientException, serviceException);
                }
            }


            void checkCRC64<Request extends OSSRequest, Result extends OSSResult>(Request request
            , Result result)  {
        if (request.crc64Config == CRC64Config.yes ? true : false) {
            try {
                OSSUtils.checkChecksum(result.clientCRC, result.serverCRC, result.requestId);
            } on InconsistentException catch ( e) {
                throw OSSClientException(e.getMessage(), e);
            }
        }
    }


   class _OSSCompletedCallback3 extends  OSSCompletedCallback<AppendObjectRequest, AppendObjectResult>{
     _OSSCompletedCallback3(this.completedCallback);

      final OSSCompletedCallback completedCallback;
                @override
                 void onSuccess(AppendObjectRequest request, AppendObjectResult result) {
                    bool checkCRC = request.crc64Config == CRC64Config.yes;
                    if (request.initCRC64 != null && checkCRC) {
                        result.clientCRC = CRC64.combine(request.initCRC64, result.clientCRC,
                                (result.nextPosition - request.position));
                    }
                    checkCRC64WithCallback(request, result, completedCallback);
                }

                @override
                 void onFailure(AppendObjectRequest request, OSSClientException? clientException, OSSServiceException? serviceException) {
                    completedCallback.onFailure(request, clientException, serviceException);
                }
            }

      void checkCRC64WithCallback<Request extends OSSRequest, Result extends OSSResult>(Request request
            , Result result, OSSCompletedCallback<Request, Result>? completedCallback) {
        try {
            checkCRC64(request, result);
            if (completedCallback != null) {
                completedCallback.onSuccess(request, result);
            }
        } on OSSClientException catch ( e) {
            if (completedCallback != null) {
                completedCallback.onFailure(request, e, null);
            }
        }
            }
    


 String calcObjectCRCFromParts(List<PartETag> partETags) {
        String crc = '';
        for (PartETag partETag in partETags) {
            if (partETag.crc64 ==null || partETag.partSize <= 0) {
                return '';
            }
            crc = CRC64.combine(crc, partETag.crc64, partETag.partSize);
        }
        return crc;
    }
