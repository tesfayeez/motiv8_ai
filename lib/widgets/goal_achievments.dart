import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            const Icon(Icons.trending_up, size: 50.0, color: Colors.blueAccent),
            Text('Goal Streaks',
                style: GoogleFonts.poppins(color: Colors.blueAccent)),
            Text(goalStreaks.toString(),
                style: GoogleFonts.poppins(color: Colors.blueAccent)),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.calendar_today,
              size: 50.0,
              color: Colors.blueAccent,
            ),
            Text(
              'Perfect Days',
              style: GoogleFonts.poppins(color: Colors.blueAccent),
            ),
            Text(
              perfectDays.toString(),
              style: GoogleFonts.poppins(color: Colors.blueAccent),
            ),
          ],
        ),
        Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 50.0,
              color: Colors.blueAccent,
            ),
            Text(
              'Daily Average',
              style: GoogleFonts.poppins(color: Colors.blueAccent),
            ),
            Text(
              dailyAverageHabits.toStringAsFixed(1),
              style: GoogleFonts.poppins(color: Colors.blueAccent),
            ),
          ],
        ),
      ],
    );
  }
}
