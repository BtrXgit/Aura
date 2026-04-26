import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/component/native_ad.dart';
import 'package:aura/controllers/ad_controller.dart';
import 'package:aura/services/admob_service.dart';
import 'package:aura/subscription/subscription.dart';
import 'package:aura/util/players/soundsPlayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconly/iconly.dart';

class RecommendedSoundsPage extends StatefulWidget {
  RecommendedSoundsPage({super.key});

  @override
  State<RecommendedSoundsPage> createState() => _RecommendedSoundsPageState();
}

class _RecommendedSoundsPageState extends State<RecommendedSoundsPage> {
 
  List<String> recommendedImageUrl = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Focean.jpg?alt=media&token=687073b1-be9f-4bf0-9f9f-379b60a59969',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbirdsong.jpg?alt=media&token=3273f108-27d8-4ad1-b96b-ddc845fe8407',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fpiano.jpg?alt=media&token=72789b21-67b9-4f7c-a444-d19628e54489',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fharp.jpg?alt=media&token=86b8d014-0547-404d-af58-90f9c156f4bf',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbonfire.jpg?alt=media&token=1a19e51f-260f-41b8-8e91-47afbf2572f9',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fchimes.jpg?alt=media&token=a43f462d-0e40-4be5-8fbb-55397cca4d84',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fwindintrees.jpg?alt=media&token=49c081bf-b63f-4994-92bb-eeb56cdb93d0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fzen.jpg?alt=media&token=3d71080b-bca6-4cd2-8830-f866f4e95867',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Frainfall.jpg?alt=media&token=de69900f-6f3f-4dc5-a99b-4f4d345db517',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fthunderstorm.jpg?alt=media&token=92f285f5-3e1b-4981-bbd2-d21f4789b33f',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fbowl.jpg?alt=media&token=c690e04e-e5a1-41d9-b38a-6a2c53a9d5ba',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FRecommended%20Sounds%2Fcity%20rain.jpg?alt=media&token=fe70dac2-953a-479e-93af-04276c1ec624',
  ];

  List<String> recommendedSoundes = [
    'Ocean Waves',
    'Birdsong',
    'Soft Piano',
    'Harp',
    'Bonfire',
    'Wind Chimes',
    'Wind in the Trees',
    'Zen Garden',
    'Rainfall',
    'Thunderstorm',
    'Tibetan Bowl',
    'City Rain',
  ];

  List<String> songs = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Home%2FOcean%20Waves.mp3?alt=media&token=d72831af-8b6f-4609-a43d-0ffbcb4af1a3',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Home%2FBirdsong.mp3?alt=media&token=0aa04915-ddf4-4178-a449-c4df063f3445',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FSoft%20Piano.mp3?alt=media&token=b99e81a3-2f90-4dbb-9111-5df0d4b54143',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FHarp.mp3?alt=media&token=74d14dfa-6255-469b-836b-613d17a4b622',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FBonfire.mp3?alt=media&token=1f50ef65-565d-4b20-bb29-8a2a2ef8f8a1',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FWind%20Chimes.mp3?alt=media&token=8fe38f34-4875-49dc-a4c0-c2cc695df620',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FWind%20in%20the%20Trees.mp3?alt=media&token=0d47a620-019d-4ab8-989f-c9718ed83261',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FZen%20Garden%20Music.mp3?alt=media&token=fd4f17fa-b0d0-4795-9cba-5e9fdd2a7c41',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Home%2FRain.mp3?alt=media&token=75029cfc-b181-4f46-a8ce-a6f4069c92e2',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FThunderstorm.mp3?alt=media&token=a822aac1-0850-40cd-af10-2bfcb740411b',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FRecommended%2FTibetan%20Bowl.mp3?alt=media&token=440c2ff1-ec62-4507-a759-e83e9e20793e',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Home%2FCity%20Rain.mp3?alt=media&token=bc7216ee-a962-440d-b57a-ecc731d3afab',
  ];

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

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF131321),
        title: Text(
          'Recommended Sounds',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF131321),
      body: _buildPlaylistListView(),
     
    );
  }

  Widget _buildPlaylistListView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: recommendedSoundes.length,
        separatorBuilder: (context, index) {
          if (index == 1 && index > 0) {
            return _buildNativeAdWidget();
          } else {
            return Container();
          }
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Get.to(SoundsPlayer(
              currentIndex: index,
              songs: songs,
              title: 'Recommended Sounds',
              imageUrl: recommendedImageUrl,
              soundNames: recommendedSoundes,
            )),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                image: DecorationImage(
                  image: AssetImage('assets/st1.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              margin: EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            recommendedImageUrl[index],
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            recommendedSoundes[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            IconlyBold.play,
                            size: 54,
                            color: Colors.white,
                          ),
                        ],
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
}
