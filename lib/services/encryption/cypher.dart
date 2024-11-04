import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class Cypher {
  static final Cypher _cypher = Cypher._internal();
  factory Cypher() {
    return _cypher;
  }
  Cypher._internal();

  late Encrypter _encrypter;
  bool _isInitialized = false;

  Future<void> init(String passkey) async {
    final key = Key.fromUtf8(passkey);
    _encrypter = Encrypter(AES(key));
    _isInitialized = true;
  }

  bool get isReady => _isInitialized;

  static String generatePassword(String password) {
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters long');
    }
    final salt = base64Encode(utf8.encode(password.split('').reversed.join()));
    var key = deriveKey(password, salt);
    return key;
  }

  static String deriveKey(String password, String salt) {
    var combo = password + salt;
    return combo.length > 32
        ? combo.substring(0, 32)
        : combo.padRight(32, salt);
  }

  String encrypt(String text) {
    if (!_isInitialized) {
      throw Exception('Cypher not initialized. Call init() first.');
    }
    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(text, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  String decrypt(String encrypted) {
    if (!_isInitialized) {
      throw Exception('Cypher not initialized. Call init() first.');
    }
    try {
      final parts = encrypted.split(':');
      if (parts.length != 2) throw Exception('Invalid encrypted data format');

      final iv = IV.fromBase64(parts[0]);
      return _encrypter.decrypt(Encrypted.fromBase64(parts[1]), iv: iv);
    } catch (e) {
      throw Exception('Failed to decrypt: Invalid data or wrong key');
    }
  }
}
