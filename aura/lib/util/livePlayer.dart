import 'dart:async';
import 'dart:ui';
import 'package:aura/data/live_songs.dart';
import 'package:aura/util/visualizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:palette_generator/palette_generator.dart';

class AuraLivePlayer extends StatefulWidget {
  final int currentIndex;
  final List<LiveSongs> songs;

  const AuraLivePlayer({
    required this.currentIndex,
    required this.songs,
    Key? key,
  }) : super(key: key);

  @override
  State<AuraLivePlayer> createState() => _AuraLivePlayerState();
}

class _AuraLivePlayerState extends State<AuraLivePlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  Color? dominantColor;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    if (widget.songs.isNotEmpty) {
      _initializePlayer();
      _audioPlayer.play();
    }
    _loadDominantColor();
  }

  Future<void> _loadDominantColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(widget.songs[_currentIndex].imageUrl));
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color;
    });
  }

  void _initializePlayer() {
    if (_currentIndex >= 0 && _currentIndex < widget.songs.length) {
      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);

      _audioPlayer.processingStateStream.listen((processingState) {
        setState(() {});

        if (processingState == ProcessingState.completed) {
          _playNext();
        }
      });
    }
  }

  void _playNext() {
    if (widget.songs.isNotEmpty) {
      if (_currentIndex < widget.songs.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
        _audioPlayer.stop();
      }

      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);
      _audioPlayer.play();
      _loadDominantColor();
    }
  }

  void _playPrevious() {
    if (widget.songs.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);
      _audioPlayer.play();
      _loadDominantColor();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Timer? _timer;

  Future<void> _showTimerDialog() async {
    int? selectedTime;

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
            style: GoogleFonts.inter(fontSize: 18, color: Colors.white),
          ),
          content: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width - 100,
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: timerOptions
                  .map((option) => ElevatedButton(
                        onPressed: () {
                          selectedTime = option['duration'];
                          Navigator.of(context).pop(selectedTime);
                        },
                        style: ButtonStyle(
                          backgroundColor: (selectedTime == option['duration'])
                              ? MaterialStateProperty.all(Color(0xFF131321))
                              : MaterialStateProperty.all(Colors.grey[800]),
                        ),
                        child: Text(
                          option['label'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selectedTime != null) {
      _stopTimer();
      _startTimer(selectedTime!);
    }
  }

  void _startTimer(int durationInSeconds) {
    _timer = Timer(Duration(seconds: durationInSeconds), () {
      _audioPlayer.stop();
      setState(() {});
    });

    setState(() {});
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            _playPrevious();
          } else if (details.primaryVelocity! < 0) {
            _playNext();
          }
        },
        child: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.songs[_currentIndex].imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.08,
                  ),
                  Text(
                    'Playing From',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'widget.title',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.06,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      height: screenHeight * 0.38,
                      width: screenWidth - 74,
                      fit: BoxFit.cover,
                      imageUrl: widget.songs[_currentIndex].imageUrl,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ListTile(
                            title: Text(
                              widget.songs[_currentIndex].songName,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                            subtitle: Text(
                              widget.songs[_currentIndex].artist,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: StreamBuilder<Duration>(
                            stream: _audioPlayer.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              final duration =
                                  _audioPlayer.duration ?? Duration.zero;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor:
                                          dominantColor ?? Colors.blue,
                                      inactiveTrackColor: Colors.grey,
                                      thumbColor: Colors.white,
                                      overlayColor:
                                          Colors.blue.withOpacity(0.3),
                                      valueIndicatorColor: Colors.blue,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 8.0),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                              overlayRadius: 16.0),
                                      valueIndicatorShape:
                                          const PaddleSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Slider(
                                      value: position.inSeconds.toDouble(),
                                      max: duration.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        _audioPlayer.seek(
                                            Duration(seconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                  // Next/Previous button will come here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Iconsax.previous,
                          size: 38,
                          color: Colors.white,
                        ),
                        onPressed: _playPrevious,
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _audioPlayer.playing ? Iconsax.pause : Iconsax.play,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_audioPlayer.playing) {
                              _audioPlayer.pause();
                            } else {
                              _audioPlayer.play();
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Iconsax.next,
                          size: 38,
                          color: Colors.white,
                        ),
                        onPressed: _playNext,
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: screenHeight * 0.04,
                // right: screenWidth * 0.04,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _showTimerDialog,
                        icon: const Icon(
                          Iconsax.timer_1,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.share,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.08,
                right: screenWidth * 0.04,
                child: IconButton(
                  icon: Icon(
                    Iconsax.setting_5,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: (() =>
                      Get.to(GlowingBalls(), transition: Transition.fadeIn)),
                ),
              ),
              Positioned(
                top: screenHeight * 0.08,
                left: screenWidth * 0.04,
                child: IconButton(
                  icon: Icon(
                    Iconsax.close_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: (() => Navigator.pop(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
