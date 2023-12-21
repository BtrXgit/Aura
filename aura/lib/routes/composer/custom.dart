import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

class AuraComposer extends StatefulWidget {
  // final ScrollController controller;
  const AuraComposer({
    Key? key,
    // required this.controller,
  }) : super(key: key);

  @override
  State<AuraComposer> createState() => AuraComposerState();
}

class AuraComposerState extends State<AuraComposer> {
  int playingAudioCount = 0;
  int selectedTimerDuration = 0;
  Timer? audioTimer;

  final List<AudioPlayer> audioPlayers =
      List.generate(54, (index) => AudioPlayer());

  List<ValueNotifier<double>> volumes =
      List.generate(54, (_) => ValueNotifier<double>(1.0));

  final List<String> audioPaths = [
    //nature
    'assets/nature/cave.ogg',
    'assets/nature/creek.ogg',
    'assets/nature/desert.ogg',
    'assets/nature/fire.ogg',
    'assets/nature/lake.ogg',
    'assets/nature/night.ogg',
    'assets/nature/ocean.ogg',
    'assets/nature/rainforest.ogg',
    'assets/nature/wind.ogg',
    //Animals
    'assets/animals/birds.ogg',
    'assets/animals/rainforest_birds.ogg',
    'assets/animals/crickets.ogg',
    'assets/animals/frogs.ogg',
    'assets/animals/owls.ogg',
    'assets/animals/whales.ogg',
    'assets/animals/wolves.ogg',
    //rain
    'assets/rain/rain.ogg',
    'assets/rain/thunders.ogg',
    'assets/rain/thunderstorm.ogg',
    'assets/rain/rain_in_forest.ogg',
    'assets/rain/rain_on_leaves.ogg',
    'assets/rain/rain_on_roof.mp3',
    'assets/rain/rain_on_tent.mp3',
    'assets/rain/rain_on_window.mp3',
    'assets/rain/rain_under_umbrella.ogg',

    //music
    'assets/music/harp.mp3',
    'assets/music/piano.ogg',
    'assets/music/piano_2.ogg',
    'assets/music/guitar.mp3',
    'assets/music/lofi_guitar.mp3',
    'assets/music/guitar_sentimental.mp3',
    'assets/music/acoustic_guitar.mp3',
    'assets/music/violin.mp3',
    'assets/music/peaceful.mp3',
    'assets/music/rhodes.mp3',
    'assets/music/ambience.mp3',
    'assets/music/ambient.mp3',
    'assets/music/chill.mp3',
    'assets/music/cinematic.mp3',
    //ASMR
    'assets/asmr/breathing.ogg',
    'assets/asmr/car_engine.ogg',
    'assets/asmr/cat_purring.ogg',
    'assets/asmr/chewing.ogg',
    'assets/asmr/crackling.ogg',
    'assets/asmr/hair_clippers.ogg',
    'assets/asmr/page_turning.ogg',
    'assets/asmr/scratching.ogg',
    'assets/asmr/tapping.ogg',
    'assets/asmr/whispering.ogg',
    //transport
    'assets/transport/car.ogg',
    'assets/transport/train.ogg',
    'assets/transport/airplane.ogg',
    'assets/transport/boat.ogg',
    'assets/transport/boat_ride.ogg',
  ];

  final List<String> audioNames = [
    //nature
    'Cave',
    'Creek',
    'Desert',
    'Fire',
    'Lake',
    'Night',
    'Ocean',
    'Forest',
    'Wind',
    //animals
    "Birds",
    "Birds",
    "Crickets",
    "Frogs",
    "Owls",
    "Whales",
    "Wolves",
    //rain
    "Rain",
    "Thunder",
    "Thunder",
    "Forest",
    "Leaves",
    "Roof",
    "Tent",
    "Window",
    "Umbrella",

    //music
    'Harp',
    'Piano',
    'Piano',
    'Guitar',
    'Guitar',
    'Guitar',
    'Guitar',
    'Violin',
    'Peaceful',
    'Rhodes',
    'Ambient',
    'Ambient',
    'Chill',
    'Cinematic',
    //ASMR
    'Breathing',
    'Engine',
    'Cat Purring',
    'Chewing',
    'Crackling',
    'Hair Clip.',
    'Page',
    'Scratch',
    'Tapping',
    'Whispering',
    //transport
    'Car',
    'Train',
    'Airplane',
    'Boat',
    'Boat',
  ];

