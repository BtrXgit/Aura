import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongsScreen extends StatelessWidget {
  final Song playlist;

  SongsScreen(this.playlist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF131321),
        title: Text(
          '${playlist.playlistName}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF131321),
      body: _buildSongsBody(),
    );
  }

  Widget _buildSongsBody() {
    return FutureBuilder(
      future: _fetchSongs(),
      builder: (context, AsyncSnapshot<List<Song>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error: ${snapshot.error}');
        } else {
          return _buildSongsListView(snapshot.data!);
        }
      },
    );
  }

  Widget _buildSongsListView(List<Song> songs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Artist: ${playlist.artist}', style: TextStyle(fontSize: 18)),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              Song song = songs[index];
              return GestureDetector(
                onTap: () => Get.to(
                  AuraPlayer(
                    currentIndex: index,
                    songs: songs,
                    title: 'Focus',
                  ),
                  transition: Transition.downToUp,
                ),
                child: Column(
                  children: [
                    CachedNetworkImage(
                        width: 200, height: 200, imageUrl: playlist.imageUrl),
                    ListTile(
                      title: Text(song.songName),
                      // subtitle: Text('URL: ${song.songUrl}'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<List<Song>?> _fetchSongs() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('relaxing')
          .doc(playlist
              .id) // Assuming 'playlist.id' refers to the playlist document ID
          .collection('sounds')
          .get();

      return querySnapshot.docs.map((doc) {
        // Use the data from the 'sounds' subcollection
        final data = doc.data() as Map<String, dynamic>;
        return Song(
          id: doc.id,
          songName: data['songName'] ?? '',
          artist: playlist.artist,
          imageUrl: playlist.imageUrl,
          songUrl: data['songUrl'] ?? '',
          playlistName: data['playlistName'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching songs: $e');
      return null;
    }
  }
}
