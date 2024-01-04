import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relaxing Playlists'),
      ),
      body: FutureBuilder(
        future: _fetchPlaylists(),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the playlists
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> playlist = snapshot.data![index];
                return ListTile(
                  title: Text(playlist['artist'] ?? ''),
                  subtitle: Image.network(playlist['imageUrl'] ?? ''),
                  onTap: () {
                    // Navigate to a new screen to display songs in the selected playlist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongsScreen(
                          playlist['id'],
                          artist: playlist['artist'],
                          imageUrl: playlist['imageUrl'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> _fetchPlaylists() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('relaxing').get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'artist': doc['artist'],
          'imageUrl': doc['imageUrl'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching playlists: $e');
      return null;
    }
  }
}

class SongsScreen extends StatelessWidget {
  final String playlistId;
  final String artist;
  final String imageUrl;

  SongsScreen(this.playlistId, {required this.artist, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songs by $artist'),
      ),
      body: FutureBuilder(
        future: _fetchSongs(),
        builder:
            (context, AsyncSnapshot<List<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the songs in the selected playlist
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Artist: $artist', style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> song = snapshot.data![index];
                      return Column(
                        children: [
                          Image.network(imageUrl),
                          ListTile(
                            title: Text(song['songName'] ?? ''),
                            subtitle: Text('URL: ${song['songUrl']}'),
                            // Add any other UI elements or functionality you need
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> _fetchSongs() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('relaxing')
          .doc(playlistId)
          .collection('sounds')
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'songName': doc['songName'],
          'songUrl': doc['songUrl'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching songs: $e');
      return null;
    }
  }
}
