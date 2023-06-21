import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/goal_header_widget.dart';

class GoalOrTaskScreen extends ConsumerWidget {
  final GoalTask? goalTask;
  final Goal? goal;
  const GoalOrTaskScreen({Key? key, this.goal, this.goalTask})
      : super(key: key);

  dynamic getGoalOrTask() {
    if (goalTask != null) {
      return goalTask;
    } else if (goal != null) {
      return goal;
    } else {
      print('Both goal and goalTask cannot be null');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalOrTask = getGoalOrTask();
    // Now you can use goalOrTask, which will be either a GoalTask or Goal depending on their nullability

    return Scaffold(
      appBar: CustomAppBar(
        title: goalOrTask.name,
        isBackPresent: true,
        isBottomLinePresent: true,
        isCenterTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          GoalHeader(
              goal: goal,
              addGoalCallback: addGoalCallback,
              addTaskCallback: addTaskCallback)
        ]),
      )),
    );
  }
}
