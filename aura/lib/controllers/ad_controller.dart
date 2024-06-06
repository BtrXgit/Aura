import 'package:aura/services/admob_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  // InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  // NativeAd? _nativeAd;
  BannerAd? _bannerAd;
  BannerAd? _playersBannerAd;
  // bool _isAdBeingLoaded = false;

  @override
  void onInit() {
    super.onInit();
    // _createInterstitialAd();
    _createRewardedAd();
    _createBannerAd();
    _createPlayersBannerAd();
    // _createNativeAd();
  }

  // Interstitial Ad Methods
  // DateTime? _lastAdTime;

  // void _createInterstitialAd() {
  //   if (_isAdBeingLoaded) return;
  //   _isAdBeingLoaded = true;

  //   InterstitialAd.load(
  //     adUnitId: AdMobService.interstitialAdUnitId!,
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _interstitialAd = ad;
  //         _isAdBeingLoaded = false;
  //         if (kDebugMode) {
  //           print('Interstitial Ad loaded.');
  //         }
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         _interstitialAd = null;
  //         _isAdBeingLoaded = false;
  //         if (kDebugMode) {
  //           print('Failed to load Interstitial Ad: $error');
  //         }
  //       },
  //     ),
  //   );
  // }

  // void showInterstitialAd() {
  //   if (_lastAdTime != null &&
  //       DateTime.now().difference(_lastAdTime!).inMinutes < 1) {
  //     if (kDebugMode) {
  //       print('Interstitial Ad cannot be shown yet. Please wait a minute.');
  //     }
  //     return;
  //   }

  //   if (_interstitialAd != null) {
  //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (ad) {
  //         ad.dispose();
  //         _createInterstitialAd();
  //       },
  //       onAdFailedToShowFullScreenContent: (ad, error) {
  //         ad.dispose();
  //         _createInterstitialAd();
  //       },
  //     );
  //     _interstitialAd!.show();
  //     _lastAdTime = DateTime.now();
  //     _interstitialAd = null;
  //   } else {
  //     if (kDebugMode) {
  //       print('Interstitial Ad not available.');
  //     }
  //     _createInterstitialAd();
  //   }
  // }

  // Rewarded Ad Methods
  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          if (kDebugMode) {
            print('Rewarded Ad loaded.');
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          if (kDebugMode) {
            print('Failed to load Rewarded Ad: $error');
          }
        },
      ),
    );
  }

  void showRewardedAd({required VoidCallback onComplete}) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAd();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onComplete();
          if (kDebugMode) {
            print('User earned reward: ${reward.amount} ${reward.type}');
          }
          // Handle the reward
        },
      );
      _rewardedAd = null;
    } else {
      if (kDebugMode) {
        print('Rewarded Ad not available.');
      }
      _createRewardedAd();
    }
  }

  // Banner Ad Methods
  void _createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdMobService.bannerAdUnitId!,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Failed to load Banner Ad: $error');
        },
      ),
    );
    _bannerAd!.load();
  }

  BannerAd? get bannerAd => _bannerAd;

  void _createPlayersBannerAd() {
    _playersBannerAd = BannerAd(
      adUnitId: AdMobService.bannerAdUnitId!,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Failed to load Banner Ad: $error');
        },
      ),
    );
    _playersBannerAd!.load();
  }

  BannerAd? get playersBannerAd => _playersBannerAd;

  // Native Ad Methods
  // void _createNativeAd() {
  //   _nativeAd = NativeAd(
  //     adUnitId: AdMobService.nativeAdUnitId!,
  //     factoryId: 'adFactoryExample', // Replace with your actual factory ID
  //     request: const AdRequest(),
  //     listener: NativeAdListener(
  //       onAdLoaded: (Ad ad) {
  //         print('Native Ad loaded.');
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         ad.dispose();
  //         print('Failed to load Native Ad: $error');
  //       },
  //     ),
  //   );
  //   _nativeAd!.load();
  // }

  // NativeAd? get nativeAd => _nativeAd;

  @override
  void onClose() {
    // _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    // _nativeAd?.dispose();
    _bannerAd?.dispose();
    super.onClose();
  }
}
