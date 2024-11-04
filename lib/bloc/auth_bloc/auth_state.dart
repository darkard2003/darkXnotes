import 'package:awesome_notes/models/user_data_model.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState(
      {required this.isLoading, this.loadingText = 'Please wait...'});
}

class AuthStateLoggedIn extends AuthState {
  final String? error;
  final UserData user;
  const AuthStateLoggedIn(
      {this.error, required super.isLoading, required this.user});
}

class AuthStateNeedLogin extends AuthState with EquatableMixin {
  final String? error;
  const AuthStateNeedLogin(
      {this.error, required super.isLoading, String? loadingText})
      : super(loadingText: loadingText ?? '');

  @override
  List<Object?> get props => [error, isLoading];
}

class AuthStateNeedRegister extends AuthState with EquatableMixin {
  final String? error;
  const AuthStateNeedRegister(
      {this.error, required super.isLoading, String? loadingText})
      : super(loadingText: loadingText ?? '');

  @override
  List<Object?> get props => [error, isLoading];
}

class AuthStateNeedVerification extends AuthState with EquatableMixin {
  final String? error;
  final UserData user;
  const AuthStateNeedVerification({
    this.error,
    required super.isLoading,
    required this.user,
    String? loadingText,
  }) : super(loadingText: loadingText ?? '');

  @override
  List<Object?> get props => [error, isLoading];
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized() : super(isLoading: false);
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading() : super(isLoading: false);
}
