import 'dart:ui';
import 'package:aura/data/songs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';

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
  bool _isPlaying = false;

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
        setState(() {
          _isPlaying = _audioPlayer.playing;
        });

        if (processingState == ProcessingState.completed) {
          _playNext();
        }
      });
    }
  }

  void _playNext() {
    if (widget.songs.isNotEmpty && _currentIndex < widget.songs.length - 1) {
      _currentIndex++;
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
    print(
        "Songs length: ${widget.songs.length}, Current Index: $_currentIndex");

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
                                widget.songs[_currentIndex].imageUrl),
                            fit: BoxFit.cover)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.14,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width - 50,
                          fit: BoxFit.cover,
                          imageUrl: widget.songs[_currentIndex].imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.songs[_currentIndex].songName,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.songs[_currentIndex].artist,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      // Slider will come here
                      StreamBuilder<Duration>(
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
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 8.0),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 16.0),
                                  valueIndicatorShape:
                                      PaddleSliderValueIndicatorShape(),
                                  valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Slider(
                                  value: position.inSeconds.toDouble(),
                                  max: duration.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    _audioPlayer
                                        .seek(Duration(seconds: value.toInt()));
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 20),
                      // Next/Previous button will come here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
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
                            icon: Icon(
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
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                IconlyBold.heart,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            : Container(
                child: Text(
                  'No song available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
