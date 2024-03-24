// import 'dart:math';

// import 'package:aura/meditate/widgets/breather.dart';
// import 'package:aura/meditate/widgets/breather_error.dart';
// import 'package:flutter/material.dart';

// class BoxBreathing extends StatelessWidget {
//   final String pattern;

//   BoxBreathing({Key? key, required this.pattern}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     StatefulWidget breather;

//     switch (pattern) {
//       case '4x4 BoxBreathing':
//         breather = FourSecondsHold();
//         break;
//       default:
//         breather = FourSecondsHold();
//         break;
//     }

//     return Scaffold(
//       backgroundColor: Color(0xff131321),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   breather,
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FourSecondsHold extends StatefulWidget {
//   @override
//   _FourSecondsHoldState createState() => _FourSecondsHoldState();
// }

// class _FourSecondsHoldState extends State<FourSecondsHold>
//     with TickerProviderStateMixin {
//   late AnimationController _breathingController;
//   late String _action;
//   late int _phase;
//   late int _holdStartTime;
//   late int _holdDuration;

//   @override
//   void initState() {
//     super.initState();
//     _action = 'Breathe In';
//     _phase = 0;
//     _holdStartTime = 0;
//     _holdDuration = 4000;
//     _breathingController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 4000),
//     )
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           if (_phase == 0) {
//             _action = 'Hold';
//             _holdStartTime = DateTime.now().millisecondsSinceEpoch;
//             _breathingController.reset();
//             _breathingController.forward();
//           } else if (_phase == 1) {
//             _action = 'Breathe Out';
//             _breathingController.reset();
//             _breathingController.forward();
//           } else if (_phase == 2) {
//             _action = 'Hold';
//             _holdStartTime = DateTime.now().millisecondsSinceEpoch;
//             _breathingController.reset();
//             _breathingController.forward();
//           } else if (_phase == 3) {
//             _action = 'Breathe In';
//             _breathingController.reset();
//             _breathingController.forward();
//           }
//           _phase = (_phase + 1) % 4;
//         }
//       })
//       ..addListener(() {
//         setState(() {});
//       });
//     _breathingController.forward();
//   }

//   @override
//   void dispose() {
//     _breathingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double progress = _breathingController.value;
//     int currentTime;

//     if (_action == 'Hold') {
//       int elapsedTime = DateTime.now().millisecondsSinceEpoch - _holdStartTime;
//       currentTime = min(_holdDuration, max(0, elapsedTime)) ~/ 1000;
//     } else {
//       currentTime = (progress * 4).floor();
//     }

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(height: 20.0),
//         Breather(
//           breathingController: _breathingController,
//           action: _action,
//           time: '$currentTime / 4 Sec',
//         ),
//       ],
//     );
//   }
// }
