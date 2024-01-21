import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:palette_generator/palette_generator.dart';

class LivePage extends StatefulWidget {
  final int currentIndex;
  final String title;
  final List<String> songs;
  final List<String> imageUrl;
  final List<String> soundNames;

  const LivePage({
    required this.currentIndex,
    required this.songs,
    required this.title,
    required this.imageUrl,
    required this.soundNames,
    Key? key,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  bool _isRepeatOn = true;
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
            CachedNetworkImageProvider(widget.imageUrl[_currentIndex]));
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color;
    });
  }

  void _initializePlayer() {
    if (_currentIndex >= 0 && _currentIndex < widget.songs.length) {
      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex]);

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
      if (_currentIndex < widget.songs.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex]);
      _audioPlayer.play();
      _loadDominantColor();
    }
  }

  void _playPrevious() {
    if (widget.songs.isNotEmpty && _currentIndex > 0) {
      _currentIndex--;
      _audioPlayer.dynamicSet(
          pushIfNotExisted: true, url: widget.songs[_currentIndex]);
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

  void _showPlaylist() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Music Playlist',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(widget.imageUrl[index]),
                      ),
                      title: Text(
                        widget.soundNames[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _playSong(index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _playSong(int index) {
    _currentIndex = index;
    _audioPlayer.dynamicSet(
      pushIfNotExisted: true,
      url: widget.songs[_currentIndex],
    );
    _audioPlayer.play();
    _loadDominantColor();
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
            child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.imageUrl[_currentIndex],
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
                  height: MediaQuery.of(context).size.height * 0.08,
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
                  widget.title,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: MediaQuery.of(context).size.width - 74,
                    fit: BoxFit.cover,
                    imageUrl: widget.imageUrl[_currentIndex],
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
                              widget.soundNames[_currentIndex],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
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
                          _audioPlayer.playing ? Iconsax.pause : Iconsax.play,
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
                      IconButton(
                        onPressed: _showTimerDialog,
                        icon: const Icon(
                          Iconsax.timer_1,
                          color: Colors.white,
                          // size: 30,
                        ),
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
              ],
            ),
            Positioned(
              top: 50,
              right: 10,
              child: IconButton(
                icon: Icon(
                  Iconsax.music_playlist,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: _showPlaylist,
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Iconsax.close_circle,
                  color: Colors.white,
                  size: 34,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
