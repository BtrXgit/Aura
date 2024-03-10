import 'package:aura/meditate/utils/constants.dart';
import 'package:flutter/material.dart';

class Breather extends StatelessWidget {
  final AnimationController breathingController;
  final String action;

  const Breather({Key? key, required this.breathingController, required this.action}) : super(key: key);
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
              Colors.black,
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
          child: Center(child: Text(action)),
        ),
      ],
    );
  }
}