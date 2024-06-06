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

class NoisesPage extends StatefulWidget {
  const NoisesPage({super.key});

  @override
  State<NoisesPage> createState() => _NoisesPageState();
}

class _NoisesPageState extends State<NoisesPage> {
  final SubscriptionController subscriptionController =
      Get.put(SubscriptionController());
  List<String> noisesImage = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fwhite.jpg?alt=media&token=9af3e878-629c-43b4-af8f-487c3b1f14d0',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fpink.jpg?alt=media&token=34a50113-949c-4942-aadb-7c3236f4a55c',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fbrown.jpg?alt=media&token=4213f35a-3ee1-43cc-9275-8a68c6effc81',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fblue.jpg?alt=media&token=975c4669-2564-43c9-9cf4-2013dd1847a5',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fviolet.jpg?alt=media&token=60ce2298-c146-4d3a-ad68-f545f764d5e5',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fgrey.jpg?alt=media&token=6a08ebfb-3da7-49e6-a38f-3670238e2c0f',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fred.jpg?alt=media&token=bd7506c8-6f6d-4cf8-8104-bd146696cf47',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FImages%2Fgreen.jpg?alt=media&token=838a8722-d785-4a0b-a8e8-de171a351096',
  ];

  List<String> noisesSounds = [
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FWhite%20Noise.mp3?alt=media&token=bd7af2e8-2162-40c7-b0bd-e3c4ec9478e1',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FPink%20Noise.mp3?alt=media&token=4dc54875-28c0-4536-8128-450cc89679f2',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBrown%20Noise.mp3?alt=media&token=3177c986-7c1a-4a6f-af88-9fec8ff1dd73',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FBlue%20Noise.mp3?alt=media&token=84a1d86a-9e8d-4eeb-b0a6-98c3b6b96d39',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FViolet%20Noise.mp3?alt=media&token=6dbb5547-2688-4eaa-80f7-6b24df2cc901',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FGrey%20Noise.mp3?alt=media&token=3b472e36-31cc-453a-abef-97fd6383d247',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FRed%20Noise.mp3?alt=media&token=87d2860a-ba83-41a9-99ce-8cdf5bdb0649',
    'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Homepage%2FNoises%2FGreen%20Noise.mp3?alt=media&token=7dc7351d-9eb2-44a0-b2d1-26c963ae678c',
  ];

  List<String> noises = [
    'White',
    'Pink',
    'Brown',
    'Blue',
    'Violet',
    'Grey',
    'Red',
    'Green',
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
    if (!subscriptionController.isSubscribed.value) {
      loadNativeAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final adController = Get.put(AdController());
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF131321),
        title: Text(
          'Noises',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF131321),
      body: _buildPlaylistListView(),
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
    );
  }

  Widget _buildPlaylistListView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: noises.length,
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
              songs: noisesSounds,
              title: 'Coloured noise',
              imageUrl: noisesImage,
              soundNames: noises,
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
                            noisesImage[index],
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            noises[index],
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
