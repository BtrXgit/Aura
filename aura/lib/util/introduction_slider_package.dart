library introduction_slider;

import 'package:aura/util/intro_slider_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class IntroductionSlider extends StatefulWidget {
  final List<IntroductionSliderItem> items;
  final ScrollPhysics? physics;
  final Back? back;
  final Next? next;
  final Done done;
  final DotIndicator? dotIndicator;
  final Axis scrollDirection;
  // final Skip? skip;

  int initialPage;

  IntroductionSlider({
    Key? key,
    required this.items,
    this.initialPage = 0,
    this.physics,
    this.scrollDirection = Axis.horizontal,
    this.back,
    required this.done,
    this.next,
    this.dotIndicator,
    // this.skip,
  })  : assert((initialPage <= items.length - 1) && (initialPage >= 0),
            "initialPage can't be less than 0 or greater than items length."),
        super(key: key);

  @override
  State<IntroductionSlider> createState() => _IntroductionSliderState();
}

class _IntroductionSliderState extends State<IntroductionSlider> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage);
    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastIndex = widget.initialPage == widget.items.length - 1;
    return Scaffold(
      backgroundColor: Color(0xFF131321),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: widget.items.length,
            physics: widget.physics,
            scrollDirection: widget.scrollDirection,
            onPageChanged: (index) =>
                setState(() => widget.initialPage = index),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: widget.items[index].backgroundColor,
                  gradient: widget.items[index].gradient,
                  image: widget.items[index].backgroundImageDecoration,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    widget.items[index].image ?? const SizedBox(),
                    widget.items[index].title ?? const SizedBox(),
                    widget.items[index].subtitle ?? const SizedBox(),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),
          widget.dotIndicator == null
              ? const SizedBox()
              : Positioned(
                  bottom: 80,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        widget.items.length,
                        (index) => AnimatedContainer(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: index == widget.initialPage
                                ? widget.dotIndicator?.selectedColor
                                : widget.dotIndicator?.unselectedColor ??
                                    widget.dotIndicator?.selectedColor
                                        ?.withOpacity(0.5),
                          ),
                          height: widget.dotIndicator?.size,
                          width: index == widget.initialPage
                              ? widget.dotIndicator!.size! * 2.5
                              : widget.dotIndicator!.size,
                          duration: const Duration(milliseconds: 350),
                        ),
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: 35,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (widget.initialPage == 0 || widget.back == null)
                      ? const SizedBox()
                      : TextButton(
                          onPressed: () => pageController.previousPage(
                            duration: widget.back!.animationDuration!,
                            curve: widget.back!.curve!,
                          ),
                          style: widget.back!.style,
                          child: widget.back!.child,
                        ),
                  lastIndex
                      ? TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                transitionDuration:
                                    widget.done.animationDuration!,
                                transitionsBuilder: (context, animation,
                                    secondAnimation, child) {
                                  animation = CurvedAnimation(
                                    parent: animation,
                                    curve: widget.done.curve!,
                                  );
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: widget.scrollDirection ==
                                              Axis.vertical
                                          ? const Offset(0, 1.0)
                                          : const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return widget.done.home!;
                                },
                              ),
                            );
                          },
                          style: widget.done.style,
                          child: widget.done.child,
                        )
                      : widget.next == null
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () => pageController.nextPage(
                                duration: widget.next!.animationDuration!,
                                curve: widget.next!.curve!,
                              ),
                              style: widget.next!.style,
                              child: widget.next!.child,
                            ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 40,
              right: 14,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionDuration: widget.done.animationDuration!,
                      transitionsBuilder:
                          (context, animation, secondAnimation, child) {
                        animation = CurvedAnimation(
                          parent: animation,
                          curve: widget.done.curve!,
                        );
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: widget.scrollDirection == Axis.vertical
                                ? const Offset(0, 1.0)
                                : const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return widget.done.home!;
                      },
                    ),
                  );
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.kanit(color: Colors.white, fontSize: 20),
                ),
              ))
        ],
      ),
    );
  }
}

class DotIndicator {
  final double? size;
  final Color? selectedColor;
  final Color? unselectedColor;

  const DotIndicator({
    this.size = 10,
    this.selectedColor = Colors.white,
    this.unselectedColor,
  });
}
