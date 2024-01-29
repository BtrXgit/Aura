import 'package:aura/routes/pages/player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RelaxingLive extends StatefulWidget {
  const RelaxingLive({super.key});

  @override
  State<RelaxingLive> createState() => _RelaxingLiveState();
}

class _RelaxingLiveState extends State<RelaxingLive> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<LiveSongs> relaxingLive = [];

  @override
  void initState() {
    super.initState();
    _getRelaxingLiveData().listen((snapshot) {
      setState(() {
        relaxingLive =
            snapshot.docs.map((doc) => LiveSongs.fromFirestore(doc)).toList();
      });
    });
  }

  Stream<QuerySnapshot> _getRelaxingLiveData() {
    return _firestore.collection('relaxingLive').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131321),
      body: _buildRelaxingCategory(),
    );
  }

  Widget _buildRelaxingCategory() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 8, top: 10),
      child: SizedBox(
        height: 250,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1.2),
          itemCount: relaxingLive.length,
          itemBuilder: (BuildContext context, int index) {
            var song = relaxingLive[index];
            return Container(
              width: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(song.imageUrl),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(14)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 13, 12, 53),
                  ),
                  child: ListTile(
                    title: Text(
                      song.songName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(song.artist),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
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
