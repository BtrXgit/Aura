import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MeditationViewModel {
  final List<Color> pageColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double value;
  final InnerWidget? innerWidget;

  MeditationViewModel(
      {required this.pageColors,
      required this.appearance,
      this.min = 0,
      this.max = 100,
      this.value = 50,
      this.innerWidget});
}

class MeditationTimerPage extends StatelessWidget {
  final MeditationViewModel viewModel;
  const MeditationTimerPage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: viewModel.pageColors,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp)),
        child: SafeArea(
          child: Center(
              child: SleekCircularSlider(
            onChangeStart: (double value) {},
            onChangeEnd: (double value) {},
            innerWidget: viewModel.innerWidget,
            appearance: viewModel.appearance,
            min: viewModel.min,
            max: viewModel.max,
            initialValue: viewModel.value,
          )),
        ),
      ),
    );
  }
}
