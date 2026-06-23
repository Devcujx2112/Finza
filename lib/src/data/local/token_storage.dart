// ignore_for_file: deprecated_member_use

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String refreshToken);

  Future<void> saveEmail(String email);
  Future<String?> getEmail();
  Future<void> savePassword(String password);
  Future<String?> getPassword();
  Future<void> saveRememberPassword(bool rememberPassword);
  Future<bool?> getRememberPassword();

  Future<void> clearTokens();
}

class SecureTokenStorage implements TokenStorage {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _emailKey = 'email';
  static const _passwordKey = 'password';
  static const _rememberPasswordKey = 'remember_password';
  final FlutterSecureStorage _storage;

  static final SecureTokenStorage instance = SecureTokenStorage._internal();

  SecureTokenStorage._internal()
    : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );
  factory SecureTokenStorage() => instance;

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  @override
  Future<String?> getAccessToken() => _storage.read(key: _accessKey);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  @override
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessKey, value: token);

  @override
  Future<void> saveRefreshToken(String refreshToken) =>
      _storage.write(key: _refreshKey, value: refreshToken);

  @override
  Future<void> saveEmail(String email) =>
      _storage.write(key: _emailKey, value: email);

  @override
  Future<String?> getEmail() => _storage.read(key: _emailKey);

  @override
  Future<void> savePassword(String password) =>
      _storage.write(key: _passwordKey, value: password);

  @override
  Future<String?> getPassword() => _storage.read(key: _passwordKey);

  @override
  Future<void> saveRememberPassword(bool rememberPassword) => _storage.write(
    key: _rememberPasswordKey,
    value: rememberPassword.toString(),
  );

  @override
  Future<bool?> getRememberPassword() =>
      _storage.read(key: _rememberPasswordKey).then((value) => value == "true");
}
