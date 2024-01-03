import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id; // Add this line for the id property
  final String songName;
  final String artist;
  final String imageUrl;
  final String songUrl;

  Song({
    required this.id, // Add this line for the id property
    required this.songName,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id, // Set the id property with the document ID
      songName: data['songName'] ?? '',
      artist: data['artist'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      songUrl: data['songUrl'] ?? '',
    );
  }
}
