import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/dialog/alart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late final TextEditingController _name;
  late final FirebaseAuth auth;
  var _showPassword = false;
  var _showConfirmPassword = false;

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _name = TextEditingController();
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
        if (state is AuthStateNeedRegister) {
          final errMsg = state.error;
          if (errMsg != null) {
            await showAlartDialog(
                title: 'Register error', content: errMsg, context: context);
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(
                height: 150,
              ),
              const Text(
                'Register to continue...',
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
                        controller: _name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 169, 126, 242),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a email' : null,
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'email@address.com',
                        label: const Text('Email'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 169, 126, 242),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      scrollPadding: const EdgeInsets.all(10),
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
                      obscureText: !_showPassword,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value != _password.text ? 'Password not match' : null,
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        hintText: 'confirm password',
                        label: const Text('Confirm password'),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 169, 126, 242),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          }),
                          icon: Icon(_showConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      obscureText: !_showConfirmPassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = _email.text;
                    final password = _password.text;
                    final comfirmPassword = _confirmPassword.text;
                    final name = _name.text;
                    if (password == comfirmPassword) {
                      BlocProvider.of<AuthBloc>(context).add(
                        AuthEventRegister(
                          email: email,
                          password: password,
                          confirmPassword: comfirmPassword,
                          name: name,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShowLogin());
                },
                child: const Text('Already have an account? Login here...'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
