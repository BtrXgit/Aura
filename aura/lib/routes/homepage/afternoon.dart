import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/live/live.dart';
import 'package:aura/routes/pages/player.dart';
import 'package:aura/routes/tweaks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AuraHomePageAfternoon extends StatefulWidget {
  final ScrollController controller;

  const AuraHomePageAfternoon({required this.controller, Key? key})
      : super(key: key);

  @override
  State<AuraHomePageAfternoon> createState() => _AuraHomePageAfternoonState();
}

class _AuraHomePageAfternoonState extends State<AuraHomePageAfternoon>
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

  final List<Color> itemColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.yellow,
    Colors.pink,
    Colors.indigo,
    Colors.brown,
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
    fetchUserProfileData();
  }

  String? userName;
  String? userPhotoUrl;
  Future<void> fetchUserProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userName = user.displayName;
        userPhotoUrl = user.photoURL;
      });
    }
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

  String _getImageAsset(String greeting) {
    switch (greeting) {
      case 'Good Morning':
        return 'assets/morning.jpg';
      case 'Good Afternoon':
        return 'assets/afternoon.jpg';
      case 'Good Evening':
        return 'assets/evening.jpg';
      case 'Good Night':
        return 'assets/night.jpg';
      default:
        return 'assets/morning.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final backgroundImage = _getImageAsset(greeting);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 3, 31),
      body: NestedScrollView(
        controller: widget.controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              forceMaterialTransparency: false,
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              floating: true,
              pinned: true,
              backgroundColor: const Color.fromARGB(255, 14, 3, 31),
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double offset = constraints.biggest.height;
                bool isAppBarExpanded = offset > 100;

                return FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  title: isAppBarExpanded
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Explore',
                              style: GoogleFonts.caveat(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // ElevatedButton(
                            //     onPressed: () {}, child: Text('Live'))
                            Container(
                              width: 70,
                              height: 34,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Live ",
                                  style: GoogleFonts.openSans(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting,
                                style: GoogleFonts.dancingScript(
                                  //lobster  // carattere  //dancing script
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$userName',
                                style: GoogleFonts.openSans(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    IconlyBold.bookmark,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(
                                      () => SettingsPage(
                                            controller: widget.controller,
                                          ),
                                      transition:
                                          Transition.rightToLeftWithFade),
                                  child: (userPhotoUrl != null)
                                      ? SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              userPhotoUrl!,
                                            ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: Colors.blue,
                                          size: 28,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ];
        },
        body: _buildContentColumn(),
      ),
    );
  }

  Widget _buildContentColumn() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 8.0),
            child: GestureDetector(
              onTap: () => Get.to(
                () => LivePage(
                  currentIndex: 0,
                  songs: songs,
                ),
                transition: Transition.downToUp,
              ),
              child: Text(
                'Live',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: GestureDetector(
              onTap: () => Get.to(
                () => LivePage(
                  currentIndex: 0,
                  songs: songs,
                ),
                transition: Transition.downToUp,
              ),
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Focus',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildDummyCategory(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Relaxing',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDummyCategory(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Devotional',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDummyCategory(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Chill Beats 🤙🏝️',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildDummyCategory(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'LoFi - Hip Hop',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildDummyCategory(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'LoFi - Jazz',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildDummyCategory(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'LoFi - Dream Pop',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildDummyCategory(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildDummyCategory() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        bottom: 20,
      ),
      child: SizedBox(
        height: 250,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.2,
          ),
          itemCount: songs.length,
          itemBuilder: (BuildContext context, int index) {
            var song = songs[index];
            return GestureDetector(
              onTap: () => Get.to(
                AuraPlayer(
                  currentIndex: index,
                  songs: songs,
                ),
                transition: Transition.downToUp,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(song.imageUrl),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(14)),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 13, 12, 53),
                        ),
                        child: ListTile(
                          title: Text(
                            song.songName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(song.artist),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(
                        IconlyBold.bookmark,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
