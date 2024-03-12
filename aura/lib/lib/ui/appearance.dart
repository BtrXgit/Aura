import 'package:aura/lib/ui/breath_in.dart';
import 'package:aura/lib/utils.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

final customWidth =
    CustomSliderWidths(trackWidth: 1, progressBarWidth: 28, shadowWidth: 60);
final customColors = CustomSliderColors(
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
    bottomLabelText: 'Breathing', //breathe in,nold, breathe out come here,
    mainLabelStyle: TextStyle(
        color: HexColor('#FF6BD9'),
        fontSize: 60.0,
        fontWeight: FontWeight.w100),
    modifier: (double value) {
      final seconds = value.toInt();
      return '$seconds Sec';
    });

final CircularSliderAppearance appearance10 = CircularSliderAppearance(
    customWidths: customWidth,
    customColors: customColors,
    startAngle: 180,
    angleRange: 180,
    infoProperties: info10,
    size: 280.0,
    counterClockwise: true,
    animDurationMultiplier: 3);
final viewModel = SliderViewModel(
    appearance: appearance10,
    min: 0,
    max: 20,
    // value: 10,
    pageColors: [
      HexColor('#FFFFFF'),
      HexColor('#D7F2FD'),
      HexColor('#FFFFFF'),
      HexColor('#FFFFFF')
    ]);
final slider = SliderPage(
  viewModel: viewModel,
);
