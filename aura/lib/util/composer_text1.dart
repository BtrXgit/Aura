import 'package:aura/data/composer_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class ComposerAudio extends StatefulWidget {
  const ComposerAudio({super.key});

  @override
  State<ComposerAudio> createState() => _ComposerAudioState();
}

class _ComposerAudioState extends State<ComposerAudio> {
  int playingAudioCount = 0;

  List<String> musicaudioUrl = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fharp.mp3?alt=media&token=70fdb10c-c8d0-4b37-ab67-531c5de6fd93',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fpiano.ogg?alt=media&token=b61ec5c0-3234-4854-a10b-99c2e68fc4d9',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fpiano_2.ogg?alt=media&token=4aff1172-1be0-40a5-b967-e32e534479e0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fguitar.mp3?alt=media&token=c8784bf4-7eb9-44f4-8909-ea0a8cdb31c8',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Flofi_guitar.mp3?alt=media&token=6b13d5c5-bf73-4337-946d-99104134d075',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fguitar_sentimental.mp3?alt=media&token=a544af90-7dec-45cc-accc-13a81723c91c',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Facoustic_guitar.mp3?alt=media&token=8a07bb81-7cf9-497c-89ed-fc55296b5944',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fviolin.mp3?alt=media&token=82f7fb84-874b-49ca-a6a0-c00d64543f9f',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fpeaceful.mp3?alt=media&token=c5cebdf4-c205-43c5-91d8-cd14edacf478',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Frhodes.mp3?alt=media&token=09ee6fc8-c258-437b-a5cd-8b3a746f0dc7',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fambience.mp3?alt=media&token=de4d5a31-2ab0-4d18-bd99-25598e65a6f0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fambient.mp3?alt=media&token=04eb6fe1-2f5c-4de2-aa40-27148e562b42',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fchill.mp3?alt=media&token=2d894f1c-e261-42cb-82fa-ae5aaf765099',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/composer%2Fmusic%2Fcinematic.mp3?alt=media&token=38679047-a6f8-4843-9b2d-f7a6363326b0',
  ];

  @override
  void initState() {
    super.initState();
    _loadmusicAudios();
  }

  final List<AudioPlayer> musicaudioPlayer =
      List.generate(14, (index) => AudioPlayer());

  Future<void> _loadmusicAudios() async {
    final storage = FirebaseStorage.instance;

    for (int i = 0;
        i < musicaudioPlayer.length && i < musicaudioUrl.length;
        i++) {
      final downloadUrl = await storage.ref(musicaudioUrl[i]).getDownloadURL();
      final audioSource = AudioSource.uri(Uri.parse(downloadUrl));
      await musicaudioPlayer[i].setAudioSource(audioSource);
    }

    for (final audioPlayer in musicaudioPlayer) {
      audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 28, 48),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Music Category',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                for (int i = 0; i < 14; i++)
                  _buildAudioControl(
                    icon: musicIcons[i],
                    label: musicaudioNames[i],
                    audioPlayer: musicaudioPlayer[i],
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
    required Widget icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: audioPlayer.playing
                ? const Color.fromARGB(255, 37, 194, 42)
                : const Color.fromARGB(255, 38, 43, 80),
          ),
          child: InkWell(
            onTap: () {
              _toggleAudioPlayback(audioPlayer);
            },
            child: SizedBox(height: 40, width: 40, child: icon),
          ),
        ),
        const SizedBox(height: 3),
        audioPlayer.playing
            ? _buildVolumeSlider(audioPlayer)
            : Text(
                label,
                style: const TextStyle(
                  color: Color.fromARGB(255, 103, 247, 110),
                ),
              ),
        const SizedBox(height: 3),
      ],
    );
  }

  Widget _buildVolumeSlider(AudioPlayer audioPlayer) {
    return SizedBox(
      width: 74,
      height: 20,
      child: Slider(
        value: audioPlayer.volume,
        onChanged: (value) {
          setState(() {
            audioPlayer.setVolume(value);
          });
        },
      ),
    );
  }

  void _toggleAudioPlayback(AudioPlayer audioPlayer) {
    if (audioPlayer.playing) {
      audioPlayer.pause();
      setState(() {
        playingAudioCount--;
      });
    } else {
      if (playingAudioCount >= 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only 8 audios can be played at a time.'),
          ),
        );
        return;
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        audioPlayer.play();
        setState(() {
          playingAudioCount++;
        });
      });
    }

    print('Audio Player State: ${audioPlayer.playing ? 'Playing' : 'Paused'}');
  }
}
