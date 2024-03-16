import 'package:aura/lib/utils.dart';
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
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 230.0 + 80 * breathingController.value,
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
                  HexColor('#76E2FF').withOpacity(0.5),
                  HexColor('#4E09ED').withOpacity(0.5),
                  HexColor('#F7E4FF').withOpacity(0.3),
                ]),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: 180.0 + 60 * breathingController.value,
              decoration: BoxDecoration(
                color: HexColor('#000000').withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Text(
                time,
                style: GoogleFonts.kanit(
                  fontSize: 24, color: Color(0xff131321),
                  // fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          action,
          style: GoogleFonts.kanit(
            fontSize: 24,
            color: Color(0xff131321),
            // fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
