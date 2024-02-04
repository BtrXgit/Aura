import 'dart:ui';
import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/component/native_ad.dart';
import 'package:aura/routes/pages/bookmarkedPage.dart';
import 'package:aura/routes/pages/live/focusLive.dart';
import 'package:aura/util/players/soundsPlayer.dart';
import 'package:aura/routes/pages/live/relaxingLive.dart';
import 'package:aura/routes/pages/sounds/noises.dart';
import 'package:aura/routes/pages/sounds/recommendedSounds.dart';
import 'package:aura/routes/pages/playlists/playlists.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:text_scroll/text_scroll.dart';
import '../pages/live/sleepLive.dart';

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
    'assets/relaxingLive.jpg',
    'assets/studyLive.jpg',
    'assets/sleepingLive.jpg',
  ];

  List<String> kNames = [
    'Relaxing',
    'Focus/Study',
    'Sleep',
  ];

  // bool isPlaying = false;

  // Set<String> favoriteSongs = Set<String>();

  BannerAd? _banner;
  InterstitialAd? _interstitialAd;
  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  void loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: AdMobService.nativeAdsUnit!,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.medium),
        customOptions: {});
    _nativeAd?.load();
  }

  Widget _buildNativeAdWidget() {
    if (_nativeAdIsLoaded) {
      return NativeAdSmall(_nativeAd!);
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
    loadNativeAd();
    fetchUserProfileData();
    // _loadFavoriteSongs();
  }

  // Future<void> _loadFavoriteSongs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Set<String> favorites =
  //       prefs.getStringList('favorites')?.toSet() ?? Set<String>();
  //   setState(() {
  //     favoriteSongs = favorites;
  //   });
  // }

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
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Focean.jpg?alt=media&token=687073b1-be9f-4bf0-9f9f-379b60a59969',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbirdsong.jpg?alt=media&token=3273f108-27d8-4ad1-b96b-ddc845fe8407',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fpiano.jpg?alt=media&token=72789b21-67b9-4f7c-a444-d19628e54489',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fharp.jpg?alt=media&token=86b8d014-0547-404d-af58-90f9c156f4bf',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbonfire.jpg?alt=media&token=1a19e51f-260f-41b8-8e91-47afbf2572f9',
  ];

  List<String> recommendedSoundes = [
    'Ocean Waves',
    'Birdsong',
    'Soft Piano',
    'Harp',
    'Bonfire',
  ];

  List<String> songs = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FOcean%20Waves.mp3?alt=media&token=50e60efc-4d61-42f0-af36-ad9ba1be46ca',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FBirdsong.mp3?alt=media&token=b589b721-3f73-4151-9b5b-ea8011a9f175',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FSoft%20Piano.mp3?alt=media&token=b99e81a3-2f90-4dbb-9111-5df0d4b54143',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FHarp.mp3?alt=media&token=74d14dfa-6255-469b-836b-613d17a4b622',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FBonfire.mp3?alt=media&token=1f50ef65-565d-4b20-bb29-8a2a2ef8f8a1',
  ];

  List<String> noisesImage = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fwhite.jpg?alt=media&token=9af3e878-629c-43b4-af8f-487c3b1f14d0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fpink.jpg?alt=media&token=34a50113-949c-4942-aadb-7c3236f4a55c',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fbrown.jpg?alt=media&token=4213f35a-3ee1-43cc-9275-8a68c6effc81',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fblue.jpg?alt=media&token=975c4669-2564-43c9-9cf4-2013dd1847a5',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fviolet.jpg?alt=media&token=60ce2298-c146-4d3a-ad68-f545f764d5e5',
  ];

  List<String> noisesSounds = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FWhite%20Noise.mp3?alt=media&token=bd7af2e8-2162-40c7-b0bd-e3c4ec9478e1',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FPink%20Noise.mp3?alt=media&token=4dc54875-28c0-4536-8128-450cc89679f2',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBrown%20Noise.mp3?alt=media&token=3177c986-7c1a-4a6f-af88-9fec8ff1dd73',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBlue%20Noise.mp3?alt=media&token=84a1d86a-9e8d-4eeb-b0a6-98c3b6b96d39',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FViolet%20Noise.mp3?alt=media&token=6dbb5547-2688-4eaa-80f7-6b24df2cc901',
  ];

  List<String> noises = [
    'White Noise',
    'Pink Noise',
    'Brown Noise',
    'Blue Noise',
    'Violet Noise',
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
        // return 'assets/morning.jpg';
        return 'assets/afternoon.jpg';
      case 'Good Evening':
        return 'assets/evening.jpg';
      case 'Good Night':
        return 'assets/night.jpg';
      default:
        return 'assets/morning.jpg';
    }
  }

  String randomRelaxingImage(String greeting) {
    switch (greeting) {
      case 'Good Morning':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F10.jpg?alt=media&token=c5f0a5f8-45f0-4a46-8837-04d46a4ecf7b';
      case 'Good Afternoon':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F3.jpg?alt=media&token=c5598838-ea0a-4038-8b77-5a45e48abe42';
      case 'Good Evening':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F2.jpg?alt=media&token=3e0cf4f7-11ef-4ad9-9d4e-5976b013b826';
      case 'Good Night':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F6.jpg?alt=media&token=80df50a3-5b3c-4586-b876-3e2a40480170';
      default:
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRelaxing%2F10.jpg?alt=media&token=c5f0a5f8-45f0-4a46-8837-04d46a4ecf7b';
    }
  }

  String randomFocusImage(String greeting) {
    switch (greeting) {
      case 'Good Morning':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusMorning.jpg?alt=media&token=db0b3aa1-f38e-40f7-a29d-0fcadd17e3a7';
      case 'Good Afternoon':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusAfternoon.jpg?alt=media&token=dcdf8900-886c-459e-8e15-871999669766';
      case 'Good Evening':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusEvening.jpg?alt=media&token=abcbf1d0-39be-4c53-9f37-31c4fab1b702';
      case 'Good Night':
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusNight.jpg?alt=media&token=942958f4-7aee-4891-b01e-30e14a7717de';
      default:
        return 'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusNight.jpg?alt=media&token=942958f4-7aee-4891-b01e-30e14a7717de';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(child: _buildContentColumn()),
    );
  }

  Widget _buildContentColumn() {
    final greeting = _getGreeting();
    final backgroundImage = _getImageAsset(greeting);
    final relaxingImage = randomRelaxingImage(greeting);
    final focusImage = randomFocusImage(greeting);
    return Stack(
      children: [
        RotatedBox(
          quarterTurns: 1,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/style3.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          controller: widget.controller,
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.28,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.075,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                // width: MediaQuery.of(context).size.width,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.075,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 10, bottom: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: GoogleFonts.kanit(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => Get.to(BookmarkedPage(),
                                  transition: Transition.fadeIn),
                              child: Container(
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
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            (userPhotoUrl != null)
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
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 20,
                      //   width: MediaQuery.of(context).size.width,
                      //   decoration: BoxDecoration(
                      //     color: Color(0xFF131321),
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(20),
                      //       topRight: Radius.circular(20),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 10, bottom: 8.0),
                child: Text(
                  'Recommended',
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: recommendedSoundes.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    // Capture the current index in a separate variable
                    int currentIndex = index;

                    if (index == recommendedSoundes.length) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(RecommendedSoundsPage());
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 18),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1F36),
                            borderRadius: BorderRadius.circular(20),
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
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: ScaleAnimation(
                          // verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _recommendedContainer(
                              soundsName: recommendedSoundes[currentIndex],
                              imageLink: recommendedImageUrl[currentIndex],
                              index: currentIndex,
                              height: 200,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              _ScrollText(
                  title: 'Live Radios',
                  scrollText:
                      'Lofi | Beats to Relax | Beats to study | Beats to sleep.'),
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
                    int index = entry.key;
                    String imageUrl = entry.value;
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Builder(
                            builder: (
                              BuildContext context,
                            ) {
                              return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    Get.to(
                                        const RelaxingLive(
                                          title: 'Relaxing Live',
                                          imageUrl: 'assets/relaxingLive.jpg',
                                        ),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  } else if (index == 1) {
                                    Get.to(
                                        const FocusLive(
                                          title: 'Focus Live',
                                          imageUrl: 'assets/studyLive.jpg',
                                        ),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  } else if (index == 2) {
                                    Get.to(
                                        const SleepLive(
                                          title: 'Sleep Live',
                                          imageUrl: 'assets/sleepingLive.jpg',
                                        ),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
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
                                    Positioned(
                                      bottom: -1,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.075,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 5, sigmaY: 5),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.075,
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      kNames[index],
                                                      style: GoogleFonts.kanit(
                                                          color: Colors.white,
                                                          fontSize: 26),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Icon(
                                        IconlyBold.play,
                                        size: 74,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              //title: - Ambient Sounds
              //subtitle: - Immersive Nature Sounds
              //data: - Summer Seashore, morning sunshine, nighttime camping, mystic cosmos, zen temple, placid jungle, home comforts, stormy nights, city strolling
              _buildNativeAdWidget(),

              _ScrollText(
                  title: 'Coloured noise',
                  scrollText: 'Dive into digital world of sounds.'),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: noises.length + 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext, int) {
                    if (int == noises.length) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(NoisesPage());
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 18),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1F36),
                            borderRadius: BorderRadius.circular(20),
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
                      return _noisesContainer(
                          soundsName: noises[int],
                          imageLink: noisesImage[int],
                          index: index,
                          height: 200);
                    }
                  },
                ),
              ),

              //title: - Music
              //subtitle: - Melodies that touch the soul
              //space travel, hope, moonlight, sunglow, dust, buddhist chant, illusion, wandering, smoke, fantastic space, hesitance, sunspots, solitude, coffee shop, meditation, slumber, temple, ray of sunlight

              _ScrollText(
                  title: 'Relaxing 🍃',
                  scrollText:
                      'Relaxing Sound | Beats to Relax | Beats to chill.'),
              GestureDetector(
                  onTap: () => Get.to(PlaylistsPage(
                        category: 'relaxing',
                      )),
                  child: _buildDummyCategory(
                    imageLink: relaxingImage,
                  )),
              _ScrollText(
                  title: 'Focus 📚',
                  scrollText: 'Lofi | Beats to Focus | Beats to study.'),
              GestureDetector(
                onTap: () => Get.to(PlaylistsPage(
                  category: 'focus',
                )),
                child: _buildDummyCategory(imageLink: focusImage),
              ),
              _ScrollText(
                  title: 'Calm & Cozy ',
                  scrollText:
                      'Ambient Sound | Beats to relax | Beats to work | Beats to sleep.'),
              GestureDetector(
                onTap: () => Get.to(PlaylistsPage(
                  category: 'calm and cozy',
                )),
                child: _buildDummyCategory(
                    imageLink:
                        'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fcozy.jpg?alt=media&token=3269db39-02fe-4d89-a05c-506cf08f27cc'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
                child: Text(
                  'Synthwave/Chillwave',
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(PlaylistsPage(
                  category: 'chillwave',
                )),
                child: _buildDummyCategory(
                    imageLink:
                        'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fsynthwave.jpg?alt=media&token=d2c50d2c-c6eb-40e4-b05b-7f88bf81af31'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
                child: Text(
                  'LoFi - Sad',
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(PlaylistsPage(
                  category: 'lofi sad',
                )),
                child: _buildDummyCategory(
                    imageLink:
                        'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fsad.jpg?alt=media&token=37f31103-0868-402e-8bf2-2401b5ca50bb'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
                child: Text(
                  'LoFi - Hip Hop',
                  style: GoogleFonts.kanit(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(PlaylistsPage(
                  category: 'lofi hiphop',
                )),
                child: _buildDummyCategory(
                    imageLink:
                        'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fhiphop.jpg?alt=media&token=88e8441e-3ef7-4b06-b628-c37de276be6e'),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
              //   child: Text(
              //     'ChillDrive',
              //     style: GoogleFonts.kanit(
              //       color: Colors.white,
              //       fontSize: 24,
              //     ),
              //   ),
              // ),
              // _buildDummyCategory(
              //     imageLink:
              //         'https://i.pinimg.com/564x/d8/b2/7f/d8b27f84e75c359d0c786890f6f1dac3.jpg'),
              // Padding(
              //   padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
              //   child: Text(
              //     'Devotional',
              //     style: GoogleFonts.kanit(
              //       color: Colors.white,
              //       fontSize: 24,
              //     ),
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () => Get.to(DevotionalPage(
              //     category: 'Devotional',
              //   )),
              //   child: _buildDummyCategory(
              //       imageLink:
              //           'https://i.pinimg.com/564x/7b/87/0e/7b870ec101537650c42c5b169f9ee186.jpg'),
              // ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recommendedContainer({
    required String soundsName,
    required String imageLink,
    required int index,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => Get.to(SoundsPlayer(
        currentIndex: index,
        songs: songs,
        title: 'Recommended Sounds',
        imageUrl: recommendedImageUrl,
        soundNames: recommendedSoundes,
      )),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 18),
            height: height,
            width: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(imageLink),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high),
                borderRadius: BorderRadius.circular(20)),
          ),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(left: 18),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          soundsName,
                          style: GoogleFonts.kanit(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 10,
            child: Icon(
              IconlyBold.play,
              size: 42,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noisesContainer({
    required String soundsName,
    required String imageLink,
    required int index,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => Get.to(SoundsPlayer(
        currentIndex: index,
        songs: songs,
        title: 'Coloured Noise',
        imageUrl: noisesImage,
        soundNames: noises,
      )),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 18),
            height: height,
            width: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(imageLink),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high),
                borderRadius: BorderRadius.circular(20)),
          ),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(left: 18),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          soundsName,
                          style: GoogleFonts.kanit(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 10,
            child: Icon(
              IconlyBold.play,
              size: 42,
              color: Colors.white,
            ),
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
      child: Stack(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(imageLink),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Icon(
              IconlyBold.play,
              size: 52,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ScrollText({
    required String title,
    required String scrollText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 10,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.kanit(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: TextScroll(
              scrollText,
              intervalSpaces: 10,
              velocity: Velocity(pixelsPerSecond: Offset(40, 0)),
              style: GoogleFonts.kanit(color: Colors.grey, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
