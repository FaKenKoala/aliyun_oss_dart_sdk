import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_dns_mini.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/oss_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/model/bucket_lifecycle_rule.dart';

import 'http_message.dart';

class RequestMessage extends HttpMessage {
  Uri? service;
  Uri? endpoint;
  String? bucketName;
  String? objectKey;
  HttpMethod? method;
  bool isAuthorizationRequired = true;
  Map<String, String> parameters = <String, String>{};
  bool checkCRC64 = false;
  OSSCredentialProvider? credentialProvider;
  bool httpDnsEnable = false;
  bool pathStyleAccessEnable = false;
  bool customPathPrefixEnable = false;
  String? ipWithHeader;
  bool isInCustomCnameExcludeList = false;

  String? uploadFilePath;
  List<int>? uploadData;
  Uri? uploadUri;

  void createBucketRequestBodyMarshall(Map<String, String>? configures) {
    StringBuffer xmlBody = StringBuffer();
    if (configures != null) {
      xmlBody.write("<CreateBucketConfiguration>");
      configures.forEach((key, value) {
        xmlBody.write("<$key>$value</$key>");
      });
      xmlBody.write("</CreateBucketConfiguration>");

      List<int> binaryData = utf8.encode(xmlBody.toString());
      int length = binaryData.length;

      InputStream inStream = ByteArrayInputStream(binaryData);
      content = inStream;
      contentLength = length;
    }
  }

  void putBucketRefererRequestBodyMarshall(
      List<String>? referers, bool allowEmpty) {
    StringBuffer xmlBody = StringBuffer();
    xmlBody.write("<RefererConfiguration>");
    xmlBody.write("<AllowEmptyReferer>" +
        (allowEmpty ? "true" : "false") +
        "</AllowEmptyReferer>");
    if (referers != null && referers.isNotEmpty) {
      xmlBody.write("<RefererList>");
      for (String referer in referers) {
        xmlBody.write("<Referer>$referer</Referer>");
      }
      xmlBody.write("</RefererList>");
    }
    xmlBody.write("</RefererConfiguration>");

    List<int> binaryData = utf8.encode(xmlBody.toString());
    int length = binaryData.length;

    InputStream inStream = ByteArrayInputStream(binaryData);
    content = inStream;
    contentLength = length;
  }

  void putBucketLoggingRequestBodyMarshall(
      String? targetBucketName, String? targetPrefix) {
    StringBuffer xmlBody = StringBuffer();
    xmlBody.write("<BucketLoggingStatus>");
    if (targetBucketName != null) {
      xmlBody.write("<LoggingEnabled><TargetBucket>" +
          targetBucketName +
          "</TargetBucket>");
      if (targetPrefix != null) {
        xmlBody.write("<TargetPrefix>" + targetPrefix + "</TargetPrefix>");
      }
      xmlBody.write("</LoggingEnabled>");
    }

    xmlBody.write("</BucketLoggingStatus>");

    List<int> binaryData = utf8.encode(xmlBody.toString());
    int length = binaryData.length;

    InputStream inStream = ByteArrayInputStream(binaryData);
    content = inStream;
    contentLength = length;
  }

  void putBucketLifecycleRequestBodyMarshall(
      List<BucketLifecycleRule> lifecycleRules) {
    StringBuffer xmlBody = StringBuffer();
    xmlBody.write("<LifecycleConfiguration>");
    for (BucketLifecycleRule rule in lifecycleRules) {
      xmlBody.write("<Rule>");

      rule.identifier.apply((str) => xmlBody.write("<ID>$str</ID>"));

      rule.prefix.apply((str) => xmlBody.write("<Prefix>$str</Prefix>"));

      xmlBody.write(
          "<Status>" + (rule.status ? "Enabled" : "Disabled") + "</Status>");

      if (rule.days != null) {
        xmlBody.write("<Days>${rule.days}</Days>");
      } else if (rule.expireDate != null) {
        xmlBody.write("<Date>${rule.expireDate}</Date>");
      }

      if (rule.multipartDays != null) {
        xmlBody.write("<AbortMultipartUpload><Days>" +
            rule.multipartDays! +
            "</Days></AbortMultipartUpload>");
      } else if (rule.multipartExpireDate != null) {
        xmlBody.write("<AbortMultipartUpload><Date>" +
            rule.multipartExpireDate! +
            "</Date></AbortMultipartUpload>");
      }

      if (rule.iADays != null) {
        xmlBody.write("<Transition><Days>" +
            rule.iADays! +
            "</Days><StorageClass>IA</StorageClass></Transition>");
      } else if (rule.iAExpireDate != null) {
        xmlBody.write("<Transition><Date>" +
            rule.iAExpireDate! +
            "</Date><StorageClass>IA</StorageClass></Transition>");
      } else if (rule.archiveDays != null) {
        xmlBody.write("<Transition><Days>" +
            rule.archiveDays! +
            "</Days><StorageClass>Archive</StorageClass></Transition>");
      } else if (rule.archiveExpireDate != null) {
        xmlBody.write("<Transition><Date>" +
            rule.archiveExpireDate! +
            "</Date><StorageClass>Archive</StorageClass></Transition>");
      }

      xmlBody.write("</Rule>");
    }

    xmlBody.write("</LifecycleConfiguration>");

    List<int> binaryData = utf8.encode(xmlBody.toString());
    int length = binaryData.length;
    InputStream inStream = ByteArrayInputStream(binaryData);
    content = inStream;
    contentLength = length;
  }

