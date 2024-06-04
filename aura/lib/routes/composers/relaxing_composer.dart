import 'dart:async';
import 'dart:ui';
import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/component/native_ad.dart';
import 'package:aura/core/broken_icons.dart';
import 'package:aura/data/composer_data/relaxing_composer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// ignore: unused_import
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';

class RelaxingComposer extends StatefulWidget {
  const RelaxingComposer({Key? key}) : super(key: key);

  @override
  State<RelaxingComposer> createState() => RelaxingComposerState();
}

class RelaxingComposerState extends State<RelaxingComposer> {
  int playingAudioCount = 0;
  final List<AudioPlayer> natureaudioPlayer =
      List.generate(6, (index) => AudioPlayer());
  final List<AudioPlayer> animalsaudioPlayer =
      List.generate(5, (index) => AudioPlayer());
  final List<AudioPlayer> rainaudioPlayer =
      List.generate(6, (index) => AudioPlayer());
  final List<AudioPlayer> musicaudioPlayer =
      List.generate(8, (index) => AudioPlayer());
  final List<AudioPlayer> asmraudioPlayer =
      List.generate(6, (index) => AudioPlayer());
  final List<AudioPlayer> transportaudioPlayer =
      List.generate(4, (index) => AudioPlayer());
  final Map<String, AudioPlayer> audioCache = {};

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadNativeAd();
    _loadAllAudios();
    _timer = null;
  }

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  void loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: AdMobService.composerAdsUnit!,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.medium),
        customOptions: {});
    _nativeAd?.load();
  }

  Widget _buildNativeAdWidget() {
    if (_nativeAdIsLoaded) {
      return NativeAdSmall(_nativeAd!);
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  Future<void> _loadAllAudios() async {
    await _loadCategoryAudios(natureaudioPaths, natureaudioPlayer);
    await _loadCategoryAudios(animalsaudioPaths, animalsaudioPlayer);
    await _loadCategoryAudios(rainaudioPaths, rainaudioPlayer);
    await _loadCategoryAudios(musicaudioPaths, musicaudioPlayer);
    await _loadCategoryAudios(asmraudioPaths, asmraudioPlayer);
    await _loadCategoryAudios(transportaudioPaths, transportaudioPlayer);
  }

  Future<void> _loadCategoryAudios(
      List<String> paths, List<AudioPlayer> players) async {
    for (int i = 0; i < paths.length; i++) {
      await _loadAudio(paths[i], players[i]);
    }

    for (final audioPlayer in players) {
      audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  Future<void> _loadAudio(String path, AudioPlayer audioPlayer) async {
    if (!audioCache.containsKey(path)) {
      await audioPlayer.setAsset(path);
      audioCache[path] = audioPlayer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Frelaxing.gif?alt=media&token=766d5a4b-f114-45c7-b7c0-2e0076c77386'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          SingleChildScrollView(
            controller: ScrollController(),
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: FadeInImage(
                          placeholder: AssetImage(
                              'assets/composer.gif'),
                          image: CachedNetworkImageProvider(
                              'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Frelaxing.gif?alt=media&token=766d5a4b-f114-45c7-b7c0-2e0076c77386'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.075,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Relaxing',
                                        style: GoogleFonts.dancingScript(
                                          color: Colors.white,
                                          fontSize: 38,
                                        ),
                                      ),
                                      _buildController(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                      image: AssetImage('assets/style3.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Nature Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < natureaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: natureIcons[i],
                                label: natureaudioNames[i],
                                audioPlayer: natureaudioPlayer[i],
                                colour: const Color.fromARGB(255, 38, 224, 45),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildNativeAdWidget(),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Animals Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < animalsaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: animalsIcons[i],
                                label: animalsaudioNames[i],
                                audioPlayer: animalsaudioPlayer[i],
                                colour: const Color.fromARGB(255, 97, 33, 10),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Rain Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < rainaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: rainIcons[i],
                                label: rainaudioNames[i],
                                audioPlayer: rainaudioPlayer[i],
                                colour: const Color.fromARGB(255, 33, 152, 243),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Music Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < musicaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: musicIcons[i],
                                label: musicaudioNames[i],
                                audioPlayer: musicaudioPlayer[i],
                                colour: const Color.fromARGB(255, 176, 39, 135),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'ASMR Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < asmraudioPaths.length; i++)
                              _buildAudioControl(
                                icon: asmrIcons[i],
                                label: asmraudioNames[i],
                                audioPlayer: asmraudioPlayer[i],
                                colour: const Color.fromARGB(255, 181, 115, 15),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF1F1F36),
                    image: DecorationImage(
                        image: AssetImage('assets/style3.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 20),
                            child: Text(
                              'Transport Category',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            for (int i = 0; i < transportaudioPaths.length; i++)
                              _buildAudioControl(
                                icon: transportIcons[i],
                                label: transportaudioNames[i],
                                audioPlayer: transportaudioPlayer[i],
                                colour: const Color.fromARGB(255, 24, 147, 98),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildController() {
    bool isAudioPlaying = false;
    for (var player in natureaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in animalsaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in rainaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in musicaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in asmraudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    for (var player in transportaudioPlayer) {
      if (player.playing) {
        isAudioPlaying = true;
      }
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: isAudioPlaying,
            child: GestureDetector(
              onTap: () {
                _showTimerDialog();
              },
              child: const Icon(
                Broken.timer_1,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Visibility(
            visible: isAudioPlaying,
            child: GestureDetector(
              onTap: () {
                _stopAllAudioPlayers();
              },
              child: const Icon(
                Broken.stop_circle,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControl({
    required String label,
    required AudioPlayer audioPlayer,
    required Widget icon,
    required Color colour,
  }) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          padding: const EdgeInsets.all(14.0),
          // margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: audioPlayer.playing ? colour : const Color(0xFF131321),
          ),
          child: InkWell(
            onTap: () {
              _toggleAudioPlayback(audioPlayer);
            },
            child: SizedBox(height: 40, width: 40, child: icon),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        audioPlayer.playing
            ? _buildVolumeSlider(audioPlayer)
            : Text(
                label,
                style: const TextStyle(
                  // color: Color.fromARGB(255, 103, 247, 110),
                  color: Colors.white,
                ),
              ),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  Widget _buildVolumeSlider(AudioPlayer audioPlayer) {
    return SizedBox(
        width: 64,
        child: SliderTheme(
          data: const SliderThemeData(
            trackHeight: 2.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
            thumbColor: Colors.white,
            activeTrackColor: Colors.white,
          ),
          child: Slider(
            value: audioPlayer.volume,
            onChanged: (value) {
              setState(() {
                audioPlayer.setVolume(value);
              });
            },
          ),
        ));
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

  Future<void> _showTimerDialog() async {
    int? selectedTime;

    selectedTime = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        List<Map<String, dynamic>> timerOptions = [
          {'duration': 300, 'label': '5 Minutes'},
          {'duration': 600, 'label': '10 Minutes'},
          {'duration': 1800, 'label': '30 Minutes'},
          {'duration': 3600, 'label': '1 Hour'},
          {'duration': 7200, 'label': '2 Hours'},
          {'duration': 18000, 'label': '5 Hours'},
        ];

        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF131321),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select Timer Duration',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView(
                  children: timerOptions
                      .map(
                        (option) => ListTile(
                          onTap: () {
                            selectedTime = option['duration'];
                            Navigator.of(context).pop(selectedTime);
                          },
                          tileColor: (selectedTime == option['duration'])
                              ? Color(0xFF131321)
                              : Colors.grey[800],
                          title: Center(
                            child: Text(
                              option['label'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedTime != null) {
      _timer?.cancel();
      _startTimer(selectedTime!);
    }
  }

  void _startTimer(int durationInSeconds) {
    _timer = Timer(Duration(seconds: durationInSeconds), () {
      _stopAllAudioPlayers();
      setState(() {});
    });

    setState(() {});
  }

  void _stopAllAudioPlayers() {
    for (var player in natureaudioPlayer) {
      player.stop();
    }
    for (var player in animalsaudioPlayer) {
      player.stop();
    }
    for (var player in rainaudioPlayer) {
      player.stop();
    }
    for (var player in musicaudioPlayer) {
      player.stop();
    }
    for (var player in asmraudioPlayer) {
      player.stop();
    }
    for (var player in transportaudioPlayer) {
      player.stop();
    }
    setState(() {
      playingAudioCount = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _nativeAd?.dispose();
    _timer = null;
    _stopAllAudioPlayers();
    for (var player in natureaudioPlayer) {
      player.dispose();
    }
    for (var player in animalsaudioPlayer) {
      player.dispose();
    }
    for (var player in rainaudioPlayer) {
      player.dispose();
    }
    for (var player in musicaudioPlayer) {
      player.dispose();
    }
    for (var player in asmraudioPlayer) {
      player.dispose();
    }
    for (var player in transportaudioPlayer) {
      player.dispose();
    }
    super.dispose();
  }
}
