import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const LinearProgressIndicator(),
            Expanded(
              child: Center(
                child: Image.asset("assets/images/logo.png",width: 100)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
