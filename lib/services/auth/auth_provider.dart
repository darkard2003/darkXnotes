import 'package:awesome_notes/models/user_data_model.dart';
abstract class AuthProvider {
  Future<UserData?> get user;

  Future<UserData> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserData> registerWithEmail({
    required String email,
    required String password,
  });

  Future<void> sendVerificationEmail();

  Future<void> logOut();
}
