import 'dart:async';
import 'package:aura/lib/utils.dart';
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
              pageColors: [
                HexColor('#FFFFFF'),
                HexColor('#D7F2FD'),
                HexColor('#FFFFFF'),
                HexColor('#FFFFFF')
              ],
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
      trackColor: HexColor('#000000').withOpacity(0.1),
      progressBarColors: [
        HexColor('#76E2FF').withOpacity(0.5),
        HexColor('#4E09ED').withOpacity(0.5),
        HexColor('#F7E4FF').withOpacity(0.3)
      ],
      dynamicGradient: true,
      shadowColor: HexColor('#55B3E4'),
      shadowMaxOpacity: 0.02,
    );

    final info = InfoProperties(
      bottomLabelStyle: TextStyle(
          color: Color(0xff131321), fontSize: 24, fontWeight: FontWeight.w400),
      bottomLabelText: labelText,
      mainLabelStyle: TextStyle(
          color: Color(0xff131321),
          fontSize: 60.0,
          fontWeight: FontWeight.w500),
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
      animDurationMultiplier: 3.5,
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
