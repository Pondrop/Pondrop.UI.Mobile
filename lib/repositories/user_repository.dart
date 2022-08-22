import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pondrop/models/models.dart';

class UserRepository {
  UserRepository({
    required FlutterSecureStorage secureStorage,
  })  : _secureStorage = secureStorage;

  static const _userKey = 'User';

  final FlutterSecureStorage _secureStorage;

  Future<User?> getUser() async {
    final value = await _secureStorage.read(key: _userKey);
    
    if (value?.isNotEmpty == true) {
      return User.fromJson(jsonDecode(value!));
    }

    return null;
  }

  Future<void> setUser(User user) async {
    final value = jsonEncode(user.toJson());
    await _secureStorage.write(key: _userKey, value: value);
  }

  Future<void> clearUser() async {
    await _secureStorage.delete(key: _userKey);
  }
}
