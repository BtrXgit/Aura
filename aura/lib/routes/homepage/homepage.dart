import 'package:aura/routes/pages/sounds/recommended_sounds.dart';
import 'package:aura/routes/tweaks.dart';
import 'package:aura/routes/pages/playlists/playlists.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuraHomePage extends StatefulWidget {
  final ScrollController controller;

  const AuraHomePage({required this.controller, Key? key}) : super(key: key);

  @override
  State<AuraHomePage> createState() => _AuraHomePageState();
}

class _AuraHomePageState extends State<AuraHomePage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  Set<String> favoriteSongs = Set<String>();

  @override
  void initState() {
    super.initState();
    fetchUserProfileData();
    _loadFavoriteSongs();
  }

  Future<void> _loadFavoriteSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> favorites =
        prefs.getStringList('favorites')?.toSet() ?? Set<String>();
    setState(() {
      favoriteSongs = favorites;
    });
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

  List<String> recommendedImageUrl = [
    'https://i.pinimg.com/564x/a5/ba/00/a5ba003ca05f2646b8c2735ac0b6e3d9.jpg',
    'https://i.pinimg.com/736x/7e/bb/a1/7ebba1c8f506046205f223e7f4477994.jpg',
    'https://i.pinimg.com/564x/6d/b2/d4/6db2d4c4c456211650429781a47ee95b.jpg',
    'https://i.pinimg.com/564x/75/50/0b/75500bd88c86833f3c64b769d5d197de.jpg',
    'https://i.pinimg.com/564x/b6/31/84/b631841cb3a29e6f7be99c5ec0bca1d0.jpg',
  ];
  List<String> recommendedSoundes = [
    'Ocean Waves',
    'Birdsong',
    'Soft Piano',
    'Harp',
    'Bonfire',
  ];

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
    return Scaffold(
      backgroundColor: Color(0xFF131321),
      body: _buildContentColumn(),
    );
  }

  Widget _buildContentColumn() {
    final greeting = _getGreeting();
    final backgroundImage = _getImageAsset(greeting);
    return SingleChildScrollView(
      controller: widget.controller,
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                              transition: Transition.rightToLeftWithFade),
                          child: (userPhotoUrl != null)
                              ? SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage: CachedNetworkImageProvider(
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 8.0),
            child: Text(
              'Recommended',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: recommendedSoundes.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext, int) {
                if (int == recommendedSoundes.length) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(RecommendedSoundsPage());
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 18),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F36),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'See More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return _recommendedContainer(
                      soundsName: recommendedSoundes[int],
                      imageLink: recommendedImageUrl[int]);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 8.0),
            child: Text(
              'Live Radios',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: CarouselSlider(
              options: CarouselOptions(
                scrollPhysics: const ClampingScrollPhysics(),
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Relaxing',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
              onTap: () => Get.to(PlaylistsPage(
                    category: 'relaxing',
                  )),
              child: _buildDummyCategory(
                  imageLink:
                      'https://i.pinimg.com/564x/44/71/a8/4471a8ddace0be709396f797b1e89729.jpg')),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Focus',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(PlaylistsPage(
              category: 'focus',
            )),
            child: _buildDummyCategory(
                imageLink:
                    'https://i.pinimg.com/564x/41/59/e2/4159e2b7160850b7051fe7d91ce674dc.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Calm & Cozy',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(PlaylistsPage(
              category: 'calm and cozy',
            )),
            child: _buildDummyCategory(
                imageLink:
                    'https://i.pinimg.com/564x/47/16/03/471603819ac91c1c73d947ada797bf07.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'Synthwave/Chillwave',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(PlaylistsPage(
              category: 'chillwave',
            )),
            child: _buildDummyCategory(
                imageLink:
                    'https://i.pinimg.com/564x/6f/a2/6e/6fa26eb2b9bf7fbd32671d3617a9a3fd.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'LoFi - Sad',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(PlaylistsPage(
              category: 'lofi sad',
            )),
            child: _buildDummyCategory(
                imageLink:
                    'https://i.pinimg.com/564x/91/53/57/91535759da1d41ec29fe4c9c1f3fc3b0.jpg'),
          ),
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
          GestureDetector(
            onTap: () => Get.to(PlaylistsPage(
              category: 'lofi hiphop',
            )),
            child: _buildDummyCategory(
                imageLink:
                    'https://i.pinimg.com/564x/9e/00/71/9e0071917b7fcc601f24c058de09c221.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Text(
              'ChillDrive',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildDummyCategory(
              imageLink:
                  'https://i.pinimg.com/564x/d8/b2/7f/d8b27f84e75c359d0c786890f6f1dac3.jpg'),
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
          _buildDummyCategory(
              imageLink:
                  'https://i.pinimg.com/564x/7b/87/0e/7b870ec101537650c42c5b169f9ee186.jpg'),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 8.0),
            child: Text(
              'Noises',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: recommendedSoundes.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext, int) {
                if (int == recommendedSoundes.length) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(RecommendedSoundsPage());
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'See More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return _recommendedContainer(
                      soundsName: recommendedSoundes[int],
                      imageLink: recommendedImageUrl[int]);
                }
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _recommendedContainer({
    required String soundsName,
    required String imageLink,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 18),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(imageLink),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high),
                  borderRadius: BorderRadius.circular(14)),
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Icon(
                IconlyBold.play,
                size: 32,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 18, top: 4),
          child: Text(
            soundsName,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _buildDummyCategory({
    required String imageLink,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20,
      ),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(imageLink), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}