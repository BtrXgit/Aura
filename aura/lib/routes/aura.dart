import 'package:flutter/material.dart';

class AuraHomePage extends StatefulWidget {
  final ScrollController controller;

  const AuraHomePage({required this.controller, Key? key}) : super(key: key);

  @override
  State<AuraHomePage> createState() => _AuraHomePageState();
}

class _AuraHomePageState extends State<AuraHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> data = ['Sleep', 'Relaxing', 'Focus', 'Live'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: data.length, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                greeting,
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "XD",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: _buildTabBar(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Center(
                          child:
                              Text('1', style: TextStyle(color: Colors.white)),
                        ),
                        Center(
                          child:
                              Text('2', style: TextStyle(color: Colors.white)),
                        ),
                        Center(
                          child:
                              Text('3', style: TextStyle(color: Colors.white)),
                        ),
                        Center(
                          child:
                              Text('4', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    Color primaryColour = Theme.of(context).colorScheme.primary;
    return TabBar(
      controller: _tabController,
      tabs: data.map((tab) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.046,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1.0, color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Tab(
            child: Text(
              tab,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
