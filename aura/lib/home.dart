import 'package:aura/core/broken_icons.dart';
import 'package:aura/meditate/screens/meditation_home.dart';
import 'package:aura/routes/composers/composers.dart';
import 'package:aura/routes/homepage/homepage.dart';
import 'package:aura/routes/settings/settings.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late int currentPage;
//   late TabController tabController;

//   @override
//   void initState() {
//     currentPage = 0;
//     tabController = TabController(length: 4, vsync: this);
//     tabController.animation!.addListener(
//       () {
//         final value = tabController.animation!.value.round();
//         if (value != currentPage && mounted) {
//           changePage(value);
//         }
//       },
//     );
//     super.initState();
//   }

//   void changePage(int newPage) {
//     setState(() {
//       currentPage = newPage;
//     });
//   }

//   Color homeColor = const Color.fromARGB(255, 175, 202, 0);
//   Color customColor = Color(0xFF7B4294);
//   Color locationColor = const Color.fromARGB(255, 59, 255, 226);
//   Color settingsColor = Colors.blue;
//   Color unselectedColor = Colors.grey;
//   Color _getIndicatorColor(int page) {
//     switch (page) {
//       case 0:
//         return homeColor;
//       case 1:
//         return customColor;
//       case 2:
//         return locationColor;
//       case 3:
//         return settingsColor;
//       default:
//         return unselectedColor;
//     }
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: null,
//       body: Stack(
//         children: [
//           BottomBar(
//             fit: StackFit.expand,
//             icon: (width, height) => Center(
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 onPressed: null,
//                 icon: Icon(
//                   Icons.arrow_upward_rounded,
//                   color: Colors.grey,
//                   size: width,
//                 ),
//               ),
//             ),
//             borderRadius: BorderRadius.circular(500),
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.decelerate,
//             showIcon: true,
//             width: MediaQuery.of(context).size.width * 0.75,
//             // barColor: Colors.black.computeLuminance() > 0.5
//             //     ? Colors.black
//             //     : const Color.fromARGB(255, 14, 3, 31),
//             barColor: Color(0xFF131321),
//             start: 2,
//             end: 0,
//             offset: 10,
//             barAlignment: Alignment.bottomCenter,
//             iconHeight: 50,
//             iconWidth: 50,
//             reverse: false,
//             hideOnScroll: true,
//             scrollOpposite: false,
//             onBottomBarHidden: () {},
//             onBottomBarShown: () {},
//             body: (context, controller) => TabBarView(
//               controller: tabController,
//               dragStartBehavior: DragStartBehavior.down,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 AuraHomePage(
//                   controller: controller,
//                 ),
//                 // AuraComposerTest(
//                 //   controller: controller,
//                 // ),
//                 AuraComposers(
//                   controller: controller,
//                 ),
//                 // const ExploreWorldPage(
//                 //     // controller: controller,
//                 //     ),

//                 MeditationScreen(),
//                 // FourSevenEight(),

//                 SettingsPage(
//                   controller: controller,
//                 ),
//               ],
//             ),
//             child: TabBar(
//               dividerColor: Colors.transparent,
//               indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
//               controller: tabController,
//               indicator: UnderlineTabIndicator(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide(
//                       color: _getIndicatorColor(currentPage), width: 6),
//                   insets: const EdgeInsets.fromLTRB(16, 0, 16, 8)),
//               tabs: [
//                 SizedBox(
//                   height: 58,
//                   width: 40,
//                   child: Center(
//                     child: Icon(
//                       Broken.home_2,
//                       color: currentPage == 0 ? homeColor : unselectedColor,
//                       size: currentPage == 0 ? 32 : 28,
//                       // color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 58,
//                   width: 40,
//                   child: Center(
//                       child: Icon(
//                     Broken.music,
//                     color: currentPage == 1 ? customColor : unselectedColor,
//                     size: currentPage == 1 ? 32 : 28,
//                   )),
//                 ),
//                 SizedBox(
//                   height: 58,
//                   width: 40,
//                   child: Center(
//                       child: Icon(
//                     Broken.profile_2user,
//                     color: currentPage == 2 ? locationColor : unselectedColor,
//                     size: currentPage == 2 ? 32 : 28,
//                   )),
//                 ),
//                 SizedBox(
//                   height: 58,
//                   width: 40,
//                   child: Center(
//                       child: Icon(
//                     Broken.setting_2,
//                     color: currentPage == 3 ? settingsColor : unselectedColor,
//                     size: currentPage == 3 ? 32 : 28,
//                   )),
//                 ),
//               ],
//             ),
//           ),
//           // Positioned(
//           //     bottom: 100,
//           //     right: 10,
//           //     left: 10,
//           //     child: Container(
//           //       width: 200,
//           //       height: 50,
//           //       color: Colors.red,
//           //     ))
//         ],
//       ),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget?> _pages;

  int selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = List.generate(4, (_) => null);
    _initializePage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedPageIndex,
        children: _pages.map((page) {
          if (page == null) {
            return Container();
          } else {
            return page;
          }
        }).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Color(0xff131321),
        indicatorColor: Color(0xFFE6EDFF),
        selectedIndex: selectedPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            selectedPageIndex = index;
            if (_pages[index] == null) {
              _initializePage(index);
            }
          });
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(
              Broken.home_2,
              size: 28,
              color: Color(0xff131321),
            ),
            icon: Icon(
              Broken.home_2,
              size: 28,
              color: Color(0xFFE6EDFF).withOpacity(0.6),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Broken.music,
              color: Color(0xff131321),
              size: 28,
            ),
            icon: Icon(
              Broken.music,
              size: 28,
              color: Color(0xFFE6EDFF).withOpacity(0.6),
            ),
            label: 'Composers',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Broken.profile_2user, color: Color(0xff131321), size: 28),
            icon: Icon(
              Broken.profile_2user,
              color: Color(0xFFE6EDFF).withOpacity(0.6),
              size: 28,
            ),
            label: 'Meditate',
          ),
          NavigationDestination(
            selectedIcon:
                Icon(Broken.setting_2, color: Color(0xff131321), size: 28),
            icon: Icon(
              Broken.setting_2,
              color: Color(0xFFE6EDFF).withOpacity(0.6),
              size: 28,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _initializePage(int index) {
    switch (index) {
      case 0:
        _pages[index] = AuraHomePage();
        break;
      case 1:
        _pages[index] = AuraComposers();
        break;
      case 2:
        _pages[index] = MeditationScreen();
        break;
      case 3:
        _pages[index] = SettingsPage();
        break;
      default:
        throw Exception('Invalid index');
    }
  }
}
