import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to import the required package

class CustomStackCard extends StatelessWidget {
  // final String imagePath;
  final IconData icon;
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final Color? color;

  const CustomStackCard({
    Key? key,
    // required this.imagePath,
    this.color,
    required this.icon,
    required this.onTap,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width;
    // double containerHeight = MediaQuery.of(context).size.height * 0.2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.fromLTRB(20, 4, 20, 4),
        width: containerWidth,
        // height: containerHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage('assets/style3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Icon(
                  icon,
                  size: 32,
                  color: color ?? Colors.white,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kanit(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 2),
                    Padding(
                      padding: EdgeInsets.only(left: 2, right: 2),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
