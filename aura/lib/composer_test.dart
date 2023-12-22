import 'dart:async';
import 'package:aura/data/composer_data.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AuraComposerTest extends StatefulWidget {
  const AuraComposerTest({Key? key}) : super(key: key);

  @override
  State<AuraComposerTest> createState() => AuraComposerTestState();
}

class AuraComposerTestState extends State<AuraComposerTest> {
  int playingAudioCount = 0;
  final List<AudioPlayer> natureaudioPlayer =
      List.generate(9, (index) => AudioPlayer());
  final List<AudioPlayer> animalsaudioPlayer =
      List.generate(7, (index) => AudioPlayer());

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadnatureAudios();
    _loadanimalsAudios();
  }

  Future<void> _loadnatureAudios() async {
    for (int i = 0;
        i < natureaudioPlayer.length && i < natureaudioPaths.length;
        i++) {
      await natureaudioPlayer[i].setAsset(natureaudioPaths[i]);
    }
    for (final audioPlayer in natureaudioPlayer) {
      audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  Future<void> _loadanimalsAudios() async {
    for (int i = 0;
        i < animalsaudioPlayer.length && i < animalsaudioPaths.length;
        i++) {
      await animalsaudioPlayer[i].setAsset(animalsaudioPaths[i]);
    }
    for (final audioPlayer in animalsaudioPlayer) {
      audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: <Widget>[
                  for (int i = 0; i < 9; i++)
                    _buildAudioControl(
                      icon: natureIcons[i],
                      label: natureaudioNames[i],
                      audioPlayer: natureaudioPlayer[i],
                    ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: <Widget>[
                  for (int i = 0; i < 7; i++)
                    _buildAudioControl(
                      icon: animalsIcons[i],
                      label: animalsaudioNames[i],
                      audioPlayer: animalsaudioPlayer[i],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showTimerDialog();
            },
            child: Icon(Icons.timer),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _stopAllAudioPlayers();
            },
            child: Icon(Icons.stop),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioPlayer audioPlayer,
    required Widget icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.all(3.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: audioPlayer.playing
                ? const Color.fromARGB(255, 37, 194, 42)
                : const Color.fromARGB(255, 38, 43, 80),
          ),
          child: InkWell(
            onTap: () {
              _toggleAudioPlayback(audioPlayer);
            },
            child: SizedBox(height: 44, width: 44, child: icon),
          ),
        ),
        const SizedBox(height: 3),
        audioPlayer.playing
            ? _buildVolumeSlider(audioPlayer)
            : Text(
                label,
                style: const TextStyle(
                  color: Color.fromARGB(255, 103, 247, 110),
                ),
              ),
        const SizedBox(height: 3),
      ],
    );
  }

  Widget _buildVolumeSlider(AudioPlayer audioPlayer) {
    return SizedBox(
      width: 80,
      height: 30,
      child: Slider(
        value: audioPlayer.volume,
        onChanged: (value) {
          setState(() {
            audioPlayer.setVolume(value);
          });
        },
      ),
    );
  }

  void _toggleAudioPlayback(AudioPlayer audioPlayer) {
    if (audioPlayer.playing) {
      audioPlayer.pause();
      setState(() {
        playingAudioCount--;
      });
    } else {
      if (playingAudioCount >= 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only 8 audios can be played at a time.'),
          ),
        );
        return;
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        audioPlayer.play();
        setState(() {
          playingAudioCount++;
        });
      });
    }

    print('Audio Player State: ${audioPlayer.playing ? 'Playing' : 'Paused'}');
  }

  Future<void> _showTimerDialog() async {
    int? selectedTime = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int? selectedTime;
        return AlertDialog(
          title: Text('Select Timer Duration (seconds)'),
          content: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Validate and set the selected time
                  if (value.isNotEmpty) {
                    selectedTime = int.tryParse(value);
                  }
                },
                decoration: InputDecoration(labelText: 'Duration'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedTime);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (selectedTime != null) {
      _startTimer(selectedTime);
    }
  }

  void _startTimer(int durationInSeconds) {
    _timer = Timer(Duration(seconds: durationInSeconds), () {
      _stopAllAudioPlayers();
      setState(() {});
    });

    setState(() {});
  }

  void _stopAllAudioPlayers() {
    for (var player in natureaudioPlayer) {
      player.stop();
    }
    for (var player in animalsaudioPlayer) {
      player.stop();
    }
    setState(() {
      playingAudioCount = 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
