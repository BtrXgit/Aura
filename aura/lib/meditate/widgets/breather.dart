import 'package:aura/meditate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Breather extends StatelessWidget {
  final AnimationController breathingController;
  final String action;
  final String time;

  const Breather(
      {Key? key,
      required this.breathingController,
      required this.action,
      required this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 210.0 + 70 * breathingController.value,
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
              greenAccent,
              greenAccent,
              greenAccent,
              greenAccent,
              Color(0xff131321),
            ]),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          height: 160.0 + 50 * breathingController.value,
          decoration: BoxDecoration(
            color: greenAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                action,
                style: GoogleFonts.dancingScript(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.dancingScript(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )),
        ),
      ],
    );
  }
}
