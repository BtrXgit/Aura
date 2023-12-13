import 'package:flutter/material.dart';

class ExploreWorld extends StatelessWidget {
  const ExploreWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
                Tab(text: 'Tab 3'),
                Tab(text: 'Tab 4'),
                Tab(text: 'Tab 5'),
                Tab(text: 'Tab 6'),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Content for Tab 1')),
                  Center(child: Text('Content for Tab 2')),
                  Center(child: Text('Content for Tab 3')),
                  Center(child: Text('Content for Tab 4')),
                  Center(child: Text('Content for Tab 5')),
                  Center(child: Text('Content for Tab 6')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ExploreWorld(),
  ));
}
