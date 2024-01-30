import 'package:aura/authentication/auth%20pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:metaballs/dart_ui_real.dart';

class AuraOnboarding extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      titleTextStyle: TextStyle(color: Color(0xFFE6EDFF), fontSize: 24),
      subTitleTextStyle: TextStyle(
        color: Color(0xFFE6EDFF),
        fontSize: 20,
      ),
      title: 'Buy & Sell',
      subTitle: 'Browse the menu and order directly from the application',
      imageUrl: 'assets/splash/splash.jpg',
    ),
    Introduction(
      titleTextStyle:
          GoogleFonts.cookie(color: Color(0xFFE6EDFF), fontSize: 38),
      subTitleTextStyle: GoogleFonts.kanit(
        color: Color(0xFFE6EDFF),
        fontSize: 18,
      ),
      title: 'Reasons, ',
      subTitle: 'Why to choose Aura?',
      imageUrl: 'assets/whatAura.png',
    ),
    Introduction(
      titleTextStyle:
          GoogleFonts.cookie(color: Color(0xFFE6EDFF), fontSize: 38),
      subTitleTextStyle: GoogleFonts.kanit(
        color: Color(0xFFE6EDFF),
        fontSize: 18,
      ),
      title: 'Aura Composer',
      subTitle:
          'Make custom sounds that helps to meditate, fall asleep faster, and relax mind',
      imageUrl: 'assets/splash/splash3.jpg',
      imageHeight: 300,
      imageWidth: 300,
    ),
    Introduction(
      titleTextStyle:
          GoogleFonts.cookie(color: Color(0xFFE6EDFF), fontSize: 38),
      subTitleTextStyle: GoogleFonts.kanit(
        color: Color(0xFFE6EDFF),
        fontSize: 18,
      ),
      title: 'Aura',
      subTitle:
          'The app that calms your restless mind and improves sleep quality',
      imageUrl: 'assets/splash/splash4.jpg',
      imageHeight: 300,
      imageWidth: 300,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Color(0xFF131321),
      skipTextStyle: TextStyle(color: Color(0xFFE6EDFF), fontSize: 18),
      foregroundColor: Color(0xFFE6EDFF),
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(),
          ), //MaterialPageRoute
        );
      },
    );
  }
}
