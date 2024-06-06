import 'dart:async';
import 'dart:convert';
import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/component/native_ad.dart';
import 'package:aura/controllers/ad_controller.dart';
import 'package:aura/data/songs.dart';
import 'package:aura/routes/pages/playlists/playlists_songs.dart';
import 'package:aura/services/admob_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  final adController = Get.put(AdController());

  @override
  void initState() {
    super.initState();
    loadNativeAd();
    _initPreferences();
    _playlistsController = StreamController<List<Song>>();
    _fetchPlaylists();
  }

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  void loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: AdMobService.nativeAdUnitId!,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.medium),
        customOptions: {});
    _nativeAd?.load();
  }

  Widget _buildNativeAdWidget() {
    if (_nativeAdIsLoaded) {
      return NativeAdSmall(_nativeAd!);
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  void _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) {
      return s[0].toUpperCase() + s.substring(1);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF131321),
        title: Text(
          '${capitalize(widget.category)} Playlists',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: adController.playersBannerAd != null
          ? Container(
              alignment: Alignment.center,
              child: AdWidget(ad: adController.playersBannerAd!),
              width: adController.playersBannerAd!.size.width.toDouble(),
              height: adController.playersBannerAd!.size.height.toDouble(),
            )
          : null,
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
          return Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        }
      },
    );
  }

  Widget _buildPlaylistListView(List<Song> playlists) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: playlists.length,
        separatorBuilder: (context, index) {
          if (index == 1 && index > 0) {
            return _buildNativeAdWidget();
          } else {
            return Container();
          }
        },
        itemBuilder: (context, index) {
          Song playlist = playlists[index];
          return GestureDetector(
            onTap: () => Get.to(
              () => SongsScreen(playlist, '${widget.category}'),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.24,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  image: DecorationImage(
                      image: AssetImage('assets/st1.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(14)),
              margin: EdgeInsets.symmetric(vertical: 6.0),
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
                            playlist.playlistName!,
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
