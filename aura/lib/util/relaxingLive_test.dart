import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aura/util/livePlayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RelaxingLive extends StatefulWidget {
  const RelaxingLive({super.key});

  @override
  State<RelaxingLive> createState() => _RelaxingLiveState();
}

class _RelaxingLiveState extends State<RelaxingLive> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<LiveSongs> relaxingLive = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _getRelaxingLiveData().listen((snapshot) {
      setState(() {
        relaxingLive =
            snapshot.docs.map((doc) => LiveSongs.fromFirestore(doc)).toList();
      });

      if (relaxingLive.isNotEmpty) {
        var random = Random();
        index = random.nextInt(relaxingLive.length);

        Timer(
          Duration(seconds: 5),
          () {
            Get.off(
              AuraLivePlayer(
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

  Stream<QuerySnapshot> _getRelaxingLiveData() {
    return _firestore.collection('relaxingLive').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131321),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Relaxing%2FLive%2FrelaxingLive.jpg?alt=media&token=e50a6120-4787-41f1-8730-15d1f7ec6795'),
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
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

class LiveSongs {
  final String songName;
  final String artist;
  final String imageUrl;
  final String songUrl;

  LiveSongs({
    required this.songName,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
  });

  factory LiveSongs.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LiveSongs(
      songName: data['songName'] ?? '',
      artist: data['artist'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      songUrl: data['songUrl'] ?? '',
    );
  }
}
