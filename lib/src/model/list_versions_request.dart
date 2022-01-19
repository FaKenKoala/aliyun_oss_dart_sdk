import 'generic_request.dart';

class ListVersionsRequest extends GenericRequest {
  ListVersionsRequest({
    String? bucketName,
    this.prefix,
    this.keyMarker,
    this.versionIdMarker,
    this.delimiter,
    this.maxResults,
  }) : super(bucketName: bucketName);

  String? prefix;

  String? keyMarker;

  String? versionIdMarker;

  String? delimiter;

  int? maxResults;

  String? encodingType;
}
