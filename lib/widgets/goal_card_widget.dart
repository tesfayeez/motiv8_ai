import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/add_task_dialog.dart';
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

  GoalCard({
    this.goalTaskModel,
    this.goalModel,
    required this.goalDate,
    required this.alarmTime,
    required this.currentTime,
    required this.percentage,
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
            SimpleDialogOption(
              onPressed: () {
                // Duplicate goal
                // Perform the action for duplicating the goal here
                // ref.watch(goalControllerProvider.notifier).createGoal(
                //     name: "${widget.goalModel.name} Duplicate",
                //     description: widget.goalModel.description,
                //     startDate: widget.goalModel.startDate,
                //     endDate: widget.goalModel.endDate,
                //     reminderFrequency: '',
                //     tasks: [],
                //     context: context,
                //     userID: ref.watch(currentUserProvider)!.uid);
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Duplicate goal', style: GoogleFonts.poppins()),
                  const Icon(Icons.content_copy),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                CustomDialog.show(context);
                // Complete goal
                // Perform the action for completing the goal here
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Complete goal', style: GoogleFonts.poppins()),
                  const Icon(Icons.check_circle),
                ],
              ),
            ),
            if (widget.goalTaskModel != null)
              SimpleDialogOption(
                onPressed: () {
                  // Delete goal
                  // Perform the action for deleting the goal here
                  // ref.watch(goalControllerProvider.notifier).deleteGoal(
                  //     goalId: widget.goalTaskModel.id, context: context);
                  // Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Delete Task',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                    const Icon(Icons.delete, color: Colors.red),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.93;

    if (widget.percentage == 100) {
      _confettiController.play();
    }

    final String name =
        widget.goalTaskModel?.name ?? widget.goalModel?.name ?? '';
    final String description = widget.goalTaskModel?.description ??
        widget.goalModel?.description ??
        '';

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onLongPress: () {
          // Vibration.vibrate();
          HapticFeedback.heavyImpact();
          showDialogForEditingGoal();
        },
        onTap: () {
          HapticFeedback.lightImpact();

          print("Clicked $name");
        },
        child: SizedBox(
          width: width,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckbox(
                            value: _isSelected,
                            onChanged: (bool newValue) {
                              setState(() {
                                _isSelected = newValue;
                              });
                            },
                          ),
                          const SizedBox(width: 5.0),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2.0),
                                Text(
                                  capitalize(name),
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  capitalize(description),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  'Task Date: ${DateFormat.yMMMd().format(widget.goalDate)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          if (widget.goalModel != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 15.0),
                                CircularStepProgressIndicator(
                                  unselectedColor: Colors.black,
                                  height: 55,
                                  totalSteps: 10,
                                  currentStep: 2,
                                  width: 55,
                                  roundedCap: (_, isSelected) => isSelected,
                                ),
                              ],
                            ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.alarm,
                                color: Colors.blue,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                widget.alarmTime,
                                style: GoogleFonts.poppins(
                                    fontSize: 10, color: Colors.grey),
                              ),
                              const SizedBox(width: 8.0),
                              const Icon(
                                Icons.access_time,
                                color: Colors.blue,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                widget.currentTime,
                                style: GoogleFonts.poppins(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
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
