import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

class Cypher {
  static final Cypher _cypher = Cypher._internal();
  factory Cypher() {
    return _cypher;
  }
  Cypher._internal();

  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));
  final _passkeykey = "passkey";
  final _iv = IV.fromLength(16);
  late Encrypter _encrypter;

  void init() async {
    var passkey = await storage.read(key: _passkeykey);
    final key = Key.fromUtf8(passkey!);
    _encrypter = Encrypter(AES(key));
  }

  Cypher.storePassword(String password) {
    storage.write(key: _passkeykey, value: password);
  }

  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: _iv).toString();
  }

  String decrypt(String so) {
    return _encrypter.decrypt(Encrypted.fromUtf8(so), iv: _iv);
  }
}
