import 'dart:async';
import 'package:aura/core/broken_icons.dart';
import 'package:aura/data/meditation_sounds_data.dart';
import 'package:aura/routes/meditate/screens/techniques/fourseven/breath_in.dart';
import 'package:aura/routes/meditate/screens/techniques/fourseven/breathe_out.dart';
import 'package:aura/routes/meditate/screens/techniques/fourseven/hold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';

class FourSevenEight extends StatefulWidget {
  FourSevenEight({Key? key}) : super(key: key);

  @override
  _FourSevenEightState createState() => _FourSevenEightState();
}

class _FourSevenEightState extends State<FourSevenEight> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentSoundIndex = -1;

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
    _audioPlayer.dispose();
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
                    ),
                  ),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xff131321),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Choose Background Sound',
                              style: GoogleFonts.kanit(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              spacing: 6,
                              runSpacing: 10,
                              children: List.generate(
                                meditationSounds.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    _audioPlayer.dynamicSet(
                                      url: meditationSounds[index],
                                      pushIfNotExisted: true,
                                      preload: true,
                                    );
                                    _audioPlayer.processingStateStream
                                        .listen((processingState) {
                                      setState(() {});

                                      if (processingState ==
                                          ProcessingState.completed) {
                                        _audioPlayer.seek(Duration.zero);
                                      }
                                    });
                                    _audioPlayer.play();
                                    setState(() {
                                      _currentSoundIndex = index;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: _currentSoundIndex == index
                                      ? SizedBox(
                                          height: 54,
                                          width: 54,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Color.fromARGB(255, 33, 33, 59),
                                            radius: 20,
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green,
                                              size: 40,
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            width: 54,
                                            height: 54,
                                            imageUrl: playerImages[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  color: Color(0xff131321),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Choose Background Sound',
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
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