  List<int> deleteMultipleObjectRequestBodyMarshall(
      List<String> objectKeys, bool isQuiet) {
    StringBuffer xmlBody = StringBuffer();
    xmlBody.write("<Delete>");
    if (isQuiet) {
      xmlBody.write("<Quiet>true</Quiet>");
    } else {
      xmlBody.write("<Quiet>false</Quiet>");
    }
    for (String key in objectKeys) {
      xmlBody.write("<Object>");
      xmlBody.write("<Key>$key</Key>");
      xmlBody.write("</Object>");
    }
    xmlBody.write("</Delete>");
    List<int> binaryData = utf8.encode(xmlBody.toString());
    int length = binaryData.length;
    InputStream inStream = ByteArrayInputStream(binaryData);
    content = inStream;
    contentLength = length;
    return binaryData;
  }

  String buildOSSServiceURL() {
    if (service == null) {
      OSSUtils.assertTrue(service != null, "Service haven't been set!");
      return '';
    }

    String originHost = service!.host;
    String scheme = service!.scheme;

    String? urlHost;
    if (httpDnsEnable && scheme.equalsIgnoreCase("http")) {
      urlHost = HttpdnsMini.getInstance().getIpByHostAsync(originHost);
    } else {
      OSSLog.logDebug(
          "[buildOSSServiceURL], disable httpdns or http is not need httpdns");
    }
    urlHost ??= originHost;

    headers[HttpHeaders.host] = originHost;

    String baseURL = scheme + "://" + urlHost;
    String? queryString = OSSUtils.paramToQueryString(parameters);

    if (queryString.nullOrEmpty) {
      return baseURL;
    } else {
      return "$baseURL?$queryString";
    }
  }

  String buildCanonicalURL() {
    OSSUtils.assertTrue(endpoint != null, "Endpoint haven't been set!");

    String scheme = endpoint!.scheme;
    String originHost = endpoint!.host;
    String? portString;
    String path = endpoint!.path;

    int port = endpoint!.port;
    if (port != -1) {
      portString = '$port';
    }

    if (originHost.nullOrEmpty) {
      String url = endpoint.toString();
      OSSLog.logDebug("endpoint url : " + url);
//            originHost = url.substring((scheme + "://").length(),url.length());
    }

    OSSLog.logDebug(" scheme : " + scheme);
    OSSLog.logDebug(" originHost : " + originHost);
    OSSLog.logDebug(" port : $portString");

    bool isPathStyle = false;

    String baseURL = scheme + "://" + originHost;
    if (portString.notNullOrEmpty) {
      baseURL += (":$portString");
    }

    if (bucketName.notNullOrEmpty) {
      if (OSSUtils.isOssOriginHost(originHost)) {
        // official endpoint
        originHost = "$bucketName.$originHost";
        String? urlHost;
        if (httpDnsEnable) {
          urlHost = HttpdnsMini.getInstance().getIpByHostAsync(originHost);
        } else {
          OSSLog.logDebug("[buildCannonicalURL], disable httpdns");
        }
        addHeader(HttpHeaders.host, originHost);

        if (urlHost.notNullOrEmpty) {
          baseURL = scheme + "://$urlHost";
        } else {
          baseURL = scheme + "://" + originHost;
        }
      } else if (isInCustomCnameExcludeList) {
        if (pathStyleAccessEnable) {
          isPathStyle = true;
        } else {
          baseURL = scheme + "://$bucketName" + "." + originHost;
        }
      } else if (OSSUtils.isValidateIP(originHost)) {
        // ip address
        if (ipWithHeader.nullOrEmpty) {
          isPathStyle = true;
        } else {
          addHeader(HttpHeaders.host, ipWithHeader!);
        }
      }
    }

    if (customPathPrefixEnable && path != null) {
      baseURL += path;
    }

    if (isPathStyle) {
      baseURL += ("/$bucketName");
    }

    if (objectKey.notNullOrEmpty) {
      baseURL += "/" + HttpUtil.urlEncode(objectKey);
    }

    String? queryString = OSSUtils.paramToQueryString(parameters);

    //输入请求信息日志
    StringBuffer printReq = StringBuffer();
    printReq.write("request---------------------\n");
    printReq.write("request url=" + baseURL + "\n");
    printReq.write("request params=$queryString\n");

    headers.forEach((key, value) {
      printReq
        ..write("requestHeader [" + key + "]: ")
        ..write(value + "\n");
    });

    OSSLog.logDebug(printReq.toString());

    if (OSSUtils.isEmptyString(queryString)) {
      return baseURL;
    } else {
      return "$baseURL?$queryString";
    }
  }
}
