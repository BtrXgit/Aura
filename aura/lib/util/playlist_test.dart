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
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the playlists
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> playlist = snapshot.data![index];
                return ListTile(
                  title: Text(playlist['name']),
                  subtitle: Text(playlist['description']),
                  onTap: () {
                    // Navigate to a new screen to display songs in the selected playlist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongsScreen(playlist['id']),
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

  Future<List<Map<String, dynamic>>> _fetchPlaylists() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('playlists').get();

    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
        'description': doc['description'],
      };
    }).toList();
  }
}

class SongsScreen extends StatelessWidget {
  final String playlistId;

  SongsScreen(this.playlistId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songs'),
      ),
      body: FutureBuilder(
        future: _fetchSongs(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Display the songs in the selected playlist
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> song = snapshot.data![index];
                return ListTile(
                  title: Text(song['sound_name']),
                  subtitle: Text('Duration: ${song['duration']}'),
                  // Add any other UI elements or functionality you need
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchSongs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlistId)
        .collection('sounds')
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'sound_name': doc['sound_name'],
        'url': doc['url'],
        'duration': doc['duration'],
      };
    }).toList();
  }
}

void main() {
  runApp(MaterialApp(
    home: PlaylistScreen(),
  ));
}
