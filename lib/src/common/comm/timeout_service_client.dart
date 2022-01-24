import 'dart:html';

import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/client_error_code.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/oss_error_code.dart';
import 'package:aliyun_oss_dart_sdk/src/oss_exception.dart';

import 'default_service_client.dart';
import 'execution_context.dart';
import 'request_message.dart';
import 'response_message.dart';
import 'retry_strategy.dart';

/// Default implementation of {@link ServiceClient}.
 class TimeoutServiceClient extends DefaultServiceClient {
     ThreadPoolExecutor executor;

     TimeoutServiceClient(ClientConfiguration config):super(config) {
        int processors = Runtime.getRuntime().availableProcessors();
        executor = ThreadPoolExecutor(processors * 5, processors * 10, 60, TimeUnit.SECONDS,
                ArrayBlockingQueue<Runnable>(processors * 100), Executors.defaultThreadFactory(),
                ThreadPoolExecutor.CallerRunsPolicy());
        executor.allowCoreThreadTimeOut(true);
    }

    @override
     ResponseMessage sendRequestCore(ServiceClient.Request request, ExecutionContext context) {
        HttpRequestBase httpRequest = httpRequestFactory.createHttpRequest(request, context);
        HttpClientContext httpContext = HttpClientContext.create();
        httpContext.setRequestConfig(this.requestConfig);

        CloseableHttpResponse httpResponse = null;
        HttpRequestTask httpRequestTask = HttpRequestTask(httpRequest, httpContext);
        Future<CloseableHttpResponse> future = executor.submit(httpRequestTask);

        try {
            httpResponse = future.GET(this.config.getRequestTimeout(), TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            logException("[ExecutorService]The current thread was interrupted while waiting: ", e);

            httpRequest.abort();
            throw ClientException(e);
        } catch (ExecutionException e) {
            RuntimeException ex;
            httpRequest.abort();

            if (e.getCause() is IOException) {
                ex = ExceptionFactory.createNetworkException((IOException) e.getCause());
            } else {
                ex = OSSException(e.getMessage(), e);
            }

            logException("[ExecutorService]The computation threw an exception: ", ex);
            throw ex;
        } catch (TimeoutException e) {
            logException("[ExecutorService]The wait " + this.config.getRequestTimeout() + " timed out: ", e);

            httpRequest.abort();
            throw ClientException(e.getMessage(), OSSErrorCode.REQUEST_TIMEOUT, "Unknown", e);
        }

        return buildResponse(request, httpResponse);
    }

    @override
     void shutdown() {
        executor.shutdown();
        try {
            if (!executor.awaitTermination(ClientConfiguration.DEFAULT_THREAD_POOL_WAIT_TIME, TimeUnit.MILLISECONDS)) {
                executor.shutdownNow();
                if (!executor.awaitTermination(ClientConfiguration.DEFAULT_THREAD_POOL_WAIT_TIME,
                        TimeUnit.MILLISECONDS)) {
                    getLog().warn("Pool did not terminate in "
                            + ClientConfiguration.DEFAULT_THREAD_POOL_WAIT_TIME / 1000 + " seconds");
                }
            }
        } catch (InterruptedException ie) {
            executor.shutdownNow();
            Thread.currentThread().interrupt();
        }
        super.shutdown();
    }
 }
    class HttpRequestTask implements Callable<CloseableHttpResponse> {
         HttpRequestBase httpRequest;
         HttpClientContext httpContext;

         HttpRequestTask(HttpRequestBase httpRequest, HttpClientContext httpContext) {
            this.httpRequest = httpRequest;
            this.httpContext = httpContext;
        }

        @override
         CloseableHttpResponse call() throws Exception {
            return httpClient.execute(httpRequest, httpContext);
        }
    }



class DefaultRetryStrategy extends RetryStrategy {

        @override
         bool shouldRetry(Exception ex, RequestMessage request, ResponseMessage response, int retries) {
            if (ex is ClientException) {
                String? errorCode = ex.errorCode;
                if ([ClientErrorCode.CONNECTION_TIMEOUT
                        , ClientErrorCode.SOCKET_TIMEOUT
                        , ClientErrorCode.CONNECTION_REFUSED
                        , ClientErrorCode.UNKNOWN_HOST
                        , ClientErrorCode.SOCKET_EXCEPTION
                        , ClientErrorCode.SSL_EXCEPTION].contains(errorCode)) {
                    return true;
                }

                // Don't retry when request input stream is non-repeatable
                if (errorCode == ClientErrorCode.NONREPEATABLE_REQUEST) {
                    return false;
                }
            }

            if (ex is OSSException) {
                String? errorCode = ex.errorCode;
                // No need retry for invalid responses
                if (errorCode == OSSErrorCode.INVALID_RESPONSE) {
                    return false;
                }
            }

            if (response != null) {
                int statusCode = response.statusCode;
                if (statusCode == HttpStatus.internalServerError || statusCode == HttpStatus.badGateway ||
                        statusCode == HttpStatus.serviceUnavailable) {
                    return true;
                }
            }

            return false;
        }
    }
