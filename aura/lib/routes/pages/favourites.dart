import 'package:aura/authentication/auth%20pages/login_page.dart';
import 'package:aura/core/broken_icons.dart';
import 'package:aura/data/songs.dart';
import 'package:aura/util/players/mainAuraPlayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteSongsScreen extends StatefulWidget {
  final ScrollController controller;
  FavouriteSongsScreen({required this.controller, Key? key});

  @override
  _FavouriteSongsScreenState createState() => _FavouriteSongsScreenState();
}

class _FavouriteSongsScreenState extends State<FavouriteSongsScreen> {
  ScrollController scrollController = ScrollController();
  late Stream<QuerySnapshot>? _likedSongsStream;
  List<Song> songs = [];

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  void _fetchSongs() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      _likedSongsStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Favourites')
          .snapshots();

      _likedSongsStream!.listen((QuerySnapshot snapshot) {
        setState(() {
          songs = snapshot.docs.map((doc) {
            return Song.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();
        });
      });
    } else {
      _likedSongsStream = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (user != null)
            IconButton(
              onPressed: () {
                String userId = user.uid;
                _showClearFavoritesConfirmationDialog(context, userId);
              },
              icon: Icon(Broken.trash),
            )
        ],
        elevation: 0,
        forceMaterialTransparency: true,
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Favourites',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: user == null ? _buildSignInPrompt(context) : _buildSongsList(songs),
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please sign in to see liked songs',
            style: GoogleFonts.kanit(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(const LoginPage(),
                  transition: Transition.rightToLeftWithFade);
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _buildSongsList(List<Song> songs) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        controller: widget.controller,
        itemCount: songs.length,
        itemBuilder: (context, index) {
          Song song = songs[index];
          return Card(
            elevation: 2,
            color: Color(0xFF1C1C1E),
            child: InkWell(
              onTap: () => Get.to(
                () => AuraPlayer(
                  currentIndex: index,
                  songs: songs,
                  title: 'Favourites',
                ),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: songs[index].imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                title: Text(
                  song.songName,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song.artist,
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
                trailing: IconButton(
                    onPressed: () => Get.to(
                          () => AuraPlayer(
                            currentIndex: index,
                            songs: songs,
                            title: 'Favourites',
                          ),
                        ),
                    icon: Icon(Broken.play_circle)),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showClearFavoritesConfirmationDialog(
      BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Clear Favorites?'),
          content: const Text(
              'Are you sure you want to clear all your favorite songs?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                clearAllLikedSongs(userId);
                Navigator.of(context).pop();
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void clearAllLikedSongs(String userId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Favourites')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      if (kDebugMode) {
        print('All liked songs deleted successfully!');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to delete all liked songs: $error');
      }
    });
  }
}

class SongCard extends StatelessWidget {
  // final Song song;
  final String imageUrl;
  final String artist;
  final String songName;
  final String songUrl;

  SongCard(
      {required this.imageUrl,
      required this.artist,
      required this.songName,
      required this.songUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        title: Text(songName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(artist),
        trailing: Icon(Icons.play_arrow, color: Colors.purple),
        onTap: () {
          // Handle song play action
        },
      ),
    );
  }
}
