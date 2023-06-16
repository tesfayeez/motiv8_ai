import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/widgets/time_line_widget.dart';

class GoalTaskCard extends StatelessWidget {
  final List<GoalTask>? goalTasksList;
  final GoalTask? goalTask;
  final Goal? goal;
  final VoidCallback? goalTaskCallback;
  final VoidCallback? addTaskCallback;
  final bool isNotAddable;

  GoalTaskCard(
      {this.goalTask,
      this.goal,
      this.goalTaskCallback,
      this.addTaskCallback,
      this.goalTasksList,
      this.isNotAddable = false});

  @override
  Widget build(BuildContext context) {
    final isGoalTaskPresent = goalTask != null;
    final isGoalPresent = goal != null;

    return GestureDetector(
      onTap: isNotAddable
          ? () {
              if (isGoalPresent && goalTaskCallback != null) {
                goalTaskCallback!();
              }
            }
          : null,
      child: Card(
        elevation: !isNotAddable ? 1 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          side: !isNotAddable
              ? BorderSide.none
              : BorderSide(
                  color: Color(0xFF00C853), // Set the desired border color here
                  width: 1.0, // Set the desired border width here
                ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                capitalize(
                  isGoalPresent
                      ? 'Your Goal 🎯 😄'
                      : (isGoalTaskPresent ? goalTask!.name : ''),
                ),
                style: GoogleFonts.poppins(
                  fontSize: isGoalPresent ? 25 : 18,
                  fontWeight: isGoalPresent ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                capitalize(
                  isGoalPresent
                      ? goal!.description
                      : (isGoalTaskPresent ? goalTask!.description : ''),
                ),
                style: GoogleFonts.poppins(
                    fontSize: isGoalPresent ? 18 : 14,
                    fontWeight: isGoalPresent ? FontWeight.w500 : null),
              ),
              const SizedBox(height: 8.0),
              if (!isGoalTaskPresent && isGoalPresent)
                const Divider(
                  color: Colors.grey,
                ),
              if (!isGoalPresent && isGoalTaskPresent && !isNotAddable) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGoalTaskPresent
                          ? DateFormat('MMMM d, yyyy').format(goalTask!.date)
                          : '',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: addTaskCallback,
                      child: Text(
                        'Add Task',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF1988FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                )
              ],
              if (isGoalPresent && !isGoalTaskPresent) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'From: ${goal!.startDate != null ? DateFormat.yMMMd().format(goal!.startDate!) : ''}',
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'To: ${goal!.endDate != null ? DateFormat.yMMMd().format(goal!.endDate!) : ''}',
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                )
              ],
              if (isGoalPresent &&
                  goalTasksList != null &&
                  goalTasksList!.isNotEmpty) ...[
                const SizedBox(
                  height: 5,
                ),
                const Text('Your Task'),
                Timeline(
                  tasks: goalTasksList!,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
