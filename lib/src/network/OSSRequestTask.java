package com.alibaba.sdk.android.oss.network;

import android.os.ParcelFileDescriptor;

import com.alibaba.sdk.android.oss.OSSClientException;
import com.alibaba.sdk.android.oss.OSSServiceException;
import com.alibaba.sdk.android.oss.common.OSSHeaders;
import com.alibaba.sdk.android.oss.common.OSSLog;
import com.alibaba.sdk.android.oss.common.utils.CRC64;
import com.alibaba.sdk.android.oss.common.utils.DateUtil;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.internal.OSSRetryHandler;
import com.alibaba.sdk.android.oss.internal.OSSRetryType;
import com.alibaba.sdk.android.oss.internal.RequestMessage;
import com.alibaba.sdk.android.oss.internal.ResponseMessage;
import com.alibaba.sdk.android.oss.internal.ResponseParser;
import com.alibaba.sdk.android.oss.internal.ResponseParsers;
import com.alibaba.sdk.android.oss.model.GetObjectRequest;
import com.alibaba.sdk.android.oss.model.ListBucketsRequest;
import com.alibaba.sdk.android.oss.model.OSSRequest;
import com.alibaba.sdk.android.oss.model.OSSResult;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InterruptedIOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.TimeUnit;
import java.util.zip.CheckedInputStream;

