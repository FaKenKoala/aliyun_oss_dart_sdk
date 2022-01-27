import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/lib_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_result.dart';
import 'package:aliyun_oss_dart_sdk/src/network/lib_network.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

class OSSAsyncTask<T extends OSSResult> {
  Future<T> future;

  /// TODO:使用dio的CancelToken替代
  ExecutionContext? context;

  bool _canceled = false;
  bool _isCompleted = false;

  OSSAsyncTask._(this.future, this.context) {
    future.whenComplete(() {
      _isCompleted = true;
    });
  }

  static OSSAsyncTask<T> wrapRequestTask<T extends OSSResult>(
      Future<T> future, ExecutionContext context) {
    OSSAsyncTask<T> asynTask = OSSAsyncTask._(future, context);
    return asynTask;
  }

  /// Cancel the task
  void cancel() {
    _canceled = true;
      context?.cancellationHandler.cancel();
  }

  /// Checks if the task is complete
  bool isCompleted() => _isCompleted;

  /// Waits and gets the result.
  Future<T> getResult() async {
    try {
      T result = await future;
      return result;
    } on InterruptedException catch (e) {
      throw OSSClientException(
          " InterruptedException and message : $e");
    } catch (e) {
      if (e is OSSClientException || e is OSSServiceException) {
        rethrow;
      } else {
        throw OSSClientException("Unexpected exception! $e");
      }
    }
  }

  /// Waits until the task is finished
  void waitUntilFinished() async {
    try {
      await future;
    } catch (ignore) {
      ///
    }
  }

  /// Gets the flag if the task has been canceled.
  bool isCanceled() => _canceled;
}
