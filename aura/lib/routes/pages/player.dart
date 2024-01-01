import 'dart:ui';
import 'package:aura/composer_test.dart';
import 'package:aura/data/songs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'dart:math';

import 'package:palette_generator/palette_generator.dart';

class AuraPlayer extends StatefulWidget {
  final int currentIndex;
  final List<Song> songs;

  const AuraPlayer({
    required this.currentIndex,
    required this.songs,
    Key? key,
  }) : super(key: key);

  @override
  State<AuraPlayer> createState() => _AuraPlayerState();
}

class _AuraPlayerState extends State<AuraPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
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

  // void _initializePlayer() {
  //   if (_currentIndex >= 0 && _currentIndex < widget.songs.length) {
  //     _audioPlayer.dynamicSet(
  //         pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);

  //     _audioPlayer.processingStateStream.listen((processingState) {
  //       setState(() {});

  //       if (processingState == ProcessingState.completed) {
  //         if (_isRepeatOn) {
  //           // If repeat is on, seek to the beginning of the current song
  //           _audioPlayer.seek(Duration.zero);
  //         } else {
  //           _playNext();
  //         }
  //       }
  //     });
  //   }
  // }

  // void _playNext() {
  //   if (widget.songs.isNotEmpty) {
  //     if (_isShuffleOn) {
  //       _currentIndex = Random().nextInt(widget.songs.length);
  //     } else {
  //       if (_currentIndex < widget.songs.length - 1) {
  //         _currentIndex++;
  //       } else {
  //         if (_isRepeatOn) {
  //           // If repeat is on and we reached the end, go back to the first song
  //           _currentIndex = 0;
  //         } else {
  //           // If repeat is off, stop playing
  //           _audioPlayer.stop();
  //           return;
  //         }
  //       }
  //     }

  //     _audioPlayer.dynamicSet(
  //         pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);
  //     _audioPlayer.play();
  //   }
  // }

  void _initializePlayer() {
    if (_currentIndex >= 0 && _currentIndex < widget.songs.length) {
      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);

      _audioPlayer.processingStateStream.listen((processingState) {
        setState(() {});

        if (processingState == ProcessingState.completed) {
          if (_isRepeatOn) {
            _audioPlayer.seek(Duration.zero);
          } else {
            _playNext();
          }
        }
      });
    }
  }

  void _playNext() {
    if (widget.songs.isNotEmpty) {
      if (_isShuffleOn) {
        _currentIndex = Random().nextInt(widget.songs.length);
      } else {
        if (_currentIndex < widget.songs.length - 1) {
          _currentIndex++;
        } else {
          if (_isRepeatOn) {
            _currentIndex = 0;
          } else {
            _currentIndex = 0;
            _audioPlayer.stop();
          }
        }
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

  Future<void> _loadDominantColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(widget.songs[_currentIndex].imageUrl));
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: widget.songs.isNotEmpty &&
                  _currentIndex >= 0 &&
                  _currentIndex < widget.songs.length
              ? Stack(
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
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                        Text(
                          'Playing From Playlist',
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Focus',
                          style: GoogleFonts.openSans(
                              color: Colors.white, fontSize: 14),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.38,
                            width: MediaQuery.of(context).size.width - 74,
                            fit: BoxFit.cover,
                            imageUrl: widget.songs[_currentIndex].imageUrl,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.songs[_currentIndex].songName,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.songs[_currentIndex].artist,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 44,
                                height: 44,
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
                                  onPressed: () {},
                                  icon: const Icon(
                                    IconlyLight.heart,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Slider will come here
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
                        const SizedBox(height: 20),
                        // Next/Previous button will come here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Iconsax.previous,
                                size: 34,
                                color: Colors.white,
                              ),
                              onPressed: _playPrevious,
                            ),
                            Container(
                              width: 64,
                              height: 64,
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
                                  _audioPlayer.playing
                                      ? Iconsax.pause
                                      : Iconsax.play,
                                  size: 34,
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
                                size: 34,
                                color: Colors.white,
                              ),
                              onPressed: _playNext,
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Iconsax.shuffle,
                                      color: _isShuffleOn
                                          ? dominantColor ?? Colors.blue
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isShuffleOn = !_isShuffleOn;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Iconsax.repeat,
                                      color: _isRepeatOn
                                          ? dominantColor ?? Colors.blue
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isRepeatOn = !_isRepeatOn;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Iconsax.share,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       IconButton(
                        //         onPressed: () {},
                        //         icon: const Icon(
                        //           IconlyBold.heart,
                        //           color: Colors.white,
                        //           size: 30,
                        //         ),
                        //       ),
                        //       IconButton(
                        //         onPressed: () {},
                        //         icon: const Icon(
                        //           Icons.share,
                        //           color: Colors.white,
                        //           size: 30,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                    Positioned(
                      top: 50,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Iconsax.setting_3, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Iconsax.music_playlist,
                            color: Colors.white),
                        onPressed: () {
                          _showQueue(context);
                        },
                      ),
                    ),
                  ],
                )
              : const Text(
                  'No song available',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget _openComposer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width - 50,
      child: AuraComposerTest(),
    );
  }

  void _showQueue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: widget.songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  imageUrl: widget.songs[index].imageUrl,
                ),
              ),
              title: Text(widget.songs[index].songName),
              subtitle: Text(widget.songs[index].artist),
              onTap: () {
                _currentIndex = index;
                _audioPlayer.dynamicSet(
                  pushIfNotExisted: true,
                  url: widget.songs[_currentIndex].songUrl,
                );
                _audioPlayer.play();
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
