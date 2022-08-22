import 'dart:async';

import 'package:pondrop/api/auth_api.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({AuthApi? authApi})
      : _authApi = authApi ?? AuthApi();

  final AuthApi _authApi;
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final accessToken = await _authApi.signIn(email: email, password: password);

    if (accessToken.isNotEmpty) {
      _controller.add(AuthenticationStatus.authenticated);
    }

    return accessToken;
  }

  Future<void> signOut(String accessToken) async {
    await _authApi.signOut(accessToken);
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
