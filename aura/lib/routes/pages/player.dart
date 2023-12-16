import 'package:aura/data/songs.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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

    if (widget.songs.isNotEmpty) {
      _initializePlayer();
      _audioPlayer.play(); // Play the audio automatically
    }
  }

  void _initializePlayer() {
    if (_currentIndex >= 0 && _currentIndex < widget.songs.length) {
      _audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);

      _audioPlayer.processingStateStream.listen((processingState) {
        setState(() {
          _isPlaying = _audioPlayer.playing;
        });

        if (processingState == ProcessingState.completed) {
          // The current song has ended, play the next one
          _playNext();
        }
      });
    }
  }

  void _playNext() {
    if (widget.songs.isNotEmpty && _currentIndex < widget.songs.length - 1) {
      _currentIndex++;
      _audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);
      _audioPlayer.play();
    }
  }

  void _playPrevious() {
    if (widget.songs.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      _audioPlayer.setUrl(widget.songs[_currentIndex].songUrl);
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
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
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _audioPlayer.duration ?? Duration.zero;

                      return Column(
                        children: [
                          Text(
                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Slider(
                            value: position.inSeconds.toDouble(),
                            max: duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              _audioPlayer
                                  .seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ],
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
                        icon: Icon(_audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow),
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
