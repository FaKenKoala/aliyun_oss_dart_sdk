import 'generic_request.dart';

class GetAsyncFetchTaskRequest extends GenericRequest {
  String? taskId;

  GetAsyncFetchTaskRequest(String bucketName, [this.taskId])
      : super(bucketName: bucketName);
}
