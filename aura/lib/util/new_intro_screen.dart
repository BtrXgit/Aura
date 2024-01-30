import 'package:aura/authentication/auth%20pages/auth_page.dart';
import 'package:aura/util/intro_slider_widgets.dart';
import 'package:aura/util/introduction_slider_package.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionSlider(
      items: [
        IntroductionSliderItem(
          backgroundColor: Color(0xFF131321),
          image: Image.asset("assets/whatAura.png"),
          title: Text(
            "Reasons,",
            style: GoogleFonts.cookie(color: Color(0xFFE6EDFF), fontSize: 38),
          ),
          subtitle: Text(
            "Why to choose Aura?",
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: GoogleFonts.kanit(
              color: Color(0xFFE6EDFF),
              fontSize: 18,
            ),
          ),
        ),
        IntroductionSliderItem(
          image: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/splash/splash3.jpg',
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            "Aura Composer",
            style: GoogleFonts.cookie(color: Color(0xFFE6EDFF), fontSize: 38),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              "Make custom sounds that helps to meditate, fall asleep faster, and relax mind.",
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: GoogleFonts.kanit(
                color: Color(0xFFE6EDFF),
                fontSize: 18,
              ),
            ),
          ),
          backgroundColor: Color(0xFF131321),
        ),
        IntroductionSliderItem(
          image: FlutterLogo(),
          title: Text("Title 3"),
          backgroundColor: Color(0xFF131321),
        ),
      ],
      done: Done(
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
        home: AuthPage(),
      ),
      next: Next(
          child: Icon(
        Icons.arrow_forward,
        color: Colors.white,
      )),
      back: Back(
          child: Icon(
        Icons.arrow_back,
        color: Colors.white,
      )),
      dotIndicator: DotIndicator(),
    );
  }
}
