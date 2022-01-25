 import 'dart:math';

import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

import 'oss_retry_type.dart';

class OSSRetryHandler {

     int maxRetryCount = 2;

     OSSRetryHandler(int maxRetryCount) {
        setMaxRetryCount(maxRetryCount);
    }

     void setMaxRetryCount(int maxRetryCount) {
        this.maxRetryCount = maxRetryCount;
    }

/// TODO:与异常类型有关，需要重点重写
     OSSRetryType shouldRetry(Exception e, int currentRetryCount) {
        if (currentRetryCount >= maxRetryCount) {
            return OSSRetryType.OSSRetryTypeShouldNotRetry;
        }

        if (e is OSSClientException) {
            if (e.isCanceledException()) {
                return OSSRetryType.OSSRetryTypeShouldNotRetry;
            }

            Exception localException = (Exception) e.getCause();
            if (localException is InterruptedOSSIOException
                    && (localException is! SocketTimeoutException)) {
                OSSLog.logError("[shouldRetry] - is interrupted!");
                return OSSRetryType.OSSRetryTypeShouldNotRetry;
            } else if (localException is ArgumentError) {
                return OSSRetryType.OSSRetryTypeShouldNotRetry;
            }
            OSSLog.logDebug("shouldRetry - " + e.toString());
            return OSSRetryType.OSSRetryTypeShouldRetry;
        } else if (e is OSSServiceException) {
            if (e.errorCode.equalsIgnoreCase("RequestTimeTooSkewed")) {
                return OSSRetryType.OSSRetryTypeShouldFixedTimeSkewedAndRetry;
            } else if (e.statusCode >= 500) {
                return OSSRetryType.OSSRetryTypeShouldRetry;
            } else {
                return OSSRetryType.OSSRetryTypeShouldNotRetry;
            }
        } else {
            return OSSRetryType.OSSRetryTypeShouldNotRetry;
        }
    }

     int timeInterval(int currentRetryCount, OSSRetryType retryType) {
        switch (retryType) {
            case OSSRetryType.OSSRetryTypeShouldRetry:
                return (pow(2, currentRetryCount) * 200).toInt();
            default:
                return 0;
        }
    }
}
