// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:provider/provider.dart';

// class AudioPlayerProvider extends ChangeNotifier {
//   final AudioPlayer audioPlayer1 = AudioPlayer();
//   final AudioPlayer audioPlayer2 = AudioPlayer();
//   final AudioPlayer audioPlayer3 = AudioPlayer();
//   bool isPlaying1 = false;
//   bool isPlaying2 = false;
//   bool isPlaying3 = false;

//   void togglePlayback1() {
//     if (isPlaying1) {
//       audioPlayer1.pause();
//     } else {
//       audioPlayer1.play();
//     }
//     isPlaying1 = !isPlaying1;
//     notifyListeners();
//   }

//   void togglePlayback2() {
//     if (isPlaying2) {
//       audioPlayer2.pause();
//     } else {
//       audioPlayer2.play();
//     }
//     isPlaying2 = !isPlaying2;
//     notifyListeners();
//   }

//   void togglePlayback3() {
//     if (isPlaying3) {
//       audioPlayer3.pause();
//     } else {
//       audioPlayer3.play();
//     }
//     isPlaying3 = !isPlaying3;
//     notifyListeners();
//   }
// }
