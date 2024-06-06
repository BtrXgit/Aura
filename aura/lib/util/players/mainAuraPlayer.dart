import 'dart:math';
import 'dart:ui';

import 'package:aura/controllers/ad_controller.dart';
import 'package:aura/controllers/player_controller.dart';
import 'package:aura/core/broken_icons.dart';
import 'package:aura/data/songs.dart';
import 'package:aura/liveChat/chat_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:newton_particles/newton_particles.dart';

class AuraPlayer extends StatelessWidget {
  final int currentIndex;
  final List<Song> songs;
  final String title;

  const AuraPlayer({
    required this.currentIndex,
    required this.songs,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuraPlayerController());
    final adController = Get.put(AdController());
    if (controller.songs.isNotEmpty) {
      controller.stopAndClear();
    }
    controller.currentIndex.value = currentIndex;
    controller.title.value = title;
    controller.songs.addAll(songs);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializePlayer();
    });

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      bottomNavigationBar: adController.bannerAd != null
          ? Container(
              alignment: Alignment.center,
              child: AdWidget(ad: adController.bannerAd!),
              width: adController.bannerAd!.size.width.toDouble(),
              height: adController.bannerAd!.size.height.toDouble(),
            )
          : null,
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            controller.playPrevious();
          } else if (details.primaryVelocity! < 0) {
            controller.playNext();
          }
        },
        child: Obx(() {
          return controller.songs.isNotEmpty &&
                  controller.currentIndex.value >= 0 &&
                  controller.currentIndex.value < controller.songs.length
              ? Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.45,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              controller.songs[controller.currentIndex.value]
                                  .imageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                          child: Container(
                            decoration: BoxDecoration(
                                color:
                                    controller.dominantColor?.withOpacity(0.01),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: controller.isPlaying.value
                            ? Newton(
                                activeEffects: [
                                  RainEffect(
                                    particleConfiguration:
                                        ParticleConfiguration(
                                      shape: CircleShape(),
                                      size: const Size(5, 5),
                                      color: const SingleParticleColor(
                                          color: Colors.white),
                                    ),
                                    effectConfiguration:
                                        const EffectConfiguration(),
                                  )
                                ],
                              )
                            : null,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                        Text(
                          'Playing From Playlist',
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          title,
                          style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 35, right: 30, left: 30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: controller
                                  .songs[controller.currentIndex.value]
                                  .imageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 20),
                          child: ListTile(
                            leading: IconButton(
                              onPressed: () async {
                                final userId =
                                    FirebaseAuth.instance.currentUser?.uid;
                                if (userId != null) {
                                  final song = controller
                                      .songs[controller.currentIndex.value];
                                  final imageUrl = song.imageUrl;
                                  final songName = song.songName;
                                  final artist = song.artist;
                                  final songUrl = song.songUrl;

                                  final isLiked = await controller
                                      .checkIfSongIsLiked(userId, songUrl);
                                  controller.isSongLiked.value = isLiked;

                                  controller.toggleLikeSong(
                                    userId: userId,
                                    imageUrl: imageUrl,
                                    songName: songName,
                                    artist: artist,
                                    songUrl: songUrl,
                                  );
                                }
                              },
                              icon: Icon(
                                controller.isSongLiked.value
                                    ? IconlyBold.heart
                                    : IconlyLight.heart,
                                color: controller.isSongLiked.value
                                    ? Colors.red
                                    : Colors.white,
                              ),
                              // icon: Obx(() => Icon(
                              //       controller.isSongLiked.value
                              //           ? IconlyBold.heart
                              //           : IconlyLight.heart,
                              //       color: controller.isSongLiked.value
                              //           ? Colors.red
                              //           : Colors.white,
                              //     )),
                            ),
                            title: Text(
                              controller.songs[controller.currentIndex.value]
                                  .songName,
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            subtitle: Text(
                              controller
                                  .songs[controller.currentIndex.value].artist,
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: StreamBuilder<Duration>(
                            stream: controller.audioPlayer.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              final duration =
                                  controller.audioPlayer.duration ??
                                      Duration.zero;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor:
                                          controller.dominantColor,
                                      inactiveTrackColor: Colors.grey,
                                      thumbColor: Colors.white,
                                      overlayColor:
                                          Colors.blue.withOpacity(0.3),
                                      valueIndicatorColor: Colors.blue,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 8.0),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                              overlayRadius: 16.0),
                                      valueIndicatorShape:
                                          const PaddleSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Slider(
                                      value: position.inSeconds.toDouble(),
                                      max: duration.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        controller.audioPlayer.seek(
                                            Duration(seconds: value.toInt()));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.isShuffleOn.value =
                                      !controller.isShuffleOn.value;
                                },
                                icon: Icon(
                                  Broken.shuffle,
                                  size: 30,
                                  color: controller.isShuffleOn.value
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                              IconButton(
                                onPressed: () => controller.playPrevious(),
                                icon: Icon(
                                  Broken.previous,
                                  size: 30,
                                  color: Colors.white,
                                ),
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
                                  onPressed: () {
                                    if (controller.audioPlayer.playing) {
                                      controller.audioPlayer.pause();
                                    } else {
                                      controller.audioPlayer.play();
                                    }
                                  },
                                  icon: Icon(
                                    controller.isPlaying.value
                                        ? Broken.pause
                                        : Broken.play,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => controller.playNext(),
                                icon: Icon(
                                  Broken.next,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.isRepeatOn.value =
                                      !controller.isRepeatOn.value;
                                },
                                icon: Icon(
                                  Broken.repeat,
                                  size: 30,
                                  color: controller.isRepeatOn.value
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () => Get.to(ChatScreen()),
                        //   child: Container(
                        //     height: 60,
                        //     width: 200,
                        //     color: controller.dominantColor,
                        //     child: Text('Chat'),
                        //   ),
                        // ),
                      ],
                    ),
                    Positioned(
                      top: 50,
                      left: 10,
                      child: IconButton(
                        onPressed: () => controller.showTimerDialog(context),
                        icon: const Icon(
                          Broken.timer_1,
                          color: Colors.white,
                          // size: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(
                          Broken.music_playlist,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Color(0xFF131321),
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Column(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          'Now Playing',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: controller.songs.length,
                                          itemBuilder: (context, index) {
                                            bool isCurrentSong =
                                                controller.currentIndex.value ==
                                                    index;

                                            return ListTile(
                                              tileColor: isCurrentSong
                                                  ? Colors.grey[200]
                                                  : null,
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  imageUrl: controller
                                                      .songs[index].imageUrl,
                                                ),
                                              ),
                                              title: Text(
                                                controller
                                                    .songs[index].songName,
                                                style: TextStyle(
                                                  color: isCurrentSong
                                                      ? Color(0xFF131321)
                                                      : Colors.white,
                                                  fontWeight: isCurrentSong
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                              subtitle: Text(controller
                                                  .songs[index].artist),
                                              trailing: IconButton(
                                                icon: Icon(Broken.close_circle),
                                                onPressed: () {
                                                  setState(() {
                                                    controller.songs
                                                        .removeAt(index);
                                                    if (controller.currentIndex
                                                            .value ==
                                                        index) {
                                                      controller.audioPlayer
                                                          .stop();
                                                    }
                                                  });
                                                },
                                              ),
                                              onTap: () {
                                                controller.currentIndex.value =
                                                    index;
                                                controller.audioPlayer
                                                    .dynamicSet(
                                                  pushIfNotExisted: true,
                                                  url: controller
                                                      .songs[index].songUrl,
                                                );
                                                controller.audioPlayer.play();
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
