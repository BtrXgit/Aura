import 'package:aura/meditate/widgets/breather_error.dart';
import 'package:aura/meditate/widgets/two_stage.dart';
import 'package:flutter/material.dart';

class Breathing extends StatelessWidget {
  final String pattern;

  Breathing({Key? key, required this.pattern}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StatefulWidget breather;

    switch (pattern) {
      case '7/11 Breathing':
        breather = TwoStage();
        break;
      case '4-7-8 Breathing':
        breather = TwoStage();
        break;
      default:
        breather = TwoStage();
        break;
    }

    return Scaffold(
        backgroundColor: Color(0xff131321),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    breather != null ? breather : BreatherError(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
