package com.alibaba.sdk.android.oss.internal;

import android.content.Context;
import android.os.Build;
import android.text.TextUtils;

import com.alibaba.sdk.android.oss.ClientConfiguration;
import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.common.HttpMethod;
import com.alibaba.sdk.android.oss.common.OSSConstants;
import com.alibaba.sdk.android.oss.common.OSSHeaders;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.RequestParameters;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.utils.BinaryUtil;
import com.alibaba.sdk.android.oss.common.utils.CRC64;
import com.alibaba.sdk.android.oss.common.utils.DateUtil;
import com.alibaba.sdk.android.oss.common.utils.HttpHeaders;
import com.alibaba.sdk.android.oss.common.utils.HttpUtil;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.common.utils.VersionInfoUtils;
import com.alibaba.sdk.android.oss.exception.InconsistentException;
import com.alibaba.sdk.android.oss.model.*;
import com.alibaba.sdk.android.oss.network.ExecutionContext;
import com.alibaba.sdk.android.oss.network.OSSRequestTask;

import java.io.UnsupportedEncodingException;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.URI;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import okhttp3.Dispatcher;
import okhttp3.OkHttpClient;

/**
 * Created by zhouzhuo on 11/22/15.
 */
 class InternalRequestOperation {

     static final int LIST_PART_MAX_RETURNS = 1000;
     static final int MAX_PART_NUMBER = 10000;
     static ExecutorService executorService =
            Executors.newFixedThreadPool(OSSConstants.DEFAULT_BASE_THREAD_POOL_SIZE, new ThreadFactory() {
                @override
                 Thread newThread(Runnable r) {
                    return new Thread(r, "oss-android-api-thread");
                }
            });
     volatile URI endpoint;
     URI service;
     OkHttpClient innerClient;
     Context applicationContext;
     OSSCredentialProvider credentialProvider;
     int maxRetryCount = OSSConstants.DEFAULT_RETRY_COUNT;
     ClientConfiguration conf;

     InternalRequestOperation(Context context, final URI endpoint, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        this.applicationContext = context;
        this.endpoint = endpoint;
        this.credentialProvider = credentialProvider;
        this.conf = conf;

        OkHttpClient.Builder builder = new OkHttpClient.Builder()
                .followRedirects(false)
                .followSslRedirects(false)
                .retryOnConnectionFailure(false)
                .cache(null)
                .hostnameVerifier(new HostnameVerifier() {
                    @override
                     bool verify(String hostname, SSLSession session) {
                        return HttpsURLConnection.getDefaultHostnameVerifier().verify(endpoint.getHost(), session);
                    }
                });

        if (conf != null) {
            Dispatcher dispatcher = new Dispatcher();
            dispatcher.setMaxRequests(conf.getMaxConcurrentRequest());

            builder.connectTimeout(conf.getConnectionTimeout(), TimeUnit.MILLISECONDS)
                    .readTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .writeTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .dispatcher(dispatcher);

            if (conf.getProxyHost() != null && conf.getProxyPort() != 0) {
                builder.proxy(new Proxy(Proxy.Type.HTTP, new InetSocketAddress(conf.getProxyHost(), conf.getProxyPort())));
            }

            this.maxRetryCount = conf.getMaxErrorRetry();
        }
        this.innerClient = builder.build();
    }

     InternalRequestOperation(Context context, OSSCredentialProvider credentialProvider, ClientConfiguration conf) {
        try {
            service = new URI("http://oss.aliyuncs.com");
            endpoint = new URI("http://127.0.0.1"); //构造假的endpoint
        } catch (Exception e) {
            throw new IllegalArgumentException("Endpoint must be a string like 'http://oss-cn-****.aliyuncs.com'," +
                    "or your cname like 'http://image.cnamedomain.com'!");
        }
        this.applicationContext = context;
        this.credentialProvider = credentialProvider;
        this.conf = conf;
        OkHttpClient.Builder builder = new OkHttpClient.Builder()
                .followRedirects(false)
                .followSslRedirects(false)
                .retryOnConnectionFailure(false)
                .cache(null)
                .hostnameVerifier(new HostnameVerifier() {
                    @override
                     bool verify(String hostname, SSLSession session) {
                        return HttpsURLConnection.getDefaultHostnameVerifier().verify(service.getHost(), session);
                    }
                });

        if (conf != null) {
            Dispatcher dispatcher = new Dispatcher();
            dispatcher.setMaxRequests(conf.getMaxConcurrentRequest());

            builder.connectTimeout(conf.getConnectionTimeout(), TimeUnit.MILLISECONDS)
                    .readTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .writeTimeout(conf.getSocketTimeout(), TimeUnit.MILLISECONDS)
                    .dispatcher(dispatcher);

            if (conf.getProxyHost() != null && conf.getProxyPort() != 0) {
                builder.proxy(new Proxy(Proxy.Type.HTTP, new InetSocketAddress(conf.getProxyHost(), conf.getProxyPort())));
            }

            this.maxRetryCount = conf.getMaxErrorRetry();
        }
        this.innerClient = builder.build();
    }

     PutObjectResult syncPutObject(
            PutObjectRequest request) throws OSSClientException, OSSServiceException {
        PutObjectResult result = putObject(request, null).getResult();
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<PutObjectResult> putObject(
            PutObjectRequest request, final OSSCompletedCallback<PutObjectRequest, PutObjectResult> completedCallback) {
        OSSLog.logDebug(" Internal putObject Start ");
        RequestMessage requestMessage = new RequestMessage();
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
            requestMessage.getHeaders().put("x-oss-callback", OSSUtils.populateMapToBase64JsonString(request.getCallbackParam()));
        }
        if (request.getCallbackVars() != null) {
            requestMessage.getHeaders().put("x-oss-callback-var", OSSUtils.populateMapToBase64JsonString(request.getCallbackVars()));
        }
        OSSLog.logDebug(" populateRequestMetadata ");
        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());
        OSSLog.logDebug(" canonicalizeRequestMessage ");
        canonicalizeRequestMessage(requestMessage, request);
        OSSLog.logDebug(" ExecutionContext ");
        ExecutionContext<PutObjectRequest, PutObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(new OSSCompletedCallback<PutObjectRequest, PutObjectResult>() {
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
        ResponseParser<PutObjectResult> parser = new ResponseParsers.PutObjectResponseParser();

        Callable<PutObjectResult> callable = new OSSRequestTask<PutObjectResult>(requestMessage, parser, executionContext, maxRetryCount);
        OSSLog.logDebug(" call OSSRequestTask ");
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<CreateBucketResult> createBucket(
            CreateBucketRequest request, OSSCompletedCallback<CreateBucketRequest, CreateBucketResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        if (request.getBucketACL() != null) {
            requestMessage.getHeaders().put(OSSHeaders.OSS_CANNED_ACL, request.getBucketACL().toString());
        }
        try {
            Map<String, String> configures = new HashMap<String, String>();
            if (request.getLocationConstraint() != null) {
                configures.put(CreateBucketRequest.TAB_LOCATIONCONSTRAINT, request.getLocationConstraint());
            }
            configures.put(CreateBucketRequest.TAB_STORAGECLASS, request.getBucketStorageClass().toString());
            requestMessage.createBucketRequestBodyMarshall(configures);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<CreateBucketRequest, CreateBucketResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<CreateBucketResult> parser = new ResponseParsers.CreateBucketResponseParser();

        Callable<CreateBucketResult> callable = new OSSRequestTask<CreateBucketResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketResult> deleteBucket(
            DeleteBucketRequest request, OSSCompletedCallback<DeleteBucketRequest, DeleteBucketResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketRequest, DeleteBucketResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteBucketResult> parser = new ResponseParsers.DeleteBucketResponseParser();
        Callable<DeleteBucketResult> callable = new OSSRequestTask<DeleteBucketResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketInfoResult> getBucketInfo(
            GetBucketInfoRequest request, OSSCompletedCallback<GetBucketInfoRequest, GetBucketInfoResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("bucketInfo", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketInfoRequest, GetBucketInfoResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketInfoResult> parser = new ResponseParsers.GetBucketInfoResponseParser();
        Callable<GetBucketInfoResult> callable = new OSSRequestTask<GetBucketInfoResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketACLResult> getBucketACL(
            GetBucketACLRequest request, OSSCompletedCallback<GetBucketACLRequest, GetBucketACLResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("acl", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketACLRequest, GetBucketACLResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketACLResult> parser = new ResponseParsers.GetBucketACLResponseParser();
        Callable<GetBucketACLResult> callable = new OSSRequestTask<GetBucketACLResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketRefererResult> putBucketReferer(
            PutBucketRefererRequest request, OSSCompletedCallback<PutBucketRefererRequest, PutBucketRefererResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("referer", "");

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
        ExecutionContext<PutBucketRefererRequest, PutBucketRefererResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutBucketRefererResult> parser = new ResponseParsers.PutBucketRefererResponseParser();
        Callable<PutBucketRefererResult> callable = new OSSRequestTask<PutBucketRefererResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketRefererResult> getBucketReferer(
            GetBucketRefererRequest request, OSSCompletedCallback<GetBucketRefererRequest, GetBucketRefererResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("referer", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketRefererRequest, GetBucketRefererResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketRefererResult> parser = new ResponseParsers.GetBucketRefererResponseParser();
        Callable<GetBucketRefererResult> callable = new OSSRequestTask<GetBucketRefererResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketLoggingResult> putBucketLogging(
            PutBucketLoggingRequest request, OSSCompletedCallback<PutBucketLoggingRequest, PutBucketLoggingResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("logging", "");

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
        ExecutionContext<PutBucketLoggingRequest, PutBucketLoggingResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutBucketLoggingResult> parser = new ResponseParsers.PutBucketLoggingResponseParser();
        Callable<PutBucketLoggingResult> callable = new OSSRequestTask<PutBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketLoggingResult> getBucketLogging(
            GetBucketLoggingRequest request, OSSCompletedCallback<GetBucketLoggingRequest, GetBucketLoggingResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("logging", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketLoggingRequest, GetBucketLoggingResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketLoggingResult> parser = new ResponseParsers.GetBucketLoggingResponseParser();
        Callable<GetBucketLoggingResult> callable = new OSSRequestTask<GetBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketLoggingResult> deleteBucketLogging(
            DeleteBucketLoggingRequest request, OSSCompletedCallback<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("logging", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketLoggingRequest, DeleteBucketLoggingResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteBucketLoggingResult> parser = new ResponseParsers.DeleteBucketLoggingResponseParser();
        Callable<DeleteBucketLoggingResult> callable = new OSSRequestTask<DeleteBucketLoggingResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<PutBucketLifecycleResult> putBucketLifecycle(
            PutBucketLifecycleRequest request, OSSCompletedCallback<PutBucketLifecycleRequest, PutBucketLifecycleResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("lifecycle", "");

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
        ExecutionContext<PutBucketLifecycleRequest, PutBucketLifecycleResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutBucketLifecycleResult> parser = new ResponseParsers.PutBucketLifecycleResponseParser();
        Callable<PutBucketLifecycleResult> callable = new OSSRequestTask<PutBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetBucketLifecycleResult> getBucketLifecycle(
            GetBucketLifecycleRequest request, OSSCompletedCallback<GetBucketLifecycleRequest, GetBucketLifecycleResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("lifecycle", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetBucketLifecycleRequest, GetBucketLifecycleResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetBucketLifecycleResult> parser = new ResponseParsers.GetBucketLifecycleResponseParser();
        Callable<GetBucketLifecycleResult> callable = new OSSRequestTask<GetBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteBucketLifecycleResult> deleteBucketLifecycle(
            DeleteBucketLifecycleRequest request, OSSCompletedCallback<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("lifecycle", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteBucketLifecycleResult> parser = new ResponseParsers.DeleteBucketLifecycleResponseParser();
        Callable<DeleteBucketLifecycleResult> callable = new OSSRequestTask<DeleteBucketLifecycleResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     AppendObjectResult syncAppendObject(
            AppendObjectRequest request) throws OSSClientException, OSSServiceException {
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

        RequestMessage requestMessage = new RequestMessage();
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
        requestMessage.getParameters().put(RequestParameters.SUBRESOURCE_APPEND, "");
        requestMessage.getParameters().put(RequestParameters.POSITION, String.valueOf(request.getPosition()));

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<AppendObjectRequest, AppendObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(new OSSCompletedCallback<AppendObjectRequest, AppendObjectResult>() {
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
        ResponseParser<AppendObjectResult> parser = new ResponseParsers.AppendObjectResponseParser();

        Callable<AppendObjectResult> callable = new OSSRequestTask<AppendObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<HeadObjectResult> headObject(
            HeadObjectRequest request, OSSCompletedCallback<HeadObjectRequest, HeadObjectResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.HEAD);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<HeadObjectRequest, HeadObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<HeadObjectResult> parser = new ResponseParsers.HeadObjectResponseParser();

        Callable<HeadObjectResult> callable = new OSSRequestTask<HeadObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetObjectResult> getObject(
            GetObjectRequest request, OSSCompletedCallback<GetObjectRequest, GetObjectResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        if (request.getRange() != null) {
            requestMessage.getHeaders().put(OSSHeaders.RANGE, request.getRange().toString());
        }

        if (request.getxOssProcess() != null) {
            requestMessage.getParameters().put(RequestParameters.X_OSS_PROCESS, request.getxOssProcess());
        }

        canonicalizeRequestMessage(requestMessage, request);

        if (request.getRequestHeaders() != null) {
            for (Map.Entry<String, String> entry : request.getRequestHeaders().entrySet()) {
                requestMessage.getHeaders().put(entry.getKey(), entry.getValue());
            }
        }

        ExecutionContext<GetObjectRequest, GetObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        executionContext.setProgressCallback(request.getProgressListener());
        ResponseParser<GetObjectResult> parser = new ResponseParsers.GetObjectResponseParser();

        Callable<GetObjectResult> callable = new OSSRequestTask<GetObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<GetObjectACLResult> getObjectACL(GetObjectACLRequest request, OSSCompletedCallback<GetObjectACLRequest, GetObjectACLResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("acl", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setParameters(query);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<GetObjectACLRequest, GetObjectACLResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetObjectACLResult> parser = new ResponseParsers.GetObjectACLResponseParser();

        Callable<GetObjectACLResult> callable = new OSSRequestTask<GetObjectACLResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<CopyObjectResult> copyObject(
            CopyObjectRequest request, OSSCompletedCallback<CopyObjectRequest, CopyObjectResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getDestinationBucketName());
        requestMessage.setObjectKey(request.getDestinationKey());

        OSSUtils.populateCopyObjectHeaders(request, requestMessage.getHeaders());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<CopyObjectRequest, CopyObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<CopyObjectResult> parser = new ResponseParsers.CopyObjectResponseParser();

        Callable<CopyObjectResult> callable = new OSSRequestTask<CopyObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteObjectResult> deleteObject(
            DeleteObjectRequest request, OSSCompletedCallback<DeleteObjectRequest, DeleteObjectResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<DeleteObjectRequest, DeleteObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteObjectResult> parser = new ResponseParsers.DeleteObjectResponseParser();

        Callable<DeleteObjectResult> callable = new OSSRequestTask<DeleteObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<DeleteMultipleObjectResult> deleteMultipleObject(
            DeleteMultipleObjectRequest request, OSSCompletedCallback<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put("delete", "");

        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setParameters(query);
        try {
            byte[] bodyBytes = requestMessage.deleteMultipleObjectRequestBodyMarshall(request.getObjectKeys(), request.getQuiet());
            if (bodyBytes != null && bodyBytes.length > 0) {
                requestMessage.getHeaders().put(OSSHeaders.CONTENT_MD5, BinaryUtil.calculateBase64Md5(bodyBytes));
                requestMessage.getHeaders().put(OSSHeaders.CONTENT_LENGTH, String.valueOf(bodyBytes.length));
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<DeleteMultipleObjectRequest, DeleteMultipleObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<DeleteMultipleObjectResult> parser = new ResponseParsers.DeleteMultipleObjectResponseParser();

        Callable<DeleteMultipleObjectResult> callable = new OSSRequestTask<DeleteMultipleObjectResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);


    }

     OSSAsyncTask<ListBucketsResult> listBuckets(
            ListBucketsRequest request, OSSCompletedCallback<ListBucketsRequest, ListBucketsResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setService(service);
        requestMessage.setEndpoint(endpoint); //设置假Endpoint

        canonicalizeRequestMessage(requestMessage, request);

        OSSUtils.populateListBucketRequestParameters(request, requestMessage.getParameters());
        ExecutionContext<ListBucketsRequest, ListBucketsResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListBucketsResult> parser = new ResponseParsers.ListBucketResponseParser();
        Callable<ListBucketsResult> callable = new OSSRequestTask<ListBucketsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListObjectsResult> listObjects(
            ListObjectsRequest request, OSSCompletedCallback<ListObjectsRequest, ListObjectsResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());

        canonicalizeRequestMessage(requestMessage, request);

        OSSUtils.populateListObjectsRequestParameters(request, requestMessage.getParameters());

        ExecutionContext<ListObjectsRequest, ListObjectsResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListObjectsResult> parser = new ResponseParsers.ListObjectsResponseParser();

        Callable<ListObjectsResult> callable = new OSSRequestTask<ListObjectsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<InitiateMultipartUploadResult> initMultipartUpload(
            InitiateMultipartUploadRequest request, OSSCompletedCallback<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters().put(RequestParameters.SUBRESOURCE_UPLOADS, "");
        if (request.isSequential) {
            requestMessage.getParameters().put(RequestParameters.SUBRESOURCE_SEQUENTIAL, "");
        }

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<InitiateMultipartUploadRequest, InitiateMultipartUploadResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<InitiateMultipartUploadResult> parser = new ResponseParsers.InitMultipartResponseParser();

        Callable<InitiateMultipartUploadResult> callable = new OSSRequestTask<InitiateMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     UploadPartResult syncUploadPart(
            UploadPartRequest request) throws OSSClientException, OSSServiceException {
        UploadPartResult result = uploadPart(request, null).getResult();
        checkCRC64(request, result);
        return result;
    }

     OSSAsyncTask<UploadPartResult> uploadPart(
            UploadPartRequest request, final OSSCompletedCallback<UploadPartRequest, UploadPartResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters().put(RequestParameters.UPLOAD_ID, request.getUploadId());
        requestMessage.getParameters().put(RequestParameters.PART_NUMBER, String.valueOf(request.getPartNumber()));
        requestMessage.setUploadData(request.getPartContent());
        if (request.getMd5Digest() != null) {
            requestMessage.getHeaders().put(OSSHeaders.CONTENT_MD5, request.getMd5Digest());
        }

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<UploadPartRequest, UploadPartResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(new OSSCompletedCallback<UploadPartRequest, UploadPartResult>() {
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
        ResponseParser<UploadPartResult> parser = new ResponseParsers.UploadPartResponseParser();

        Callable<UploadPartResult> callable = new OSSRequestTask<UploadPartResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     CompleteMultipartUploadResult syncCompleteMultipartUpload(
            CompleteMultipartUploadRequest request) throws OSSClientException, OSSServiceException {
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

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setStringBody(OSSUtils.buildXMLFromPartEtagList(request.getPartETags()));

        requestMessage.getParameters().put(RequestParameters.UPLOAD_ID, request.getUploadId());

        if (request.getCallbackParam() != null) {
            requestMessage.getHeaders().put("x-oss-callback", OSSUtils.populateMapToBase64JsonString(request.getCallbackParam()));
        }
        if (request.getCallbackVars() != null) {
            requestMessage.getHeaders().put("x-oss-callback-var", OSSUtils.populateMapToBase64JsonString(request.getCallbackVars()));
        }

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<CompleteMultipartUploadRequest, CompleteMultipartUploadResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(new OSSCompletedCallback<CompleteMultipartUploadRequest, CompleteMultipartUploadResult>() {
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
        ResponseParser<CompleteMultipartUploadResult> parser = new ResponseParsers.CompleteMultipartUploadResponseParser();

        Callable<CompleteMultipartUploadResult> callable = new OSSRequestTask<CompleteMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<AbortMultipartUploadResult> abortMultipartUpload(
            AbortMultipartUploadRequest request, OSSCompletedCallback<AbortMultipartUploadRequest, AbortMultipartUploadResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.DELETE);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters().put(RequestParameters.UPLOAD_ID, request.getUploadId());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<AbortMultipartUploadRequest, AbortMultipartUploadResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<AbortMultipartUploadResult> parser = new ResponseParsers.AbortMultipartUploadResponseParser();

        Callable<AbortMultipartUploadResult> callable = new OSSRequestTask<AbortMultipartUploadResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListPartsResult> listParts(
            ListPartsRequest request, OSSCompletedCallback<ListPartsRequest, ListPartsResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());

        requestMessage.getParameters().put(RequestParameters.UPLOAD_ID, request.getUploadId());

        Integer maxParts = request.getMaxParts();
        if (maxParts != null) {
            if (!OSSUtils.checkParamRange(maxParts, 0, true, LIST_PART_MAX_RETURNS, true)) {
                throw new IllegalArgumentException("MaxPartsOutOfRange: " + LIST_PART_MAX_RETURNS);
            }
            requestMessage.getParameters().put(RequestParameters.MAX_PARTS, maxParts.toString());
        }

        Integer partNumberMarker = request.getPartNumberMarker();
        if (partNumberMarker != null) {
            if (!OSSUtils.checkParamRange(partNumberMarker, 0, false, MAX_PART_NUMBER, true)) {
                throw new IllegalArgumentException("PartNumberMarkerOutOfRange: " + MAX_PART_NUMBER);
            }
            requestMessage.getParameters().put(RequestParameters.PART_NUMBER_MARKER, partNumberMarker.toString());
        }

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<ListPartsRequest, ListPartsResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListPartsResult> parser = new ResponseParsers.ListPartsResponseParser();

        Callable<ListPartsResult> callable = new OSSRequestTask<ListPartsResult>(requestMessage, parser, executionContext, maxRetryCount);

        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     OSSAsyncTask<ListMultipartUploadsResult> listMultipartUploads(
            ListMultipartUploadsRequest request, OSSCompletedCallback<ListMultipartUploadsRequest, ListMultipartUploadsResult> completedCallback) {

        RequestMessage requestMessage = new RequestMessage();
        requestMessage.setIsAuthorizationRequired(request.isAuthorizationRequired());
        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());

        requestMessage.getParameters().put(RequestParameters.SUBRESOURCE_UPLOADS, "");

        OSSUtils.populateListMultipartUploadsRequestParameters(request, requestMessage.getParameters());

        canonicalizeRequestMessage(requestMessage, request);

        ExecutionContext<ListMultipartUploadsRequest, ListMultipartUploadsResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ListMultipartUploadsResult> parser = new ResponseParsers.ListMultipartUploadsResponseParser();

        Callable<ListMultipartUploadsResult> callable = new OSSRequestTask<ListMultipartUploadsResult>(requestMessage, parser, executionContext, maxRetryCount);

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
            if (!TextUtils.isEmpty(confProxyHost)) {
                proxyHost = confProxyHost;
            }

            return TextUtils.isEmpty(proxyHost);
        }
        return false;
    }

     OkHttpClient getInnerClient() {
        return innerClient;
    }

     void canonicalizeRequestMessage(RequestMessage message, OSSRequest request) {
        Map<String, String> header = message.getHeaders();

        if (header.get(OSSHeaders.DATE) == null) {
            header.put(OSSHeaders.DATE, DateUtil.currentFixedSkewedTimeInRFC822Format());
        }

        if (message.getMethod() == HttpMethod.POST || message.getMethod() == HttpMethod.PUT) {
            if (OSSUtils.isEmptyString(header.get(OSSHeaders.CONTENT_TYPE))) {
                String determineContentType = OSSUtils.determineContentType(null,
                        message.getUploadFilePath(), message.getObjectKey());
                header.put(OSSHeaders.CONTENT_TYPE, determineContentType);
            }
        }

        // When the HTTP proxy is set, httpDNS is not enabled.
        message.setHttpDnsEnable(checkIfHttpDnsAvailable(conf.isHttpDnsEnable()));
        message.setCredentialProvider(credentialProvider);
        message.setPathStyleAccessEnable(conf.isPathStyleAccessEnable());
        message.setCustomPathPrefixEnable(conf.isCustomPathPrefixEnable());

        // set ip with header
        message.setIpWithHeader(conf.getIpWithHeader());

        message.getHeaders().put(HttpHeaders.USER_AGENT, VersionInfoUtils.getUserAgent(conf.getCustomUserMark()));

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
            , Result result) throws OSSClientException {
        if (request.getCRC64() == OSSRequest.CRC64Config.YES ? true : false) {
            try {
                OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
            } catch (InconsistentException e) {
                throw new OSSClientException(e.getMessage(), e);
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
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put(RequestParameters.X_OSS_PROCESS, "");

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        String bodyString = OSSUtils.buildTriggerCallbackBody(request.getCallbackParam(), request.getCallbackVars());
        requestMessage.setStringBody(bodyString);

        String md5String = BinaryUtil.calculateBase64Md5(bodyString.getBytes());
        requestMessage.getHeaders().put(HttpHeaders.CONTENT_MD5, md5String);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<TriggerCallbackRequest, TriggerCallbackResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<TriggerCallbackResult> parser = new ResponseParsers.TriggerCallbackResponseParser();
        Callable<TriggerCallbackResult> callable = new OSSRequestTask<TriggerCallbackResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     TriggerCallbackResult asyncTriggerCallback(TriggerCallbackRequest request) throws OSSClientException, OSSServiceException {
        return triggerCallback(request, null).getResult();
    }

     OSSAsyncTask<ImagePersistResult> imageActionPersist(ImagePersistRequest request, OSSCompletedCallback<ImagePersistRequest, ImagePersistResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put(RequestParameters.X_OSS_PROCESS, "");

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.mFromBucket);
        requestMessage.setObjectKey(request.mFromObjectkey);
        requestMessage.setParameters(query);

        String bodyString = OSSUtils.buildImagePersistentBody(request.mToBucketName, request.mToObjectKey, request.mAction);
        requestMessage.setStringBody(bodyString);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<ImagePersistRequest, ImagePersistResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<ImagePersistResult> parser = new ResponseParsers.ImagePersistResponseParser();
        Callable<ImagePersistResult> callable = new OSSRequestTask<ImagePersistResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     PutSymlinkResult syncPutSymlink(PutSymlinkRequest request) throws OSSClientException, OSSServiceException {
        return putSymlink(request, null).getResult();
    }

    ;

     OSSAsyncTask<PutSymlinkResult> putSymlink(PutSymlinkRequest request, OSSCompletedCallback<PutSymlinkRequest, PutSymlinkResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put(RequestParameters.X_OSS_SYMLINK, "");

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.PUT);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        if (!OSSUtils.isEmptyString(request.getTargetObjectName())) {
            String targetObjectName = HttpUtil.urlEncode(request.getTargetObjectName(), OSSConstants.DEFAULT_CHARSET_NAME);
            requestMessage.getHeaders().put(OSSHeaders.OSS_HEADER_SYMLINK_TARGET, targetObjectName);
        }

        OSSUtils.populateRequestMetadata(requestMessage.getHeaders(), request.getMetadata());

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<PutSymlinkRequest, PutSymlinkResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<PutSymlinkResult> parser = new ResponseParsers.PutSymlinkResponseParser();
        Callable<PutSymlinkResult> callable = new OSSRequestTask<PutSymlinkResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     GetSymlinkResult syncGetSymlink(GetSymlinkRequest request) throws OSSClientException, OSSServiceException {
        return getSymlink(request, null).getResult();
    }

     OSSAsyncTask<GetSymlinkResult> getSymlink(GetSymlinkRequest request, OSSCompletedCallback<GetSymlinkRequest, GetSymlinkResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put(RequestParameters.X_OSS_SYMLINK, "");

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.GET);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<GetSymlinkRequest, GetSymlinkResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<GetSymlinkResult> parser = new ResponseParsers.GetSymlinkResponseParser();
        Callable<GetSymlinkResult> callable = new OSSRequestTask<GetSymlinkResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }

     RestoreObjectResult syncRestoreObject(RestoreObjectRequest request) throws OSSClientException, OSSServiceException {
        return restoreObject(request, null).getResult();
    }

     OSSAsyncTask<RestoreObjectResult> restoreObject(RestoreObjectRequest request, OSSCompletedCallback<RestoreObjectRequest, RestoreObjectResult> completedCallback) {
        RequestMessage requestMessage = new RequestMessage();
        Map<String, String> query = new LinkedHashMap<String, String>();
        query.put(RequestParameters.X_OSS_RESTORE, "");

        requestMessage.setEndpoint(endpoint);
        requestMessage.setMethod(HttpMethod.POST);
        requestMessage.setBucketName(request.getBucketName());
        requestMessage.setObjectKey(request.getObjectKey());
        requestMessage.setParameters(query);

        canonicalizeRequestMessage(requestMessage, request);
        ExecutionContext<RestoreObjectRequest, RestoreObjectResult> executionContext = new ExecutionContext(getInnerClient(), request, applicationContext);
        if (completedCallback != null) {
            executionContext.setCompletedCallback(completedCallback);
        }
        ResponseParser<RestoreObjectResult> parser = new ResponseParsers.RestoreObjectResponseParser();
        Callable<RestoreObjectResult> callable = new OSSRequestTask<RestoreObjectResult>(requestMessage, parser, executionContext, maxRetryCount);
        return OSSAsyncTask.wrapRequestTask(executorService.submit(callable), executionContext);
    }
}