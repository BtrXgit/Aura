import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

class ColorsEffectPair {
  final List<Color> colors;
  final MetaballsEffect? effect;
  final String name;

  ColorsEffectPair({
    required this.colors,
    required this.name,
    required this.effect,
  });
}

List<ColorsEffectPair> colorsAndEffects = [
  ColorsEffectPair(colors: [
    const Color.fromARGB(255, 255, 21, 0),
    const Color.fromARGB(255, 255, 153, 0),
  ], effect: MetaballsEffect.follow(), name: 'FOLLOW'),
  ColorsEffectPair(colors: [
    const Color.fromARGB(255, 0, 255, 106),
    const Color.fromARGB(255, 255, 251, 0),
  ], effect: MetaballsEffect.grow(), name: 'GROW'),
  ColorsEffectPair(colors: [
    const Color.fromARGB(255, 90, 60, 255),
    const Color.fromARGB(255, 120, 255, 255),
  ], effect: MetaballsEffect.speedup(), name: 'SPEEDUP'),
  ColorsEffectPair(colors: [
    const Color.fromARGB(255, 255, 60, 120),
    const Color.fromARGB(255, 237, 120, 255),
  ], effect: MetaballsEffect.ripple(), name: 'RIPPLE'),
  ColorsEffectPair(colors: [
    const Color.fromARGB(255, 120, 217, 255),
    const Color.fromARGB(255, 255, 234, 214),
  ], effect: null, name: 'NONE'),
];

class GlowingBalls extends StatefulWidget {
  const GlowingBalls({Key? key}) : super(key: key);

  @override
  State<GlowingBalls> createState() => _GlowingBallsState();
}

class _GlowingBallsState extends State<GlowingBalls> {
  int colorEffectIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Material(
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            colorEffectIndex = (colorEffectIndex + 1) % colorsAndEffects.length;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
              gradient: RadialGradient(
                  center: Alignment.bottomCenter,
                  radius: 1.5,
                  colors: [
                Color.fromARGB(255, 13, 35, 61),
                Colors.black,
              ])),
          child: Metaballs(
            effect: colorsAndEffects[colorEffectIndex].effect,
            glowRadius: 1,
            glowIntensity: 0.6,
            maxBallRadius: 50,
            minBallRadius: 20,
            metaballs: 40,
            color: Colors.grey,
            gradient: LinearGradient(
                colors: colorsAndEffects[colorEffectIndex].colors,
                begin: Alignment.bottomRight,
                end: Alignment.topLeft),
          ),
        ),
      ),
    );
  }
}
