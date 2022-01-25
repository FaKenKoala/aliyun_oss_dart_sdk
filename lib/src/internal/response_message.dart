import 'package:http/http.dart';

import 'http_message.dart';
import 'request_message.dart';

class ResponseMessage extends HttpMessage {
  Response? response;
  RequestMessage? request;
  int statusCode = 0;

}
