import 'package:flutter/material.dart';

class CustomMixin extends StatefulWidget {
  const CustomMixin(
      {super.key, required ScrollController controller, required Color color});

  @override
  State<CustomMixin> createState() => _CustomMixinState();
}

class _CustomMixinState extends State<CustomMixin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Aura Custom'),
        backgroundColor: Colors.red.shade600,
      ),
      backgroundColor: Colors.red.shade400,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
