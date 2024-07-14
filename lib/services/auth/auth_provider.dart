import 'package:awesome_notes/models/user_data_model.dart';

abstract class AppAuthProvider {
  Future<UserData?> get user;

  Future<String> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserData> registerWithEmail({
    required String email,
    required String password,
    String name = '',
  });

  Future<void> sendVerificationEmail();

  Future<void> logOut();

  Future<UserData?> refreshUser(UserData user);

  Future<void> sendEmailVerification(UserData user);
}
