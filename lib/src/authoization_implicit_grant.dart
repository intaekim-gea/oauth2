import 'dart:convert';

import 'package:http/http.dart' as http;
import 'client.dart';
import 'handle_access_token_response.dart';

// Intae, Kim - Added to support implicit grant
Future<Client> handleImplicitAuthorizationResponse(
  Map<String, String> parameters,
  Uri authorizationEndpoint,
  String? identifier,
  String? secret, {
  bool basicAuth = true,
  http.Client? httpClient,
}) async {
  final response = http.Response(
      jsonEncode({
        'access_token': parameters['access_token'],
        'token_type': 'bearer',
        'expires_in': parameters['expires_in'],
        'refresh_token': null,
      }),
      200,
      headers: {'content-type': 'application/json'});
  final credentials = handleAccessTokenResponse(
    response,
    authorizationEndpoint,
    DateTime.now(),
    ['scope'],
    ',',
  );
  return Client(credentials,
      identifier: identifier,
      secret: secret,
      basicAuth: basicAuth,
      httpClient: httpClient,
      onCredentialsRefreshed: null);
}
