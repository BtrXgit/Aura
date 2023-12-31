import 'dart:ui';
import 'package:aura/composer_test.dart';
import 'package:aura/data/songs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'dart:math';

class LivePage extends StatefulWidget {
  final int currentIndex;
  final List<Song> songs;

  const LivePage({
    required this.currentIndex,
    required this.songs,
    Key? key,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    if (widget.songs.isNotEmpty) {
      _initializePlayer();
      _audioPlayer.play();
    }
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
        // If we reached the end, stop playing
        _audioPlayer.stop();
        return;
      }

      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);
      _audioPlayer.play();
    }
  }

  void _playPrevious() {
    if (widget.songs.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex].songUrl);
      _audioPlayer.play();
    }
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
      body: Center(
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
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
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
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                IconlyLight.heart,
                                color: Colors.white,
                                size: 28,
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
                                    activeTrackColor: Colors.blue,
                                    inactiveTrackColor: Colors.grey,
                                    thumbColor: Colors.blue,
                                    overlayColor: Colors.blue.withOpacity(0.3),
                                    valueIndicatorColor: Colors.blue,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 8.0),
                                    overlayShape: const RoundSliderOverlayShape(
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
                      const SizedBox(height: 50),
                      // Next/Previous button will come here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              size: 34,
                              color: Colors.white,
                            ),
                            onPressed: _playPrevious,
                          ),
                          IconButton(
                            icon: Icon(
                              _audioPlayer.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 34,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (_audioPlayer.playing) {
                                _audioPlayer.pause();
                              } else {
                                _audioPlayer.play();
                              }
                              setState(() {
                                // Updating the state to trigger a rebuild to change the icon
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              size: 34,
                              color: Colors.white,
                            ),
                            onPressed: _playNext,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 50,
                    left: 10,
                    child: IconButton(
                      icon: Icon(IconlyBold.setting, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 10,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              )
            : const Text(
                'No song available',
                style: TextStyle(color: Colors.white),
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
}
