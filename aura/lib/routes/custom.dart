import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

class CustomMixin extends StatefulWidget {
  const CustomMixin({
    Key? key,
    required ScrollController controller,
    // required Color color,
  }) : super(key: key);

  @override
  State<CustomMixin> createState() => _CustomMixinState();
}

class _CustomMixinState extends State<CustomMixin>
    with SingleTickerProviderStateMixin {
  int playingAudioCount = 0;

  List<ValueNotifier<double>> volumes =
      List.generate(40, (_) => ValueNotifier<double>(0.5));

  late TabController _tabController;
  final List<String> data = ["Nature", "Animals", "Rain", "Music", "ASMR"];

  final List<AudioPlayer> audioPlayers =
      List.generate(40, (index) => AudioPlayer());

  int selectedTimerDuration = 0;

  Timer? audioTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
    'assets/rain/rain_on_roof.ogg',
    'assets/rain/rain_on_tent.ogg',
    'assets/rain/rain_on_window.ogg',
    'assets/rain/rain_under_umbrella',

    //music
    'assets/music/harp.mp3',
    'assets/music/piano.ogg',
    'assets/music/piano_2.ogg',
    'assets/music/guitar.mp3',
    'assets/music/violin.mp3',

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
    'Violin',
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
  ];

  Future<void> _loadAudios() async {
    try {
      for (int i = 0; i < audioPlayers.length && i < audioPaths.length; i++) {
        try {
          await audioPlayers[i].setAsset(audioPaths[i]);
        } catch (e) {
          print('Error loading audio: $e');
        }
      }
      for (final audioPlayer in audioPlayers) {
        audioPlayer.setLoopMode(LoopMode.all);
      }
    } catch (e) {
      print('Error loading audio: $e');
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Select Timer Duration',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 10.0),
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
              SizedBox(height: 10.0),
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
          padding: EdgeInsets.all(16.0),
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/1.jpeg'),
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
                _buildTabBar(),
                Expanded(
                  child: _buildTabViews(),
                ),
              ],
            ),
            _buildPlayerController(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 4),
      child: TabBar(
        physics: const BouncingScrollPhysics(),
        indicatorPadding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        controller: _tabController,
        indicatorColor: Colors.green,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Color.fromARGB(255, 0, 104, 125),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
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
              border: GradientBoxBorder(
                  width: 4,
                  gradient: LinearGradient(colors: [
                    Colors.green,
                    Color.fromARGB(255, 0, 104, 125),
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
      ),
    );
  }

  Widget _buildTabViews() {
    return TabBarView(
      controller: _tabController,
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
          physics: BouncingScrollPhysics(),
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
          physics: BouncingScrollPhysics(),
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
              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 25; i < 29; i++)
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
                  for (int i = 29; i < 30; i++)
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
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 30; i < 34; i++)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(),
                  for (int i = 39; i < 40; i++)
                    _buildAudioControl(
                      icon: audioIcons[i],
                      label: audioNames[i],
                      audioPlayer: audioPlayers[i],
                      volume: volumes[i],
                    ),
                ],
              ),
              SizedBox(
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
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: audioPlayer.playing
              ? Colors.green
              : Color.fromARGB(255, 0, 104, 125),
        ),
        child: InkWell(
          onTap: () {
            _toggleAudioPlayback(audioPlayer);
          },
          customBorder: CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 54, child: icon),
              Text(
                label,
                style: TextStyle(
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
          SnackBar(
            content: Text('Only 8 audios can be played at a time.'),
          ),
        );
        return;
      }

      Future.delayed(Duration(milliseconds: 100), () {
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
        SnackBar(
          content: Text('No sounds are playing.'),
        ),
      );
    }

    setState(() {});
    print('Sounds Stopped');
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
            style: TextStyle(color: Colors.black),
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
    bool _isAudioPlaying = false;
    for (final audioPlayer in audioPlayers) {
      if (audioPlayer.playing) {
        _isAudioPlaying = true;
        break;
      }
    }
    return Visibility(
      visible: _isAudioPlaying,
      child: Positioned(
        // bottom: 70,
        bottom: MediaQuery.of(context).size.height * 0.09,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 64,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: GradientBoxBorder(
                  width: 4,
                  gradient: LinearGradient(colors: [
                    Colors.green,
                    Color.fromARGB(255, 0, 104, 125),
                  ])),
              // border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  icon: Icon(
                    Iconsax.timer,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () => _stopPlayingSounds(audioPlayers),
                  icon: Icon(
                    Iconsax.stop,
                    color: Colors.white,
                    size: 30,
                  )),
              IconButton(
                onPressed: () => _volumeAll(context),
                icon: Stack(
                  children: [
                    Icon(
                      Iconsax.volume_up,
                      color: Colors.white,
                      size: 30,
                    ),
                    if (_countPlayingAudios(audioPlayers) > 0)
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
                              _countPlayingAudios(audioPlayers).toString(),
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
