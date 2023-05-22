import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgress extends StatelessWidget {
  final double percent;

  CircleProgress({required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: CustomPaint(
        painter: CircleProgressPainter(percent),
        child: Center(
          child: Text(
            '${(percent * 100).round()}%',
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double percent;
  final int totalSegments =
      10; // the total number of segments you want to divide the circle into
  final Color filledColor = Colors.blue; // color for the filled segments
  final Color unfilledColor = Colors.grey; // color for the unfilled segments

  CircleProgressPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    double radius = min(size.width, size.height) / 2;

    Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < totalSegments; i++) {
      paint.color = i < totalSegments * percent ? filledColor : unfilledColor;
      double startRadian = -pi / 2 + 2 * pi / totalSegments * i;
      double sweepRadian = 2 * pi / totalSegments;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
