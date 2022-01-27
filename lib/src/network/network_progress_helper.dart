
 import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';

import 'execution_context.dart';
import 'lib_network.dart';

class NetworkProgressHelper {

    /**
     * process response progress
     */
     static OkHttpClient addProgressResponseListener(OkHttpClient client,
                                                           final ExecutionContext context) {
        OkHttpClient newClient = client.newBuilder()
                .addNetworkInterceptor(Interceptor() {
                    @override
                     Response intercept(Chain chain)  {
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
        return ProgressTouchableRequestBody(input, contentLength, contentType);
    }
}
