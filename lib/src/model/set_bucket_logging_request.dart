import 'generic_request.dart';

class SetBucketLoggingRequest extends GenericRequest {
  /// Value can be null when user want to close bucket logging functionality.
  String? targetBucket;

  String? targetPrefix;

  SetBucketLoggingRequest(String bucketName) : super(bucketName: bucketName);
}
