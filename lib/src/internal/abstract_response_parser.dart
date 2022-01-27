import 'dart:collection';

import 'package:http/http.dart';

import 'package:aliyun_oss_dart_sdk/src/common/oss_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/oss_ioexception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_result.dart';

abstract class AbstractResponseParser<T extends OSSResult>
    implements ResponseParser<T> {
  //关闭okhttp响应链接
  static void safeCloseResponse(ResponseMessage response) {
    try {
      response.close();
    } catch (e) {
      /// ignored
    }
  }

  /// 数据解析，子类需要复写自己的具体实现
  T parseData(ResponseMessage response, T result);

  bool needCloseResponse() {
    return true;
  }

  @override
  T parse(ResponseMessage response) {
    try {
      var result = OSSResult();
      result.requestId = response.headers[OSSHeaders.ossHeaderRequestId];
      result.statusCode = response.statusCode;
      result.responseHeader = parseResponseHeader(response.response!);
      setCRC(result, response);
      result = parseData(response, result as T);
      return result;
    } catch (e) {
      OSSIOException ioException = OSSIOException(e);
      // e.printStackTrace();
      OSSLog.logThrowable2Local(e);
      throw ioException;
    } finally {
      if (needCloseResponse()) {
        safeCloseResponse(response);
      }
    }
  }

  //处理返回信息的信息头
  Map<String, String> parseResponseHeader(Response response) {
    Map<String, String> result = LinkedHashMap<String, String>(
      equals: (p0, p1) => p0.equalsIgnoreCase(p1),
    );
    result.addAll(response.headers);
    return result;
  }

  void setCRC<Result extends OSSResult>(
      Result result, ResponseMessage response) {
    InputStream? inputStream = response.request?.content;
    if (inputStream != null && inputStream is CheckedInputStream) {
      result.clientCRC = inputStream.checksum.value;
    }

    result.serverCRC = response.headers[OSSHeaders.ossHashCrc64Ecma];
  }
}
