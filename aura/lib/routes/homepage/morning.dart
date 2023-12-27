import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AuraHomePageMorning extends StatefulWidget {
  final ScrollController controller;

  const AuraHomePageMorning({required this.controller, Key? key})
      : super(key: key);

  @override
  State<AuraHomePageMorning> createState() => _AuraHomePageMorningState();
}

class _AuraHomePageMorningState extends State<AuraHomePageMorning>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int index = 0;
  List<Song> songs = [];
  List<Song> songstest = [];

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
    _getFocusData().listen((snapshot) {
      setState(() {
        songs = snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
      });
    });
    _getRelaxingData().listen((snapshot) {
      setState(() {
        songstest =
            snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
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

  Stream<QuerySnapshot> _getFocusData() {
    return _firestore.collection('songs').snapshots();
  }

  Stream<QuerySnapshot> _getRelaxingData() {
    return _firestore.collection('songtest').snapshots();
  }

  Widget _buildSongList(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          var song = songs[index];

          return ListTile(
            title: Text(
              song.songName,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(song.artist),
            leading: CachedNetworkImage(
              width: 64,
              fit: BoxFit.cover,
              imageUrl: song.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            onTap: () => Get.to(
              AuraPlayer(
                currentIndex: index,
                songs: songs,
              ),
              transition: Transition.fadeIn,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongtestList(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: songstest.length,
        itemBuilder: (context, index) {
          var song = songstest[index];

          return ListTile(
            title: Text(
              song.songName,
              style: const TextStyle(color: Colors.white),
            ),
            leading: CachedNetworkImage(
              width: 64,
              fit: BoxFit.cover,
              imageUrl: song.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // onTap: () {
            //   _playAudio(song.songUrl);
            // },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 3, 31),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: widget.controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                    child: Text(
                      greeting,
                      style: GoogleFonts.dancingScript(
                          //lobster  // carattere  //dancing script
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Yogi",
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
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
                  const Text(
                    'Focus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  _buildSongList(context),
                  const Text(
                    'Relaxing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  _buildSongtestList(context),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            if (isPlaying)
              Positioned(
                bottom: 80,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () => _audioPlayer.stop(),
                  child: const Icon(
                    Icons.stop,
                    size: 34,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Future<void> _playAudio(String audioUrl) async {
  //   try {
  //     await _audioPlayer.dynamicSet(pushIfNotExisted: true, url: audioUrl);
  //     await _audioPlayer.play();

  //     setState(() {
  //       isPlaying = true;
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error playing audio: $e");
  //     }
  //   }
  // }
}
