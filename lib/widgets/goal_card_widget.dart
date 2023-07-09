import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/add_task_dialog.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/custom_checkbox.dart';
import 'package:motiv8_ai/widgets/custom_dialog_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

class GoalCard extends ConsumerStatefulWidget {
  final GoalTask? goalTaskModel;
  final Goal? goalModel;
  final DateTime goalDate;
  final String alarmTime;
  final String currentTime;
  final int percentage;
  final VoidCallback onTap;

  GoalCard({
    this.goalTaskModel,
    this.goalModel,
    required this.goalDate,
    required this.alarmTime,
    required this.currentTime,
    required this.percentage,
    required this.onTap,
  });

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends ConsumerState<GoalCard> {
  late ConfettiController _confettiController;
  bool _isSelected = false;

  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Path drawCircle(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    ));
    return path;
  }

  Future<void> showDialogForEditingGoal() {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return SimpleDialog(
          title: Text('Options', style: GoogleFonts.poppins()),
          children: [
            if (widget.goalModel != null)
              SimpleDialogOption(
                onPressed: () {
                  // Edit goal
                  // Perform the action for editing the goal here
                  showDialog(
                    context: context,
                    builder: (context) => AddTaskDialog(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Add Task', style: GoogleFonts.poppins()),
                    const Icon(Icons.edit),
                  ],
                ),
              ),
            if (widget.goalModel != null)
              SimpleDialogOption(
                onPressed: () {
                  // Edit goal
                  // Perform the action for editing the goal here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Edit goal', style: GoogleFonts.poppins()),
                    const Icon(Icons.edit),
                  ],
                ),
              ),
            if (widget.goalTaskModel != null)
              SimpleDialogOption(
                onPressed: () {
                  ref.read(notificationServiceProvider).showNotificationAtTime(
                        id: Random().nextInt(63),
                        title: 'Hey!did you complete your task?',
                        body: widget.goalTaskModel!.description,
                        scheduledTime: widget.goalTaskModel!.taskReminderTime,
                      );

                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Add Reminder', style: GoogleFonts.poppins()),
                    const Icon(Icons.notifications),
                  ],
                ),
              ),
            if (widget.goalTaskModel != null &&
                !widget.goalTaskModel!.isCompleted)
              SimpleDialogOption(
                onPressed: () {
                  ref.read(goalControllerProvider.notifier).completeGoalTask(
                        goalTask: widget.goalTaskModel!,
                        isComplete: !widget.goalTaskModel!.isCompleted,
                        context: context,
                      );
                  Navigator.of(context).pop();
                  CustomDialog.show(context);
                  // Complete goal
                  // Perform the action for completing the goal here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        widget.goalTaskModel != null
                            ? 'Complete task'
                            : 'Complete goal',
                        style: GoogleFonts.poppins()),
                    const Icon(Icons.check_circle),
                  ],
                ),
              ),
            if (widget.goalModel != null)
              SimpleDialogOption(
                onPressed: () {
                  // Delete goal
                  // Perform the action for deleting the goal here
                  ref.watch(goalControllerProvider.notifier).deleteGoal(
                      goalId: widget.goalModel!.id, context: context);
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Delete Goal',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                    const Icon(Icons.delete, color: Colors.red),
                  ],
                ),
              ),
            if (widget.goalTaskModel != null)
              SimpleDialogOption(
                onPressed: () {
                  // Edit goal
                  // Perform the action for editing the goal here
                  showDialog(
                    context: context,
                    builder: (context) => AddTaskDialog(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Edit Task', style: GoogleFonts.poppins()),
                    const Icon(Icons.edit),
                  ],
                ),
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.93;
    int percentage;
    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    final bool isTaskCompleted = widget.goalTaskModel?.isCompleted ?? false;

    final String name =
        widget.goalTaskModel?.name ?? widget.goalModel?.name ?? '';
    final String description = widget.goalTaskModel?.description ??
        widget.goalModel?.description ??
        '';

    if (widget.goalModel != null) {
      if (widget.goalModel!.tasks!.length > 0) {
        percentage = (widget.goalModel!.completedTasks /
                widget.goalModel!.tasks!.length *
                100)
            .round();
      } else {
        percentage = 0;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onLongPress: () {
          // Vibration.vibrate();
          HapticFeedback.heavyImpact();
          showDialogForEditingGoal();
        },
        onTap: () {
          widget.onTap();
          HapticFeedback.lightImpact();

          print("Clicked $name");
        },
        child: SizedBox(
          width: width,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: goalCardDarkThemeDecoration(
                    theme.colorScheme.onSecondaryContainer, isDark),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.goalTaskModel != null)
                            CustomCheckbox(
                              color: theme.colorScheme.tertiary,
                              value: widget.goalTaskModel!.isCompleted,
                              onChanged: (bool newValue) {
                                if (newValue) {
                                  // Check the new value instead of the old one
                                  HapticFeedback.vibrate();
                                  _confettiController.play();
                                }

                                ref
                                    .read(goalControllerProvider.notifier)
                                    .completeGoalTask(
                                      goalTask: widget.goalTaskModel!,
                                      isComplete: newValue,
                                      context: context,
                                    );
                                setState(() {
                                  _isSelected = newValue;
                                });
                              },
                            ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2.0),
                                Text(
                                  capitalize(name),
                                  style: GoogleFonts.poppins(
                                    decoration: isTaskCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontSize: 16,
                                    color: theme.colorScheme.tertiary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  capitalize(description),
                                  style: GoogleFonts.poppins(
                                    decoration: isTaskCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: theme.colorScheme.tertiary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                widget.goalModel != null
                                    ? Row(
                                        children: [
                                          Text(
                                            DateFormat.yMMMd().format(
                                                widget.goalModel!.startDate),
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: theme.colorScheme.tertiary,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: theme.colorScheme.onTertiary,
                                          ),
                                          Text(
                                            DateFormat.yMMMd().format(
                                                widget.goalModel!.endDate),
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: theme.colorScheme.tertiary,
                                            ),
                                          )
                                        ],
                                      )
                                    : Text(
                                        'Task Date: ${DateFormat.yMMMd().format(widget.goalDate)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: theme.colorScheme.tertiary
                                              .withOpacity(0.8),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          if (widget.goalModel != null)
                            Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularStepProgressIndicator(
                                    totalSteps: 5,
                                    currentStep:
                                        widget.goalModel!.completedTasks,
                                    stepSize: 5,
                                    selectedColor: theme.colorScheme.primary,
                                    unselectedColor: Colors.transparent,
                                    padding: 0,
                                    width: 60,
                                    height: 60,
                                    selectedStepSize: 5,
                                    roundedCap: (_, __) => true,
                                    child: Center(
                                      child: Text(
                                        "10%",
                                        // "${(widget.goalModel!.completedTasks / widget.goalModel!.tasks!.length * 100).round()}%",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.surface,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                    'Progress',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onTertiary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                      Divider(
                        color: theme.colorScheme.tertiary,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Chip(
                          //   autofocus: true,
                          //   label: Text(
                          //     'High Priority',
                          //     style: GoogleFonts.poppins(
                          //       color: Colors.red,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                          Row(
                            children: [
                              // Icon(
                              //   Icons.alarm,
                              //   color: theme.colorScheme.primary,
                              //   size: 18,
                              // ),
                              // const SizedBox(
                              //   width: 2,
                              // ),
                              // Text(
                              //   widget.alarmTime,
                              //   style: GoogleFonts.poppins(
                              //       fontSize: 12,
                              //       color: theme.colorScheme.tertiary),
                              // ),
                              // const SizedBox(width: 8.0),

                              SvgPicture.asset(
                                'assets/alarm.svg',
                                width: 12,
                                color: theme.colorScheme.primary,
                              ),

                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                widget.goalTaskModel != null
                                    ? DateFormat('h:mm aaaa')
                                        .format(widget
                                            .goalTaskModel!.taskReminderTime)
                                        .toLowerCase()
                                    : widget.goalModel!.reminderTime
                                        .format(context),
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: theme.colorScheme.tertiary),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(width: 10.0),
                    ],
                  ),
                ),
              ),
              if (_isSelected)
                Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    createParticlePath: drawCircle,
                    maximumSize: const Size(9, 9),
                    minimumSize: const Size(8, 8),
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ],
                  ),
                ),
              Positioned(
                right: 15,
                top: 5,
                child: GestureDetector(
                  onTap: showDialogForEditingGoal,
                  child: const Icon(Icons.more_horiz),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
