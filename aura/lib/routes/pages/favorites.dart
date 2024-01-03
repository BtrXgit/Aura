import 'package:aura/data/songs.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Song> favoriteSongs;

  const FavoritesPage({Key? key, required this.favoriteSongs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Songs'),
      ),
      body: ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          Song song = favoriteSongs[index];
          return ListTile(
            title: Text(song.songName),
            subtitle: Text(song.artist),
          );
        },
      ),
    );
  }
}
