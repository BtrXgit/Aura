// import 'package:aura/authentication/auth%20pages/auth_page.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';

// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({Key? key}) : super(key: key);

//   @override
//   OnBoardingScreenState createState() => OnBoardingScreenState();
// }

// class OnBoardingScreenState extends State<OnBoardingScreen> {
//   final introKey = GlobalKey<IntroductionScreenState>();

//   void _onIntroSkip(context) {
//     _onIntroEnd(context);
//   }

//   void _onIntroEnd(context) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (_) => const AuthPage()),
//     );
//   }

//   Widget _buildImage(String assetName, [double width = 350]) {
//     return Image.asset('assets/$assetName', width: width);
//   }

//   PageViewModel _buildPageViewModel({
//     required String title,
//     required String body,
//     required String imageAsset,
//     required PageDecoration pageDecoration,
//     required bool reverse,
//   }) {
//     return PageViewModel(
//       title: title,
//       body: body,
//       image: _buildImage(imageAsset),
//       decoration: pageDecoration,
//       reverse: reverse,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.white);
//     const pageDecoration = PageDecoration(
//       titleTextStyle: TextStyle(
//         fontSize: 28.0,
//         fontWeight: FontWeight.w700,
//         color: Colors.white,
//       ),
//       bodyTextStyle: bodyStyle,
//       bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
//       pageColor: Color(0xFF131321),
//       imagePadding: EdgeInsets.zero,
//     );

//     return IntroductionScreen(
//       key: introKey,
//       globalBackgroundColor: Color(0xFF131321),
//       allowImplicitScrolling: false,
//       autoScrollDuration: 10000,
//       infiniteAutoScroll: false,
//       pages: [
//         _buildPageViewModel(
//           title: "Aura",
//           body: ".",
//           imageAsset: 'img1.jpg',
//           pageDecoration: pageDecoration,
//           reverse: false,
//         ),
//         _buildPageViewModel(
//           title: "Aura",
//           body:
//               "The app that calm your restless mind and improves sleep quality",
//           imageAsset: 'img2.jpg',
//           pageDecoration: pageDecoration,
//           reverse: false,
//         ),
//         _buildPageViewModel(
//           title: "Title of last page - reversed",
//           body: "Last beautiful body text for this example onboarding",
//           imageAsset: 'img1.jpg',
//           pageDecoration: pageDecoration.copyWith(
//             bodyFlex: 2,
//             imageFlex: 4,
//             bodyAlignment: Alignment.bottomCenter,
//             imageAlignment: Alignment.topCenter,
//           ),
//           reverse: true,
//         ),
//       ],
//       onDone: () => _onIntroEnd(context),
//       onSkip: () => _onIntroSkip(context),
//       showSkipButton: true,
//       skipOrBackFlex: 0,
//       nextFlex: 0,
//       showBackButton: false,
//       back: const Icon(Icons.arrow_back),
//       skip: const Text('Skip',
//           style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
//       next: const Icon(
//         Icons.arrow_forward,
//         color: Colors.black,
//       ),
//       done: const Text('Done',
//           style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
//       curve: Curves.fastLinearToSlowEaseIn,
//       controlsMargin: const EdgeInsets.all(16),
//       controlsPadding: kIsWeb
//           ? const EdgeInsets.all(12.0)
//           : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
//       dotsDecorator: const DotsDecorator(
//         size: Size(10.0, 10.0),
//         color: Color(0xFFBDBDBD),
//         activeSize: Size(22.0, 10.0),
//         activeColor: Colors.black,
//         activeShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(25.0)),
//         ),
//       ),
//       dotsContainerDecorator: const ShapeDecoration(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         ),
//       ),
//     );
//   }
// }
