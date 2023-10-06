import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CustomMixin extends StatefulWidget {
  const CustomMixin({
    Key? key,
    required ScrollController controller,
    required Color color,
  }) : super(key: key);

  @override
  State<CustomMixin> createState() => _CustomMixinState();
}

class _CustomMixinState extends State<CustomMixin> {
  final AudioPlayer audioPlayer1 = AudioPlayer();
  final AudioPlayer audioPlayer2 = AudioPlayer();
  final AudioPlayer audioPlayer3 = AudioPlayer();
  double volume1 = 0.5;
  double volume2 = 0.5;
  double volume3 = 0.5;
  final sliderValue1 = ValueNotifier<double>(0.5);
  final sliderValue2 = ValueNotifier<double>(0.5);
  final sliderValue3 = ValueNotifier<double>(0.5);
  int selectedTimerDuration = 0;

  Timer? audioTimer;

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    try {
      await audioPlayer1.setAsset('assets/nature/heavyrain.mp3');
      await audioPlayer2.setAsset('assets/nature/fireplace.mp3');
      await audioPlayer3.setAsset('assets/nature/fallingleaves.mp3');
      audioPlayer1.setLoopMode(LoopMode.all);
      audioPlayer2.setLoopMode(LoopMode.all);
      audioPlayer3.setLoopMode(LoopMode.all);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  int _countPlayingAudios() {
    int count = 0;
    if (audioPlayer1.playing) {
      count++;
    }
    if (audioPlayer2.playing) {
      count++;
    }
    if (audioPlayer3.playing) {
      count++;
    }
    return count;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Select Timer Duration',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimerDuration = 0;
                  });
                  Navigator.pop(context);
                  if (selectedTimerDuration > 0) {
                    startTimer(selectedTimerDuration);
                  }
                },
                child: Text(
                  'No Timer',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        selectedTimerDuration == 0 ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimerDuration = 5;
                  });
                  Navigator.pop(context);
                  if (selectedTimerDuration > 0) {
                    startTimer(selectedTimerDuration);
                  }
                },
                child: Text(
                  '5 Seconds',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        selectedTimerDuration == 5 ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimerDuration = 300;
                  });
                  Navigator.pop(context);
                  if (selectedTimerDuration > 0) {
                    startTimer(selectedTimerDuration);
                  }
                },
                child: Text(
                  '5 Minutes',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedTimerDuration == 300
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimerDuration = 600;
                  });
                  Navigator.pop(context);
                  if (selectedTimerDuration > 0) {
                    startTimer(selectedTimerDuration);
                  }
                },
                child: Text(
                  '10 Minutes',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedTimerDuration == 600
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimerDuration = 1800;
                  });
                  Navigator.pop(context);
                  if (selectedTimerDuration > 0) {
                    startTimer(selectedTimerDuration);
                  }
                },
                child: Text(
                  '30 Minutes',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedTimerDuration == 1800
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimerDuration = 3600;
                  });
                  Navigator.pop(context);
                  if (selectedTimerDuration > 0) {
                    startTimer(selectedTimerDuration);
                  }
                },
                child: Text(
                  '1 Hour',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedTimerDuration == 3600
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }

  // void _volumeAll(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             _buildVolumeControl(
  //               label: 'Heavy Rain',
  //               audioPlayer: audioPlayer1,
  //               sliderValue: sliderValue1,
  //             ),
  //             _buildVolumeControl(
  //               label: 'Fireplace',
  //               audioPlayer: audioPlayer2,
  //               sliderValue: sliderValue2,
  //             ),
  //             _buildVolumeControl(
  //               label: 'Tokyo',
  //               audioPlayer: audioPlayer3,
  //               sliderValue: sliderValue3,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _volumeAll() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Volume Controls'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  _buildVolumeControl(
                    label: 'Heavy Rain',
                    audioPlayer: audioPlayer1,
                    sliderValue: sliderValue1,
                  ),
                  _buildVolumeControl(
                    label: 'Fireplace',
                    audioPlayer: audioPlayer2,
                    sliderValue: sliderValue2,
                  ),
                  _buildVolumeControl(
                    label: 'Tokyo',
                    audioPlayer: audioPlayer3,
                    sliderValue: sliderValue3,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
        title: const Text("Aura Test"),
      ),
      backgroundColor: Colors.orangeAccent.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAudioControl(
                    label: 'Heavy Rain',
                    audioPlayer: audioPlayer1,
                    volume: volume1,
                    sliderValue: sliderValue1,
                    icon: Icon(
                      Icons.water_drop_outlined,
                      size: 40,
                    )),
                _buildAudioControl(
                  label: 'Fireplace',
                  audioPlayer: audioPlayer2,
                  volume: volume2,
                  sliderValue: sliderValue2,
                  icon: Icon(
                    Icons.fire_extinguisher_outlined,
                    size: 40,
                  ),
                ),
                _buildAudioControl(
                  label: 'Tokyo  ',
                  audioPlayer: audioPlayer3,
                  volume: volume3,
                  sliderValue: sliderValue3,
                  icon: Icon(
                    Icons.nature_outlined,
                    size: 40,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: 300,
              height: 60,
              color: Colors.green.shade400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        _showBottomSheet(context);
                      },
                      icon: Icon(Icons.timer)),
                  IconButton(
                      onPressed: () => _stopPlayingSounds(),
                      icon: Icon(Icons.stop_circle_outlined)),
                  IconButton(
                    onPressed: () => _volumeAll(),
                    icon: Stack(
                      children: [
                        Icon(Icons.volume_up_outlined),
                        if (_countPlayingAudios() > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  _countPlayingAudios().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeControl({
    required String label,
    required AudioPlayer audioPlayer,
    required ValueNotifier<double> sliderValue,
  }) {
    return Visibility(
      visible: audioPlayer.playing,
      child: Column(
        children: [
          Text(label),
          Slider(
            value: sliderValue.value,
            onChanged: (value) {
              setState(() {
                sliderValue.value = value;
              });
              audioPlayer.setVolume(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioPlayer audioPlayer,
    required double volume,
    required ValueNotifier<double> sliderValue,
    required Icon icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: audioPlayer.playing ? Colors.green : Colors.red,
          ),
          child: InkWell(
            onTap: () {
              _toggleAudioPlayback(audioPlayer);
            },
            customBorder: CircleBorder(),
            child: icon,
          ),
        ),
        Text(label),
        Visibility(
          visible: audioPlayer.playing,
          child: Column(
            children: [
              Text(label),
              Slider(
                value: sliderValue.value,
                onChanged: (value) {
                  setState(() {
                    sliderValue.value = value;
                  });
                  audioPlayer.setVolume(value);
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  void _toggleAudioPlayback(AudioPlayer audioPlayer) {
    if (audioPlayer.playing) {
      audioPlayer.pause();
      if (audioTimer != null) {
        audioTimer!.cancel();
      }
    } else {
      audioPlayer.play();
    }
    setState(() {});
  }

  void _stopPlayingSounds() {
    if (audioPlayer1.playing) {
      audioPlayer1.pause();
    }
    if (audioPlayer2.playing) {
      audioPlayer2.pause();
    }
    if (audioPlayer3.playing) {
      audioPlayer3.pause();
    }
    if (audioTimer != null) {
      audioTimer!.cancel();
    }
    setState(() {});
    print('Sounds Stopped');
  }

  void startTimer(int duration) {
    audioTimer = Timer(Duration(seconds: duration), () {
      if (audioPlayer1.playing) {
        audioPlayer1.pause();
      }
      if (audioPlayer2.playing) {
        audioPlayer2.pause();
      }
      if (audioPlayer3.playing) {
        audioPlayer3.pause();
      }
    });
  }

  @override
  void dispose() {
    audioPlayer1.dispose();
    audioPlayer2.dispose();
    audioPlayer3.dispose();
    super.dispose();
  }
}
