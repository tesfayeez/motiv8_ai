import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/time_line_widget.dart';

class GoalTaskCardWidget extends ConsumerWidget {
  final GoalTask? goalTask;
  final VoidCallback? addTaskCallback;

  GoalTaskCardWidget({
    this.goalTask,
    this.addTaskCallback,
  });

  Color generateRandomColor() {
    final random = Random();
    final color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    return color;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGoalTaskPresent = goalTask != null;
    final theme = ref.watch(themeProvider);
    final isDarkTheme = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      width: double.infinity - 40,
      decoration: goalCardTimeLineboxDecoration(
        isDarkTheme,
        theme.colorScheme.onSecondaryContainer,
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(8),
                  width: 8,
                  decoration: BoxDecoration(
                    color: generateRandomColor(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          goalTask!.name,
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          goalTask!.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        Text(DateFormat('MMMM d, yyyy').format(goalTask!.date),
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: addTaskCallback,
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                alignment: Alignment.center,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'Add Task',
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
