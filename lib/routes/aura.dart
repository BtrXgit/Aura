import 'package:flutter/material.dart';

class AuraHomePage extends StatelessWidget {
  final Color color;
  final ScrollController controller;

  const AuraHomePage({required this.color, required this.controller, Key? key})
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
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
