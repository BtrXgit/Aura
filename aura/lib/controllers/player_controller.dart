import 'dart:async';
import 'dart:ui';
import 'package:aura/data/songs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'dart:math';
import 'package:palette_generator/palette_generator.dart';

class AuraPlayerController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  var currentIndex = 0.obs;
  var isShuffleOn = false.obs;
  var isRepeatOn = false.obs;
  var isSongLiked = false.obs;
  var title = ''.obs;
  Color? dominantColor;
  var isPlaying = false.obs;
  var songs = <Song>[].obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    if (songs.isNotEmpty) {
      initializePlayer();
    }
    loadDominantColor();

    // Listen to player state changes
    audioPlayer.playerStateStream.listen((playerState) {
      isPlaying.value = playerState.playing;
    });
  }

  void stopAndClear() {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    }
    songs.clear();
  }

  void initializePlayer() {
    if (currentIndex.value >= 0 && currentIndex.value < songs.length) {
      audioPlayer
          .dynamicSet(
              pushIfNotExisted: true, url: songs[currentIndex.value].songUrl)
          .then((_) {
        audioPlayer.play();
        loadDominantColor();
      });

      audioPlayer.processingStateStream.listen((processingState) {
        if (processingState == ProcessingState.completed) {
          if (isRepeatOn.value) {
            audioPlayer.seek(Duration.zero);
          } else {
            playNext();
          }
        }
      });
    }
  }

  void playNext() {
    if (songs.isNotEmpty) {
      if (isShuffleOn.value) {
        currentIndex.value = Random().nextInt(songs.length);
      } else {
        // Check if current index is at the last song
        if (currentIndex.value < songs.length - 1) {
          currentIndex.value++;
        } else {
          // If repeat is on, loop back to the first song
          if (isRepeatOn.value) {
            currentIndex.value = 0;
          } else {
            // If repeat is off, loop back to the first song and continue playing
            currentIndex.value = 0;
          }
        }
      }

      audioPlayer
          .dynamicSet(
              pushIfNotExisted: true, url: songs[currentIndex.value].songUrl)
          .then((_) {
        audioPlayer.play();
        loadDominantColor();
      });
    }
  }

  void playPrevious() {
    if (songs.isNotEmpty && currentIndex.value > 0) {
      currentIndex.value--;
      audioPlayer
          .dynamicSet(
              pushIfNotExisted: true, url: songs[currentIndex.value].songUrl)
          .then((_) {
        audioPlayer.play();
        loadDominantColor();
      });
    }
  }

  Future<void> loadDominantColor() async {
    if (songs.isNotEmpty && currentIndex.value >= 0) {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
              CachedNetworkImageProvider(songs[currentIndex.value].imageUrl));
      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.blue;
    }
  }

  void checkIfSongIsLiked(String userId, String songUrl) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Favourites')
        .where('songUrl', isEqualTo: songUrl)
        .get()
        .then((querySnapshot) {
      isSongLiked.value = querySnapshot.docs.isNotEmpty;
    }).catchError((error) {
      if (kDebugMode) {
        print('Error checking if image is already liked: $error');
      }
    });
  }

  void toggleLikeSong(
      {required String userId,
      required String imageUrl,
      required String songName,
      required String artist,
      required String songUrl}) async {
    final isLiked = !isSongLiked.value;

    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Favourites')
        .where('songUrl', isEqualTo: songUrl)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.first.reference.delete().then((_) {
          isSongLiked.value = isLiked;
        }).catchError((error) {
          if (kDebugMode) {
            print('Failed to remove song from favorites: $error');
          }
        });
      } else {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Favourites')
            .add({
          'songName': songName,
          'imageUrl': imageUrl,
          'songUrl': songUrl,
          'artist': artist,
        }).then((value) {
          isSongLiked.value = isLiked;
        }).catchError((error) {
          if (kDebugMode) {
            print('Failed to like image: $error');
          }
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error checking if image is already liked: $error');
      }
    });
  }

  void startTimer(int durationInSeconds) {
    timer = Timer(Duration(seconds: durationInSeconds), () {
      audioPlayer.stop();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void onClose() {
    // audioPlayer.dispose();
    timer?.cancel();
    super.onClose();
  }
}


  // void playNext() {
  //   if (songs.isNotEmpty) {
  //     if (isShuffleOn.value) {
  //       currentIndex.value = Random().nextInt(songs.length);
  //     } else {
  //       if (currentIndex.value < songs.length - 1) {
  //         currentIndex.value++;
  //       } else {
  //         if (isRepeatOn.value) {
  //           currentIndex.value = 0;
  //         } else {
  //           currentIndex.value = 0;
  //           audioPlayer.stop();
  //         }
  //       }
  //     }

  //     audioPlayer
  //         .dynamicSet(
  //             pushIfNotExisted: true, url: songs[currentIndex.value].songUrl)
  //         .then((_) {
  //       audioPlayer.play();
  //       loadDominantColor();
  //     });
  //   }
  // }
