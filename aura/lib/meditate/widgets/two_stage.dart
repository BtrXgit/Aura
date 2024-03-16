import 'package:aura/core/broken_icons.dart';
import 'package:aura/meditate/widgets/breather.dart';
import 'package:flutter/material.dart';

class TwoStage extends StatefulWidget {
  @override
  _TwoStageState createState() => _TwoStageState();
}

class _TwoStageState extends State<TwoStage> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late String _action;

  @override
  void initState() {
    super.initState();
    _action = 'Breathe In';
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _breathingController.duration = const Duration(seconds: 11);
          _action = 'Breathe Out';
          _breathingController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _action = 'Breathe In';
          _breathingController.forward();
        }
      })
      ..addListener(() {
        setState(() {});
      });
    _breathingController.forward();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _breathingController.value;
    int inhaleTime = (progress * 7).floor();
    int exhaleTime = (progress * 11).floor();

    int currentTime;

    if (_action == 'Breathe In') {
      currentTime = inhaleTime;
    } else {
      currentTime = exhaleTime;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height: 20.0),
        Breather(
          breathingController: _breathingController,
          action: _action,
          time: '$currentTime / ${_action == 'Breathe In' ? 7 : 11} Sec',
        ),
      ],
    );
  }
}
