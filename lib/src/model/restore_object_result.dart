import 'generic_result.dart';

/// Successful response of restore object operation.
class RestoreObjectResult extends GenericResult {
  RestoreObjectResult(this.statusCode);

  int statusCode;
  String? versionId;
}
