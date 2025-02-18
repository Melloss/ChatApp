import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Settings {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'token_key';
  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  static Future<String?> getToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }
}
