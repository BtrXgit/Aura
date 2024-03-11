import 'package:aura/meditate/model.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'utils.dart';

final CircularSliderAppearance appearance01 = CircularSliderAppearance();

final customWidth10 =
    CustomSliderWidths(trackWidth: 1, progressBarWidth: 28, shadowWidth: 60);
final customColors10 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.5),
    trackColor: HexColor('#000000').withOpacity(0.1),
    progressBarColors: [
      HexColor('#76E2FF').withOpacity(0.5),
      HexColor('#4E09ED').withOpacity(0.5),
      HexColor('#F7E4FF').withOpacity(0.3)
    ],
    dynamicGradient: true,
    shadowColor: HexColor('#55B3E4'),
    shadowMaxOpacity: 0.02);

final info10 = InfoProperties(
    bottomLabelStyle: TextStyle(
        color: HexColor('#5F9DF5'), fontSize: 24, fontWeight: FontWeight.w200),
    bottomLabelText: 'Volume',
    mainLabelStyle: TextStyle(
        color: HexColor('#FF6BD9'),
        fontSize: 60.0,
        fontWeight: FontWeight.w100),
    modifier: (double value) {
      final volume = value.toInt();
      return '$volume db';
    });

final CircularSliderAppearance appearance10 = CircularSliderAppearance(
    customWidths: customWidth10,
    customColors: customColors10,
    startAngle: 180,
    angleRange: 240,
    infoProperties: info10,
    size: 280.0,
    counterClockwise: true,
    animDurationMultiplier: 3);
final viewModel10 = MeditationViewModel(
    appearance: appearance10,
    min: -25,
    max: 0,
    value: -17,
    pageColors: [
      HexColor('#FFFFFF'),
      HexColor('#D7F2FD'),
      HexColor('#FFFFFF'),
      HexColor('#FFFFFF')
    ]);
final example10 = MeditationTimerPage(
  viewModel: viewModel10,
);

class SliderHomePage extends StatefulWidget {
  SliderHomePage({Key? key}) : super(key: key);

  _SliderHomePageState createState() => _SliderHomePageState();
}

class _SliderHomePageState extends State<SliderHomePage> {
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Container(child: example10);
  }
}
