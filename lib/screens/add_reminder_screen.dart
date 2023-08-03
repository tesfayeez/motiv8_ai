import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/custom_date_picker.dart';

class AddReminderScreen extends ConsumerWidget {
  final GoalTask goalTask;
  final bool? isitReschedule;

  const AddReminderScreen(
      {Key? key, required this.goalTask, this.isitReschedule})
      : super(key: key);

  void onReschedule(
      DateTime time, DateTime date, WidgetRef ref, BuildContext context) {
    GoalTask updateGoalTask =
        goalTask.copyWith(taskReminderTime: time, date: date);
    ref
        .read(goalControllerProvider.notifier)
        .updateGoalTask(updatedGoalTask: updateGoalTask, context: context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeController = TextEditingController();
    final dateController = TextEditingController();

    return Scaffold(
      appBar: CustomAppBar(
        title: isitReschedule != null && isitReschedule == true
            ? 'Reschedule Task'
            : 'Add a Reminder',
        isBackPresent: false,
        isCloseOnTheRight: true,
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              isitReschedule != null && isitReschedule == true
                  ? 'Task Reminder Time'
                  : 'Add Time',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 15),
            CustomDatePicker(
              time: goalTask.taskReminderTime,
              controller: timeController,
              hintText: 'Select Time',
              showDate: false,
            ),
            const SizedBox(height: 25),
            Text(
              isitReschedule != null && isitReschedule == true
                  ? 'Reschedule Date'
                  : 'Add Date',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 15),
            CustomDatePicker(
              date: goalTask.date,
              controller: dateController,
              hintText: 'Select Date',
              showDate: true,
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: isitReschedule != null && isitReschedule == true
                  ? 'Reschedule '
                  : 'Add Reminder',
              onPressed: () {
                final selectedDate =
                    DateFormat('EEEE, MMM d, yyyy').parse(dateController.text);
                final selectedTime = timeController.text.isNotEmpty
                    ? DateFormat('h:mm a').parse(timeController.text)
                    : goalTask.taskReminderTime;
                final selectedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                    selectedTime.second);

                if (dateController.text.isNotEmpty &&
                    timeController.text.isNotEmpty) {
                  handleReminderTime(ref, selectedDateTime, context);
                } else {
                  showPlatformAlertDialog(
                    context: context,
                    title: 'Empty Fields',
                    description: 'Please add time and date to add a reminder',
                    reschedule: false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void handleReminderTime(
      WidgetRef ref, DateTime selectedDateTime, BuildContext context) {
    final goalDate = goalTask.date;
    final goalTime = goalTask.taskReminderTime;
    final goalDateTime = DateTime(goalDate.year, goalDate.month, goalDate.day,
        goalTime.hour, goalTime.minute, goalTime.second);

    if (isitReschedule != null && isitReschedule == false) {
      if (selectedDateTime.isBefore(goalDate)) {
        showPlatformAlertDialog(
          context: context,
          title: 'Invalid Reminder Date',
          description: 'Please select a future date for the reminder.',
          reschedule: false,
        );
      } else if (selectedDateTime.isAfter(goalDateTime)) {
        showPlatformAlertDialog(
          context: context,
          title: 'Invalid Reminder Date',
          description:
              "The selected reminder date is after the goal task date. Would you like to reschedule the task?",
          reschedule: true,
          onTapReschedule: () => onReschedule(
            DateTime(selectedDateTime.hour, selectedDateTime.minute),
            selectedDateTime,
            ref,
            context,
          ),
        );
      } else if (selectedDateTime.isAtSameMomentAs(goalDateTime)) {
        showPlatformAlertDialog(
          context: context,
          title: 'Same Reminder Date and Time',
          description:
              "The reminder you've set is the same as the current date and time.",
          reschedule: false,
        );
      } else {
        ref.read(notificationServiceProvider).showNotificationAtTime(
              id: Random().nextInt(63),
              title: 'Hey! Did you complete your task?',
              body: goalTask.description,
              scheduledTime: selectedDateTime.toLocal(),
            );
      }
    } else {
      onReschedule(
        DateTime(selectedDateTime.hour, selectedDateTime.minute),
        selectedDateTime,
        ref,
        context,
      );
      ref.read(notificationServiceProvider).showNotificationAtTime(
          id: Random().nextInt(63),
          title: 'Hey! Did you complete your task?',
          body: goalTask.description,
          scheduledTime: selectedDateTime.toLocal());
    }
  }
}
