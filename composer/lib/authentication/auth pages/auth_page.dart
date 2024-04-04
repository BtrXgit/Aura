import 'login_page.dart';
import '../../home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage(
                // title: 'Aura: Lofi, Relaxing, and Sleep Music',
              );
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
