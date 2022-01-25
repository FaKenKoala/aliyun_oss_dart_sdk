
 import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';

import 'oss_federation_credential_provider.dart';
import 'oss_federation_token.dart';
import 'package:http/http.dart' as http;
class OSSAuthCredentialProvider extends OSSFederationCredentialProvider {

     String authServerUrl;
     AuthDecoder? decoder;

     OSSAuthCredentialProvider(this.authServerUrl);

    @override
     Future<OSSFederationToken> getFederationToken()  async{
        OSSFederationToken authToken;
        String authData;
        try {
      Uri stsUrl = Uri.parse(authServerUrl);

      http.Response response = await http.get(stsUrl);
      authData = response.body;
      if (decoder != null) {
        authData = decoder!.decode(authData);
      }

      final map = jsonDecode(authData) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        authToken = OSSFederationToken.fromJson(map);
      } else {
        String errorCode = map["ErrorCode"];
        String errorMessage = map["ErrorMessage"];
        throw OSSClientException(
            "ErrorCode: " + errorCode + "| ErrorMessage: " + errorMessage);
      }
      return authToken;
    } catch (e) {
      throw OSSClientException(e);
    }
    }

     
}

abstract class AuthDecoder {
        String decode(String data);
    }