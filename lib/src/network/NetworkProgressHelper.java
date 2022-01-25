package com.alibaba.sdk.android.oss.network;


import java.io.IOException;
import java.io.InputStream;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Response;

/**
 * Created by jingdan on 2017/9/12.
 */

 class NetworkProgressHelper {

    /**
     * process response progress
     */
     static OkHttpClient addProgressResponseListener(OkHttpClient client,
                                                           final ExecutionContext context) {
        OkHttpClient newClient = client.newBuilder()
                .addNetworkInterceptor(Interceptor() {
                    @override
                     Response intercept(Chain chain) throws IOException {
                        Response originalResponse = chain.proceed(chain.request());
                        return originalResponse.newBuilder()
                                .body(ProgressTouchableResponseBody(originalResponse.body(),
                                        context))
                                .build();
                    }
                })
                .build();
        return newClient;
    }

    /**
     * process request progress
     */
     static ProgressTouchableRequestBody addProgressRequestBody(InputStream input,
                                                                      int contentLength,
                                                                      String contentType,
                                                                      ExecutionContext context) {
        return ProgressTouchableRequestBody(input, contentLength, contentType, context);
    }
}