  final List<Widget> audioIcons = [
    Image.asset('assets/icons/cave.png'),
    Image.asset('assets/icons/creek.png'),
    Image.asset('assets/icons/desert.png'),
    Image.asset('assets/icons/fire.png'),
    Image.asset('assets/icons/lake.png'),
    Image.asset('assets/icons/night.png'),
    Image.asset('assets/icons/ocean.png'),
    Image.asset('assets/icons/forest.png'),
    Image.asset('assets/icons/wind.png'),
    //animals
    Image.asset('assets/icons/birds.png'),
    Image.asset('assets/icons/birds2.png'),
    Image.asset('assets/icons/crickets.png'),
    Image.asset('assets/icons/frog.png'),
    Image.asset('assets/icons/owls.png'),
    Image.asset('assets/icons/whale.png'),
    Image.asset('assets/icons/wolves.png'),
    //rain
    Image.asset('assets/icons/rain/rain.png'),
    Image.asset('assets/icons/rain/storm.png'),
    Image.asset('assets/icons/rain/thunderstorm.png'),
    Image.asset('assets/icons/rain/rain_in_forest.png'),
    Image.asset('assets/icons/rain/rain_on_leaves.png'),
    Image.asset('assets/icons/rain/rain_on_roof.png'),
    Image.asset('assets/icons/rain/rain_on_leaves.png'),
    Image.asset('assets/icons/rain/rain_on_window.png'),
    Image.asset('assets/icons/rain/rain_under_umbrella.png'),

    //music
    Image.asset('assets/icons/harp.png'),
    Image.asset('assets/icons/piano.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),
    Image.asset('assets/icons/piano2.png'),

    //ASMR
    Image.asset('assets/icons/asmr/breathing.png'),
    Image.asset('assets/icons/asmr/car_engine.png'),
    Image.asset('assets/icons/asmr/cat_purring.png'),
    Image.asset('assets/icons/asmr/chewing.png'),
    Image.asset('assets/icons/asmr/crackling.png'),
    Image.asset('assets/icons/asmr/hair_clippers.png'),
    Image.asset('assets/icons/asmr/page_turning.png'),
    Image.asset('assets/icons/asmr/scratching.png'),
    Image.asset('assets/icons/asmr/tapping.png'),
    Image.asset('assets/icons/asmr/whispering.png'),
    //transport
    Image.asset('assets/icons/transport/car.png'),
    Image.asset('assets/icons/transport/train.png'),
    Image.asset('assets/icons/transport/plane.png'),
    Image.asset('assets/icons/transport/boat.png'),
    Image.asset('assets/icons/transport/boat.png'),
  ];

  @override
  void initState() {
    super.initState();
    _loadAudios();
  }

  Future<void> _loadAudios() async {
    try {
      for (int i = 0; i < audioPlayers.length && i < audioPaths.length; i++) {
        try {
          await audioPlayers[i].setAsset(audioPaths[i]);
          print('Audio at index $i loaded successfully.');
        } catch (e) {
          print('Error loading audio at index $i: $e');
        }
      }
      for (final audioPlayer in audioPlayers) {
        audioPlayer.setLoopMode(LoopMode.all);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading audio: $e');
      }
    }
  }

  int _countPlayingAudios(List<AudioPlayer> audioPlayers) {
    int count = 0;
    for (final audioPlayer in audioPlayers) {
      if (audioPlayer.playing) {
        count++;
      }
    }
    return count;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Select Timer Duration',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              _buildTimerOption(0, 'No Timer'),
              _buildTimerOption(5, '5 Seconds'),
              _buildTimerOption(60, '1 Minute'),
              _buildTimerOption(300, '5 Minutes'),
              _buildTimerOption(600, '10 Minutes'),
              _buildTimerOption(1800, '30 Minutes'),
              _buildTimerOption(3600, '1 Hour'),
              _buildTimerOption(7200, '2 Hours'),
              _buildTimerOption(10800, '3 Hours '),
              _buildTimerOption(18000, '5 Hours'),
              const SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimerOption(int duration, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimerDuration = duration;
        });
        Navigator.pop(context);
        if (selectedTimerDuration > 0) {
          startTimer(selectedTimerDuration, audioPlayers);
        }
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: selectedTimerDuration == duration ? Colors.blue : Colors.black,
        ),
      ),
    );
  }

  void _volumeAll(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < audioPlayers.length; i++)
                _buildVolumeControl(
                    label: audioNames[i],
                    audioPlayer: audioPlayers[i],
                    sliderValue: volumes[i]),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xFF131321),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Customization Sound',
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 28, 28, 48),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Nature Category',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: <Widget>[
                              for (int i = 0; i < 9; i++)
                                _buildAudioControl(
                                  icon: audioIcons[i],
                                  label: audioNames[i],
                                  audioPlayer: audioPlayers[i],
                                  volume: volumes[i],
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
                      color: const Color.fromARGB(255, 28, 28, 48),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Animals Category',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: <Widget>[
                              for (int i = 9; i < 16; i++)
                                _buildAudioControl(
                                  icon: audioIcons[i],
                                  label: audioNames[i],
                                  audioPlayer: audioPlayers[i],
                                  volume: volumes[i],
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
                      color: const Color.fromARGB(255, 28, 28, 48),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Rain Category',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: <Widget>[
                              for (int i = 16; i < 25; i++)
                                _buildAudioControl(
                                  icon: audioIcons[i],
                                  label: audioNames[i],
                                  audioPlayer: audioPlayers[i],
                                  volume: volumes[i],
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
                      color: const Color.fromARGB(255, 28, 28, 48),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Music Category',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: <Widget>[
                              for (int i = 25; i < 39; i++)
                                _buildAudioControl(
                                  icon: audioIcons[i],
                                  label: audioNames[i],
                                  audioPlayer: audioPlayers[i],
                                  volume: volumes[i],
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
                      color: const Color.fromARGB(255, 28, 28, 48),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'ASMR Category',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: <Widget>[
                              for (int i = 39; i < 49; i++)
                                _buildAudioControl(
                                  icon: audioIcons[i],
                                  label: audioNames[i],
                                  audioPlayer: audioPlayers[i],
                                  volume: volumes[i],
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
                      color: const Color.fromARGB(255, 28, 28, 48),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Transport Category',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: <Widget>[
                              for (int i = 49; i < 54; i++)
                                _buildAudioControl(
                                  icon: audioIcons[i],
                                  label: audioNames[i],
                                  audioPlayer: audioPlayers[i],
                                  volume: volumes[i],
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
            _buildPlayerController(),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioPlayer audioPlayer,
    required ValueNotifier<double> volume,
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
        const SizedBox(
          height: 3,
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 103, 247, 110),
            // fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 3,
        ),
      ],
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

  void _stopPlayingSounds(List<AudioPlayer> audioPlayers) {
    bool anySoundsPlaying = false;

    for (final audioPlayer in audioPlayers) {
      if (audioPlayer.playing) {
        audioPlayer.pause();
        playingAudioCount--;
        anySoundsPlaying = true;
      }
    }

    if (anySoundsPlaying) {
      if (audioTimer != null) {
        audioTimer!.cancel();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No sounds are playing.'),
        ),
      );
    }

    setState(() {});
    if (kDebugMode) {
      print('Sounds Stopped');
    }
  }

  void startTimer(int duration, List<AudioPlayer> audioPlayers) {
    audioTimer = Timer(Duration(seconds: duration), () {
      for (final audioPlayer in audioPlayers) {
        if (audioPlayer.playing) {
          audioPlayer.stop();
        }
      }
    });
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
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          ValueListenableBuilder<double>(
            valueListenable: sliderValue,
            builder: (context, value, child) {
              return Slider(
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    sliderValue.value = newValue;
                  });
                  audioPlayer.setVolume(newValue);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerController() {
    bool isAudioPlaying = false;
    for (final audioPlayer in audioPlayers) {
      if (audioPlayer.playing) {
        isAudioPlaying = true;
        break;
      }
    }
    return Visibility(
      visible: isAudioPlaying,
      child: Positioned(
        bottom: 75,
        left: 45,
        right: 45,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 64,
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 80, 218, 243),
                Color.fromARGB(255, 12, 26, 176),
                Colors.purple,
                Color.fromARGB(255, 232, 52, 88),
              ]),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon: const Icon(
                    IconlyLight.time_circle,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () => _stopPlayingSounds(audioPlayers),
                  icon: const Icon(
                    Iconsax.stop,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                onPressed: () => _volumeAll(context),
                icon: Stack(
                  children: [
                    const Icon(
                      IconlyLight.volume_down,
                      color: Colors.white,
                      size: 30,
                    ),
                    if (_countPlayingAudios(audioPlayers) > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              _countPlayingAudios(audioPlayers).toString(),
                              style: const TextStyle(
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
      ),
    );
  }

  @override
  void dispose() {
    for (final audioPlayer in audioPlayers) {
      audioPlayer.dispose();
    }
    super.dispose();
  }
}