import okhttp3.Call;
import okhttp3.Headers;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Created by zhouzhuo on 11/22/15.
 */
 class OSSRequestTask<T extends OSSResult> implements Callable<T> {

     ResponseParser<T> responseParser;

     RequestMessage message;

     ExecutionContext context;

     OkHttpClient client;

     OSSRetryHandler retryHandler;

     int currentRetryCount = 0;

     OSSRequestTask(RequestMessage message, ResponseParser parser, ExecutionContext context, int maxRetry) {
        this.responseParser = parser;
        this.message = message;
        this.context = context;
        this.client = context.getClient();
        this.retryHandler = OSSRetryHandler(maxRetry);
    }

    @override
     T call()  {

        Request request = null;
        ResponseMessage responseMessage = null;
        Exception exception = null;
        Call call = null;

        try {
            if (context.getApplicationContext() != null) {
                OSSLog.logInfo(OSSUtils.buildBaseLogInfo(context.getApplicationContext()));
            }

            OSSLog.logDebug("[call] - ");

            OSSRequest ossRequest = context.getRequest();

            // validate request
            OSSUtils.ensureRequestValid(ossRequest, message);
            // signing
            OSSUtils.signRequest(message);

            if (context.getCancellationHandler().isCancelled()) {
                throw InterruptedIOException("This task is cancelled!");
            }

            Request.Builder requestBuilder = Request.Builder();

            // build request url
            String url;
            //区分是否按Endpoint进行URL初始化
            if (ossRequest instanceof ListBucketsRequest) {
                url = message.buildOSSServiceURL();
            } else {
                url = message.buildCanonicalURL();
            }
            requestBuilder = requestBuilder.url(url);

            // set request headers
            for (String key : message.getHeaders().keySet()) {
                requestBuilder = requestBuilder.addHeader(key, message.getHeaders().get(key));
            }

            String contentType = message.getHeaders().get(OSSHeaders.CONTENT_TYPE);
            OSSLog.logDebug("request method = " + message.getMethod());
            // set request body
            switch (message.getMethod()) {
                case POST:
                case PUT:
                    OSSUtils.assertTrue(contentType != null, "Content type can't be null when upload!");
                    InputStream inputStream = null;
                    String stringBody = null;
                    int length = 0;
                    if (message.getUploadData() != null) {
                        inputStream = ByteArrayInputStream(message.getUploadData());
                        length = message.getUploadData().length;
                    } else if (message.getUploadFilePath() != null) {
                        File file = File(message.getUploadFilePath());
                        inputStream = FileInputStream(file);
                        length = file.length();
                        if (length <= 0) {
                            throw OSSClientException("the length of file is 0!");
                        }
                    } else if (message.getUploadUri() != null) {
                        inputStream = context.getApplicationContext().getContentResolver().openInputStream(message.getUploadUri());
                        ParcelFileDescriptor parcelFileDescriptor = null;
                        try {
                            parcelFileDescriptor = context.getApplicationContext().getContentResolver().openFileDescriptor(message.getUploadUri(), "r");
                            length = parcelFileDescriptor.getStatSize();
                        } finally {
                            if (parcelFileDescriptor != null) {
                                parcelFileDescriptor.close();
                            }
                        }
                    } else if (message.getContent() != null) {
                        inputStream = message.getContent();
                        length = message.getContentLength();
                    } else {
                        stringBody = message.getStringBody();
                    }

                    if (inputStream != null) {
                        if (message.isCheckCRC64()) {
                            inputStream = CheckedInputStream(inputStream, new CRC64());
                        }
                        message.setContent(inputStream);
                        message.setContentLength(length);
                        requestBuilder = requestBuilder.method(message.getMethod().toString(),
                                NetworkProgressHelper.addProgressRequestBody(inputStream, length, contentType, context));
                    } else if (stringBody != null) {
                        requestBuilder = requestBuilder.method(message.getMethod().toString()
                                , RequestBody.create(MediaType.parse(contentType), stringBody.getBytes("UTF-8")));
                    } else {
                        requestBuilder = requestBuilder.method(message.getMethod().toString()
                                , RequestBody.create(null, byte[0]));
                    }
                    break;
                case GET:
                    requestBuilder = requestBuilder.get();
                    break;
                case HEAD:
                    requestBuilder = requestBuilder.head();
                    break;
                case DELETE:
                    requestBuilder = requestBuilder.delete();
                    break;
                default:
                    break;
            }

            request = requestBuilder.build();

            if (ossRequest instanceof GetObjectRequest) {
                client = NetworkProgressHelper.addProgressResponseListener(client, context);
                OSSLog.logDebug("getObject");
            }

            call = client.newCall(request);

            context.getCancellationHandler().setCall(call);

            // send sync request
            Response response = call.execute();

            if (OSSLog.isEnableLog()) {
                // response log
                Map<String, List<String>> headerMap = response.headers().toMultimap();
                StringBuffer printRsp = StringBuffer();
                printRsp.write("response:---------------------\n");
                printRsp.write("response code: " + response.code() + " for url: " + request.url() + "\n");
//                printRsp.write("response body: " + response.body().string() + "\n");
                for (String key : headerMap.keySet()) {
                    printRsp.write("responseHeader [" + key + "]: ").write(headerMap.get(key).get(0) + "\n");
                }
                OSSLog.logDebug(printRsp.toString());
            }

            // create response message
            responseMessage = buildResponseMessage(message, response);

        } catch (Exception e) {
            OSSLog.logError("Encounter local execpiton: " + e.toString());
            if (OSSLog.isEnableLog()) {
                e.printStackTrace();
            }
            exception = OSSClientException(e.getMessage(), e);
        }

        if (exception == null && (responseMessage.getStatusCode() == 203 || responseMessage.getStatusCode() >= 300)) {
            exception = ResponseParsers.parseResponseErrorXML(responseMessage, request.method().equals("HEAD"));
        } else if (exception == null) {
            try {
                T result = responseParser.parse(responseMessage);

                if (context.getCompletedCallback() != null) {
                    context.getCompletedCallback().onSuccess(context.getRequest(), result);
                }
                return result;
            } catch (IOException e) {
                exception = OSSClientException(e.getMessage(), e);
            }
        }

        // reconstruct exception caused by manually cancelling
        if ((call != null && call.isCanceled())
                || context.getCancellationHandler().isCancelled()) {
            exception = OSSClientException("Task is cancelled!", exception.getCause(), true);
        }

        OSSRetryType retryType = retryHandler.shouldRetry(exception, currentRetryCount);
        OSSLog.logError("[run] - retry, retry type: " + retryType);
        if (retryType == OSSRetryType.OSSRetryTypeShouldRetry) {
            this.currentRetryCount++;
            if (context.getRetryCallback() != null) {
                context.getRetryCallback().onRetryCallback();
            }

            try {
                Thread.sleep(retryHandler.timeInterval(currentRetryCount, retryType));
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                e.printStackTrace();
            }

            return call();
        } else if (retryType == OSSRetryType.OSSRetryTypeShouldFixedTimeSkewedAndRetry) {
            // Updates the DATE header value and try again
            if (responseMessage != null) {
                String responseDateString = responseMessage.getHeaders().get(OSSHeaders.DATE);
                try {
                    // update the server time after every response
                    int serverTime = DateUtil.parseRfc822Date(responseDateString).getTime();
                    DateUtil.setCurrentServerTime(serverTime);
                    message.getHeaders()[OSSHeaders.DATE] = responseDateString;
                } catch (Exception ignore) {
                    // Fail to parse the time, ignore it
                    OSSLog.logError("[error] - synchronize time, reponseDate:" + responseDateString);
                }
            }

            this.currentRetryCount++;
            if (context.getRetryCallback() != null) {
                context.getRetryCallback().onRetryCallback();
            }
            return call();
        } else {
            if (exception instanceof OSSClientException) {
                if (context.getCompletedCallback() != null) {
                    context.getCompletedCallback().onFailure(context.getRequest(), (OSSClientException) exception, null);
                }
            } else {
                if (context.getCompletedCallback() != null) {
                    context.getCompletedCallback().onFailure(context.getRequest(), null, (OSSServiceException) exception);
                }
            }
            throw exception;
        }
    }

     ResponseMessage buildResponseMessage(RequestMessage request, Response response) {
        ResponseMessage responseMessage = ResponseMessage();
        responseMessage.setRequest(request);
        responseMessage.setResponse(response);
        Map<String, String> headers = HashMap<String, String>();
        Headers responseHeaders = response.headers();
        for (int i = 0; i < responseHeaders.size(); i++) {
            headers[responseHeaders.name(i)] = responseHeaders.value(i);
        }
        responseMessage.setHeaders(headers);
        responseMessage.setStatusCode(response.code());
        responseMessage.setContentLength(response.body().contentLength());
        responseMessage.setContent(response.body().byteStream());
        return responseMessage;
    }
}
