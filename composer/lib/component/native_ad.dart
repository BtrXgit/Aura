import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdMedium extends StatelessWidget {
  final NativeAd nativeAd;

  const NativeAdMedium(this.nativeAd, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 320,
        minHeight: 320,
        maxWidth: 400,
        maxHeight: 400,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        child: AdWidget(ad: nativeAd),
      ),
    );
  }
}

class NativeAdSmall extends StatelessWidget {
  final NativeAd nativeAd;

  const NativeAdSmall(this.nativeAd, {super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 320,
        minHeight: 90,
        maxWidth: 400,
        maxHeight: 200,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        child: AdWidget(ad: nativeAd),
      ),
    );
  }
}
