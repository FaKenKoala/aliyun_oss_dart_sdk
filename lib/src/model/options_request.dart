import '../http_method.dart';
import 'generic_request.dart';

class OptionsRequest extends GenericRequest {
  String? origin;
  HttpMethod? requestMethod;
  String? requestHeaders;

  OptionsRequest([String? bucketName, String? key])
      : super(bucketName: bucketName, key: key);
}
