import 'dart:async';
import 'dart:convert';
import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/playlists/playlists_songs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistsPage extends StatefulWidget {
  final String category;

  const PlaylistsPage({required this.category, Key? key}) : super(key: key);

  @override
  _PlaylistsPageState createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF131321),
        title: Text(
          '${widget.category} Playlists',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF131321),
      body: _buildPlaylistBody(),
    );
  }

  Widget _buildPlaylistBody() {
    return StreamBuilder<List<Song>>(
      stream: _playlistsController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildPlaylistListView(snapshot.data!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildPlaylistListView(List<Song> playlists) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: playlists.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          Song playlist = playlists[index];
          return GestureDetector(
            onTap: () => Get.to(
              () => SongsScreen(playlist, '${widget.category}'),
            ),
            child: Container(
              decoration: BoxDecoration(
                  // color: const Color(0xFF1F1F36),
                  image: DecorationImage(
                      image: AssetImage('assets/style3.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist.playlistName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            playlist.artist,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(playlist.imageUrl),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _fetchPlaylists() async {
    try {
      final cachedData = _preferences?.getStringList('playlists');
      if (cachedData != null) {
        _playlistsController.add(cachedData
            .map((json) => Song.fromFirestore(jsonDecode(json)))
            .toList());
        return; // Return early if data is cached
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('${widget.category}')
          .get();

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
