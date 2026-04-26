// import 'package:aura/component/native_ad.dart';
// import 'package:aura/services/admob_service.dart';
// import 'package:aura/subscription/subscription.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdController extends GetxController {
//   InterstitialAd? _interstitialAd;
//   RewardedAd? _rewardedAd;
//   BannerAd? _bannerAd;
//   BannerAd? _playersBannerAd;
//   NativeAd? _nativeAd;
//   var _nativeAdIsLoaded = false.obs;
//   bool _isAdBeingLoaded = false;

//   final SubscriptionController subscriptionController =
//       Get.find<SubscriptionController>();

//   @override
//   void onInit() {
//     super.onInit();
//     if (!subscriptionController.isSubscribed.value) {
//       _createInterstitialAd();
//       _createRewardedAd();
//       _createBannerAd();
//       _createPlayersBannerAd();
//       loadNativeAd();
//     }
//   }

//   // Native Ad Methods
//   void loadNativeAd() {
//     if (subscriptionController.isSubscribed.value) return;

//     _nativeAd = NativeAd(
//       adUnitId: AdMobService.nativeAdUnitId!,
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           _nativeAdIsLoaded.value = true;
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//         },
//         onAdClicked: (ad) {},
//         onAdImpression: (ad) {},
//         onAdClosed: (ad) {},
//         onAdOpened: (ad) {},
//         onAdWillDismissScreen: (ad) {},
//         onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
//       ),
//       request: const AdRequest(),
//       nativeTemplateStyle:
//           NativeTemplateStyle(templateType: TemplateType.medium),
//       customOptions: {},
//     );
//     _nativeAd?.load();
//   }

//   // void refreshNativeAd() {
//   //   if (subscriptionController.isSubscribed.value) return;

//   //   _nativeAd?.dispose();
//   //   _nativeAdIsLoaded.value = false;
//   //   loadNativeAd();
//   // }

//   Widget buildNativeAdWidget() {
//     return Obx(() {
//       if (_nativeAdIsLoaded.value) {
//         return NativeAdSmall(_nativeAd!);
//       } else {
//         return SizedBox(
//           height: 0,
//         );
//       }
//     });
//   }

//   // Interstitial Ad Methods
//   DateTime? _lastAdTime;

//   void _createInterstitialAd() {
//     if (_isAdBeingLoaded || subscriptionController.isSubscribed.value) return;

//     _isAdBeingLoaded = true;

//     InterstitialAd.load(
//       adUnitId: AdMobService.interstitialAdUnitId!,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitialAd = ad;
//           _isAdBeingLoaded = false;
//           if (kDebugMode) {
//             print('Interstitial Ad loaded.');
//           }
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           _interstitialAd = null;
//           _isAdBeingLoaded = false;
//           if (kDebugMode) {
//             print('Failed to load Interstitial Ad: $error');
//           }
//         },
//       ),
//     );
//   }

//   void showInterstitialAd() {
//     if (subscriptionController.isSubscribed.value) return;

//     if (_lastAdTime != null &&
//         DateTime.now().difference(_lastAdTime!).inMinutes < 1) {
//       if (kDebugMode) {
//         print('Interstitial Ad cannot be shown yet. Please wait a minute.');
//       }
//       return;
//     }

//     if (_interstitialAd != null) {
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           ad.dispose();
//           _createInterstitialAd();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           ad.dispose();
//           _createInterstitialAd();
//         },
//       );
//       _interstitialAd!.show();
//       _lastAdTime = DateTime.now();
//       _interstitialAd = null;
//     } else {
//       if (kDebugMode) {
//         print('Interstitial Ad not available.');
//       }
//       _createInterstitialAd();
//     }
//   }

//   // Rewarded Ad Methods
//   void _createRewardedAd() {
//     if (subscriptionController.isSubscribed.value) return;

//     RewardedAd.load(
//       adUnitId: AdMobService.rewardedAdUnitId!,
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//           _rewardedAd = ad;
//           if (kDebugMode) {
//             print('Rewarded Ad loaded.');
//           }
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           _rewardedAd = null;
//           if (kDebugMode) {
//             print('Failed to load Rewarded Ad: $error');
//           }
//         },
//       ),
//     );
//   }

//   void showRewardedAd({required VoidCallback onComplete}) {
//     if (subscriptionController.isSubscribed.value) return;

//     if (_rewardedAd != null) {
//       _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//           ad.dispose();
//           _createRewardedAd();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           ad.dispose();
//           _createRewardedAd();
//         },
//       );
//       _rewardedAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//           onComplete();
//           if (kDebugMode) {
//             print('User earned reward: ${reward.amount} ${reward.type}');
//           }
//           // Handle the reward
//         },
//       );
//       _rewardedAd = null;
//     } else {
//       if (kDebugMode) {
//         print('Rewarded Ad not available.');
//       }
//       _createRewardedAd();
//     }
//   }

//   // Banner Ad Methods
//   void _createBannerAd() {
//     if (subscriptionController.isSubscribed.value) return;

//     _bannerAd = BannerAd(
//       adUnitId: AdMobService.bannerAdUnitId!,
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           print('Banner Ad loaded.');
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           ad.dispose();
//           print('Failed to load Banner Ad: $error');
//         },
//       ),
//     );
//     _bannerAd!.load();
//   }

//   BannerAd? get bannerAd => _bannerAd;

//   void _createPlayersBannerAd() {
//     if (subscriptionController.isSubscribed.value) return;

//     _playersBannerAd = BannerAd(
//       adUnitId: AdMobService.bannerAdUnitId!,
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           print('Banner Ad loaded.');
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           ad.dispose();
//           print('Failed to load Banner Ad: $error');
//         },
//       ),
//     );
//     _playersBannerAd!.load();
//   }

//   BannerAd? get playersBannerAd => _playersBannerAd;


//   void showSubscriptionDialog(BuildContext context,
//       {required VoidCallback onComplete}) {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         title: Text(
//           'Access Required',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         content: Text(
//           'You need to subscribe or watch an ad to access this feature.',
//           style: TextStyle(
//             fontSize: 16,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         actionsPadding: const EdgeInsets.symmetric(horizontal: 12.0),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blueAccent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             onPressed: () {
//               showRewardedAd(
//                 onComplete: onComplete,
//               );
//             },
//             child: const Text('Watch Ad'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             onPressed: () {
//               Get.to(() => SubscriptionPage());
//             },
//             child: const Text('Buy Pro'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void onClose() {
//     _interstitialAd?.dispose();
//     _rewardedAd?.dispose();
//     _bannerAd?.dispose();
//     _nativeAd?.dispose();
//     super.onClose();
//   }
// }
