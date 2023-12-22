import 'package:awesome_notes/bloc/auth_bloc/auth_event.dart';
import 'package:awesome_notes/bloc/auth_bloc/auth_state.dart';
import 'package:awesome_notes/services/auth/auth_exp.dart';
import 'package:awesome_notes/services/auth/firebase_auth_provider.dart';
import 'package:awesome_notes/services/cloud_database/cloud_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
export 'package:awesome_notes/bloc/auth_bloc/auth_event.dart';
export 'package:awesome_notes/bloc/auth_bloc/auth_state.dart';
export 'package:awesome_notes/services/auth/auth_exp.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(FirebaseAuthProvider provider)
      : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialise();
        final user = await provider.user;
        if (user == null) {
          emit(const AuthStateNeedLogin(isLoading: false));
        } else if (!user.isVerified) {
          emit(AuthStateNeedVerification(isLoading: false, user: user));
        } else {
          emit(AuthStateLoggedIn(isLoading: false, user: user));
        }
      },
    );

    on<AuthEventLogin>(
      (event, emit) async {
        try {
          emit(const AuthStateNeedLogin(
              isLoading: true,
              loadingText: 'Please wait while we log you in...'));

          final email = event.email;
          final password = event.password;
          final user =
              await provider.loginWithEmail(email: email, password: password);

          if (user.isVerified) {
            emit(AuthStateLoggedIn(isLoading: false, user: user));
          } else {
            emit(AuthStateNeedVerification(isLoading: false, user: user));
          }
        } on AuthExp catch (exp) {
          emit(AuthStateNeedLogin(error: exp.message, isLoading: false));
        }
      },
    );

    on<AuthEventRegister>((event, emit) async {
      try {
        emit(const AuthStateNeedRegister(
            isLoading: true,
            loadingText: 'Please wait while we register you...'));

        final email = event.email;
        final password = event.password;
        final confirmPassword = event.confirmPassword;
        final name = event.name;

        if (password == confirmPassword) {
          try {
            final user = await provider.registerWithEmail(
                email: email, password: password);
            user.name = name;

            user.sendEmailVerification();

            await CloudDatabase.currentUser().addUserData(user);

            emit(AuthStateNeedVerification(isLoading: false, user: user));
          } on Exception catch (exp) {
            emit(
                AuthStateNeedRegister(error: exp.toString(), isLoading: false));
          }
        } else {
          emit(const AuthStateNeedRegister(
              isLoading: false, error: 'Passwords do not match'));
        }
      } on AuthExp catch (exp) {
        emit(AuthStateNeedRegister(error: exp.message, isLoading: false));
      }
    });

    on<AuthEventShowLogin>(
      (event, emit) {
        emit(const AuthStateNeedLogin(isLoading: false));
      },
    );

    on<AuthEventShowRegister>(
      (event, emit) {
        emit(const AuthStateNeedRegister(isLoading: false));
      },
    );

    on<AuthEventLogout>(
      (event, emit) async {
        await provider.logOut();
        emit(const AuthStateNeedLogin(isLoading: false));
      },
    );

    on<AuthEventVerifyEmail>(
      (event, emit) async {
        final user = event.user;
        emit(
          AuthStateNeedVerification(
            isLoading: true,
            loadingText: 'Please wait while we verify you...',
            user: user,
          ),
        );
        await user.reload();
        if (user.isVerified) {
          await CloudDatabase.currentUser().updateUserData(user);
          emit(AuthStateLoggedIn(isLoading: false, user: user));
        } else {
          emit(AuthStateNeedVerification(isLoading: false, user: user));
        }
      },
    );

    on<AuthEventSendVerificationEmail>(
      (event, emit) {
        final user = event.user;
        user.sendEmailVerification();
      },
    );
  }
}
