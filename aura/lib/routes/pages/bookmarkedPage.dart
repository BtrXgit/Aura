import 'package:aura/core/broken_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkedPage extends StatelessWidget {
  const BookmarkedPage({super.key});
  @override
  Widget build(BuildContext context) {
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Broken.trash,
              color: Colors.white,
            ),
          )
        ],
        elevation: 0,
        // centerTitle: true,
        backgroundColor: Color(0xFF131321),
        title: Text(
          'Favorites',
          style: GoogleFonts.kanit(
            color: Colors.white,
            fontSize: 22,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFF131321),
      body: SafeArea(
        child: Center(
          child: Text(
            'Oops, Something went wrong! 😓',
            style: GoogleFonts.kanit(color: Colors.white, fontSize: 18),
          ),

          // Column(
          //   children: [
          //     Text(message.notification!.title.toString()),
          //     Text(message.notification!.body.toString()),
          //     Text(message.data.toString()),
          //     Text(
          //       'No Notifications available',
          //       style: GoogleFonts.kanit(color: primaryColor, fontSize: 18),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
