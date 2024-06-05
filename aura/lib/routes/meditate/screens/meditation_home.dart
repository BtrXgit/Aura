import 'package:aura/authentication/services/admob_service.dart';
import 'package:aura/component/native_ad.dart';
import 'package:aura/routes/meditate/screens/techniques/fourseven/four_seven_eight.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'techniques/seven_eleven.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class MeditationHome extends StatefulWidget {
  final ScrollController controller;
  const MeditationHome({
    required this.controller,
    super.key,
  });

  @override
  State<MeditationHome> createState() => _MeditationHomeState();
}

class _MeditationHomeState extends State<MeditationHome> {
  @override
  void initState() {
    super.initState();
    loadNativeAd();
  }

  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  void loadNativeAd() {
    _nativeAd = NativeAd(
        adUnitId: AdMobService.nativeAdsUnit!,
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
                    image: DecorationImage(
                      image: AssetImage('assets/meditate/meditate2.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
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
                                    'Meditation Techniques',
                                    style: GoogleFonts.dancingScript(
                                      color: Colors.white,
                                      fontSize: 34,
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
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Breathing();
                }));
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/meditate/meditate.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                          image: AssetImage('assets/st1.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '7/11 Breathing',
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
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (_) {
            //       return BoxBreathing(pattern: 'Box Breathing');
            //     }));
            //   },
            //   child: Stack(
            //     children: [
            //       Container(
            //         width: MediaQuery.of(context).size.width - 40,
            //         height: 200,
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage('assets/meditate/meditate1.jpg'),
            //             fit: BoxFit.cover,
            //           ),
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //       ),
            //       Positioned(
            //         bottom: -1,
            //         left: 0,
            //         right: 0,
            //         child: Container(
            //           width: MediaQuery.of(context).size.width,
            //           height: MediaQuery.of(context).size.height * 0.075,
            //           decoration: BoxDecoration(
            //             color: Colors.transparent,
            //             borderRadius: BorderRadius.only(
            //               bottomLeft: Radius.circular(20),
            //               bottomRight: Radius.circular(20),
            //             ),
            //           ),
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.only(
            //               bottomLeft: Radius.circular(20),
            //               bottomRight: Radius.circular(20),
            //             ),
            //             child: BackdropFilter(
            //               filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            //               child: Container(
            //                   width: MediaQuery.of(context).size.width,
            //                   height:
            //                       MediaQuery.of(context).size.height * 0.075,
            //                   decoration: BoxDecoration(
            //                     color: Colors.black.withOpacity(0.4),
            //                     borderRadius: BorderRadius.only(
            //                       bottomLeft: Radius.circular(20),
            //                       bottomRight: Radius.circular(20),
            //                     ),
            //                     boxShadow: [
            //                       BoxShadow(
            //                         color: Colors.black.withOpacity(0.1),
            //                         spreadRadius: 5,
            //                         blurRadius: 7,
            //                         offset: Offset(0, 3),
            //                       ),
            //                     ],
            //                   ),
            //                   child: Align(
            //                     alignment: Alignment.centerLeft,
            //                     child: Padding(
            //                       padding: EdgeInsets.only(left: 10),
            //                       child: Text(
            //                         'Box Breathing',
            //                         style: GoogleFonts.kanit(
            //                             color: Colors.white, fontSize: 26),
            //                       ),
            //                     ),
            //                   )),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return FourSevenEight();
                }));
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/meditate/meditate1.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                          image: AssetImage('assets/st1.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '4-7-8 Breathing',
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
