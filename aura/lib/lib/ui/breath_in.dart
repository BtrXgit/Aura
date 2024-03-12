import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class BreatheIn extends StatefulWidget {
  BreatheIn({Key? key}) : super(key: key);

  @override
  _BreatheInState createState() => _BreatheInState();
}

class _BreatheInState extends State<BreatheIn> {
  late PageController _controller;
  late Timer _timer;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _startAutomaticSlide();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startAutomaticSlide() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          SliderPage(
            viewModel: SliderViewModel(
              pageColors: [Colors.blue, Colors.lightBlue],
              appearance: _buildAppearance(0, 'Breathe In', 4),
              max: 4,
              initialValue: _currentPageIndex == 0 ? 4 : 0,
            ),
          ),
        ],
      ),
    );
  }

  CircularSliderAppearance _buildAppearance(
      int index, String labelText, double max) {
    final customWidth = CustomSliderWidths(
        trackWidth: 1, progressBarWidth: 28, shadowWidth: 60);
    final customColors = CustomSliderColors(
      dotColor: Colors.white.withOpacity(0.5),
      trackColor: Colors.black.withOpacity(0.1),
      progressBarColors: [
        Colors.blue.withOpacity(0.5),
        Colors.blue.withOpacity(0.5),
        Colors.blue.withOpacity(0.3),
      ],
      dynamicGradient: true,
      shadowColor: Colors.blue.shade300,
      shadowMaxOpacity: 0.02,
    );

    final info = InfoProperties(
      bottomLabelStyle: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w200),
      bottomLabelText: labelText,
      mainLabelStyle: TextStyle(
          color: Colors.white, fontSize: 60.0, fontWeight: FontWeight.w100),
      modifier: (double value) {
        final seconds = value.toInt();
        return '$seconds Sec';
      },
    );

    return CircularSliderAppearance(
      customWidths: customWidth,
      customColors: customColors,
      startAngle: 180,
      angleRange: 180,
      infoProperties: info,
      size: 280.0,
      counterClockwise: true,
      animDurationMultiplier: 4,
    );
  }
}

class SliderViewModel {
  final List<Color> pageColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double initialValue;

  SliderViewModel({
    required this.pageColors,
    required this.appearance,
    this.min = 0,
    required this.max,
    this.initialValue = 0,
  });
}

class SliderPage extends StatelessWidget {
  final SliderViewModel viewModel;

  const SliderPage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: viewModel.pageColors,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SleekCircularSlider(
            onChangeStart: (double value) {},
            onChangeEnd: (double value) {},
            appearance: viewModel.appearance,
            min: viewModel.min,
            max: viewModel.max,
            initialValue: viewModel.initialValue,
          ),
        ),
      ),
    );
  }
}
