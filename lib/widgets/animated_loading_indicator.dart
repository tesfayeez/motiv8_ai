import 'package:flutter/material.dart';

class AnimatedEmojiLoadingIndicator extends StatefulWidget {
  @override
  _AnimatedEmojiLoadingIndicatorState createState() =>
      _AnimatedEmojiLoadingIndicatorState();
}

class _AnimatedEmojiLoadingIndicatorState
    extends State<AnimatedEmojiLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: _animation.value,
                    child: const Text(
                      '🤔',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Opacity(
                    opacity: 1 - _animation.value,
                    child: const Text(
                      '💭',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
