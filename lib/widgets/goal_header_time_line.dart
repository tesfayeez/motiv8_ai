import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

class GoalHeaderTimeline extends ConsumerWidget {
  final List<GoalTask> tasks;

  const GoalHeaderTimeline({required this.tasks});

  Color generateRandomColor() {
    final random = Random();
    // Generate a random color by limiting the minimum value for each color component
    final color = Color.fromARGB(
      255,
      128 + random.nextInt(128), // Red component will be between 128 and 255
      128 + random.nextInt(128), // Green component will be between 128 and 255
      128 + random.nextInt(128), // Blue component will be between 128 and 255
    );
    return color;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = ref.watch(themeProvider);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final randomColor = generateRandomColor();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: randomColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            DateFormat('MMM d, yyyy').format(task.date),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: theme.colorScheme.onTertiary,
                            ),
                          ),
                        ),
                        const DashedLine(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: GoalTaskCardForHeaderWidget(
                  color: randomColor,
                  goalTask: task,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashedLine extends StatelessWidget {
  final int numDashes;
  final Color color;

  const DashedLine({this.numDashes = 58, this.color = const Color(0xFFC4D7FF)});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        numDashes,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            height: 2,
            width: 2,
            color: color,
          ),
        ),
      ),
    );
  }
}

class GoalTaskCardForHeaderWidget extends ConsumerWidget {
  final GoalTask goalTask;
  final Color color;

  const GoalTaskCardForHeaderWidget(
      {required this.goalTask, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final isDarkTheme = theme.brightness == Brightness.dark;
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 2,
            color: color,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10),
              padding: const EdgeInsets.all(10),
              decoration: addedTasksToGoalHeader(
                  theme.colorScheme.tertiaryContainer, isDarkTheme),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    goalTask.name,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.tertiary),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    goalTask.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: theme.colorScheme.tertiary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
