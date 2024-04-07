import 'package:aura/core/broken_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class ExploreWorldPage extends StatefulWidget {
  const ExploreWorldPage({super.key});

  @override
  State<ExploreWorldPage> createState() => _ExploreWorldPageState();
}

class _ExploreWorldPageState extends State<ExploreWorldPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131321),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        'https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Felephant.jpg?alt=media&token=d6679bca-e4e3-48fa-8477-5f8740210be7'),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Broken.setting,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFF131321),
                                  title: Text(
                                    'Aura World Explore',
                                    style: GoogleFonts.kanit(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  content: Text(
                                    "Page Under Development. Exciting update coming soon!",
                                    style: GoogleFonts.kanit(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Close',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.36,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Icon(IconlyBold.play, color: Colors.white, size: 64),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        'Amazing corners of the planet',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kanit(
                          color: Colors.white,
                          fontSize: 48,
                          height: 1.2,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
