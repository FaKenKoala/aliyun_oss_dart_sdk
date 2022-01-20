import 'async_fetch_task_configuration.dart';
import 'async_fetch_task_state.dart';
import 'generic_result.dart';

class GetAsyncFetchTaskResult extends GenericResult {
  String? taskId;
  AsyncFetchTaskState? asyncFetchTaskState;
  String? errorMsg;
  AsyncFetchTaskConfiguration? asyncFetchTaskConfiguration;
}
