import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/dialog/loading/loading_dialog.dart';
import 'package:awesome_notes/screens/auth_screen/ver_screen.dart';
import 'package:awesome_notes/screens/create_or_update_note/create_or_update_note.dart';
import 'package:awesome_notes/screens/auth_screen/loading_screen.dart';
import 'package:awesome_notes/screens/auth_screen/login_screen.dart';
import 'package:awesome_notes/screens/auth_screen/register_screen.dart';
import 'package:awesome_notes/screens/note_screen/note_screen.dart';
import 'package:awesome_notes/services/auth/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'darkXnotes',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: lightDynamic,
          scaffoldBackgroundColor: lightDynamic?.surface ?? Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: lightDynamic?.primary ?? Colors.blue,
          ),
          dialogBackgroundColor: lightDynamic?.surface ?? Colors.white,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: darkDynamic,
          scaffoldBackgroundColor: darkDynamic?.surface ?? Colors.grey[900],
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: darkDynamic?.primary ?? Colors.grey[800],
            foregroundColor: darkDynamic?.onPrimary ?? Colors.white,
          ),
          dialogBackgroundColor: darkDynamic?.surface ?? Colors.grey[900],
          snackBarTheme: SnackBarThemeData(
            backgroundColor: darkDynamic?.primaryContainer ?? Colors.grey[900],
            contentTextStyle: TextStyle(
              color: darkDynamic?.onPrimaryContainer ?? Colors.white,
            ),
          ),
        ),
        home: BlocProvider(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const Home(),
        ),
        routes: {
          '/update': (context) => const CreateOrUpdateNote(),
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final loading = LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          loading.show(context: context, text: state.loadingText);
        } else {
          loading.hide();
        }
      },
      builder: ((context, state) {
        if (state is AuthStateNeedLogin) {
          return const LoginScreen();
        } else if (state is AuthStateNeedRegister) {
          return const RegisterScreen();
        } else if (state is AuthStateLoggedIn) {
          final user = state.user;
          return NotesScreen(user: user);
        } else if (state is AuthStateUninitialized) {
          context.read<AuthBloc>().add(const AuthEventInitialize());
          return const LoadingScreen();
        } else if (state is AuthStateNeedVerification) {
          final user = state.user;
          return VerifyEmailScreen(
            user: user,
          );
        } else {
          return const LoadingScreen();
        }
      }),
    );
  }
}
