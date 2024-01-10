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

class AuraHomePageAfternoon extends StatefulWidget {
  final ScrollController controller;

  const AuraHomePageAfternoon({required this.controller, Key? key})
      : super(key: key);

  @override
  State<AuraHomePageAfternoon> createState() => _AuraHomePageAfternoonState();
}

class _AuraHomePageAfternoonState extends State<AuraHomePageAfternoon>
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
    final greeting = _getGreeting();
    final backgroundImage = _getImageAsset(greeting);
    return Scaffold(
      backgroundColor: Color(0xFF131321),
      body: NestedScrollView(
        physics: ClampingScrollPhysics(),
        controller: widget.controller,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              forceMaterialTransparency: false,
              expandedHeight: MediaQuery.of(context).size.height * 0.2,
              floating: true,
              pinned: true,
              backgroundColor: const Color(0xFF131321),
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double offset = constraints.biggest.height;
                bool isAppBarExpanded = offset > 100;

                return FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  title: isAppBarExpanded
                      ? null
                      : Text(
                          'Explore',
                          style: GoogleFonts.caveat(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
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
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              'LoFi - Hip Hop',
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildDummyCategory(
              imageLink:
                  'https://i.pinimg.com/564x/9e/00/71/9e0071917b7fcc601f24c058de09c221.jpg'),
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
          _buildDummyCategory(
              imageLink:
                  'https://i.pinimg.com/564x/3a/ee/3e/3aee3e7a1d246af2d101c3a533ee6bae.jpg'),
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
          _buildDummyCategory(
              imageLink:
                  'https://i.pinimg.com/564x/90/fd/ba/90fdbaaefd745116eb4a3e79033757c1.jpg'),
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
          _buildDummyCategory(
              imageLink:
                  'https://i.pinimg.com/564x/e1/a9/a8/e1a9a85ca836f02953b5a64b4516210e.jpg'),
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
          const SizedBox(
            height: 50,
          ),
        ],
      ),
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
          color: Colors.white,
          image: DecorationImage(
              image: CachedNetworkImageProvider(imageLink), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
