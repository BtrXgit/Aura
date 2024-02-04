import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedUI extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final BoxDecoration decoration;
  final ImageFilter filter;
  final BorderRadiusGeometry radius;
  final Positioned? positioned;

  const FrostedUI({
    super.key,
    this.child,
    this.height,
    this.width,
    required this.decoration,
    required this.filter,
    required this.radius,
    this.positioned,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child!,
        if (positioned != null)
          Container(
            width: width,
            height: height,
            decoration: decoration,
            child: ClipRRect(
              borderRadius: radius,
              child: BackdropFilter(
                filter: filter,
                child: Container(
                  width: width,
                  height: height,
                  decoration: decoration,
                  child: child,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
