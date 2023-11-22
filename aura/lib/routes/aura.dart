import 'package:flutter/material.dart';

class AuraHomePage extends StatelessWidget {
  // final Color color;
  final ScrollController controller;

  const AuraHomePage(
      {
      // required this.color,
      required this.controller,
      Key? key})
      : super(key: key);

  String _getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                greeting,
                style: const TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "XD",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: RotatedBox(
                quarterTurns: 3,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Live',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Relaxing',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Sleep',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          )
                        ],
                      ),
                    ]),
              ),
            ),
            Container(
              height: 1000,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
