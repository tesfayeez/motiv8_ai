import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/goal%20header%20widgets/goal_header_master_widget.dart';

class GoalHeader extends ConsumerWidget {
  final Goal goal;
  final GoalTask? goalTask;
  final VoidCallback addGoalCallback;
  final VoidCallback addTaskCallback;

  const GoalHeader({
    required this.goal,
    required this.addGoalCallback,
    required this.addTaskCallback,
    this.goalTask,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGoalPresent = goal != null;
    final theme = ref.read(themeProvider);
    final goalTaskList = ref.watch(goalTaskListProvider);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return StyledContainer(
      color: theme.colorScheme.onSecondaryContainer,
      child: PaddedColumn(
        children: [
          HeaderRow(
            title: isGoalPresent ? '${goal.name} 🎯' : '',
            addTaskCallback: addTaskCallback,
            addGoalCallback: addGoalCallback,
            showAddGoal: true,
            actionButtonColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8.0),
          GoalDescriptionText(
            description: goal.description,
            isGoalPresent: isGoalPresent,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 10.0),
          if (isGoalPresent) ...[
            GoalDateRow(
              startDate: goal.startDate,
              endDate: goal.endDate,
            ),
          ],
          const SizedBox(height: 10),
          if (isGoalPresent) ...[
            TaskListConsumer(
              goalTaskList: goalTaskList,
              isGoalPresent: isGoalPresent,
              color: theme.colorScheme.tertiary,
            ),
          ],
        ],
      ),
    );
  }
}

// class DateCard extends StatelessWidget {
//   final DateTime date;
//   final Color mainDateColor;
//   final Color secondDateColor;
//   final Color boxColor;
//   final bool isDarkTheme;
//   final VoidCallback? onTap;

//   const DateCard({
//     required this.date,
//     required this.mainDateColor,
//     required this.secondDateColor,
//     required this.boxColor,
//     required this.isDarkTheme,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     String day = date.day.toString();
//     String monthYear = DateFormat('MMM yyyy').format(date);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 90,
//         height: 75,
//         decoration: goalCardTimeLineboxDecoration(
//           isDarkTheme,
//           boxColor,
//         ),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 day,
//                 style: GoogleFonts.poppins(fontSize: 30, color: mainDateColor),
//               ),
//               Text(
//                 monthYear,
//                 style:
//                     GoogleFonts.poppins(fontSize: 12, color: secondDateColor),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class DateCard extends ConsumerStatefulWidget {
  final DateTime? date;
  final bool isDatePicker;
  final String hintText;
  final TextEditingController? controller;

  DateCard({
    this.date,
    this.controller,
    this.isDatePicker = false,
    this.hintText = '',
  });

  @override
  _DateCardState createState() => _DateCardState();
}

class _DateCardState extends ConsumerState<DateCard> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    if (widget.date != null) {
      date = widget.date!;
    } else {
      date = DateTime.now();
    }
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS || kIsWeb) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3.5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    showDayOfWeek: true,
                    onDateTimeChanged: (picked) {
                      if (picked != null && picked != date) {
                        setState(() {
                          date = picked;
                          widget.controller!.text = _formatDate(picked);
                        });
                      }
                    },
                    minimumYear: 2023,
                    maximumYear: 2030,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    } else {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
      );

      if (picked != null && picked != widget.date) {
        setState(() {
          date = picked;
          widget.controller!.text = _formatDate(picked);
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isDatePicker) {
      widget.controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isDarkTheme = theme.colorScheme.brightness == Brightness.dark;
    String day = date.day.toString();
    String monthYear = DateFormat('MMM yyyy').format(date);

    return GestureDetector(
      onTap: widget.isDatePicker ? () => _selectDate(context) : null,
      child: Container(
        width: !widget.isDatePicker ? 90 : 120,
        height: !widget.isDatePicker ? 90 : 120,
        decoration: goalCardTimeLineboxDecoration(
          isDarkTheme,
          theme.colorScheme.onSecondaryContainer,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isDatePicker)
                Text(
                  widget.hintText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: theme.colorScheme.onTertiary.withOpacity(0.4),
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              Text(
                day,
                style: GoogleFonts.poppins(
                    fontSize: !widget.isDatePicker ? 30 : 40,
                    color: !widget.isDatePicker
                        ? theme.colorScheme.onTertiary
                        : theme.colorScheme.primary),
              ),
              Text(
                monthYear,
                style: GoogleFonts.poppins(
                    fontSize: !widget.isDatePicker ? 12 : 14,
                    color: theme.colorScheme.onTertiary),
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GoalDescriptionText extends StatelessWidget {
  final String description;
  final bool isGoalPresent;
  final Color color;

  const GoalDescriptionText({
    required this.description,
    required this.isGoalPresent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      capitalize(description),
      style: GoogleFonts.poppins(
        color: color,
        fontSize: isGoalPresent ? 16 : 14,
        fontWeight: isGoalPresent ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }
}
