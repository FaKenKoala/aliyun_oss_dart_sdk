/// Client configuration for access to Ali cloud services
 class ClientConfiguration {

     ClientConfiguration(); 


     static final int DEFAULT_MAX_RETRIES = 2;
     int maxConcurrentRequest = 5;
     int socketTimeout = 60 * 1000;
     int connectionTimeout = 60 * 1000;
     int max_log_size = 5 * 1024 * 1024;
     int maxErrorRetry = DEFAULT_MAX_RETRIES;
     List<String> customCnameExcludeList = [];
     String proxyHost;
     int proxyPort;
     String mUserAgentMark;
     bool httpDnsEnable = true;
     bool checkCRC64 = false;//crc64 default false
     String ipWithHeader;
     bool pathStyleAccessEnable = false;
     bool customPathPrefixEnable = false;


    /// Gets the default configuration instance
     static ClientConfiguration getDefaultConf() {
        return ClientConfiguration();
    }

    /// Gets the max concurrent request count
    ///
    /// @return
     int getMaxConcurrentRequest() {
        return maxConcurrentRequest;
    }

    /// Sets the max concurrent request count
    ///
    /// @param maxConcurrentRequest The max HTTP request count
     void setMaxConcurrentRequest(int maxConcurrentRequest) {
        this.maxConcurrentRequest = maxConcurrentRequest;
    }

    /// Gets the socket timeout in milliseconds
    /// 0 means infinite (not recommended)
    ///
    /// @return the socket timeout in milliseconds
     int getSocketTimeout() {
        return socketTimeout;
    }

    /// Gets the socket timeout in milliseconds
    /// 0 means infinite (not recommended)
    ///
    /// @param socketTimeout the socket timeout in milliseconds
     void setSocketTimeout(int socketTimeout) {
        this.socketTimeout = socketTimeout;
    }

    /// Gets the connection timeout in milliseconds
    ///
    /// @return The connection timeout in milliseconds
     int getConnectionTimeout() {
        return connectionTimeout;
    }

    /// Sets the connection timeout in milliseconds
    ///
    /// @param connectionTimeout The connection timeout in milliseconds
     void setConnectionTimeout(int connectionTimeout) {
        this.connectionTimeout = connectionTimeout;
    }

     int getMaxLogSize() {
        return max_log_size;
    }

    /// set max log file size  default 5mb
    ///
    /// @param max_log_size
     void setMaxLogSize(int max_log_size) {
        this.max_log_size = max_log_size;
    }

    /// Gets the max retry count after the recoverable failure. By default it's 2.
    ///
    /// @return The max retry count after the recoverable failure.
     int getMaxErrorRetry() {
        return maxErrorRetry;
    }

    /// Sets the max retry count after the recoverable failure. By default it's 2.
    ///
    /// @param maxErrorRetry The max retry count after the recoverable failure.
     void setMaxErrorRetry(int maxErrorRetry) {
        this.maxErrorRetry = maxErrorRetry;
    }

    /// Gets the immutable CName excluded list. The element in this list will skip the CName resolution.
    ///
    /// @return CNAME excluded list.
     List<String> getCustomCnameExcludeList() {
        return Collections.unmodifiableList(this.customCnameExcludeList);
    }

    /// Sets CNAME excluded list
    ///
    /// @param customCnameExcludeList CNAME excluded list
     void setCustomCnameExcludeList(List<String> customCnameExcludeList) {
        if (customCnameExcludeList == null || customCnameExcludeList.size() == 0) {
            throw IllegalArgumentException("cname exclude list should not be null.");
        }

        this.customCnameExcludeList.clear();
        for (String host : customCnameExcludeList) {
            if (host.contains("://")) {
                this.customCnameExcludeList.add(host.substring(host.indexOf("://") + 3));
            } else {
                this.customCnameExcludeList.add(host);
            }
        }
    }

     String getProxyHost() {
        return proxyHost;
    }

     void setProxyHost(String proxyHost) {
        this.proxyHost = proxyHost;
    }

     int getProxyPort() {
        return proxyPort;
    }

     void setProxyPort(int proxyPort) {
        this.proxyPort = proxyPort;
    }

     String getCustomUserMark() {
        return mUserAgentMark;
    }

     void setUserAgentMark(String mark) {
        this.mUserAgentMark = mark;
    }

     bool isHttpDnsEnable() {
        return httpDnsEnable;
    }

     void setHttpDnsEnable(bool httpdnsEnable) {
        this.httpDnsEnable = httpdnsEnable;
    }

     bool isCheckCRC64() {
        return checkCRC64;
    }

    /// set check file with CRC64
    ///
    /// @param checkCRC64
     void setCheckCRC64(bool checkCRC64) {
        this.checkCRC64 = checkCRC64;
    }

     String getIpWithHeader() {
        return ipWithHeader;
    }

     void setIpWithHeader(String ipWithHeader) {
        this.ipWithHeader = ipWithHeader;
    }

    /// Gets the flag of using Second Level Domain style to access the
    /// endpoint. By default it's false. When using Second Level Domain, then the bucket endpoint
    /// would be: http://host/bucket. Otherwise, it will be http://bucket.host
    ///
    /// @return True if it's enabled; False if it's disabled.
     bool isPathStyleAccessEnable() {
        return pathStyleAccessEnable;
    }

    /// Sets the flag of using Second Level Domain style to access the
    /// endpoint. By default it's false.
    ///
    /// @param pathStyleAccessEnable
    ///            True if it's enabled; False if it's disabled.
     void setPathStyleAccessEnable(bool pathStyleAccessEnable) {
        this.pathStyleAccessEnable = pathStyleAccessEnable;
    }

    /// Gets the flag of using custom path prefix to access the
    /// endpoint. By default it's false. When using custom path prefix, then the bucket endpoint
    /// would be: http://host/customPath. Otherwise, it will be http://host
    ///
    /// @return True if it's enabled; False if it's disabled.
     bool isCustomPathPrefixEnable() {
        return customPathPrefixEnable;
    }

    /// Sets the flag of using custom path prefix to access the
    /// endpoint. By default it's false.
    ///
    /// @param customPathPrefixEnable
    ///            True if it's enabled; False if it's disabled.
     void setCustomPathPrefixEnable(bool customPathPrefixEnable) {
        this.customPathPrefixEnable = customPathPrefixEnable;
    }

}
