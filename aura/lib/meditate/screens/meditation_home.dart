import 'package:aura/lib/ui/four_seven_eight.dart';
import 'package:aura/meditate/screens/box_breathing.dart';
import 'package:aura/meditate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'breathing.dart';

class MeditationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Breathing(pattern: '7/11 Breathing');
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      child: const Text(
                        "7/11 Pattern",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return BoxBreathing(pattern: 'Box Breathing');
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      child: const Text(
                        "Box Breathing",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return FourSevenEight();
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      child: const Text(
                        "4-7-8 Pattern",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
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
