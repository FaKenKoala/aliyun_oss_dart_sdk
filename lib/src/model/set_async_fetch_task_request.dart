import 'async_fetch_task_configuration.dart';
import 'generic_request.dart';

class SetAsyncFetchTaskRequest extends GenericRequest {
  AsyncFetchTaskConfiguration? asyncFetchTaskConfiguration;

  SetAsyncFetchTaskRequest(String bucketName,
      [this.asyncFetchTaskConfiguration])
      : super(bucketName: bucketName);
}
