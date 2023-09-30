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
  final AudioPlayer audioPlayer3 = AudioPlayer();
  double volume1 = 1.0;
  double volume2 = 1.0;
  double volume3 = 1.0;
  final sliderValue1 = ValueNotifier<double>(1.0);
  final sliderValue2 = ValueNotifier<double>(1.0);
  final sliderValue3 = ValueNotifier<double>(1.0);

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    try {
      await audioPlayer1.setAsset('assets/nature/heavyrain.mp3');
      await audioPlayer2.setAsset('assets/nature/fireplace.mp3');
      await audioPlayer3.setAsset('assets/nature/fallingleaves.mp3');
      audioPlayer1.setLoopMode(LoopMode.all);
      audioPlayer2.setLoopMode(LoopMode.all);
      audioPlayer3.setLoopMode(LoopMode.all);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                _buildAudioControl(
                    label: 'Heavy Rain',
                    audioPlayer: audioPlayer1,
                    volume: volume1,
                    sliderValue: sliderValue1,
                    icon: Icon(
                      Icons.water_drop_outlined,
                      size: 40,
                    )),
                _buildAudioControl(
                  label: 'Fireplace',
                  audioPlayer: audioPlayer2,
                  volume: volume2,
                  sliderValue: sliderValue2,
                  icon: Icon(
                    Icons.fire_extinguisher_outlined,
                    size: 40,
                  ),
                ),
                _buildAudioControl(
                  label: 'Falling Leaves',
                  audioPlayer: audioPlayer3,
                  volume: volume3,
                  sliderValue: sliderValue3,
                  icon: Icon(
                    Icons.nature_outlined,
                    size: 40,
                  ),
                ),
              ],
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
    required Icon icon,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: audioPlayer.playing ? Colors.green : Colors.red,
          ),
          child: InkWell(
            onTap: () {
              _toggleAudioPlayback(audioPlayer);
            },
            customBorder: CircleBorder(),
            child: icon,
          ),
        ),
        Text(label),
        Visibility(
          visible: audioPlayer.playing,
          child: SizedBox(
            width: 100,
            child: Slider(
              value: sliderValue.value,
              onChanged: (value) {
                setState(() {
                  sliderValue.value = value;
                });
                audioPlayer.setVolume(value);
              },
            ),
          ),
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
    setState(() {});
  }

  @override
  void dispose() {
    audioPlayer1.dispose();
    audioPlayer2.dispose();
    super.dispose();
  }
}
