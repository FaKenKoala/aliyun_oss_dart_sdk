package com.alibaba.sdk.android.oss.network;

import android.content.Context;

import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.callback.OSSRetryCallback;
import com.alibaba.sdk.android.oss.model.OSSRequest;
import com.alibaba.sdk.android.oss.model.OSSResult;

import okhttp3.OkHttpClient;

/**
 * Created by zhouzhuo on 11/22/15.
 */
 class ExecutionContext<Request extends OSSRequest, Result extends OSSResult> {

     Request request;
     OkHttpClient client;
     CancellationHandler cancellationHandler = new CancellationHandler();
     Context applicationContext;

     OSSCompletedCallback completedCallback;
     OSSProgressCallback progressCallback;
     OSSRetryCallback retryCallback;


     ExecutionContext(OkHttpClient client, Request request) {
        this(client, request, null);
    }

     ExecutionContext(OkHttpClient client, Request request, Context applicationContext) {
        setClient(client);
        setRequest(request);
        this.applicationContext = applicationContext;
    }

     Context getApplicationContext() {
        return applicationContext;
    }

     Request getRequest() {
        return request;
    }

     void setRequest(Request request) {
        this.request = request;
    }

     OkHttpClient getClient() {
        return client;
    }

     void setClient(OkHttpClient client) {
        this.client = client;
    }

     CancellationHandler getCancellationHandler() {
        return cancellationHandler;
    }

     OSSCompletedCallback<Request, Result> getCompletedCallback() {
        return completedCallback;
    }

     void setCompletedCallback(OSSCompletedCallback<Request, Result> completedCallback) {
        this.completedCallback = completedCallback;
    }

     OSSProgressCallback getProgressCallback() {
        return progressCallback;
    }

     void setProgressCallback(OSSProgressCallback progressCallback) {
        this.progressCallback = progressCallback;
    }

     OSSRetryCallback getRetryCallback() {
        return retryCallback;
    }

     void setRetryCallback(OSSRetryCallback retryCallback) {
        this.retryCallback = retryCallback;
    }
}
