
import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/service_client.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/service_client.dart';

import 'service_client.dart';

/// Default implementation of {@link ServiceClient}.
 class DefaultServiceClient extends ServiceClient {
     static HttpRequestFactory httpRequestFactory = HttpRequestFactory();
	 static Method setNormalizeUriMethod = null;

     CloseableHttpClient httpClient;
     HttpClientConnectionManager connectionManager;
     RequestConfig requestConfig;
     CredentialsProvider credentialsProvider;
     HttpHost proxyHttpHost;
     AuthCache authCache;

     DefaultServiceClient(ClientConfiguration config) {
        connectionManager = createHttpClientConnectionManager();
        httpClient = createHttpClient(connectionManager);
        RequestConfig.Builder requestConfigBuilder = RequestConfig.custom();
        requestConfigBuilder.setConnectTimeout(config.getConnectionTimeout());
        requestConfigBuilder.setSocketTimeout(config.getSocketTimeout());
        requestConfigBuilder.setConnectionRequestTimeout(config.getConnectionRequestTimeout());
        requestConfigBuilder.setRedirectsEnabled(config.isRedirectEnable());

        String? proxyHost = resolveStringValue(config.proxyHost, "http.proxyHost", config.isUseSystemPropertyValues());
        int proxyPort = resolveIntValue(config.proxyHost, "http.proxyPort", config.isUseSystemPropertyValues());

        if (proxyHost != null && proxyPort > 0) {
            proxyHttpHost = HttpHost(proxyHost, proxyPort);
            requestConfigBuilder.setProxy(proxyHttpHost);

            String? proxyUsername = resolveStringValue(config.proxyUsername,"http.proxyUser", config.useSystemPropertyValues);
            String? proxyPassword = resolveStringValue(config.proxyPassword,"http.proxyPassword", config.useSystemPropertyValues);
            String proxyDomain = config.proxyDomain;
            String proxyWorkstation = config.proxyWorkstation;
            if (proxyUsername != null && proxyPassword != null) {
                credentialsProvider = BasicCredentialsProvider();
                credentialsProvider.setCredentials(AuthScope(proxyHost, proxyPort),
                        NTCredentials(proxyUsername, proxyPassword, proxyWorkstation, proxyDomain));

                authCache = BasicAuthCache();
                authCache.put(proxyHttpHost, BasicScheme());
            }
        }

        //Compatible with HttpClient 4.5.9 or later
        if (setNormalizeUriMethod != null) {
            try {
                setNormalizeUriMethod.invoke(requestConfigBuilder, false);
            }catch ( e) {
            }
        }

        requestConfig = requestConfigBuilder.build();
    }

    @override
     ResponseMessage sendRequestCore(ServiceClient.Request request, ExecutionContext context) {
        HttpRequestBase httpRequest = httpRequestFactory.createHttpRequest(request, context);
        setProxyAuthorizationIfNeed(httpRequest);
        HttpClientContext httpContext = createHttpContext();
        httpContext.setRequestConfig(requestConfig);

        CloseableHttpResponse httpResponse = null;
        try {
            httpResponse = httpClient.execute(httpRequest, httpContext);
        } catch (IOException ex) {
            httpRequest.abort();
            throw ExceptionFactory.createNetworkException(ex);
        }

        return buildResponse(request, httpResponse);
    }

     static ResponseMessage buildResponse(ServiceClient.Request request, CloseableHttpResponse httpResponse)
            {

        assert (httpResponse != null);

        ResponseMessage response = ResponseMessage(request);
        response.setUrl(request.getUri());
        response.setHttpResponse(httpResponse);

        if (httpResponse.getStatusLine() != null) {
            response.setStatusCode(httpResponse.getStatusLine().getStatusCode());
        }

        if (httpResponse.getEntity() != null) {
            if (response.isSuccessful()) {
                response.setContent(httpResponse.getEntity().getContent());
            } else {
                readAndSetErrorResponse(httpResponse.getEntity().getContent(), response);
            }
        }

        for (Header header : httpResponse.getAllHeaders()) {
            if (HttpHeaders.CONTENT_LENGTH.equalsIgnoreCase(header.getName())) {
                response.setContentLength(Long.parseLong(header.getValue()));
            }
            response.addHeader(header.getName(), header.getValue());
        }

        HttpUtil.convertHeaderCharsetFromIso88591(response.getHeaders());

        return response;
    }

     static void readAndSetErrorResponse(InputStream originalContent, ResponseMessage response)
            {
        byte[] contentBytes = IOUtils.readStreamAsByteArray(originalContent);
        response.setErrorResponseAsString(String(contentBytes));
        response.setContent(ByteArrayInputStream(contentBytes));
    }

     static class DefaultRetryStrategy extends RetryStrategy {

        @override
         bool shouldRetry(Exception ex, RequestMessage request, ResponseMessage response, int retries) {
            if (ex is ClientException) {
                String errorCode = ((ClientException) ex).getErrorCode();
                if (errorCode.equals(ClientErrorCode.CONNECTION_TIMEOUT)
                        || errorCode.equals(ClientErrorCode.SOCKET_TIMEOUT)
                        || errorCode.equals(ClientErrorCode.CONNECTION_REFUSED)
                        || errorCode.equals(ClientErrorCode.UNKNOWN_HOST)
                        || errorCode.equals(ClientErrorCode.SOCKET_EXCEPTION)
                        || errorCode.equals(ClientErrorCode.SSL_EXCEPTION)) {
                    return true;
                }

                // Don't retry when request input stream is non-repeatable
                if (errorCode.equals(ClientErrorCode.NONREPEATABLE_REQUEST)) {
                    return false;
                }
            }

            if (ex is OSSException) {
                String errorCode = ((OSSException) ex).getErrorCode();
                // No need retry for invalid responses
                if (errorCode.equals(OSSErrorCode.INVALID_RESPONSE)) {
                    return false;
                }
            }

            if (response != null) {
                int statusCode = response.getStatusCode();
                if (statusCode == HttpStatus.SC_INTERNAL_SERVER_ERROR || statusCode == HttpStatus.SC_BAD_GATEWAY ||
                        statusCode == HttpStatus.SC_SERVICE_UNAVAILABLE) {
                    return true;
                }
            }

            return false;
        }
    }

    @override
     RetryStrategy getDefaultRetryStrategy() {
        return DefaultRetryStrategy();
    }

     CloseableHttpClient createHttpClient(HttpClientConnectionManager connectionManager) {
        return HttpClients.custom().setConnectionManager(connectionManager).setUserAgent(config.getUserAgent())
                .disableContentCompression().disableAutomaticRetries().build();
    }

     HttpClientConnectionManager createHttpClientConnectionManager() {
        SSLConnectionSocketFactory sslSocketFactory = null;
        try {
            List<TrustManager> trustManagerList = [];
            X509TrustManager[] trustManagers = config.getX509TrustManagers();

            if (null != trustManagers) {
                trustManagerList.addAll(Arrays.asList(trustManagers));
            }

            // get trustManager using default certification from jdk
            TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
            tmf.init((KeyStore) null);
            trustManagerList.addAll(Arrays.asList(tmf.getTrustManagers()));

            final List<X509TrustManager> finalTrustManagerList = [];
            for (TrustManager tm : trustManagerList) {
                if (tm is X509TrustManager) {
                    finalTrustManagerList.add((X509TrustManager) tm);
                }
            }
            CompositeX509TrustManager compositeX509TrustManager = CompositeX509TrustManager(finalTrustManagerList);
            compositeX509TrustManager.setVerifySSL(config.isVerifySSLEnable());
            KeyManager[] keyManagers = null;
            if (config.getKeyManagers() != null) {
                keyManagers = config.getKeyManagers();
            }

            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(keyManagers, TrustManager[]{compositeX509TrustManager}, config.getSecureRandom());

            HostnameVerifier hostnameVerifier = null;
            if (!config.isVerifySSLEnable()) {
                hostnameVerifier = NoopHostnameVerifier();
            } else if (config.getHostnameVerifier() != null) {
                hostnameVerifier = config.getHostnameVerifier();
            } else {
                hostnameVerifier = DefaultHostnameVerifier();
            }
            sslSocketFactory = SSLConnectionSocketFactory(sslContext, hostnameVerifier);
        } catch (Exception e) {
            throw ClientException(e.getMessage());
        }

        Registry<ConnectionSocketFactory> socketFactoryRegistry = RegistryBuilder.<ConnectionSocketFactory> create()
                .register(Protocol.HTTP.toString(), PlainConnectionSocketFactory.getSocketFactory())
                .register(Protocol.HTTPS.toString(), sslSocketFactory).build();

        PoolingHttpClientConnectionManager connectionManager = PoolingHttpClientConnectionManager(
                socketFactoryRegistry);
        connectionManager.setDefaultMaxPerRoute(config.maxConnections);
        connectionManager.setMaxTotal(config.maxConnections);
        connectionManager.setValidateAfterInactivity(config.getValidateAfterInactivity());
        connectionManager.setDefaultSocketConfig(
                SocketConfig.custom().setSoTimeout(config.getSocketTimeout()).setTcpNoDelay(true).build());
        if (config.isUseReaper()) {
            IdleConnectionReaper.setIdleConnectionTime(config.getIdleConnectionTime());
            IdleConnectionReaper.registerConnectionManager(connectionManager);
        }
        return connectionManager;
    }

     HttpClientContext createHttpContext() {
        HttpClientContext httpContext = HttpClientContext.create();
        httpContext.setRequestConfig(requestConfig);
        if (credentialsProvider != null) {
            httpContext.setCredentialsProvider(credentialsProvider);
            httpContext.setAuthCache(authCache);
        }
        return httpContext;
    }

     void setProxyAuthorizationIfNeed(HttpRequestBase httpRequest) {
        if (credentialsProvider != null) {
            String auth = config.getProxyUsername() + ":" + config.getProxyPassword();
            byte[] encodedAuth = Base64.encodeBase64(auth.getBytes());
            String authHeader = "Basic " + String(encodedAuth);
            httpRequest.addHeader(AUTH.PROXY_AUTH_RESP, authHeader);
        }
    }

    @override
     void shutdown() {
        IdleConnectionReaper.removeConnectionManager(connectionManager);
        connectionManager.shutdown();
    }

    @override
     String getConnectionPoolStats() {
        if (connectionManager != null && connectionManager is PoolingHttpClientConnectionManager) {
            PoolingHttpClientConnectionManager conn = (PoolingHttpClientConnectionManager)connectionManager;
            return conn.getTotalStats().toString();
        }
        return "";
    }

     static Method getClassMethd(Class<?> clazz, String methodName) {
        try {
            Method[] method = clazz.getDeclaredMethods();
            for (Method m : method) {
                if (!m.getName().equals(methodName)) {
                    continue;
                }
                return m;
            }
        } catch (Exception e) {
        }
        return null;
    }

    static {
        try {
            setNormalizeUriMethod = getClassMethd(
                    Class.forName("org.apache.http.client.config.RequestConfig$Builder"),
                    "setNormalizeUri");
        } catch (Exception e) {
        }
    }

     class CompositeX509TrustManager implements X509TrustManager {

         final List<X509TrustManager> trustManagers;
         bool verifySSL = true;

         bool isVerifySSL() {
            return this.verifySSL;
        }

         void setVerifySSL(bool verifySSL) {
            this.verifySSL = verifySSL;
        }

         CompositeX509TrustManager(List<X509TrustManager> trustManagers) {
            this.trustManagers = trustManagers;
        }

        @override
         void checkClientTrusted(X509Certificate[] chain, String authType) {
            // do nothing
        }

        @override
         void checkServerTrusted(X509Certificate[] chain, String authType) {
            if (!verifySSL) {
                return;
            }
            for (X509TrustManager trustManager : trustManagers) {
                try {
                    trustManager.checkServerTrusted(chain, authType);
                    return; // someone trusts them. success!
                } catch (CertificateException e) {
                    // maybe someone else will trust them
                }
            }
            throw CertificateException("None of the TrustManagers trust this certificate chain");
        }

        @override
         X509Certificate[] getAcceptedIssuers() {
            List<X509Certificate> certificates = [];
            for (X509TrustManager trustManager : trustManagers) {
                X509Certificate[] accepts = trustManager.getAcceptedIssuers();
                if(accepts != null && accepts.length > 0) {
                    certificates.addAll(Arrays.asList(accepts));
                }
            }
            X509Certificate[] certificatesArray = X509Certificate[certificates.size()];
            return certificates.toArray(certificatesArray);
        }
    }

     static String resolveStringValue(String value, String key, bool flag) {
        if (value == null && flag) {
            try {
                return System.getProperty(key);
            } catch (Exception e) {
            }
            return null;
        }
        return value;
    }

     static int resolveIntValue(int value, String key, bool flag) {
        if (value == -1 && flag) {
            try {
                return Integer.parseInt(System.getProperty(key));
            } catch (Exception e) {
            }
            return -1;
        }
        return value;
    }
}
