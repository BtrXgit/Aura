import 'dart:ui';

import 'package:aura/controllers/player_controller.dart';
import 'package:aura/core/broken_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio_cache/just_audio_cache.dart';

class EnlargedMiniPlayer extends StatelessWidget {
  final AuraPlayerController controller;
  const EnlargedMiniPlayer({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            controller.playPrevious();
          } else if (details.primaryVelocity! < 0) {
            controller.playNext();
          }
        },
        child: Center(
          child: Obx(() {
            return controller.songs.isNotEmpty &&
                    controller.currentIndex.value >= 0 &&
                    controller.currentIndex.value < controller.songs.length
                ? Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              controller.songs[controller.currentIndex.value]
                                  .imageUrl,
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
                            height: MediaQuery.of(context).size.height * 0.04,
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
                            controller.title.value,
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
                                onPressed: () {
                                  final userId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (userId != null) {
                                    final imageUrl = controller
                                        .songs[controller.currentIndex.value]
                                        .imageUrl;
                                    controller.checkIfSongIsLiked(
                                        userId, imageUrl);
                                    if (controller.isSongLiked.value) {
                                      controller.toggleLikeSong(
                                          userId: userId,
                                          imageUrl: imageUrl,
                                          songName: controller
                                              .songs[
                                                  controller.currentIndex.value]
                                              .songName,
                                          artist: controller
                                              .songs[
                                                  controller.currentIndex.value]
                                              .artist,
                                          songUrl: controller
                                              .songs[
                                                  controller.currentIndex.value]
                                              .songUrl);
                                    } else {
                                      final songName = controller
                                          .songs[controller.currentIndex.value]
                                          .songName;
                                      final artist = controller
                                          .songs[controller.currentIndex.value]
                                          .artist;
                                      final songUrl = controller
                                          .songs[controller.currentIndex.value]
                                          .songName;
                                      controller.toggleLikeSong(
                                          userId: userId,
                                          imageUrl: imageUrl,
                                          songName: songName,
                                          artist: artist,
                                          songUrl: songUrl);
                                    }
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
                                controller.songs[controller.currentIndex.value]
                                    .artist,
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
                                        valueIndicatorTextStyle:
                                            const TextStyle(
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
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
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
                                IconButton(
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
                        ],
                      ),
                      Positioned(
                        top: 30,
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
                        top: 30,
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
                                              bool isCurrentSong = controller
                                                      .currentIndex.value ==
                                                  index;

                                              return ListTile(
                                                tileColor: isCurrentSong
                                                    ? Colors.grey[200]
                                                    : null,
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                                  icon:
                                                      Icon(Broken.close_circle),
                                                  onPressed: () {
                                                    setState(() {
                                                      controller.songs
                                                          .removeAt(index);
                                                      if (controller
                                                              .currentIndex
                                                              .value ==
                                                          index) {
                                                        controller.audioPlayer
                                                            .stop();
                                                      }
                                                    });
                                                  },
                                                ),
                                                onTap: () {
                                                  controller.currentIndex
                                                      .value = index;
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
      ),
    );
  }
}
