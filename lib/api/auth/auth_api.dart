import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  AuthApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _authority = 'auth-service.purpleisland-ecf19528.australiaeast.azurecontainerapps.io';
  static const Map<String, String> _requestHeaders = {
    'Content-type': 'application/json',
  };

  final http.Client _httpClient;
 
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final resp = await http.post(
      Uri.https(_authority, '/Auth/shopper/signin'),
      headers: _requestHeaders,
      body: jsonEncode(<String, String>{
        'email' : email
      }));
   
    final decodedBody = jsonDecode(resp.body);
    final accessToken = decodedBody['accessToken'] as String? ?? '';

    return accessToken;
  }

  Future<void> signOut(String accessToken) {
    return http.post(
      Uri.https(_authority, '/Auth/shopper/signout'),
      headers: { 'Authorization' : 'Bearer $accessToken' });
  }
}
