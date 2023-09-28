import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AuraCustomTest extends StatefulWidget {
  const AuraCustomTest(
      {Key? key, required ScrollController controller, required Color color});

  @override
  State<AuraCustomTest> createState() => _AuraCustomTestState();
}

class _AuraCustomTestState extends State<AuraCustomTest> {
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // playAssetAudio();
  }

  Future<void> playAssetAudio() async {
    try {
      await player.setSource(AssetSource('nature/heavyrain.mp3'));
      await player.resume();
      await player.setVolume(1);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> playAssetAudio1() async {
    try {
      await player.setSource(AssetSource('nature/fallingleaves.mp3'));
      await player.resume();
      await player.setVolume(1);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stopAssetAudio() async {
    try {
      // await player.setSource(AssetSource('nature/heavyrain.mp3'));
      await player.stop();
      await player.setVolume(1);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        title: Text("Aura Test"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                playAssetAudio();
              },
              child: Text('Play Audio'),
            ),
            ElevatedButton(
              onPressed: () {
                stopAssetAudio();
              },
              child: Text('Stop Audio'),
            ),
            ElevatedButton(
              onPressed: () {
                playAssetAudio1();
              },
              child: Text('Play Falling Leaves'),
            ),
          ],
        ),
      ),
    );
  }
}
