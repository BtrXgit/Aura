import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final Color color;
  final ScrollController controller;
  const SearchPage({required this.color, required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          width: 100,
          height: 100,
          color: Colors.red,
        )
      ]),
    );
  }
}
