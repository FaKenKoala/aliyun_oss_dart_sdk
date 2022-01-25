 import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';

 final String _tag = "HttpDnsMini";
      final String _serverIP = "203.107.1.1";
      final String _accountID = "181345";
      final int _maxThreadNum = 5;
      final int _resolveTimeoutInSec = 10;
      final int _maxHoldHostNum = 100;
      final int _emptyResultHostTtl = 30;
class HttpdnsMini {


     
     static HttpdnsMini? _instance;
     Map<String, HostObject> hostManager = <String, HostObject>{};
    //  ExecutorService pool = Executors.newFixedThreadPool(_maxThreadNum);

     static HttpdnsMini getInstance() {
        if (_instance == null) {
                    _instance = HttpdnsMini();
        }
        return _instance!;
    }

     String? getIpByHostAsync(String hostName) {
        HostObject? host = hostManager[hostName];
        if (host == null || host.isExpired()) {
            OSSLog.logDebug("[httpdnsmini] - refresh host: " + hostName);
            pool.submit(QueryHostTask(hostName));
        }
        if (host != null) {
            return (host.isStillAvailable() ? host.ip : null);
        }
        return null;
    }
 }

    class HostObject {

         String hostName = '';
         String? ip ;
         int ttl = 0;
         int queryTime = 0;

        @override
         String toString() {
            return "[hostName=$hostName, ip=$ip, ttl=$ttl, queryTime=$queryTime]";
        }

         bool isExpired() {
            return queryTime + ttl < DateUtil.currentTimeSecond;
        }

        // 一个域名解析结果过期后，异步接口仍然可以返回这个结果，但最多可以容忍过期10分钟
         bool isStillAvailable() {
            return queryTime + ttl + 10 * 60 > DateUtil.currentTimeSecond;
        }

    
 }

    class QueryHostTask implements Callable<String> {
         String hostName;
         bool hasRetryed = false;

         QueryHostTask(this.hostName);

        @override
         String call() {
            String chooseServerAddress = _serverIP;
            String resolveUrl = "https://" + chooseServerAddress + "/" + _accountID + "/d?host=" + hostName;
            InputStream inStream = null;
            OSSLog.logDebug("[httpdnsmini] - buildUrl: " + resolveUrl);
            try {
                HttpURLConnection conn = (HttpURLConnection) URL(resolveUrl).openConnection();
                conn.setConnectTimeout(_resolveTimeoutInSec* 1000);
                conn.setReadTimeout(_resolveTimeoutInSec * 1000);
                if (conn.getResponseCode() != 200) {
                    OSSLog.logError("[httpdnsmini] - responseCodeNot 200, but: " + conn.getResponseCode());
                } else {
                    inStream = conn.getInputStream();
                    BufferedReader streamReader = BufferedReader(InputStreamReader(inStream, "UTF-8"));
                    StringBuffer sb = StringBuffer();
                    String line;
                    while ((line = streamReader.readLine()) != null) {
                        sb.write(line);
                    }
                    JSONObject json = JSONObject(sb.toString());
                    String? host = json.getString("host");
                    int ttl = json.getint("ttl");
                    JSONArray ips = json.getJSONArray("ips");
                    OSSLog.logDebug("[httpdnsmini] - ips:" + ips.toString());
                    if (host != null && ips != null && ips.length() > 0) {
                        if (ttl == 0) {
                            // 如果有结果返回，但是ip列表为空，ttl也为空，那默认没有ip就是解析结果，并设置ttl为一个较长的时间
                            // 避免一直请求同一个ip冲击sever
                            ttl = _emptyResultHostTtl;
                        }
                        HostObject hostObject = HostObject();
                        String? ip = (ips == null) ? null : ips.getString(0);
                        hostObject..hostName = host
                        ..ttl =ttl
                        ..ip = ip
                        ..queryTime = DateUtil.currentTimeSecond;
                        OSSLog.logDebug("[httpdnsmini] - resolve result:" + hostObject.toString());
                        if (hostManager.size() < _maxHoldHostNum) {
                            hostManager[hostName] = hostObject;
                        }
                        return ip;
                    }
                }
            } catch ( e) {
                if (OSSLog.isEnableLog()) {
                    OSSLog.logThrowable2Local(e);
                }
            } finally {
                try {
                    if (inStream != null) {
                        inStream.close();
                    }
                } catch ( e) {
                }
            }
            if (!hasRetryed) {
                hasRetryed = true;
                return call();
            }
            return null;
        }
    }