import 'package:aura/lib/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:iconly/iconly.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Navigator(
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                settings: routeSettings,
                builder: (context) {
                  return HomePage();
                },
              );
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.09,
            right: 10,
            left: 10,
            child: AuraMiniPlayer(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewScreen()),
            );
          },
          child: Text('Go to New Screen'),
        ),
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
      ),
      body: Center(
        child: Text('This is a new screen'),
      ),
    );
  }
}

class AuraMiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.grey,
      child: Center(
        child: Text('Aura Mini Player'),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Navigate to Home Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        // Navigate to Search Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
        break;
      case 2:
        // Navigate to Notifications Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationsScreen()),
        );
        break;
      case 3:
        // Navigate to Menu Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
      ],
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AuraHomePage extends StatelessWidget {
  const AuraHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        NotificationPage(),
      ),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          IconlyBold.notification,
          color: Colors.white,
        ),
      ),
    );
  }
}
