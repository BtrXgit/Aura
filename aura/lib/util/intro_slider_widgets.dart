import 'package:flutter/material.dart';

class IntroductionSliderItem {
  final Widget? image;
  final Widget? title;
  final Widget? subtitle;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BackgroundImageDecoration? backgroundImageDecoration;
  const IntroductionSliderItem({
    this.image,
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.gradient,
    this.backgroundImageDecoration,
  });
}

class BackgroundImageDecoration extends DecorationImage {
  const BackgroundImageDecoration({
    required ImageProvider<Object> image,
    BoxFit fit = BoxFit.cover,
    ColorFilter? colorFilter,
    double opacity = 1.0,
  }) : super(
          image: image,
          fit: fit,
          colorFilter: colorFilter,
          opacity: opacity,
        );
}

class Back {
  final Widget child;
  final Duration? animationDuration;
  final Curve? curve;
  final ButtonStyle? style;
  const Back({
    this.style,
    required this.child,
    this.animationDuration = const Duration(seconds: 1),
    this.curve = Curves.easeInOut,
  });
}

class Next {
  final Widget child;
  final Duration? animationDuration;
  final Curve? curve;
  final ButtonStyle? style;
  const Next({
    this.style,
    required this.child,
    this.animationDuration = const Duration(seconds: 1),
    this.curve = Curves.easeInOut,
  });
}

class Done {
  final Widget child;
  final ButtonStyle? style;
  final Duration? animationDuration;
  final Curve? curve;
  final Widget? home;
  const Done({
    this.style,
    required this.child,
    this.animationDuration = const Duration(seconds: 1),
    this.curve = Curves.easeInOut,
    required this.home,
  });
}

// class Skip {
//   final Widget child;
//   final ButtonStyle? style;
//   final Duration? animationDuration;
//   final Curve? curve;
//   final Widget? home;
//   const Skip({
//     this.style,
//     required this.child,
//     this.animationDuration = const Duration(seconds: 1),
//     this.curve = Curves.easeInOut,
//     required this.home,
//   });
// }
