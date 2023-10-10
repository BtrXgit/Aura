import 'dart:async';
import 'dart:ui';

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

class _CustomMixinState extends State<CustomMixin>
    with SingleTickerProviderStateMixin {
  int playingAudioCount = 0;

  List<ValueNotifier<double>> volumes =
      List.generate(12, (_) => ValueNotifier<double>(0.5));

  late TabController _tabController;
  final List<String> data = ["Nature", "Music"];

  final List<AudioPlayer> audioPlayers =
      List.generate(12, (index) => AudioPlayer());

  int selectedTimerDuration = 0;

  Timer? audioTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    //music
    'assets/music/harp.ogg',
    'assets/music/piano.ogg',
    'assets/music/piano_2.ogg',
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
    //music
    'Harp',
    'Piano',
    'Piano 2',
  ];

  Future<void> _loadAudios() async {
    try {
      for (int i = 0; i < audioPlayers.length && i < audioPaths.length; i++) {
        await audioPlayers[i].setAsset(audioPaths[i]);
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
              _buildTimerOption(300, '5 Minutes'),
              _buildTimerOption(600, '10 Minutes'),
              _buildTimerOption(1800, '30 Minutes'),
              _buildTimerOption(3600, '1 Hour'),
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
                      image: NetworkImage(
                          'https://i.pinimg.com/564x/2c/7a/bc/2c7abc11e0b17414d26b1bb79ea614d8.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                    ),
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
      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: TabBar(
        physics: const BouncingScrollPhysics(),
        controller: _tabController,
        indicator: const BoxDecoration(
          color: Colors.transparent,
          border:
              Border(bottom: BorderSide(color: Colors.transparent, width: 0)),
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.secondary,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
        tabs: data.map((tab) {
          return Tab(
            child: Text(
              tab,
              style: TextStyle(fontSize: 14, color: Colors.white),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(),
              for (int i = 9; i < 12; i++)
                _buildAudioControl(
                  label: audioNames[i],
                  audioPlayer: audioPlayers[i],
                  volume: volumes[i],
                ),
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
  }) {
    return Expanded(
      child: Container(
        // width: 74,
        // height: 74,
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: audioPlayer.playing
              ? Colors.green
              : Color.fromARGB(255, 125, 0, 0),
        ),
        child: InkWell(
          onTap: () {
            _toggleAudioPlayback(audioPlayer);
          },
          customBorder: CircleBorder(),
          child: Column(
            children: [
              Icon(
                Icons.play_arrow,
                size: 40,
                color: Color.fromARGB(255, 255, 98, 98),
              ),
              Text(
                label,
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 93, 93),
                    fontWeight: FontWeight.bold),
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
      playingAudioCount--;
    } else {
      if (playingAudioCount >= 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Only 8 audios can played at a time.'),
          ),
        );
        return;
      }
      audioPlayer.play();
      playingAudioCount++;
    }
    setState(() {});
  }

  void _stopPlayingSounds(List<AudioPlayer> audioPlayers) {
    for (final audioPlayer in audioPlayers) {
      if (audioPlayer.playing) {
        audioPlayer.pause();
        playingAudioCount--;
      }
    }

    if (audioTimer != null) {
      audioTimer!.cancel();
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
            style: TextStyle(color: Colors.white),
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
    return Positioned(
      // bottom: 70,
      bottom: MediaQuery.of(context).size.height * 0.09,
      left: 10,
      right: 10,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  _showBottomSheet(context);
                },
                icon: Icon(Icons.timer)),
            IconButton(
                onPressed: () => _stopPlayingSounds(audioPlayers),
                icon: Icon(Icons.stop_circle_outlined)),
            IconButton(
              onPressed: () => _volumeAll(context),
              icon: Stack(
                children: [
                  Icon(Icons.volume_up_outlined),
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
