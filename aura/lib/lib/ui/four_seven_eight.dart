import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aura/lib/ui/breath_in.dart';
import 'package:aura/lib/ui/breathe_out.dart';
import 'package:aura/lib/ui/hold.dart';

class FourSevenEight extends StatefulWidget {
  FourSevenEight({Key? key}) : super(key: key);

  @override
  _FourSevenEightState createState() => _FourSevenEightState();
}

class _FourSevenEightState extends State<FourSevenEight> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  List<Widget> _pages = [
    BreatheIn(),
    HoldBreathe(),
    BreatheOut(),
  ];
  List<int> _pageDurations = [4, 7, 8];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
        Duration(seconds: _pageDurations[_currentPageIndex]), (timer) {
      if (_currentPageIndex < _pages.length - 1) {
        _currentPageIndex++;
        _pageController.animateToPage(
          _currentPageIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _currentPageIndex = 0;
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text("4-7-8 Breathing"),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
          _timer.cancel();
          _startTimer();
        },
      ),
    );
  }
}
