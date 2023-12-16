import 'package:aura/data/songs.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AuraPlayer extends StatefulWidget {
  final int currentIndex;
  final List<Song> songs;
  final Function(String songName, String artistName) updateOverlay;
  final AudioPlayer audioPlayer;

  const AuraPlayer({
    required this.currentIndex,
    required this.songs,
    required this.updateOverlay,
    required this.audioPlayer,
    Key? key,
  }) : super(key: key);

  @override
  State<AuraPlayer> createState() => _AuraPlayerState();
}

class _AuraPlayerState extends State<AuraPlayer> {
  int _currentIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    if (widget.songs.isNotEmpty) {
      _currentIndex = widget.currentIndex;
      _initializePlayer();
      widget.audioPlayer.play(); // Play the audio automatically
    }
  }

  void _initializePlayer() {
    if (_currentIndex >= 0 && _currentIndex < widget.songs.length) {
      widget.audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);

      widget.audioPlayer.processingStateStream.listen((processingState) {
        setState(() {
          _isPlaying = widget.audioPlayer.playing;
        });

        if (processingState == ProcessingState.completed) {
          _playNext();
        }

        if (processingState == ProcessingState.ready &&
            widget.audioPlayer.playing) {
          widget.updateOverlay(
            widget.songs[_currentIndex].songName,
            widget.songs[_currentIndex].artist,
          );
        }
      });
    }
  }

  void _playNext() {
    if (widget.songs.isNotEmpty && _currentIndex < widget.songs.length - 1) {
      _currentIndex++;
      widget.audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);
      widget.audioPlayer.play();
    }
  }

  void _playPrevious() {
    if (widget.songs.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      widget.audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);
      widget.audioPlayer.play();
    }
  }

  void skipNext() {
    if (widget.audioPlayer.playing) {
      widget.audioPlayer.stop();
    }

    if (_currentIndex < widget.songs.length - 1) {
      setState(() {
        _currentIndex++;
      });
      widget.audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);
      widget.audioPlayer.play();
    }
  }

  void skipPrevious() {
    if (widget.audioPlayer.playing) {
      widget.audioPlayer.stop();
    }

    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      widget.audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);
      widget.audioPlayer.play();
    }
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
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    widget.songs[_currentIndex].imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
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
                    stream: widget.audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return Slider(
                        value: position.inSeconds.toDouble(),
                        max:
                            widget.audioPlayer.duration?.inSeconds.toDouble() ??
                                0,
                        onChanged: (value) {
                          widget.audioPlayer
                              .seek(Duration(seconds: value.toInt()));
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Play/Pause button will come here

                  SizedBox(height: 20),
                  // Next/Previous button will come here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: _playPrevious,
                      ),
                      IconButton(
                        icon: Icon(widget.audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          if (widget.audioPlayer.playing) {
                            widget.audioPlayer.pause();
                          } else {
                            widget.audioPlayer.play();
                          }
                          setState(() {
                            // Updating the state to trigger a rebuild to change the icon
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: _playNext,
                      ),
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
