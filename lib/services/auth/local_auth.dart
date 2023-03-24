import 'package:local_auth/local_auth.dart';

class LocalAuth {
  LocalAuth._getInstance();
  static final _shared = LocalAuth._getInstance();
  factory LocalAuth() => _shared;

  final localAuth = LocalAuthentication();

  Future<bool> isSupported() async {
    return await localAuth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    final result = await localAuth.authenticate(
      localizedReason: 'Please authenticate to access your notes',
    );
    return result;
  }
}
