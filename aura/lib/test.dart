import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';

class SongsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();

  SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Songs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('songs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var songs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              var songData = songs[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(songData['songName']),
                subtitle: Text(songData['artist']),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(songData['imageUrl']),
                ),
                onTap: () {
                  _playAudio(songData['songUrl']);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _playAudio(String audioUrl) async {
    try {
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }
}
