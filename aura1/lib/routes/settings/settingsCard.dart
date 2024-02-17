import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to import the required package

String _getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;
  if (hour >= 5 && hour < 12) {
    return 'Good Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon';
  } else if (hour >= 17 && hour < 20) {
    return 'Good Evening';
  } else {
    return 'Good Night';
  }
}

String _getImageAsset(String greeting) {
  switch (greeting) {
    case 'Good Morning':
      return 'assets/morning.jpg';
    case 'Good Afternoon':
      // return 'assets/morning.jpg';
      return 'assets/afternoon.jpg';
    case 'Good Evening':
      return 'assets/evening.jpg';
    case 'Good Night':
      return 'assets/night.jpg';
    default:
      return 'assets/morning.jpg';
  }
}

class CustomStackCard extends StatelessWidget {
  // final String imagePath;
  final IconData icon;
  final VoidCallback onTap;
  final String title;
  final String subtitle;

  const CustomStackCard({
    Key? key,
    // required this.imagePath,
    required this.icon,
    required this.onTap,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final backgroundImage = _getImageAsset(greeting);
    double containerWidth = MediaQuery.of(context).size.width / 2 - 25;
    double containerHeight = MediaQuery.of(context).size.height * 0.2;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          Positioned(
            bottom: -1,
            left: -1,
            right: -1,
            top: -1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.075,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
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
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 4),
                          Icon(
                            icon,
                            size: 32,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.kanit(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.only(left: 2, right: 2),
                            child: Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
