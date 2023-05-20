import 'package:flutter/material.dart';

class GoalStreaksRow extends StatelessWidget {
  final int goalStreaks;
  final int perfectDays;
  final double dailyAverageHabits;

  const GoalStreaksRow({
    Key? key,
    required this.goalStreaks,
    required this.perfectDays,
    required this.dailyAverageHabits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(
              Icons.trending_up,
              size: 50.0,
              color: theme.primaryColor,
            ),
            Text(
              'Goal Streaks',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              goalStreaks.toString(),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.calendar_today,
              size: 50.0,
              color: theme.primaryColor,
            ),
            Text(
              'Perfect Days',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              perfectDays.toString(),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 50.0,
              color: theme.primaryColor,
            ),
            Text(
              'Daily Average',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              dailyAverageHabits.toStringAsFixed(1),
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
