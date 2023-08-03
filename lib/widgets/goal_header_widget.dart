import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final theme = ref.watch(themeProvider);
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

class TimeCard extends ConsumerStatefulWidget {
  final String hintText;

  final TextEditingController? controller;

  TimeCard({
    this.controller,
    this.hintText = '',
  });

  @override
  _TimeCardState createState() => _TimeCardState();
}

class _TimeCardState extends ConsumerState<TimeCard> {
  late TimeOfDay time;

  @override
  void initState() {
    super.initState();

    time = TimeOfDay.fromDateTime(DateTime.now());
  }

  // String _formatTime(TimeOfDay timeOfDay) {
  //   final hours =
  //       timeOfDay.hour == 0 || timeOfDay.hour == 12 ? 12 : timeOfDay.hour % 12;
  //   return '${hours.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  // }
  String _formatTime(TimeOfDay timeOfDay) {
    final hours =
        timeOfDay.hour == 0 || timeOfDay.hour == 12 ? 12 : timeOfDay.hour % 12;
    final period = timeOfDay.hour >= 12 ? 'PM' : 'AM';
    return '${hours.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _selectTime(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.iOS || kIsWeb) {
      await _showCupertinoTimePicker(context);
    } else {
      await _showMaterialTimePicker(context);
    }
  }

  Future<void> _showMaterialTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (picked != null && picked != time) {
      setState(() {
        time = picked;
        widget.controller!.text = _formatTime(picked);
      });
    }
  }

  Future<void> _showCupertinoTimePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: false, // Use 12-hour format
            initialDateTime: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, time.hour, time.minute),
            onDateTimeChanged: (DateTime picked) {
              setState(() {
                time = TimeOfDay.fromDateTime(picked);
                widget.controller!.text = _formatTime(time);
              });
            },
          ),
        );
      },
    );
  }

  // your build method here
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isDarkTheme = theme.colorScheme.brightness == Brightness.dark;
    TimeOfDay selectedTime = time;
    return Center(
      child: GestureDetector(
        onTap: () => _selectTime(context),
        child: Container(
          alignment: Alignment.center,
          decoration: goalCardTimeLineboxDecoration(
            isDarkTheme,
            theme.colorScheme.onSecondaryContainer,
          ),
          height: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                SizedBox(
                  height: 5,
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/clock.svg',
                      width: 20,
                      height: 20,
                      color: theme.colorScheme.onTertiary,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      _formatTime(selectedTime),
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: theme.colorScheme.onTertiary),
                    ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    // Text(
                    //   selectedTime.period == DayPeriod.am ? 'AM' : 'PM',
                    //   style: GoogleFonts.poppins(
                    //       fontSize: 20, color: theme.colorScheme.primary),
                    // )
                  ],
                )
              ])),
        ),
      ),
    );
  }
}

class DateCard extends ConsumerStatefulWidget {
  final DateTime? date;
  final bool isDatePicker;
  final String hintText;
  final bool justDisplayer;
  final TextEditingController? controller;

  DateCard({
    this.date,
    this.controller,
    this.isDatePicker = false,
    this.hintText = '',
    this.justDisplayer = false,
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
    if (widget.isDatePicker) {
      widget.controller!.text = _formatDate(date);
    }
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    if (widget.isDatePicker) {
      if (Theme.of(context).platform == TargetPlatform.iOS || kIsWeb) {
        await _showCupertinoDatePicker(context);
      } else {
        await _showMaterialDatePicker(context);
      }
    }
  }

  Future<void> _showCupertinoDatePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            initialDateTime: date,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (picked) {
              if (picked != date) {
                setState(() {
                  date = picked;
                  widget.controller!.text = _formatDate(picked);
                });
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _showMaterialDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        widget.controller!.text = _formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isDarkTheme = theme.colorScheme.brightness == Brightness.dark;
    String day = date.day.toString();
    String monthYear = DateFormat('MMM yyyy').format(date);

    return (widget.justDisplayer)
        ? Container(
            decoration: goalCardTimeLineboxDecoration(
              isDarkTheme,
              theme.colorScheme.onSecondaryContainer,
            ),
            width: 120,
            height: 120,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                    ])),
          )
        : GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              width: widget.isDatePicker ? 120 : 100,
              height: widget.isDatePicker ? 70 : 100,
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
                    if (widget.isDatePicker) ...[
                      Row(
                        children: [
                          Text(
                            day,
                            style: GoogleFonts.poppins(
                                fontSize: !widget.isDatePicker ? 30 : 16,
                                color: !widget.isDatePicker
                                    ? theme.colorScheme.onTertiary
                                    : theme.colorScheme.primary),
                          ),
                          Text(
                            monthYear,
                            style: GoogleFonts.poppins(
                                fontSize: !widget.isDatePicker ? 12 : 16,
                                color: theme.colorScheme.onTertiary),
                          )
                        ],
                      ),
                    ],
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
