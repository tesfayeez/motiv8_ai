import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/goal_header_time_line.dart';
import 'package:motiv8_ai/widgets/goal_task_card.dart';

class GoalHeader extends ConsumerWidget {
  final Goal goal;
  final VoidCallback addGoalCallback;
  final VoidCallback addTaskCallback;

  const GoalHeader({
    required this.goal,
    required this.addGoalCallback,
    required this.addTaskCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGoalPresent = goal != null;
    final goalTasksAsyncValue = ref.watch(
        getGoalTaskStreamProvider('8e7480b5-2a2c-42ee-9c24-2bdaa55c0b89'));
    final theme = ref.read(themeProvider);
    final goalTaskList = ref.watch(goalTaskListProvider);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  capitalize(isGoalPresent ? 'Your Goal 🎯' : ''),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    buildActionButton("Add Task", () => addTaskCallback(),
                        theme.colorScheme.primary),
                    const SizedBox(width: 10),
                    buildActionButton("Add Goal", () => addGoalCallback(),
                        theme.colorScheme.primary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              capitalize(goal.description),
              style: GoogleFonts.poppins(
                fontSize: isGoalPresent ? 16 : 14,
                fontWeight: isGoalPresent ? FontWeight.w500 : null,
              ),
            ),
            const SizedBox(height: 10.0),
            if (isGoalPresent) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DateCard(date: goal.startDate),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 35,
                      color: Colors.grey,
                    ),
                  ),
                  DateCard(date: goal.endDate),
                ],
              )
            ],
            const SizedBox(height: 10),
            if (isGoalPresent) ...[
              Consumer(
                builder: (context, ref, child) {
                  if (goalTaskList.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalize(isGoalPresent ? 'Your Tasks 🎯 😄' : ''),
                          style: GoogleFonts.poppins(fontSize: 22),
                        ),
                        const SizedBox(height: 5),
                        GoalHeaderTimeline(tasks: goalTaskList),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Add AI Tasks or Create Your Own',
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 14),
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(String label, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: () {
        onTap();
        HapticFeedback.heavyImpact();
      },
      child: Container(
        alignment: Alignment.center,
        width: 90,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }
}

class DateCard extends StatelessWidget {
  final DateTime date;

  const DateCard({required this.date});

  @override
  Widget build(BuildContext context) {
    String day = date.day.toString();
    String monthYear = DateFormat('MMM yyyy').format(date);

    return Container(
      width: 90,
      height: 75,
      decoration: cardBoxDecoration(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0, // Remove the card's default elevation
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: GoogleFonts.poppins(fontSize: 30),
              ),
              Text(
                monthYear,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
