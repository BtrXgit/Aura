import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CustomMixin extends StatefulWidget {
  const CustomMixin({
    Key? key,
    required ScrollController controller,
    required Color color,
  }) : super(key: key);

  @override
  State<CustomMixin> createState() => _CustomMixinState();
}

class _CustomMixinState extends State<CustomMixin> {
  final AudioPlayer audioPlayer1 = AudioPlayer();
  final AudioPlayer audioPlayer2 = AudioPlayer();
  double volume1 = 1.0;
  double volume2 = 1.0;
  final sliderValue1 = ValueNotifier<double>(1.0);
  final sliderValue2 = ValueNotifier<double>(1.0);

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    try {
      await audioPlayer1.setAsset('assets/nature/heavyrain.mp3');
      await audioPlayer2.setAsset('assets/nature/fireplace.mp3');
      audioPlayer1.setLoopMode(LoopMode.all);
      audioPlayer2.setLoopMode(LoopMode.all);
    } catch (e) {
      print('Error loading audio: $e');
    }
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
              audioPlayer: audioPlayer1,
              volume: volume1,
              sliderValue: sliderValue1,
            ),
            _buildAudioControl(
              label: 'fireplace',
              audioPlayer: audioPlayer2,
              volume: volume2,
              sliderValue: sliderValue2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioPlayer audioPlayer,
    required double volume,
    required ValueNotifier<double> sliderValue,
  }) {
    return Column(
      children: [
        Text(label),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: audioPlayer.playing ? Colors.green : Colors.red,
          ),
          child: InkWell(
            onTap: () {
              _toggleAudioPlayback(audioPlayer);
            },
            customBorder: CircleBorder(),
            child: Icon(
              audioPlayer.playing ? Icons.pause : Icons.play_arrow,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
        Slider(
          value: sliderValue.value,
          onChanged: (value) {
            setState(() {
              sliderValue.value = value;
            });
            audioPlayer.setVolume(value);
          },
        ),
      ],
    );
  }

  void _toggleAudioPlayback(AudioPlayer audioPlayer) {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    setState(() {}); // Update the UI to reflect the change
  }

  @override
  void dispose() {
    audioPlayer1.dispose();
    audioPlayer2.dispose();
    super.dispose();
  }
}
