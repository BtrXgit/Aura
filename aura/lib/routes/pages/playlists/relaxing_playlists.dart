import 'dart:async';
import 'dart:convert';

import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelaxingPlaylistScreen extends StatefulWidget {
  @override
  _RelaxingPlaylistScreenState createState() => _RelaxingPlaylistScreenState();
}

class _RelaxingPlaylistScreenState extends State<RelaxingPlaylistScreen> {
  SharedPreferences? _preferences;
  late StreamController<List<Song>> _playlistsController;

  @override
  void initState() {
    super.initState();
    _initPreferences();
    _playlistsController = StreamController<List<Song>>();
    _fetchPlaylists();
  }

  void _initPreferences() async {
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
    return StreamBuilder<List<Song>>(
      stream: _playlistsController.stream,
      builder: (context, snapshot) {
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
    return GridView.builder(
      itemCount: playlists.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        Song playlist = playlists[index];
        return GestureDetector(
          onTap: () => Get.to(() => SongsScreen(playlist)),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(playlist.imageUrl),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(14)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 64,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 13, 12, 53),
                ),
                child: ListTile(
                  title: Text(
                    playlist.playlistName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(playlist.artist),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _fetchPlaylists() async {
    try {
      final cachedData = _preferences?.getStringList('playlists');
      if (cachedData != null) {
        _playlistsController.add(cachedData
            .map((json) => Song.fromFirestore(jsonDecode(json)))
            .toList());
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

      _playlistsController.add(playlists);
    } catch (e) {
      print('Error fetching playlists: $e');
      _playlistsController.addError(e);
    }
  }

  @override
  void dispose() {
    _playlistsController.close();
    super.dispose();
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
