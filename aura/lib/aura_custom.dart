import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AuraCustomTest extends StatefulWidget {
  const AuraCustomTest(
      {Key? key, required ScrollController controller, required Color color})
      : super(key: key);

  @override
  State<AuraCustomTest> createState() => _AuraCustomTestState();
}

class _AuraCustomTestState extends State<AuraCustomTest> {
  final AudioManager audioManager1 = AudioManager();
  final AudioManager audioManager2 = AudioManager();
  double volume1 = 1.0; // Initial volume for audio 1
  double volume2 = 1.0; // Initial volume for audio 2

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
        title: const Text("Aura Test"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildAudioControl(
              label: 'heavyrain',
              audioManager: audioManager1,
              volume: volume1,
              onVolumeChanged: (value) {
                setState(() {
                  volume1 = value;
                });
                audioManager1.setVolume(value);
              },
            ),
            _buildAudioControl(
              label: 'fireplace',
              audioManager: audioManager2,
              volume: volume2,
              onVolumeChanged: (value) {
                setState(() {
                  volume2 = value;
                });
                audioManager2.setVolume(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioManager audioManager,
    required double volume,
    required ValueChanged<double> onVolumeChanged,
  }) {
    return Column(
      children: [
        Text(label),
        Slider(
          value: volume,
          onChanged: onVolumeChanged,
        ),
        ElevatedButton(
          onPressed: () {
            audioManager.playAudio('nature/$label.mp3');
          },
          child: Text('Play $label'),
        ),
        ElevatedButton(
          onPressed: () {
            audioManager.stopAudio();
          },
          child: Text('Stop $label'),
        ),
      ],
    );
  }
}

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

  void setVolume(double volume) {
    _player.setVolume(volume);
  }
}
