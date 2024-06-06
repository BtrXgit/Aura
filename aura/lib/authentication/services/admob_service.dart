// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdMobService {
//   static String? get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       // return 'ca-app-pub-3940256099942544/6300978111';
//       return 'ca-app-pub-2502922311219626/5489027568';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-2502922311219626/1931007304';
//     }
//     return null;
//   }

//   static String? get playersAdUnitId {
//     if (Platform.isAndroid) {
//       // return 'ca-app-pub-3940256099942544/6300978111';
//       return 'ca-app-pub-2502922311219626/8618427209';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-2502922311219626/8618427209';
//     }
//     return null;
//   }

//   static String? get nativeAdsUnit {
//     if (Platform.isAndroid) {
//       // return 'ca-app-pub-3940256099942544/2247696110';
//       return 'ca-app-pub-2502922311219626/3123590816';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/2247696110';
//     }
//     return null;
//   }

//   static String? get composerAdsUnit {
//     if (Platform.isAndroid) {
//       // return 'ca-app-pub-3940256099942544/2247696110';
//       return 'ca-app-pub-2502922311219626/2127372174';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-2502922311219626/2127372174';
//     }
//     return null;
//   }

//   static final BannerAdListener bannerListener = BannerAdListener(
//       onAdLoaded: (ad) => debugPrint('Banner Ad Loaded'),
//       onAdFailedToLoad: ((ad, error) {
//         ad.dispose();
//         debugPrint('Banner Ad failed to load: $error');
//       }),
//       onAdOpened: ((ad) => debugPrint("Banner ad opened")));

//   static final BannerAdListener playersbannerListener = BannerAdListener(
//       onAdLoaded: (ad) => debugPrint('Banner Ad Loaded'),
//       onAdFailedToLoad: ((ad, error) {
//         ad.dispose();
//         debugPrint('Banner Ad failed to load: $error');
//       }),
//       onAdOpened: ((ad) => debugPrint("Banner ad opened")));
// }


//   // static String? get rewardedAdUnitId {
//   //   if (Platform.isAndroid) {
//   //     return 'ca-app-pub-2502922311219626/3131025444';
//   //     // return 'ca-app-pub-3940256099942544/5224354917';
//   //   } else if (Platform.isIOS) {
//   //     return 'ca-app-pub-2502922311219626/3131025444';
//   //   }
//   //   return null;
//   // }