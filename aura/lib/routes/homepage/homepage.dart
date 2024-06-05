import 'dart:ui';
import 'package:aura/component/user_component.dart';
import 'package:aura/controllers/home_controller.dart';
import 'package:aura/lib/notifications.dart';
import 'package:aura/liveChat/chat_test.dart';
import 'package:aura/routes/pages/favourites.dart';
import 'package:aura/routes/pages/live/focusLive.dart';
import 'package:aura/util/players/soundsPlayer.dart';
import 'package:aura/routes/pages/live/relaxingLive.dart';
import 'package:aura/routes/pages/sounds/noises.dart';
import 'package:aura/routes/pages/sounds/recommendedSounds.dart';
import 'package:aura/routes/pages/playlists/playlists.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:text_scroll/text_scroll.dart';
import '../pages/live/sleepLive.dart';

class AuraHomePage extends StatelessWidget {
  final ScrollController controller;
  final AuraHomeController auraHomeController = Get.put(AuraHomeController());
  AuraHomePage({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    return Material(
      clipBehavior: Clip.antiAlias,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: AnimationLimiter(child: _buildContentColumn(context)),
      ),
    );
  }

  Widget _buildContentColumn(context) {
    final greeting = Components.getGreeting();
    final backgroundImage = Components.getImageAsset(greeting);
    final relaxingImage = auraHomeController.randomRelaxingImage(greeting);
    final focusImage = auraHomeController.randomFocusImage(greeting);
    return SingleChildScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
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
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 10, bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greeting,
                                    style: GoogleFonts.dancingScript(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${auraHomeController.userName}',
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
                          onTap: () => Get.to(NotificationPage(),
                              transition: Transition.fadeIn),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              IconlyBold.notification,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        // IconButton(
                        //     onPressed: () {
                        //       Get.to(ChatScreen());
                        //     },
                        //     icon: Icon(Icons.chat)),
                        // const SizedBox(
                        //   width: 14,
                        // ),
                        (auraHomeController.userPhotoUrl != null)
                            ? Obx(
                                () => SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage: CachedNetworkImageProvider(
                                      auraHomeController.userPhotoUrl.value,
                                    ),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 8.0),
            child: Text(
              'Recommended',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: auraHomeController.recommendedSounds.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                int currentIndex = index;

                if (index == auraHomeController.recommendedSounds.length) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(RecommendedSoundsPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 18),
                      height: 180,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        image: DecorationImage(
                            image: AssetImage('assets/st2.png'),
                            fit: BoxFit.cover),
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
                          context,
                          soundsName: auraHomeController
                              .recommendedSounds[currentIndex],
                          imageLink: auraHomeController
                              .recommendedImageUrl[currentIndex],
                          index: currentIndex,
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
              items: auraHomeController.kImages.asMap().entries.map((entry) {
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
                                    transition: Transition.rightToLeftWithFade);
                              } else if (index == 1) {
                                Get.to(
                                    const FocusLive(
                                      title: 'Focus Live',
                                      imageUrl: 'assets/studyLive.jpg',
                                    ),
                                    transition: Transition.rightToLeftWithFade);
                              } else if (index == 2) {
                                Get.to(
                                    const SleepLive(
                                      title: 'Sleep Live',
                                      imageUrl: 'assets/sleepingLive.jpg',
                                    ),
                                    transition: Transition.rightToLeftWithFade);
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
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.075,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      image: DecorationImage(
                                        image: AssetImage('assets/st2.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          auraHomeController.kNames[index],
                                          style: GoogleFonts.kanit(
                                              color: Colors.white,
                                              fontSize: 26),
                                        ),
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

          _ScrollText(
              title: 'Coloured noise',
              scrollText: 'Dive into digital world of sounds.'),
          SizedBox(
            height: 120,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: auraHomeController.noises.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext, int) {
                if (int == auraHomeController.noises.length) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(NoisesPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 18),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        image: DecorationImage(
                            image: AssetImage('assets/st2.png'),
                            fit: BoxFit.cover),
                        shape: BoxShape.circle,
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
                    soundsName: auraHomeController.noises[int],
                    imageLink: auraHomeController.noisesImage[int],
                    index: int,
                  );
                }
              },
            ),
          ),

          //title: - Music
          //subtitle: - Melodies that touch the soul
          //space travel, hope, moonlight, sunglow, dust, buddhist chant, illusion, wandering, smoke, fantastic space, hesitance, sunspots, solitude, coffee shop, meditation, slumber, temple, ray of sunlight

          _ScrollText(
              title: 'Relaxing 🍃',
              scrollText: 'Relaxing Sound | Beats to Relax | Beats to chill.'),
          GestureDetector(
              onTap: () => Get.to(PlaylistsPage(
                    category: 'relaxing',
                  )),
              child: _buildHomepageCategory(
                context,
                imageLink: relaxingImage,
              )),
          _ScrollText(
              title: 'Focus 📚',
              scrollText: 'Lofi | Beats to Focus | Beats to study.'),
          GestureDetector(
            onTap: () => Get.to(PlaylistsPage(
              category: 'focus',
            )),
            child: _buildHomepageCategory(context, imageLink: focusImage),
          ),
          _ScrollText(
              title: 'Calm & Cozy ',
              scrollText:
                  'Ambient Sound | Beats to relax | Beats to work | Beats to sleep.'),
          GestureDetector(
            onTap: () => Get.to(PlaylistsPage(
              category: 'calm and cozy',
            )),
            child: _buildHomepageCategory(context,
                imageLink: auraHomeController.homepageCategory[0]),
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
            child: _buildHomepageCategory(context,
                imageLink: auraHomeController.homepageCategory[1]),
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
            child: _buildHomepageCategory(context,
                imageLink: auraHomeController.homepageCategory[2]),
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
            child: _buildHomepageCategory(context,
                imageLink: auraHomeController.homepageCategory[3]),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _recommendedContainer(
    context, {
    required String soundsName,
    required String imageLink,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => Get.to(SoundsPlayer(
        currentIndex: index,
        songs: auraHomeController.songs,
        title: 'Recommended Sounds',
        imageUrl: auraHomeController.recommendedImageUrl,
        soundNames: auraHomeController.recommendedSounds,
      )),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
            height: 180,
            width: 150,
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
              margin: EdgeInsets.only(left: 12),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                image: DecorationImage(
                  image: AssetImage('assets/st2.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    soundsName,
                    style: GoogleFonts.kanit(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            right: 6,
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
  }) {
    return GestureDetector(
      onTap: () => Get.to(SoundsPlayer(
        currentIndex: index,
        songs: auraHomeController.noisesSounds,
        title: 'Coloured noise',
        imageUrl: auraHomeController.noisesImage,
        soundNames: auraHomeController.noises,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 14),
            height: 84,
            width: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: CachedNetworkImageProvider(imageLink),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high),
            ),
          ),
          // SizedBox(
          //   height: 8.0,
          // ),
          Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              soundsName,
              style: GoogleFonts.kanit(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomepageCategory(
    context, {
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
        top: 20,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
              style: GoogleFonts.kanit(
                  color: Colors.grey.withOpacity(0.5), fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
