import 'package:aura/aura_composer.dart';
import 'package:aura/routes/explore.dart';
import 'package:aura/routes/homepage/homepage.dart';
import 'package:aura/routes/tweaks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:iconly/iconly.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  Color homeColor = const Color.fromARGB(255, 175, 202, 0);
  Color customColor = const Color.fromARGB(255, 59, 255, 226);
  Color locationColor = Colors.blue;
  Color settingsColor = Colors.black;
  Color unselectedColor = Colors.grey;
  Color _getIndicatorColor(int page) {
    switch (page) {
      case 0:
        return homeColor;
      case 1:
        return customColor;
      case 2:
        return locationColor;
      case 3:
        return settingsColor;
      default:
        return unselectedColor;
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: BottomBar(
        fit: StackFit.expand,
        icon: (width, height) => Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: Colors.grey,
              size: width,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(500),
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width * 0.75,
        barColor: Colors.black.computeLuminance() > 0.5
            ? Colors.black
            : const Color.fromARGB(255, 14, 3, 31),
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 35,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AuraHomePage(
              controller: controller,
            ),
            const AuraComposerTest(),
            const ExploreWorld(
                // controller: controller,
                ),
            SettingsPage(
              controller: controller,
            ),
            // SongsScreen(),
            // const ComposerAudio(),
            // AuraPlayer(),
          ],
        ),
        child: TabBar(
          dividerColor: Colors.transparent,
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          controller: tabController,
          indicator: UnderlineTabIndicator(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  BorderSide(color: _getIndicatorColor(currentPage), width: 6),
              insets: const EdgeInsets.fromLTRB(16, 0, 16, 8)),
          tabs: [
            SizedBox(
              height: 58,
              width: 40,
              child: Center(
                  child: Icon(
                IconlyBold.home,
                color: currentPage == 0 ? homeColor : unselectedColor,
                size: currentPage == 0 ? 32 : 28,
                // color: Colors.black,
              )),
            ),
            SizedBox(
              height: 58,
              width: 40,
              child: Center(
                  child: Icon(
                IconlyBold.star,
                color: currentPage == 1 ? customColor : unselectedColor,
                size: currentPage == 1 ? 32 : 28,
              )),
            ),
            SizedBox(
              height: 58,
              width: 40,
              child: Center(
                  child: Icon(
                IconlyBold.location,
                color: currentPage == 2 ? locationColor : unselectedColor,
                size: currentPage == 2 ? 32 : 28,
              )),
            ),
            SizedBox(
              height: 58,
              width: 40,
              child: Center(
                  child: Icon(
                IconlyBold.profile,
                color: currentPage == 3 ? settingsColor : unselectedColor,
                size: currentPage == 3 ? 32 : 28,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
