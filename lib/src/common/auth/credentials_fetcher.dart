import 'credentials.dart';

abstract class CredentialsFetcher {
  Uri buildUrl();

  HttpResponse send(HttpRequest request);

  Credentials parse(HttpResponse response);

  Credentials fetch([int retryTimes = 0]);
}
