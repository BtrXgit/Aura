import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAudio(String assetPath) async {
    try {
      await _player.setSource(AssetSource(assetPath));
      await _player.setVolume(1);
      await _player.resume();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }
}

class AuraCustomTest extends StatefulWidget {
  const AuraCustomTest(
      {Key? key, required ScrollController controller, required Color color})
      : super(key: key);

  @override
  State<AuraCustomTest> createState() => _AuraCustomTestState();
}

class _AuraCustomTestState extends State<AuraCustomTest> {
  final AudioManager audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
        title: Text("Aura Test"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                audioManager.playAudio('nature/heavyrain.mp3');
              },
              child: Text('Play Heavy Rain'),
            ),
            ElevatedButton(
              onPressed: () {
                audioManager.playAudio('nature/fireplace.mp3');
              },
              child: Text('Play Fireplace'),
            ),
            ElevatedButton(
              onPressed: () {
                audioManager.stopAudio();
              },
              child: Text('Stop Audio'),
            ),
          ],
        ),
      ),
    );
  }
}
