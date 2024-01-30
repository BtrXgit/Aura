import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class BookmarkedPage extends StatelessWidget {
  const BookmarkedPage({super.key});
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.trash),
          )
        ],
        elevation: 0,
        // centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'Favorites',
          style: GoogleFonts.kanit(
            color: primaryColor,
            fontSize: 22,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Text(
            'Oops, Something went wrong! 😓',
            style: GoogleFonts.kanit(color: primaryColor, fontSize: 18),
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
