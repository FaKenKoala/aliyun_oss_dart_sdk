import 'package:aliyun_oss_dart_sdk/src/callback/oss_completed_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/callback/oss_progress_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/callback/oss_retry_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_result.dart';
import 'cancellation_handler.dart';

class ExecutionContext<Request extends OSSRequest, Result extends OSSResult> {
  Request request;
  final CancellationHandler _cancellationHandler = CancellationHandler();

  OSSCompletedCallback? completedCallback;
  OSSProgressCallback? progressCallback;
  OSSRetryCallback? retryCallback;
  

  ExecutionContext(this.request);

  CancellationHandler get cancellationHandler {
    return _cancellationHandler;
  }
}
