import 'dart:ui';

import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/controllers/ad_controller.dart';
import 'package:aura/core/broken_icons.dart';
import 'package:aura/subscription/subscription.dart';
import 'package:aura/util/players/mainAuraPlayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aura/data/songs.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconly/iconly.dart';
import 'package:palette_generator/palette_generator.dart';

class SongsScreen extends StatefulWidget {
  final Song playlist;
  final String category;

  SongsScreen(this.playlist, this.category);

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  Color? dominantColor;

  @override
  void initState() {
    super.initState();
    _loadDominantColor();
  }

  Future<void> _loadDominantColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(
        widget.playlist.imageUrl,
      ),
    );
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionController = Get.put(SubscriptionController());
    final adController = Get.put(AdController());
    return Scaffold(
      appBar: null,
      bottomNavigationBar: subscriptionController.isSubscribed.value
          ? null
          : adController.bannerAd != null
              ? Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: adController.bannerAd!),
                  width: adController.bannerAd!.size.width.toDouble(),
                  height: adController.bannerAd!.size.height.toDouble(),
                )
              : null,
      body: SafeArea(
        child: NestedScrollView(
          controller: ScrollController(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                forceMaterialTransparency: false,
                floating: false,
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Color(0xFF131321),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double offset = constraints.biggest.height;
                    bool isAppBarExpanded = offset > 100;

                    return FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      title: isAppBarExpanded
                          ? null
                          : Text(
                              '${widget.playlist.playlistName}',
                              style: GoogleFonts.caveat(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      background: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      widget.playlist.imageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 28, 0, 10),
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            widget.playlist.imageUrl,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${widget.playlist.playlistName}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        Text('${widget.playlist.artist}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: IconButton(
                                        iconSize: 30,
                                        color: dominantColor,
                                        onPressed: () async {
                                          List<Song>? songs =
                                              await _fetchSongs();
                                          if (songs != null) {
                                            _playPlaylist(songs);
                                          }
                                        },
                                        icon: Icon(
                                          IconlyBold.play,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ];
          },
          body: _buildSongsBody(),
        ),
      ),
    );
  }

  void _playPlaylist(List<Song> songs) {
    Get.to(
      () => AuraPlayer(
        currentIndex: 0,
        songs: songs,
        title: widget.playlist.playlistName!,
      ),
    );
  }

  Widget _buildSongsBody() {
    return FutureBuilder(
      future: _fetchSongs(),
      builder: (context, AsyncSnapshot<List<Song>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Text(
              'Error loading songs',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return _buildSongsListView(snapshot.data!);
        }
      },
    );
  }

  Widget _buildSongsListView(List<Song> songs) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
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
                  title: widget.playlist.playlistName!,
                ),
              ),
              child: ListTile(
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
                            title: widget.playlist.playlistName!,
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

  Future<List<Song>?> _fetchSongs() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('${widget.category}')
          .doc(widget.playlist.id)
          .collection('sounds')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Song(
          id: doc.id,
          songName: data['songName'] ?? '',
          artist: widget.playlist.artist,
          imageUrl: widget.playlist.imageUrl,
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
