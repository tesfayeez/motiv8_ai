import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';

import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/goal_task_card.dart';
import 'package:motiv8_ai/widgets/goal_task_card_widget.dart';

class Timeline extends ConsumerWidget {
  final List<GoalTask> tasks;

  Timeline({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = ref.watch(themeProvider);

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final task in tasks)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 1,
                borderRadius: const BorderRadius.only(
                  topRight:
                      Radius.circular(30.0), // Rounded corner on the top right
                  bottomRight: Radius.circular(
                      30.0), // Rounded corner on the bottom right
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.date.day.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('MMM yyyy').format(task.date),
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GoalTaskCardWidget(
                  goalTask: task,
                  addTaskCallback: () {
                    ref.watch(goalControllerProvider.notifier).createGoalTask(
                          goalId: '8e7480b5-2a2c-42ee-9c24-2bdaa55c0b89',
                          goalTask: task,
                        );
                  },
                ),
              )
            ],
          ),
      ],
    );
  }
}
