import 'package:cloud_firestore/cloud_firestore.dart';

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
