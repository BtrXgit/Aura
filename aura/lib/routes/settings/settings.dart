import 'dart:ui';

import 'package:aura/core/broken_icons.dart';
import 'package:aura/routes/settings/privacyPolicy.dart';
import 'package:aura/routes/settings/settingsCard.dart';
import 'package:aura/subscription/subscription.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final ScrollController controller;
  const SettingsPage({required this.controller, Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? userName;
  String? userEmail;
  String? userPhotoUrl;

  @override
  void initState() {
    super.initState();
    fetchUserProfileData();
  }

  Future<void> fetchUserProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userName = user.displayName;
        userEmail = user.email;
        userPhotoUrl = user.photoURL;
      });
    }
  }

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

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  void deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Color backgroundColor = Theme.of(context).colorScheme.background;
            return AlertDialog(
              backgroundColor: backgroundColor,
              title: const Text('Confirm Deletion'),
              content:
                  const Text('Are you sure you want to delete your account?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await user.delete();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account deleted successfully.'),
                      ),
                    );
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.kanit(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user is currently signed in.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting user account: $e'),
        ),
      );
    }
  }

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
        return "https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Frelaxingc.jpg?alt=media&token=7f93d245-4a6e-472e-b5c8-9a31d64bce98";
      case 'Good Afternoon':
        return "https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Ffocusc.jpg?alt=media&token=8a20a461-2314-4d3a-83cb-edfedffc3707";
      case 'Good Evening':
        return "https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2FFocus%20Study%2FfocusEvening.jpg?alt=media&token=abcbf1d0-39be-4c53-9f37-31c4fab1b702";
      case 'Good Night':
        return "https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Images%2FHomepage%2Fsynthwave.jpg?alt=media&token=d2c50d2c-c6eb-40e4-b05b-7f88bf81af31";
      default:
        return "https://firebasestorage.googleapis.com/v0/b/aura-xd.appspot.com/o/Composers%2Frelaxingc.jpg?alt=media&token=7f93d245-4a6e-472e-b5c8-9a31d64bce98";
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.background;
    final greeting = _getGreeting();
    final backgroundImage = _getImageAsset(greeting);
    Color primaryColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Settings',
          style: GoogleFonts.kanit(
            // fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: widget.controller,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  if (userName != null && userEmail != null)
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: MediaQuery.of(context).size.height * 0.3,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(backgroundImage),
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
                            // width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height * 0.075,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 50,
                                  sigmaY: 50,
                                ),
                                child: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height *
                                  //     0.075,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        if (userPhotoUrl != null)
                                          CircleAvatar(
                                            radius: 64,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    userPhotoUrl!),
                                          ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '$userName',
                                          style: GoogleFonts.kanit(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          '$userEmail',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Join Us On:',
                    style: GoogleFonts.kanit(
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
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
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // CustomStackCard(
                      //   icon: IconlyLight.buy,
                      //   onTap: () => Get.to(SubscriptionPage()),
                      //   title: 'Buy Aura Pro',
                      //   subtitle: 'Access all features',
                      // ),
                      CustomStackCard(
                        icon: Broken.info_circle,
                        onTap: () => _showAboutAppBottomSheet(context),
                        title: 'About',
                        subtitle: 'Find out more about Aura',
                      ),
                      CustomStackCard(
                        icon: Broken.activity,
                        onTap: () => _showChangelogBottomSheet(context),
                        title: 'Changelog',
                        subtitle: 'Recent improvements and fixes',
                      ),
                      CustomStackCard(
                        icon: Broken.trash,
                        onTap: () => _clearCache(context),
                        title: 'Clear Cache',
                        subtitle: 'Clear all Cached data',
                      ),
                      CustomStackCard(
                        icon: Broken.bookmark,
                        onTap: () => showLicensePage(context: context),
                        title: 'Licenses',
                        subtitle: 'View open source licenses',
                      ),
                      CustomStackCard(
                        icon: Broken.security_safe,
                        onTap: () => Get.to(PrivacyPage(),
                            transition: Transition.rightToLeftWithFade),
                        title: 'Privacy Policy',
                        subtitle: 'Aura privacy policy',
                      ),
                      CustomStackCard(
                        icon: Broken.logout,
                        onTap: () => signUserOut(),
                        title: 'Logout',
                        subtitle: 'Logout of your account',
                      ),
                      CustomStackCard(
                        icon: Broken.trash,
                        color: Colors.red,
                        onTap: () => deleteAccount(context),
                        title: 'Delete Account',
                        subtitle: 'Warning! This cannot be undone',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                      'By XD.',
                      style:
                          GoogleFonts.kanit(color: primaryColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 100),
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
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: const Color(0xFF131321),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
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
                '🌟 Immerse yourself in the world of Aura – the ultimate app for Relaxing your mind and soul, to focus on work, to study, to fall asleep better. Discover an extensive selection of sounds across various categories, all presented through a beautifully designed and intuitive interface. ',
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: launchUrlPlayStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Rate Us',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
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
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: const Color(0xFF131321),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🚀 Aura Initial Release Changelog',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ChangelogEntry(
              version: '1.0.0',
              date: 'January, 2023',
              changes: [
                '🎉 Welcome to the world of Aura - the ultimate app for Relaxing your mind and soul, ',
                '👩‍🏭 To focus on work, ',
                '📚 To study,',
                '😴 To fall asleep better.',
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
