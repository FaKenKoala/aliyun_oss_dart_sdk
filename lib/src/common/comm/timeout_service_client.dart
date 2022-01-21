/// Default implementation of {@link ServiceClient}.
 class TimeoutServiceClient extends DefaultServiceClient {
    protected ThreadPoolExecutor executor;

     TimeoutServiceClient(ClientConfiguration config) {
        super(config);

        int processors = Runtime.getRuntime().availableProcessors();
        executor = new ThreadPoolExecutor(processors * 5, processors * 10, 60L, TimeUnit.SECONDS,
                new ArrayBlockingQueue<Runnable>(processors * 100), Executors.defaultThreadFactory(),
                new ThreadPoolExecutor.CallerRunsPolicy());
        executor.allowCoreThreadTimeOut(true);
    }

    @Override
     ResponseMessage sendRequestCore(ServiceClient.Request request, ExecutionContext context) throws IOException {
        HttpRequestBase httpRequest = httpRequestFactory.createHttpRequest(request, context);
        HttpClientContext httpContext = HttpClientContext.create();
        httpContext.setRequestConfig(this.requestConfig);

        CloseableHttpResponse httpResponse = null;
        HttpRequestTask httpRequestTask = new HttpRequestTask(httpRequest, httpContext);
        Future<CloseableHttpResponse> future = executor.submit(httpRequestTask);

        try {
            httpResponse = future.get(this.config.getRequestTimeout(), TimeUnit.MILLISECONDS);
        } catch (InterruptedException e) {
            logException("[ExecutorService]The current thread was interrupted while waiting: ", e);

            httpRequest.abort();
            throw new ClientException(e.getMessage(), e);
        } catch (ExecutionException e) {
            RuntimeException ex;
            httpRequest.abort();

            if (e.getCause() instanceof IOException) {
                ex = ExceptionFactory.createNetworkException((IOException) e.getCause());
            } else {
                ex = new OSSException(e.getMessage(), e);
            }

            logException("[ExecutorService]The computation threw an exception: ", ex);
            throw ex;
        } catch (TimeoutException e) {
            logException("[ExecutorService]The wait " + this.config.getRequestTimeout() + " timed out: ", e);

            httpRequest.abort();
            throw new ClientException(e.getMessage(), OSSErrorCode.REQUEST_TIMEOUT, "Unknown", e);
        }

        return buildResponse(request, httpResponse);
    }

    @Override
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

    class HttpRequestTask implements Callable<CloseableHttpResponse> {
         HttpRequestBase httpRequest;
         HttpClientContext httpContext;

         HttpRequestTask(HttpRequestBase httpRequest, HttpClientContext httpContext) {
            this.httpRequest = httpRequest;
            this.httpContext = httpContext;
        }

        @Override
         CloseableHttpResponse call() throws Exception {
            return httpClient.execute(httpRequest, httpContext);
        }
    };

}
