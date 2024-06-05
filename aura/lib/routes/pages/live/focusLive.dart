import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aura/data/songs.dart';
import 'package:aura/util/players/mainAuraPlayer.dart';
// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusLive extends StatefulWidget {
  final String title;
  final String imageUrl;

  const FocusLive({super.key, required this.imageUrl, required this.title});

  @override
  State<FocusLive> createState() => _FocusLiveState();
}

class _FocusLiveState extends State<FocusLive> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Song> relaxingLive = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _getFocusLiveData().listen((snapshot) {
      setState(() {
        relaxingLive =
            snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
      });

      if (relaxingLive.isNotEmpty) {
        var random = Random();
        index = random.nextInt(relaxingLive.length);

        Timer(
          Duration(seconds: 5),
          () {
            Get.off(
              AuraPlayer(
                title: widget.title,
                currentIndex: index,
                songs: relaxingLive,
              ),
              transition: Transition.fadeIn,
            );
          },
        );
      }
    });
  }

  // Stream<QuerySnapshot> _getFocusLiveData() {
  //   int randomLimit = Random().nextInt(51) + 50;

  //   return _firestore
  //       .collection('Liveplaylist')
  //       .doc('Sleep')
  //       .collection('sounds')
  //       .limit(randomLimit)
  //       .snapshots();
  // }

  Stream<QuerySnapshot> _getFocusLiveData() {
    // Define the range for the random limit
    int minLimit = 10;
    int maxLimit = 50;

    // Generate a random limit within the specified range
    int randomLimit = Random().nextInt(maxLimit - minLimit + 1) + minLimit;

    return _firestore
        .collection('Liveplaylist')
        .doc('Focus')
        .collection('sounds')
        .limit(randomLimit)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Widget live = Image.asset(
      'assets/live.png',
      height: 84,
      width: 84,
    );
    live = live.animate(adapter: ValueAdapter(0.5)).shimmer(
      colors: [
        const Color(0xFFFF0000),
        Colors.transparent,
      ],
    );

    live = live
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .saturate(
            delay: NumDurationExtensions(1).seconds,
            duration: NumDurationExtensions(1).seconds)
        .then()
        .tint(
          color: Colors.transparent,
        )
        .then()
        .blurXY(end: 24)
        .fadeOut();
    return Scaffold(
      backgroundColor: Color(0xFF131321),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(widget.imageUrl), fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 10,
            child: live,
          ),
          Center(child: _buildRelaxingCategory()),
        ],
      ),
    );
  }

  Widget _buildRelaxingCategory() {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 8, top: 10),
        child: DefaultTextStyle(
          style: GoogleFonts.cookie(
            fontSize: 42.0,
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            pause: Duration(milliseconds: 1000),
            animatedTexts: [
              TyperAnimatedText('Live Starting Soon....',
                  speed: Duration(milliseconds: 100)),
            ],
          ),
        ));
  }
}
