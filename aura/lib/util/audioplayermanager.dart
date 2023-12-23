import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAsset(String assetPath) async {
    await _setSourceAsset(assetPath);
    await _audioPlayer.resume();
  }

  Future<void> playFirebaseUrl(String firebaseUrl) async {
    await _setSourceFirebaseUrl(firebaseUrl);
    await _audioPlayer.resume();
  }

  Future<void> _setSourceAsset(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes = data.buffer.asUint8List();
    await _audioPlayer.setSourceBytes(Uint8List.fromList(bytes));
  }

  Future<void> _setSourceFirebaseUrl(String firebaseUrl) async {
    await _audioPlayer.setSourceUrl(firebaseUrl);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
