import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final ScrollController controller;
  const SettingsPage({required this.controller, Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _clearCache(BuildContext context) async {
    await DefaultCacheManager().emptyCache();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E1E2A),
        content: Text(
          'Cache cleared successfully 😊',
          style: GoogleFonts.kanit(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // void signUserOut() {
  //   FirebaseAuth.instance.signOut();
  //   Navigator.pop(context);
  // }

  // void deleteAccount(BuildContext context) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           Color backgroundColor = Theme.of(context).colorScheme.background;
  //           return AlertDialog(
  //             backgroundColor: backgroundColor,
  //             title: const Text('Confirm Deletion'),
  //             content:
  //                 const Text('Are you sure you want to delete your account?'),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () async {
  //                   await user.delete();
  //                   // ignore: use_build_context_synchronously
  //                   Navigator.of(context).pop();
  //                   // ignore: use_build_context_synchronously
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text('Account deleted successfully.'),
  //                     ),
  //                   );
  //                 },
  //                 child: Text(
  //                   'Delete',
  //                   style: GoogleFonts.kanit(color: Colors.red),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('No user is currently signed in.'),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error deleting user account: $e'),
  //       ),
  //     );
  //   }
  // }

  final Uri urlPlayStore = Uri.parse(
      'https://play.google.com/store/apps/dev?id=4846033393809014453');

  Future<void> launchUrlPlayStore() async {
    if (!await launchUrl(urlPlayStore)) {
      throw Exception('Could not launch $urlPlayStore');
    }
  }

  final Uri urlInstagram = Uri.parse('https://www.instagram.com/btr.xd/');

  Future<void> launchUrlInstagram() async {
    if (!await launchUrl(urlInstagram)) {
      throw Exception('Could not launch $urlInstagram');
    }
  }

  final Uri urlTwitter =
      Uri.parse('https://twitter.com/btr__xd?t=idNA9giauYavchbF0ET5YA&s=08');

  Future<void> launchUrlTwitter() async {
    if (!await launchUrl(urlTwitter)) {
      throw Exception('Could not launch $urlTwitter');
    }
  }

  final Uri urlGithub = Uri.parse('https://github.com/BatesharXgit');

  Future<void> launchUrlGithub() async {
    if (!await launchUrl(urlGithub)) {
      throw Exception('Could not launch $urlGithub');
    }
  }

  final Uri urlYoutube = Uri.parse('https://www.youtube.com/@XD.Official');

  Future<void> launchUrlYoutube() async {
    if (!await launchUrl(urlYoutube)) {
      throw Exception('Could not launch $urlYoutube');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.black;
    Color primaryColor = Colors.white;
    Color secondaryColor = Colors.grey;
    Color tertiaryColor = Colors.green;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text(
          'Settings',
          style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Theme.of(context).colorScheme.primary),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        controller: widget.controller,
        physics: const BouncingScrollPhysics(),
        child: AnimationLimiter(
          child: Center(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'AURA',
                    style: GoogleFonts.orbitron(
                      // fontFamily: 'Anurati',
                      color: primaryColor,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    'Harmonize Your Experience!',
                    style: TextStyle(color: secondaryColor),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 300,
                    height: 250,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Iconsax.info_circle,
                            size: 28,
                          ),
                          title: const Text('About'),
                          subtitle: Text('Find out more about Luca',
                              style: TextStyle(color: secondaryColor)),
                          iconColor: primaryColor,
                          textColor: primaryColor,
                          onTap: () {
                            _showAboutAppBottomSheet(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Iconsax.activity,
                            size: 28,
                          ),
                          title: const Text('Changelog'),
                          subtitle: const Text('Recent improvements and fixes',
                              style: TextStyle(color: Colors.grey)),
                          iconColor: primaryColor,
                          textColor: primaryColor,
                          onTap: () {
                            _showChangelogBottomSheet(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Iconsax.trash),
                          title: const Text('Clear Cache'),
                          subtitle: const Text('Clear all cached data',
                              style: TextStyle(color: Colors.grey)),
                          iconColor: primaryColor,
                          textColor: primaryColor,
                          onTap: () {
                            _clearCache(
                                context); // Call the function to clear cache and show snackbar
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Iconsax.bookmark,
                            size: 28,
                          ),
                          title: const Text('Liscenses'),
                          subtitle: const Text('View open source liscenses',
                              style: TextStyle(color: Colors.grey)),
                          iconColor: primaryColor,
                          textColor: primaryColor,
                          onTap: () {
                            showLicensePage(
                                context: context); // Show the licenses page
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.policy_outlined),
                          title: const Text('Privacy Policy'),
                          subtitle: const Text('Luca privacy policy',
                              style: TextStyle(color: Colors.grey)),
                          iconColor: primaryColor,
                          textColor: primaryColor,
                          onTap: () {},
                          // onTap: () {
                          //   Get.to(const PrivacyPage());
                          // }
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Iconsax.logout),
                          title: const Text('Logout'),
                          subtitle: const Text('Logout of your account',
                              style: TextStyle(color: Colors.grey)),
                          iconColor: primaryColor,
                          textColor: primaryColor,
                          // onTap: signUserOut,
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Iconsax.trash),
                          title: const Text('Delete Account'),
                          subtitle: const Text(
                            'Warning! This cannot be undone',
                            style: TextStyle(color: Colors.grey),
                          ),
                          iconColor: Colors.red,
                          textColor: primaryColor,
                          onTap: () {},
                          // onTap: () {
                          //   deleteAccount(context);
                          // },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: launchUrlPlayStore,
                          child: Icon(
                            BootstrapIcons.google_play,
                            color: primaryColor,
                            size: 34,
                          ),
                        ),
                        GestureDetector(
                          onTap: launchUrlInstagram,
                          child: Icon(
                            BootstrapIcons.instagram,
                            color: primaryColor,
                            size: 34,
                          ),
                        ),
                        GestureDetector(
                          onTap: launchUrlTwitter,
                          child: Icon(
                            BootstrapIcons.twitter,
                            color: primaryColor,
                            size: 34,
                          ),
                        ),
                        GestureDetector(
                          onTap: launchUrlGithub,
                          child: Icon(
                            BootstrapIcons.github,
                            color: primaryColor,
                            size: 34,
                          ),
                        ),
                        GestureDetector(
                          onTap: launchUrlYoutube,
                          child: Icon(
                            BootstrapIcons.youtube,
                            color: primaryColor,
                            size: 34,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Aura v 1.0.0',
                      style:
                          GoogleFonts.kanit(color: primaryColor, fontSize: 12),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Made in India.',
                      style:
                          GoogleFonts.kanit(color: primaryColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 74),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutAppBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: const Color(0xFF1E1E2A),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'About the App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '🌟 Immerse yourself in the world of Luca – the ultimate wallpaper app. Discover an extensive selection of static and dynamic wallpapers across various categories, all presented through a beautifully designed and intuitive interface. Elevate your device\'s aesthetic with Luca\'s stunning visuals that cater to every mood and style. 🎨📱',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void _showChangelogBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        color: const Color(0xFF1E1E2A),
        padding: const EdgeInsets.all(20),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🚀 Luca Initial Release Changelog',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ChangelogEntry(
              version: '1.0.0',
              date: 'October, 2023',
              changes: [
                '🎉 Welcome to the world of Luca - Your Ultimate Wallpaper Experience!',
                '🖼️ Explore a captivating collection of dynamic and static wallpapers.',
                '🎨 Immerse yourself in the beautifully designed user interface for seamless browsing.',
              ],
            ),
          ],
        ),
      );
    },
  );
}

class ChangelogEntry extends StatelessWidget {
  final String version;
  final String date;
  final List<String> changes;

  const ChangelogEntry({
    super.key,
    required this.version,
    required this.date,
    required this.changes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Version $version',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Released on $date',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: changes.map((change) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    change,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
