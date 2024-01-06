import 'package:aura/util/provider/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/player.dart';
import 'package:get/get.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var favoriteProvider = Provider.of<FavoriteProvider>(context);
    List<Song> favoriteSongs = favoriteProvider.favoriteSongs.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Songs'),
      ),
      body: ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          Song song = favoriteSongs[index];
          return GestureDetector(
            onTap: () => Get.to(
              AuraPlayer(
                currentIndex: index,
                songs: favoriteSongs,
                title: 'Favorites',
              ),
              transition: Transition.downToUp,
            ),
            child: ListTile(
              title: Text(song.songName),
              subtitle: Text(song.artist),
            ),
          );
        },
      ),
    );
  }
}
