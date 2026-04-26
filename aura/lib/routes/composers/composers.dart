import 'dart:ui';
import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/component/native_ad.dart';
import 'package:aura/controllers/ad_controller.dart';
import 'package:aura/routes/composers/relaxing_composer.dart';
import 'package:aura/routes/composers/focus_composer.dart';
import 'package:aura/services/admob_service.dart';
import 'package:aura/subscription/subscription.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AuraComposers extends StatefulWidget {
  final ScrollController controller;
  const AuraComposers({
    required this.controller,
    super.key,
  });

  @override
  State<AuraComposers> createState() => _AuraComposersState();
}

class _AuraComposersState extends State<AuraComposers> {
  // final SubscriptionController subscriptionController =
  //     Get.put(SubscriptionController());

  @override
  void initState() {
    super.initState();
    // if (!subscriptionController.isSubscribed.value) {
    //   loadNativeAd();
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
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

  @override
  Widget build(BuildContext context) {
    // final adController = Get.find<AdController>();
    return Scaffold(
      backgroundColor: Color(0xff131321),
      body: SingleChildScrollView(
        controller: widget.controller,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: FadeInImage(
                      placeholder: AssetImage(
                          'assets/composer.gif'), // Placeholder image
                      image: CachedNetworkImageProvider(
                          'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Fcomposer.gif?alt=media&token=2cb8458c-7a01-4854-9ec6-61ced86995ae'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.075,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Composers',
                                    style: GoogleFonts.dancingScript(
                                      color: Colors.white,
                                      fontSize: 38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              // onTap: () => subscriptionController.isSubscribed.value
              //     ? Get.to(RelaxingComposer())
              //     : adController.showSubscriptionDialog(
              //         context,
              //         onComplete: () => Get.to(
              //           RelaxingComposer(),
              //         ),
              //       ),
              onTap: () => Get.to(RelaxingComposer()),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Frelaxingc.jpg?alt=media&token=7f93d245-4a6e-472e-b5c8-9a31d64bce98'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.075,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        image: DecorationImage(
                          image: AssetImage('assets/st2.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Relaxing Composer',
                            style: GoogleFonts.kanit(
                                color: Colors.white, fontSize: 26),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildNativeAdWidget(),
            const SizedBox(
              height: 10,
            ),
            InkWell(
             onTap: () => Get.to(FocusComposer()),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Ffocusc.jpg?alt=media&token=8a20a461-2314-4d3a-83cb-edfedffc3707'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Positioned(
                    bottom: -1,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.075,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        image: DecorationImage(
                          image: AssetImage('assets/st2.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Focus Composer',
                            style: GoogleFonts.kanit(
                                color: Colors.white, fontSize: 26),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
