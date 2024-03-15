import 'dart:async';
import 'package:aura/authentication/auth%20pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 2),
      () {
        Get.off(AuthPage(), transition: Transition.rightToLeftWithFade);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Aura',
      style: GoogleFonts.cookie(
        fontWeight: FontWeight.w400,
        fontSize: 100,
        color: Colors.white,
        height: 0.9,
        // letterSpacing: -5,
      ),
    );
    title = title.animate(adapter: ValueAdapter(0.5)).shimmer(
      colors: [
        const Color(0xFFFFFF00),
        const Color(0xFF00FF00),
        const Color(0xFF00FFFF),
        const Color(0xFF0033FF),
        const Color(0xFFFF00FF),
        const Color(0xFFFF0000),
        const Color(0xFFFFFF00),
      ],
    );

    title = title
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .saturate(
            delay: NumDurationExtensions(1).seconds,
            duration: NumDurationExtensions(2).seconds)
        .then()
        .tint(color: const Color(0xFF80DDFF))
        .then()
        .blurXY(end: 24)
        .fadeOut();
    return Scaffold(
      backgroundColor: Color(131321),
      body: AnimationLimiter(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash/splash8.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: title,
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.headphone,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  AnimationConfiguration.synchronized(
                    child: ScaleAnimation(
                      delay: Duration(milliseconds: 500),
                      child: Text(
                        'Better with headphones.',
                        style: GoogleFonts.kanit(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
