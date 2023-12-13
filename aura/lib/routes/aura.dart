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
                children: [
                  Column(
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: _buildTabBar(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        _buildWidgets(),
                        _buildWidgets2(),
                        _buildWidgets(),
                        _buildWidgets2(),
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
    return TabBar(
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.center,
      physics: const BouncingScrollPhysics(),
      indicatorPadding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
      controller: _tabController,
      indicatorColor: Colors.grey,
      indicator: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      labelColor: const Color.fromARGB(255, 175, 202, 0),
      unselectedLabelColor: Colors.grey,
      isScrollable: true,
      labelPadding: const EdgeInsets.symmetric(horizontal: 15),
      tabs: data.map((tab) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.046,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.grey),
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

  Widget _buildWidgets() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.green,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.green,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.green,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgets2() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.pink,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.green,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.purple,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.orange,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.cyan,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.amber,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.greenAccent,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
