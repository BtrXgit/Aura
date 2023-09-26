import 'package:flutter/material.dart';

class InfiniteListPage extends StatelessWidget {
  final Color color;
  final ScrollController controller;
  const InfiniteListPage(
      {required this.color, required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple,
          )
        ]),
      ),
    );
  }
}

