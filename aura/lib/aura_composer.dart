import 'dart:async';
import 'package:aura/data/composer_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class AuraComposerTest extends StatefulWidget {
  const AuraComposerTest({Key? key}) : super(key: key);

  @override
  State<AuraComposerTest> createState() => AuraComposerTestState();
}

class AuraComposerTestState extends State<AuraComposerTest> {
  int playingAudioCount = 0;
  final List<AudioPlayer> natureaudioPlayer =
      List.generate(6, (index) => AudioPlayer());
  final List<AudioPlayer> animalsaudioPlayer =
      List.generate(5, (index) => AudioPlayer());
  final List<AudioPlayer> rainaudioPlayer =
      List.generate(6, (index) => AudioPlayer());
  final List<AudioPlayer> musicaudioPlayer =
      List.generate(8, (index) => AudioPlayer());
  final List<AudioPlayer> asmraudioPlayer =
      List.generate(6, (index) => AudioPlayer());
  final List<AudioPlayer> transportaudioPlayer =
      List.generate(4, (index) => AudioPlayer());
  final Map<String, AudioPlayer> audioCache = {};

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAllAudios();
    _timer = null;
  }

  Future<void> _loadAllAudios() async {
    await _loadCategoryAudios(natureaudioPaths, natureaudioPlayer);
    await _loadCategoryAudios(animalsaudioPaths, animalsaudioPlayer);
    await _loadCategoryAudios(rainaudioPaths, rainaudioPlayer);
    await _loadCategoryAudios(musicaudioPaths, musicaudioPlayer);
    await _loadCategoryAudios(asmraudioPaths, asmraudioPlayer);
    await _loadCategoryAudios(transportaudioPaths, transportaudioPlayer);
  }

  Future<void> _loadCategoryAudios(
      List<String> paths, List<AudioPlayer> players) async {
    for (int i = 0; i < paths.length; i++) {
      await _loadAudio(paths[i], players[i]);
    }

    for (final audioPlayer in players) {
      audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  Future<void> _loadAudio(String path, AudioPlayer audioPlayer) async {
    if (!audioCache.containsKey(path)) {
      await audioPlayer.setAsset(path);
      audioCache[path] = audioPlayer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131321),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/composer.gif'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Sounds',
                        style: GoogleFonts.dancingScript(
                            color: Colors.white, fontSize: 38),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                      image: AssetImage('assets/style3.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Nature Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < natureaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: natureIcons[i],
                                label: natureaudioNames[i],
                                audioPlayer: natureaudioPlayer[i],
                                colour: const Color.fromARGB(255, 38, 224, 45),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Animals Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < animalsaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: animalsIcons[i],
                                label: animalsaudioNames[i],
                                audioPlayer: animalsaudioPlayer[i],
                                colour: const Color.fromARGB(255, 97, 33, 10),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Rain Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < rainaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: rainIcons[i],
                                label: rainaudioNames[i],
                                audioPlayer: rainaudioPlayer[i],
                                colour: const Color.fromARGB(255, 33, 152, 243),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Music Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < musicaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: musicIcons[i],
                                label: musicaudioNames[i],
                                audioPlayer: musicaudioPlayer[i],
                                colour: const Color.fromARGB(255, 176, 39, 135),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'ASMR Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < asmraudioPaths.length; i++)
                              _buildAudioControl(
                                icon: asmrIcons[i],
                                label: asmraudioNames[i],
                                audioPlayer: asmraudioPlayer[i],
                                colour: const Color.fromARGB(255, 181, 115, 15),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Transport Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < transportaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: transportIcons[i],
                                label: transportaudioNames[i],
                                audioPlayer: transportaudioPlayer[i],
                                colour: const Color.fromARGB(255, 24, 147, 98),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
          ),
          _buildController(),
        ],
      ),
    );
  }

  Widget _buildController() {
    bool isAudioPlaying = false;
    for (var player in natureaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in animalsaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in rainaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in musicaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    return Positioned(
      right: 20,
      bottom: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          Visibility(
            visible: isAudioPlaying,
            child: FloatingActionButton(
              onPressed: () {
                _showTimerDialog();
              },
              child: const Icon(Icons.timer),
            ),
          ),
          const SizedBox(width: 8),
          Visibility(
            visible: isAudioPlaying,
            child: FloatingActionButton(
              onPressed: () {
                _stopAllAudioPlayers();
              },
              child: const Icon(Icons.stop),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioPlayer audioPlayer,
    required Widget icon,
    required Color colour,
  }) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          padding: const EdgeInsets.all(14.0),
          // margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: audioPlayer.playing ? colour : const Color(0xFF131321),
          ),
          child: InkWell(
            onTap: () {
              _toggleAudioPlayback(audioPlayer);
            },
            child: SizedBox(height: 40, width: 40, child: icon),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        audioPlayer.playing
            ? _buildVolumeSlider(audioPlayer)
            : Text(
                label,
                style: const TextStyle(
                  // color: Color.fromARGB(255, 103, 247, 110),
                  color: Colors.white,
                ),
              ),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  Widget _buildVolumeSlider(AudioPlayer audioPlayer) {
    return SizedBox(
        width: 64,
        child: SliderTheme(
          data: const SliderThemeData(
            trackHeight: 2.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
            thumbColor: Colors.white,
            activeTrackColor: Colors.white,
          ),
          child: Slider(
            value: audioPlayer.volume,
            onChanged: (value) {
              setState(() {
                audioPlayer.setVolume(value);
              });
            },
          ),
        ));
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

  int? selectedTime;

  Future<void> _showTimerDialog() async {
    selectedTime = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        List<Map<String, dynamic>> timerOptions = [
          {'duration': 60, 'label': '1M'},
          {'duration': 120, 'label': '2M'},
          {'duration': 300, 'label': '5M'},
          {'duration': 600, 'label': '10M'},
          {'duration': 1800, 'label': '30M'},
          {'duration': 3600, 'label': '1H'},
          {'duration': 7200, 'label': '2H'},
          {'duration': 18000, 'label': '5H'},
        ];

        return AlertDialog(
          title: Text(
            'Select Timer Duration',
            style: GoogleFonts.inter(fontSize: 18),
          ),
          content: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width - 100,
            child: Wrap(
              children: timerOptions
                  .map((option) => ElevatedButton(
                        onPressed: () {
                          selectedTime = option['duration'];
                          Navigator.of(context).pop(selectedTime);
                        },
                        style: ButtonStyle(
                          backgroundColor: (selectedTime == option['duration'])
                              ? MaterialStateProperty.all(Colors.red)
                              : null,
                        ),
                        child: Text(option['label']),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selectedTime != null) {
      _timer?.cancel();
      _startTimer(selectedTime!);
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
    for (var player in rainaudioPlayer) {
      player.stop();
    }
    for (var player in musicaudioPlayer) {
      player.stop();
    }
    for (var player in asmraudioPlayer) {
      player.stop();
    }
    for (var player in transportaudioPlayer) {
      player.stop();
    }
    setState(() {
      playingAudioCount = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _stopAllAudioPlayers();
    for (var player in natureaudioPlayer) {
      player.dispose();
    }
    for (var player in animalsaudioPlayer) {
      player.dispose();
    }
    for (var player in rainaudioPlayer) {
      player.dispose();
    }
    for (var player in musicaudioPlayer) {
      player.dispose();
    }
    for (var player in asmraudioPlayer) {
      player.dispose();
    }
    for (var player in transportaudioPlayer) {
      player.dispose();
    }
    super.dispose();
  }
}
