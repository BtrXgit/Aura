import 'package:aura/core/broken_icons.dart';
import 'package:aura/lib/utils.dart';
import 'package:aura/meditate/widgets/two_stage.dart';
import 'package:flutter/material.dart';

class Breathing extends StatelessWidget {
  Breathing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HexColor('#FFFFFF'),
                  HexColor('#FFFFFF'),
                  HexColor('#D7F2FD'),
                  HexColor('#FFFFFF'),
                  HexColor('#D7F2FD'),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Center(
            child: TwoStage(),
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
                    "7/11 Breathing",
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
                          return BreathingExerciseDialog();
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

class BreathingExerciseDialog extends StatelessWidget {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '7/11 Breathing Exercise',
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
                '3. Inhale slowly for a count of 7, then exhale for a count of 11.',
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
