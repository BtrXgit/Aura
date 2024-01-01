import 'dart:ui';

import 'package:aura/authentication/services/auth_service.dart';
import 'package:aura/component/square_tile.dart';
import 'package:aura/routes/pages/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Future<void> _signInAnonymously() async {
  //   try {
  //     await FirebaseAuth.instance.signInAnonymously();
  //   } catch (e) {
  //     print('Error signing in anonymously: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131321),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 20),
                  // SizedBox(
                  //   height: 150,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(6),
                  //     child: Image.asset('assets/luca.png'),
                  //   ),
                  // ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage('assets/icons/square.png'),
                          fit: BoxFit.cover),
                      border: Border.all(
                          width: 4.0,
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(38.0),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Aura',
                      style: TextStyle(
                        fontFamily: 'Anurati',
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      ('"Step into a World of Wall Artistry: \n       Your Screens, Our Canvas!"'),
                      style:
                          GoogleFonts.kanit(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'assets/google.png',
                        text: 'Continue with Google',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'By Continuing, you agree with Aura',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.to(const PrivacyPage()),
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xFFE6EDFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
