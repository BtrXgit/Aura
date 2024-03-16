import 'package:aura/core/broken_icons.dart';
import 'package:aura/data/meditation_sounds_data.dart';
import 'package:aura/lib/utils.dart';
import 'package:aura/meditate/widgets/two_stage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';

class Breathing extends StatefulWidget {
  Breathing({Key? key}) : super(key: key);

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentSoundIndex = -1;

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
