import 'package:aura/test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AuraHomePage extends StatefulWidget {
  final ScrollController controller;

  const AuraHomePage({required this.controller, Key? key}) : super(key: key);

  @override
  State<AuraHomePage> createState() => _AuraHomePageState();
}

class _AuraHomePageState extends State<AuraHomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late TabController _tabController;

  int index = 0;
  List<String> kImages = [
    'assets/slider/1.jpg',
    'assets/slider/2.jpg',
    'assets/slider/3.jpg',
    'assets/slider/4.jpg',
    'assets/slider/5.jpg',
    'assets/slider/6.jpg'
  ];

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((PlayerState state) {
      setState(() {
        isPlaying = _audioPlayer.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      greeting,
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "XD",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        height: MediaQuery.of(context).size.height * 0.4,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                        enlargeFactor: 0.3,
                        padEnds: false,
                        reverse: false,
                      ),
                      items: kImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        String imageUrl = entry.value;

                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(imageUrl),
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Text(
                    'Focus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('songs').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        var songs = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            var songData =
                                songs[index].data() as Map<String, dynamic>;

                            return ListTile(
                              title: Text(
                                songData['songName'],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(songData['artist']),
                              leading: CachedNetworkImage(
                                width: 64,
                                fit: BoxFit.cover,
                                imageUrl: songData['imageUrl'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              onTap: () {
                                _playAudio(songData['songUrl']);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isPlaying)
              Positioned(
                bottom: 75,
                left: 45,
                right: 45,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 64,
                  decoration: BoxDecoration(
                      // color: Colors.transparent,
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 80, 218, 243),
                        Color.fromARGB(255, 12, 26, 176),
                        Colors.purple,
                        Color.fromARGB(255, 232, 52, 88),
                      ]),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: _audioPlayer.playing
                            ? const Icon(
                                Icons.pause,
                                size: 34,
                              )
                            : const Icon(
                                Icons.play_arrow,
                                size: 34,
                              ),
                        onPressed: () {
                          if (_audioPlayer.playing) {
                            _audioPlayer.pause();
                          } else {
                            // Handle the logic to play the audio
                            _audioPlayer.play();
                          }
                        },
                      ),
                      // Add other player controls as needed
                      // For example, add a seek bar, volume control, etc.
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _playAudio(String audioUrl) async {
    try {
      await _audioPlayer.dynamicSet(pushIfNotExisted: true, url: audioUrl);

      await _audioPlayer.play();

      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
}
