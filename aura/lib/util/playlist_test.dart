import 'dart:convert';
import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/player.dart';
import 'package:aura/routes/pages/playlistplayer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  SharedPreferences? _preferences;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relaxing Playlists'),
      ),
      body: _buildPlaylistBody(),
    );
  }

  Widget _buildPlaylistBody() {
    return FutureBuilder(
      future: _fetchPlaylists(),
      builder: (context, AsyncSnapshot<List<Song>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error: ${snapshot.error}');
        } else {
          return _buildPlaylistListView(snapshot.data!);
        }
      },
    );
  }

  Widget _buildPlaylistListView(List<Song> playlists) {
    return ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        Song playlist = playlists[index];
        return ListTile(
          title: Text(playlist.artist),
          subtitle: Image.network(playlist.imageUrl),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SongsScreen(playlist),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Song>?> _fetchPlaylists() async {
    try {
      final cachedData = _preferences?.getStringList('playlists');
      if (cachedData != null) {
        return cachedData
            .map((json) => Song.fromMap(jsonDecode(json)))
            .toList();
      }

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('relaxing').get();

      final playlists =
          querySnapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();

      // Save to SharedPreferences for future use
      _preferences?.setStringList(
        'playlists',
        playlists.map((playlist) => jsonEncode(playlist.toMap())).toList(),
      );

      return playlists;
    } catch (e) {
      print('Error fetching playlists: $e');
      return null;
    }
  }
}

class SongsScreen extends StatelessWidget {
  final Song playlist;

  SongsScreen(this.playlist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songs by ${playlist.artist}'),
      ),
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
                  AuraPlaylistPlayer(
                    currentIndex: index,
                    songs: songs,
                    title: 'Focus',
                    imageUrl: playlist.imageUrl,
                  ),
                  transition: Transition.downToUp,
                ),
                child: Column(
                  children: [
                    Image.network(playlist.imageUrl),
                    ListTile(
                      title: Text(song.songName),
                      subtitle: Text('URL: ${song.songUrl}'),
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
          .doc(playlist.id)
          .collection('sounds')
          .get();

      return querySnapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching songs: $e');
      return null;
    }
  }
}
