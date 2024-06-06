import 'dart:ui';
import 'package:aura/controllers/player_controller.dart';
import 'package:aura/routes/composers/composers.dart';
import 'package:aura/routes/homepage/homepage.dart';
import 'package:aura/routes/meditate/screens/meditation_home.dart';
import 'package:aura/routes/pages/favourites.dart';
import 'package:aura/routes/settings/settings.dart';
import 'package:aura/util/players/mainAuraPlayer.dart';
import 'package:aura/util/players/mini_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  bool isMiniPlayerVisible = true;

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF0c0c16),
      ),
    );
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  Color homeColor = const Color.fromARGB(255, 175, 202, 0);
  Color customColor = Color(0xFF7B4294);
  Color locationColor = const Color.fromARGB(255, 59, 255, 226);
  Color favoritesColor = Colors.red;
  Color settingsColor = Colors.blue;
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
        return favoritesColor;
      case 4:
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
      body: Stack(
        children: [
          BottomBar(
            iconHeight: 50,
            iconWidth: 50,
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
            duration: const Duration(seconds: 1),
            curve: Curves.decelerate,
            showIcon: true,
            width: MediaQuery.of(context).size.width * 0.8,
            start: 2,
            end: 0,
            offset: 10,
            barAlignment: Alignment.bottomCenter,
            reverse: false,
            hideOnScroll: true,
            scrollOpposite: false,
            onBottomBarHidden: () {
              setState(() {
                isMiniPlayerVisible = false;
              });
            },
            onBottomBarShown: () {
              setState(() {
                isMiniPlayerVisible = true;
              });
            },
            body: (context, controller) => TabBarView(
              controller: tabController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AuraHomePage(
                  controller: controller,
                ),
                AuraComposers(
                  controller: controller,
                ),
                MeditationHome(
                  controller: controller,
                ),
                FavouriteSongsScreen(controller: controller),
                SettingsPage(
                  controller: controller,
                ),
              ],
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorPadding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
              controller: tabController,
              indicator: UnderlineTabIndicator(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: _getIndicatorColor(currentPage), width: 6),
                  insets: EdgeInsets.fromLTRB(20, 0, 14, 6)),
              tabs: [
                SizedBox(
                  height: 55,
                  width: 55,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/navIcons/home.svg',
                      color: currentPage == 0 ? homeColor : unselectedColor,
                      height: currentPage == 0 ? 40 : 35,
                      width: currentPage == 0 ? 40 : 35,
                      // color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 55,
                  width: 55,
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/navIcons/composer.svg',
                    color: currentPage == 1 ? customColor : unselectedColor,
                    height: currentPage == 1 ? 40 : 35,
                    width: currentPage == 1 ? 40 : 35,
                  )),
                ),
                SizedBox(
                  height: 55,
                  width: 55,
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/navIcons/meditation.svg',
                    color: currentPage == 2 ? locationColor : unselectedColor,
                    height: currentPage == 2 ? 40 : 35,
                    width: currentPage == 2 ? 40 : 35,
                  )),
                ),
                SizedBox(
                  height: 55,
                  width: 55,
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/navIcons/heart.svg',
                    color: currentPage == 3 ? favoritesColor : unselectedColor,
                    height: currentPage == 3 ? 40 : 35,
                    width: currentPage == 3 ? 40 : 35,
                  )),
                ),
                SizedBox(
                  height: 55,
                  width: 55,
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/navIcons/setting_2.svg',
                    color: currentPage == 4 ? settingsColor : unselectedColor,
                    height: currentPage == 4 ? 40 : 35,
                    width: currentPage == 4 ? 40 : 35,
                  )),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.09,
            right: 10,
            left: 10,
            child: isMiniPlayerVisible ? AuraMiniPlayer() : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class AuraMiniPlayer extends StatelessWidget {
  AuraPlayerController playerController = Get.put(AuraPlayerController());
  AuraMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Obx(
        () => GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return EnlargedMiniPlayer(
                  controller: playerController,
                );
              },
            );
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              playerController.playPrevious();
            } else if (details.primaryVelocity! < 0) {
              playerController.playNext();
            }
          },
          child: playerController.songs.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              if (playerController.songs.isNotEmpty)
                                CachedNetworkImage(
                                  width: 46,
                                  height: 46,
                                  imageUrl: playerController
                                      .songs[
                                          playerController.currentIndex.value]
                                      .imageUrl,
                                )
                              else
                                Container(),
                              SizedBox(
                                width: 6,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    playerController
                                        .songs[
                                            playerController.currentIndex.value]
                                        .songName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    playerController
                                        .songs[
                                            playerController.currentIndex.value]
                                        .artist,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final userId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (userId != null) {
                                    final song = playerController.songs[
                                        playerController.currentIndex.value];
                                    final imageUrl = song.imageUrl;
                                    final songName = song.songName;
                                    final artist = song.artist;
                                    final songUrl = song.songUrl;

                                    final isLiked = await playerController
                                        .checkIfSongIsLiked(userId, songUrl);
                                    playerController.isSongLiked.value =
                                        isLiked;

                                    playerController.toggleLikeSong(
                                      userId: userId,
                                      imageUrl: imageUrl,
                                      songName: songName,
                                      artist: artist,
                                      songUrl: songUrl,
                                    );
                                  }
                                },
                                icon: Obx(() => Icon(
                                      playerController.isSongLiked.value
                                          ? IconlyBold.heart
                                          : IconlyLight.heart,
                                      color: playerController.isSongLiked.value
                                          ? Colors.red
                                          : Colors.white,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(playerController.isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                onPressed: () {
                                  playerController.isPlaying.value
                                      ? playerController.audioPlayer.pause()
                                      : playerController.audioPlayer.play();
                                },
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int selectedPageIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   List<Widget> _pages = [
//     AuraHomePage(),
//     AuraComposers(),
//     MeditationHome(),
//     ExploreWorldPage(),
//     SettingsPage(),
//   ];

//   _changeTab(int index) {
//     setState(() {
//       selectedPageIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // body: IndexedStack(
//       //   index: selectedPageIndex,
//       //   children: _pages.map((page) {
//       //     if (page == null) {
//       //       return Container();
//       //     } else {
//       //       return page;
//       //     }
//       //   }).toList(),
//       // ),
//       body: _pages[selectedPageIndex],
//       bottomNavigationBar: NavigationBar(
//         elevation: 0,
//         height: 64,
//         backgroundColor: Color(0xff131321),
//         indicatorColor: Color(0xFFE6EDFF),
//         selectedIndex: selectedPageIndex,
//         labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
//         onDestinationSelected: (index) => _changeTab(index),
//         destinations: <NavigationDestination>[
//           NavigationDestination(
//             selectedIcon: Icon(
//               Broken.home_2,
//               size: 28,
//               color: Color(0xff131321),
//             ),
//             icon: Icon(
//               Broken.home_2,
//               size: 28,
//               color: Color(0xFFE6EDFF).withOpacity(0.6),
//             ),
//             label: 'Home',
//           ),
//           // NavigationDestination(
//           //   selectedIcon: Icon(
//           //     Broken.category,
//           //     size: 28,
//           //     color: Color(0xff131321),
//           //   ),
//           //   icon: Icon(
//           //     Broken.category,
//           //     size: 28,
//           //     color: Color(0xFFE6EDFF).withOpacity(0.6),
//           //   ),
//           //   label: 'Explore',
//           // ),
//           NavigationDestination(
//             selectedIcon: Icon(
//               Broken.music,
//               color: Color(0xff131321),
//               size: 28,
//             ),
//             icon: Icon(
//               Broken.music,
//               size: 28,
//               color: Color(0xFFE6EDFF).withOpacity(0.6),
//             ),
//             label: 'Composer',
//           ),
//           NavigationDestination(
//             selectedIcon:
//                 Icon(Broken.profile_2user, color: Color(0xff131321), size: 28),
//             icon: Icon(
//               Broken.profile_2user,
//               color: Color(0xFFE6EDFF).withOpacity(0.6),
//               size: 28,
//             ),
//             label: 'Meditate',
//           ),
//           NavigationDestination(
//             selectedIcon:
//                 Icon(Broken.location, color: Color(0xff131321), size: 28),
//             icon: Icon(
//               Broken.location,
//               color: Color(0xFFE6EDFF).withOpacity(0.6),
//               size: 28,
//             ),
//             label: 'Explore',
//           ),
//           NavigationDestination(
//             selectedIcon:
//                 Icon(Broken.setting_2, color: Color(0xff131321), size: 28),
//             icon: Icon(
//               Broken.setting_2,
//               color: Color(0xFFE6EDFF).withOpacity(0.6),
//               size: 28,
//             ),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }

//   // void _initializePage(int index) {
//   //   switch (index) {
//   //     case 0:
//   //       _pages[index] = AuraHomePage();
//   //       break;
//   //     // case 1:
//   //     //   _pages[index] = ExplorePage();
//   //     //   break;
//   //     case 1:
//   //       _pages[index] = AuraComposers();
//   //       break;
//   //     case 2:
//   //       _pages[index] = MeditationHome();
//   //       break;
//   //     case 3:
//   //       _pages[index] = SettingsPage();
//   //       break;
//   //     default:
//   //       throw Exception('Invalid index');
//   //   }
//   // }
// }

typedef BackToTopIconBuilder = Widget Function(double width, double height);

class BottomBar extends StatefulWidget {
  final Widget Function(BuildContext context, ScrollController controller) body;
  final Widget child;
  final BackToTopIconBuilder? icon;
  final double iconWidth;
  final double iconHeight;
  final Color barColor;
  final BoxDecoration? barDecoration;
  final BoxDecoration? iconDecoration;
  final double end;
  final double start;
  final double offset;
  final Duration duration;
  final Curve curve;
  final double width;
  final BorderRadius borderRadius;
  final bool showIcon;
  final Alignment alignment;
  final Alignment barAlignment;
  final Function()? onBottomBarShown;
  final Function()? onBottomBarHidden;
  final bool reverse;
  final bool scrollOpposite;
  final bool hideOnScroll;
  final StackFit fit;
  final Clip clip;

  const BottomBar({
    required this.body,
    required this.child,
    this.icon,
    this.iconWidth = 30,
    this.iconHeight = 30,
    this.barColor = Colors.black,
    this.barDecoration,
    this.iconDecoration,
    this.end = 0,
    this.start = 2,
    this.offset = 10,
    this.duration = const Duration(milliseconds: 120),
    this.curve = Curves.linear,
    this.width = 300,
    this.borderRadius = BorderRadius.zero,
    this.showIcon = true,
    @Deprecated(
        'Use barAlignment instead, this will be removed in a future release')
    this.alignment = Alignment.bottomCenter,
    this.barAlignment = Alignment.bottomCenter,
    this.onBottomBarShown,
    this.onBottomBarHidden,
    this.reverse = false,
    this.scrollOpposite = false,
    this.hideOnScroll = true,
    this.fit = StackFit.loose,
    this.clip = Clip.hardEdge,
    Key? key,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  ScrollController scrollBottomBarController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late bool isScrollingDown;
  late bool isOnTop;

  @override
  void initState() {
    isScrollingDown = widget.reverse;
    isOnTop = !widget.reverse;
    myScroll();
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, widget.start),
      end: Offset(0, widget.end),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    _controller.forward();
  }

  void showBottomBar() {
    if (mounted) {
      setState(() {
        _controller.forward();
      });
    }
    if (widget.onBottomBarShown != null) widget.onBottomBarShown!();
  }

  void hideBottomBar() {
    if (mounted && widget.hideOnScroll) {
      setState(() {
        _controller.reverse();
      });
    }
    if (widget.onBottomBarHidden != null) widget.onBottomBarHidden!();
  }

  Future<void> myScroll() async {
    scrollBottomBarController.addListener(() {
      if (!widget.reverse) {
        if (scrollBottomBarController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (!isScrollingDown) {
            isScrollingDown = true;
            isOnTop = false;
            hideBottomBar();
          }
        }
        if (scrollBottomBarController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isScrollingDown) {
            isScrollingDown = false;
            isOnTop = true;
            showBottomBar();
          }
        }
      } else {
        if (scrollBottomBarController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!isScrollingDown) {
            isScrollingDown = true;
            isOnTop = false;
            hideBottomBar();
          }
        }
        if (scrollBottomBarController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (isScrollingDown) {
            isScrollingDown = false;
            isOnTop = true;
            showBottomBar();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    scrollBottomBarController.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: widget.fit,
      alignment: widget.alignment,
      clipBehavior: widget.clip,
      children: [
        BottomBarScrollControllerProvider(
          scrollController: scrollBottomBarController,
          child: widget.body(context, scrollBottomBarController),
        ),
        if (widget.showIcon)
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(widget.offset),
                child: AnimatedOpacity(
                  duration: widget.duration,
                  curve: widget.curve,
                  opacity: isOnTop == true ? 0 : 1,
                  child: AnimatedContainer(
                    duration: widget.duration,
                    curve: widget.curve,
                    width: isOnTop == true ? 0 : widget.iconWidth,
                    height: isOnTop == true ? 0 : widget.iconHeight,
                    decoration: widget.iconDecoration ??
                        BoxDecoration(
                          color: widget.barColor,
                          shape: BoxShape.circle,
                        ),
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: ClipOval(
                      child: Material(
                        color: Theme.of(context).colorScheme.background,
                        child: InkWell(
                          onTap: () {
                            scrollBottomBarController
                                .animateTo(
                              (!widget.scrollOpposite)
                                  ? scrollBottomBarController
                                      .position.minScrollExtent
                                  : scrollBottomBarController
                                      .position.maxScrollExtent,
                              duration: widget.duration,
                              curve: widget.curve,
                            )
                                .then((value) {
                              if (mounted) {
                                setState(() {
                                  isOnTop = true;
                                  isScrollingDown = false;
                                });
                              }
                              showBottomBar();
                            });
                          },
                          child: () {
                            if (widget.icon != null) {
                              return widget.icon!(
                                  isOnTop == true ? 0 : widget.iconWidth / 2,
                                  isOnTop == true ? 0 : widget.iconHeight / 2);
                            } else {
                              return Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Color(0xff131321),
                                    size: isOnTop == true
                                        ? 0
                                        : widget.iconWidth / 2,
                                  ),
                                ),
                              );
                            }
                          }(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Align(
          alignment: widget.barAlignment,
          child: Padding(
            padding: EdgeInsets.all(widget.offset),
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: widget.width,
                decoration: widget.barDecoration ??
                    BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: widget.borderRadius,
                    ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: Container(
                    width: widget.width,
                    decoration: widget.barDecoration ??
                        BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: widget.borderRadius,
                        ),
                    child: Container(
                      width: widget.width,
                      decoration: widget.barDecoration ??
                          BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: widget.borderRadius,
                          ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//bottom bar contrller
class BottomBarScrollControllerProvider extends InheritedWidget {
  final ScrollController scrollController;
  const BottomBarScrollControllerProvider({
    required Widget child,
    required this.scrollController,
  }) : super(child: child);
  @override
  bool updateShouldNotify(BottomBarScrollControllerProvider oldWidget) =>
      scrollController != oldWidget.scrollController;
  static BottomBarScrollControllerProvider of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<BottomBarScrollControllerProvider>()!;
}
