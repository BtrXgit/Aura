import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String songName;
  final String artist;
  final String imageUrl;
  final String songUrl;

  Song({
    required this.songName,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Song(
      songName: data['songName'] ?? '',
      artist: data['artist'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      songUrl: data['songUrl'] ?? '',
    );
  }
}
