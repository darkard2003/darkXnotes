import 'package:awesome_notes/models/user_data_model.dart';
import 'package:awesome_notes/services/encryption/cypher.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogin({
    required this.email,
    required this.password,
  });
}

class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  const AuthEventRegister({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
  });
}

class AuthEventShowLogin extends AuthEvent {
  const AuthEventShowLogin();
}

class AuthEventShowRegister extends AuthEvent {
  const AuthEventShowRegister();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventVerifyEmail extends AuthEvent {
  final UserData user;
  const AuthEventVerifyEmail({required this.user});
}

class AuthEventSendVerificationEmail extends AuthEvent {
  final UserData user;
  const AuthEventSendVerificationEmail({required this.user});
}
