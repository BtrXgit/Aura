import 'package:aura/meditate/utils/constants.dart';
import 'package:aura/meditate/widgets/breather_error.dart';
import 'package:aura/meditate/widgets/three_stage.dart';
import 'package:aura/meditate/widgets/two_stage.dart';
import 'package:flutter/material.dart';

class Breathing extends StatelessWidget {
  final String pattern;

  Breathing({Key? key, required this.pattern})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    StatefulWidget breather;

    switch (pattern) {
      case '7/11 Breathing':
        breather = TwoStage();
        break;
      case '4-7-8 Breathing':
        breather = ThreeStage();
        break;
      default:
        breather = TwoStage();
        break;
    }

    return Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          title: Text(
            pattern,
            style: TextStyle(color: black),
          ),
        ),
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
