import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String songName;
  final String artist;
  final String imageUrl;
  final String songUrl;

  Song({
    required this.id,
    required this.songName,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      songName: data['songName'] ?? '',
      artist: data['artist'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      songUrl: data['songUrl'] ?? '',
    );
  }

  // Other methods, if needed

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'songName': songName,
      'artist': artist,
      'imageUrl': imageUrl,
      'songUrl': songUrl,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      songName: map['songName'],
      artist: map['artist'],
      imageUrl: map['imageUrl'],
      songUrl: map['songUrl'],
    );
  }
}
