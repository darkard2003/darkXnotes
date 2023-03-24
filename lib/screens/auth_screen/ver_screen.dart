import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  final UserData user;
  const VerifyEmailScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Check your mailbox and verify your email...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthEventVerifyEmail(user: widget.user));
                },
                child: const Text('Done')),
            TextButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(AuthEventSendVerificationEmail(user: widget.user));
                },
                child: const Text('Resend email...')),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShowLogin());
                },
                child: const Text('Not your email? Back to login...'))
          ],
        ),
      ),
    );
  }
}
