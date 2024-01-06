import 'package:flutter/material.dart';
import 'package:aura/data/songs.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Song> _favoriteSongs = [];

  List<Song> get favoriteSongs => _favoriteSongs;

  void toggleFavorite(Song song) {
    if (_favoriteSongs.contains(song)) {
      _favoriteSongs.remove(song);
    } else {
      _favoriteSongs.add(song);
    }
    notifyListeners();
  }
}
