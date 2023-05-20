import 'package:flutter/material.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/widgets/task_panel_wiget.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context); // Accessing the ThemeData
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0.5), // Grey border
        borderRadius: BorderRadius.circular(4.0),
      ),
      elevation: 0.3,
      color:
          themeData.colorScheme.surface, // Using surface color from ThemeData
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  capitalize(goal.name),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: themeData.colorScheme
                        .onSurface, // Using onSurface color from ThemeData
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              goal.description,
              style: TextStyle(
                  fontSize: 16.0,
                  color: themeData.colorScheme
                      .onSurface), // Using onSurface color from ThemeData
            ),
            const SizedBox(height: 8.0),
            Text(
              'Start Date: ${goal.startDate?.toIso8601String()}',
              style: TextStyle(
                  fontSize: 14.0,
                  color: themeData.colorScheme
                      .onSurface), // Using onSurface color from ThemeData
            ),
            Text(
              'End Date: ${goal.endDate?.toIso8601String()}',
              style: TextStyle(
                  fontSize: 14.0,
                  color: themeData.colorScheme
                      .onSurface), // Using onSurface color from ThemeData
            ),
            Text(
              'Reminder Frequency: ${goal.reminderFrequency}',
              style: TextStyle(
                  fontSize: 14.0,
                  color: themeData.colorScheme
                      .onSurface), // Using onSurface color from ThemeData
            ),
            const SizedBox(height: 8.0),
            TaskPanel(tasks: goal.tasks ?? [])
          ],
        ),
      ),
    );
  }
}
