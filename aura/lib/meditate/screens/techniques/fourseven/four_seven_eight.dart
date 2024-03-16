import 'dart:async';
import 'package:aura/core/broken_icons.dart';
import 'package:flutter/material.dart';
import 'package:aura/meditate/screens/techniques/fourseven/breath_in.dart';
import 'package:aura/meditate/screens/techniques/fourseven/breathe_out.dart';
import 'package:aura/meditate/screens/techniques/fourseven/hold.dart';

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
      body: Stack(
        children: [
          PageView(
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
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Broken.close_circle,
                        size: 28,
                      )),
                  Text(
                    "4-7-8 Breathing",
                    style: TextStyle(
                      color: Color(0xff131321),
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InfoDialog();
                        },
                      );
                    },
                    icon: Icon(
                      Broken.info_circle,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '4-7-8 Breathing Exercise',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  '1. Find a comfortable and quiet place to sit or lie down.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '2. Close your eyes and relax your body.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '3. Place the tip of your tongue against the ridge of tissue just behind your upper front teeth and keep it there throughout the exercise.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '4. Exhale completely through your mouth, making a whoosh sound.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '5. Close your mouth and inhale quietly through your nose to a mental count of four.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '6. Hold your breath for a count of seven.',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '7. Exhale completely through your mouth, making a whoosh sound to a count of eight.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff131321)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          left: 20.0,
          right: 20.0,
          child: CircleAvatar(
            backgroundColor: Color(0xff131321),
            radius: 20.0,
            child: Icon(
              Broken.info_circle,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
