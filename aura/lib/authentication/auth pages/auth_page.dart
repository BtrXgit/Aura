import 'package:aura/authentication/auth%20pages/login_page.dart';
import 'package:aura/routes/homepage/morning.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  final ScrollController controller;
  const AuthPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AuraHomePageMorning(
                controller: controller,
                // title: '',
              );
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
