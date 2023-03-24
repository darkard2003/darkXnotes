import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/dialog/alart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final FirebaseAuth auth;
  var _showPassword = false;

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedLogin) {
          final errMsg = state.error;
          if (errMsg != null) {
            await showAlartDialog(
                title: 'Login error', content: errMsg, context: context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Login to continue...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a email' : null,
                        controller: _email,
                        decoration: const InputDecoration(
                            hintText: 'email@address.com',
                            label: Text('Email'),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Color.fromARGB(255, 169, 126, 242),
                            ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: !_showPassword,
                        validator: (value) =>
                            value!.length < 6 ? 'Password is short' : null,
                        controller: _password,
                        decoration: InputDecoration(
                          hintText: 'password',
                          label: const Text('Password'),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 169, 126, 242),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              _showPassword = !_showPassword;
                            }),
                            icon: Icon(_showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                          AuthEventLogin(email: email, password: password));
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventShowRegister());
                  },
                  child: const Text('Dont have an account? Register here...'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
