import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

class CustomMixin extends StatefulWidget {
  // final ScrollController controller;
  const CustomMixin({
    Key? key,
    // required this.controller,
  }) : super(key: key);

  @override
  State<CustomMixin> createState() => _CustomMixinState();
}

class _CustomMixinState extends State<CustomMixin>
    with SingleTickerProviderStateMixin {
  int playingAudioCount = 0;

  List<ValueNotifier<double>> volumes =
      List.generate(54, (_) => ValueNotifier<double>(1.0));

  late TabController _tabController;
  final List<String> data = [
    "Nature",
    "Animals",
    "Rain",
    "Music",
    "ASMR",
    "Transport",
  ];

  final List<AudioPlayer> audioPlayers =
      List.generate(54, (index) => AudioPlayer());

  int selectedTimerDuration = 0;

  Timer? audioTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadAudios();
  }

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
    'assets/animals/birds.ogg', //not working
    'assets/animals/rainforest_birds.ogg', //not working
    'assets/animals/crickets.ogg', //not working
    'assets/animals/frogs.ogg', //not working
    'assets/animals/owls.ogg', //not working
    'assets/animals/whales.ogg', //not working
    'assets/animals/wolves.ogg', //not working
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
    "Birds 2",
    "Crickets",
    "Frogs",
    "Owls",
    "Whales",
    "Wolves",
    //rain
    "Rain",
    "Thunder",
    "Thunder 2",
    "Rain in Forest",
    "Rain on Leaves",
    "Rain on Roof",
    "Rain on Tent",
    "Rain on Window",
    "Rain under Umbrella",

    //music
    'Harp',
    'Piano',
    'Piano 2',
    'Guitar',
    'Guitar 2',
    'Guitar 3',
    'Guitar 4',
    'Violin',
    'Peaceful',
    'Rhodes',
    'Ambient',
    'Ambient 2',
    'Chill',
    'Cinematic',
    //ASMR
    'Breathing',
    'Car Engine',
    'Cat Purring',
    'Chewing',
    'Crackling',
    'Hair Clippers',
    'Page Turning',
    'Scratching',
    'Tapping',
    'Whispering',
    //transport
    'Car',
    'Train',
    'Airplane',
    'Boat',
    'Boat 2',
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

  Future<void> _loadAudios() async {
    try {
      for (int i = 0; i < audioPlayers.length && i < audioPaths.length; i++) {
        try {
          await audioPlayers[i].setAsset(audioPaths[i]);
        } catch (e) {
          if (kDebugMode) {
            print('Error loading audio: $e');
          }
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
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/1.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 2),
                  child: _buildTabBar(),
                ),
                Expanded(child: _buildTabViews()),
              ],
            ),
            _buildPlayerController(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      dividerColor: Colors.transparent,
      physics: const BouncingScrollPhysics(),
      indicatorPadding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      controller: _tabController,
      indicatorColor: Colors.transparent,
      indicator: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 80, 218, 243),
          Color.fromARGB(255, 12, 26, 176),
          Colors.purple,
          Color.fromARGB(255, 232, 52, 88),
        ]),
        borderRadius: BorderRadius.circular(20),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      isScrollable: true,
      labelPadding: const EdgeInsets.symmetric(horizontal: 5),
      tabs: data.map((tab) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.046,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            border: const GradientBoxBorder(
                width: 3,
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 80, 218, 243),
                  Color.fromARGB(255, 12, 26, 176),
                  Colors.purple,
                  Color.fromARGB(255, 232, 52, 88),
                ])),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Tab(
            child: Text(
              tab,
              style: GoogleFonts.kanit(
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTabViews() {
    return TabBarView(
      controller: _tabController,
      children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 4; i < 8; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 8; i < 9; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 9; i < 13; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 13; i < 16; i++)
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
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 16; i < 19; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 19; i < 21; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 21; i < 23; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 23; i < 25; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              const SizedBox(
                height: 150,
              )
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 25; i < 28; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 28; i < 31; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 31; i < 34; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 34; i < 37; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 37; i < 39; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              const SizedBox(
                height: 150,
              )
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 39; i < 42; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 42; i < 45; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 45; i < 48; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 48; i < 49; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              const SizedBox(
                height: 150,
              )
            ],
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 49; i < 52; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 52; i < 54; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              const SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioPlayer audioPlayer,
    required ValueNotifier<double> volume,
    required Widget icon,
  }) {
    return Expanded(
      child: Container(
        // width: 74,
        // height: 74,
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: audioPlayer.playing
              ? Colors.green
              : const Color.fromARGB(255, 0, 104, 125),
        ),
        child: InkWell(
          onTap: () {
            _toggleAudioPlayback(audioPlayer);
          },
          customBorder: const CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 54, child: icon),
              Text(
                label,
                style: const TextStyle(
                  color: Color.fromARGB(255, 103, 247, 110),
                  // fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
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
          audioPlayer.pause();
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
        // bottom: 70,
        bottom: MediaQuery.of(context).size.height * 0.09,
        left: 8,
        right: 8,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
              // color: Colors.transparent,
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 80, 218, 243),
                Color.fromARGB(255, 12, 26, 176),
                Colors.purple,
                Color.fromARGB(255, 232, 52, 88),
              ]),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon: const Icon(
                    Iconsax.timer,
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
                      Iconsax.volume_up,
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
