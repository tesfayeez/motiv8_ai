import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/widgets/goal_header_time_line.dart';
import 'package:motiv8_ai/widgets/goal_header_widget.dart';

class HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback? addTaskCallback;
  final VoidCallback? addGoalCallback;
  final VoidCallback? addSubTaskCallback;
  final Color actionButtonColor;
  final bool showAddTask;
  final bool showAddGoal;
  final bool showSubTask;
  final bool showMarkComplete;

  const HeaderRow({
    required this.title,
    required this.actionButtonColor,
    this.addTaskCallback,
    this.addGoalCallback,
    this.addSubTaskCallback,
    this.showAddTask = true,
    this.showAddGoal = true,
    this.showSubTask = false,
    this.showMarkComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (showAddTask)
              buildActionButton(
                  "Add Task", () => addTaskCallback?.call(), actionButtonColor),
            if (showAddTask && showAddGoal) const SizedBox(width: 10),
            if (showAddGoal)
              buildActionButton(
                  "Add Goal", () => addGoalCallback?.call(), actionButtonColor),
            const SizedBox(width: 10),
            if (showSubTask)
              buildActionButton("Add Subtask", () => addSubTaskCallback?.call(),
                  actionButtonColor),
            const SizedBox(width: 10),
            if (showMarkComplete)
              buildActionButton("Complete", () => addSubTaskCallback?.call(),
                  actionButtonColor)
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          capitalize(title),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class TaskListConsumer extends ConsumerWidget {
  final List<GoalTask> goalTaskList;
  final bool isGoalPresent;
  final Color color;

  const TaskListConsumer({
    required this.goalTaskList,
    required this.isGoalPresent,
    required this.color,
  });

  Widget build(BuildContext context, WidgetRef ref) {
    if (goalTaskList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            capitalize(isGoalPresent ? 'Your Tasks 🎯 😄' : ''),
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          GoalHeaderTimeline(tasks: goalTaskList),
        ],
      );
    } else {
      return Center(
        child: Text(
          'Add AI Tasks or Create Your Own',
          style: GoogleFonts.poppins(color: color, fontSize: 14),
        ),
      );
    }
  }
}

class GoalDateRow extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const GoalDateRow({
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DateCard(
          hintText: 'Start Date',
          date: startDate,
          justDisplayer: true,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_forward,
            size: 35,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        DateCard(
          hintText: 'End Date',
          date: endDate,
          justDisplayer: true,
        ),
      ],
    );
  }
}

class StyledContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const StyledContainer({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class PaddedColumn extends StatelessWidget {
  final List<Widget> children;

  const PaddedColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
