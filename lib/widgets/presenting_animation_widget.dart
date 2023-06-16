import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class PresentingAnimatedText extends AnimatedText {
  final double slideOffset; // Custom parameter for slide offset

  PresentingAnimatedText({
    required String text,
    TextStyle? textStyle,
    TextAlign? textAlign,
    required Duration duration,
    required this.slideOffset,
  }) : super(
          text: text,
          textStyle: textStyle,
          textAlign: textAlign ?? TextAlign.start,
          duration: duration,
        );

  @override
  void initAnimation(AnimationController controller) {
    controller.forward();
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: slideOffset, end: 0),
      duration: duration,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: Text(
            text,
            style: textStyle,
            textAlign: textAlign,
          ),
        );
      },
    );
  }

  @override
  Widget completeText(BuildContext context) {
    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
    );
  }
}

class AnimatedTextWrapper extends StatelessWidget {
  final Widget child;

  const AnimatedTextWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
