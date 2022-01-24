
import 'dart:io';

import '../../client_exception.dart';
import 'credentials.dart';
import 'credentials_fetcher.dart';

 abstract class HttpCredentialsFetcher implements CredentialsFetcher {

    @override
     HttpResponse send(HttpRequest request) {

        HttpResponse response;
        try {
            response = CompatibleUrlConnClient.compatibleGetResponse(request);
        } catch ( e) {
            throw IOException(e);
        }

        if (response.statusCode != HttpStatus.ok) {
            throw IOException("HttpCode=" + response.statusCode);
        }
        return response;
    }

    @override
     Credentials fetch([int retryTimes = 0])  {
        for (int i = 0; i <= retryTimes; i++) {
            try {
                Uri url = buildUrl();
        HttpRequest request = HttpRequest(url.toString());
        request.setSysMethod(MethodType.GET);
        request.setSysConnectTimeout(AuthUtils.DEFAULT_HTTP_SOCKET_TIMEOUT_IN_MILLISECONDS);
        request.setSysReadTimeout(AuthUtils.DEFAULT_HTTP_SOCKET_TIMEOUT_IN_MILLISECONDS);
        
        HttpResponse response;
        try {
            response = send(request);
        } catch ( e) {
            throw ClientException("CredentialsFetcher.fetch exception: $e");
        }
        
        return parse(response);
            } catch ( e) {
                if (i == retryTimes) {
                    rethrow;
                }
            }
        }
        throw ClientException("Failed to connect ECS Metadata Service: Max retry times exceeded.");
    }

}
