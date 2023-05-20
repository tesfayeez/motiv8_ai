import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/goal_achievments.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector_math;

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double goalProgress = 0.7;
    var theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CalendarView(),
              const SizedBox(height: 20),
              Card(
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomPaint(
                      size: const Size(200, 200),
                      painter:
                          GoalProgressPainter(goalProgress, theme.primaryColor),
                    ),
                    const SizedBox(height: 20),
                    const GoalStreaksRow(
                      goalStreaks: 2,
                      perfectDays: 10,
                      dailyAverageHabits: 3,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  GoalProgressPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double progressInDegrees = progress * 360;

    Paint grayCircle = Paint()
      ..color = Colors.grey
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    Paint progressCircle = Paint()
      ..color = color
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius =
        math.min(size.width / 2, size.height / 2) - grayCircle.strokeWidth / 2;

    canvas.drawCircle(center, radius, grayCircle);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      vector_math.radians(-90),
      vector_math.radians(-progressInDegrees),
      false,
      progressCircle,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
