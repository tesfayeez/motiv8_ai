import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/add_goals_modal_Screen.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/screens/add_reminder_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isSameDay(DateTime? date1, DateTime? date2) {
  if (date1 == null || date2 == null) {
    return false;
  }
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String capitalize(String text) {
  if (text.isEmpty) {
    return text;
  }

  return text[0].toUpperCase() + text.substring(1);
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickImage(source: ImageSource.gallery);
  if (imageFiles != null) {
    return File(imageFiles.path);
  }
  return null;
}

Path drawCircle(Size size) {
  final path = Path();
  path.addOval(Rect.fromCircle(
    center: Offset(size.width / 2, size.height / 2),
    radius: size.width / 2,
  ));
  return path;
}

TimeOfDay fromFirestore(String timeString) {
  final timeFormat = DateFormat('hh:mm a');
  final DateTime time = timeFormat.parse(timeString);
  return TimeOfDay(hour: time.hour, minute: time.minute);
}

TimeOfDay parseTime(String time) {
  try {
    final format = DateFormat.jm('en_US');
    final dt = format.parse(time);
    return TimeOfDay.fromDateTime(dt);
  } catch (e) {
    print('Invalid time format: $time');
    return TimeOfDay(hour: 10, minute: 0); // returning 10 AM as default
  }
}

String convertTo24HourFormatString(String time12HourFormat) {
  // Split the string into hours, minutes, and period
  List<String> timeParts = time12HourFormat.split(':');
  List<String> periodParts = timeParts[1].split(' ');

  int hour = int.parse(timeParts[0]);
  int minute = int.parse(periodParts[0]);
  String period = periodParts[1].trim();

  // Adjust the hour based on the period
  if (period.toUpperCase() == "PM" && hour != 12) hour += 12;
  if (period.toUpperCase() == "AM" && hour == 12) hour = 0;

  return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
}

TimeOfDay convertTo24HourFormat(String time12HourFormat) {
  // Split the string into hours, minutes, and period
  List<String> timeParts = time12HourFormat.split(':');
  List<String> periodParts = timeParts[1].split(' ');

  int hour = int.parse(timeParts[0]);
  int minute = int.parse(periodParts[0]);
  String period = periodParts[1].trim();

  // Adjust the hour based on the period
  if (period.toUpperCase() == "PM" && hour != 12) hour += 12;
  if (period.toUpperCase() == "AM" && hour == 12) hour = 0;

  return TimeOfDay(hour: hour, minute: minute);
}

TimeOfDay stringToTimeOfDay(String timeStr) {
  if (timeStr.isEmpty) {
    print('The input string is null or empty!');
    return TimeOfDay.now();
  }

  final format = DateFormat.jm(); // Assuming time format is in AM/PM

  // Replace non-breaking spaces and trim other whitespace
  String cleanedTimeStr = timeStr.replaceAll('\u{A0}', ' ').trim();

  print('Cleaned Time String: $cleanedTimeStr');

  try {
    DateTime dateTime = format.parse(cleanedTimeStr);
    print('Parsed DateTime: $dateTime');
    return TimeOfDay.fromDateTime(dateTime);
  } catch (e) {
    print('Error occurred while parsing the time: $e');
    return TimeOfDay.now();
  }
}

DateTime parseDate(String dateString, {bool regularDate = false}) {
  final DateFormat inputFormat = DateFormat('EEEE, MMM d, yyyy');
  try {
    if (regularDate) {
      final DateTime date = inputFormat.parse(dateString);
      final DateTime dateWithoutTime =
          DateTime(date.year, date.month, date.day);

      return dateWithoutTime;
    } else {
      return inputFormat.parse(dateString);
    }
  } catch (e) {
    print('Invalid date format: $dateString');
    return DateTime.now();
  }
}

BoxDecoration cardBoxDecoration(Color color, bool isDarkTheme) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: color,
    boxShadow: [
      // BoxShadow(
      //   color: Colors.grey.withOpacity(0.2),
      //   offset: const Offset(2, 2),
      //   blurRadius: 5,
      // ),
      BoxShadow(
        color: color.withOpacity(0.25),
        blurRadius: 20.0,
      )
    ],
  );
}

BoxDecoration goalCardTimeLineboxDecoration(bool isDarkTheme, Color color) {
  if (isDarkTheme) {
    return BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 20.0, // soften the shadow
          spreadRadius: 0.0, //extend the shadow
          offset: Offset(
            0.0, // Horizontal offset
            0.0, // Vertical offset
          ),
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    );
  } else {
    return BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 22.0, // soften the shadow
          spreadRadius: 0.0, //extend the shadow
          offset: const Offset(
            0.0, // Horizontal offset
            0.0, // Vertical offset
          ),
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}

BoxDecoration addedTasksToGoalHeader(Color color, bool isDarkTheme) {
  if (isDarkTheme) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(13),
    );
  } else {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: const Color(0xFFE4EDFF),
        width: 0.86783,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.circular(13),
    );
  }
}

BoxDecoration goalCardDecoration(Color color) {
  return BoxDecoration(
    color: color,
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(165, 165, 165, 0.2),
        offset: Offset(0, 5),
        blurRadius: 14,
      ),
    ],
    borderRadius: BorderRadius.circular(10),
  );
}

BoxDecoration goalCardDarkThemeDecoration(Color color, bool isDark) {
  if (isDark) {
    return BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
          color: Color(0x3F000000),
          offset: Offset(0, 0),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ],
      borderRadius: BorderRadius.circular(10),
    );
  } else {
    return BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 7,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(10),
    );
  }
}

BoxDecoration customButtonDecoration(Color color) {
  return BoxDecoration(
    color: color,
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(0, 123, 255, 0.32),
        offset: Offset(0, 6),
        blurRadius: 16,
      ),
    ],
    borderRadius: BorderRadius.circular(20),
  );
}

BoxDecoration customAuthTextfieldDecoration(Color color) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  );
}

BoxDecoration goalCardTimeLineDateDisplayerBoxDecoration(
    Color color, bool isDarkTheme) {
  if (isDarkTheme) {
    return BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 20.0, // soften the shadow
          spreadRadius: 5.0, //extend the shadow
          offset: Offset(
            5.0, // Move to right horizontally
            0.0, // Move to bottom Vertically
          ),
        ),
      ],
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(25.0),
        bottomRight: Radius.circular(25.0),
      ),
    );
  }
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        offset: Offset(3, 3),
        blurRadius: 7,
      )
    ],
    color: Colors.white,
    borderRadius: const BorderRadius.only(
      topRight: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0),
    ),
  );
}

Widget buildActionButton(String label, VoidCallback onTap, Color color) {
  return GestureDetector(
    onTap: () {
      onTap();
      HapticFeedback.lightImpact();
    },
    child: IntrinsicWidth(
      child: Container(
        constraints: BoxConstraints(minWidth: 90),
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    ),
  );
}

void showAddGoalModal(BuildContext context) {
  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: FractionallySizedBox(
            heightFactor: .9,
            child: AddGoalsModalScreen(),
          ),
        );
      });
}

void showAddReminderModal({
  required BuildContext context,
  required GoalTask task,
  bool isitReschedule = false,
}) {
  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: FractionallySizedBox(
            heightFactor: .5,
            child: AddReminderScreen(
              goalTask: task,
              isitReschedule: isitReschedule,
            ),
          ),
        );
      });
}

void showAddGoalTaskModal(BuildContext context, GoalTask? task) {
  showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: FractionallySizedBox(
          heightFactor: .7,
          child: AddGoalScreen(
            task: task,
          ),
        ),
      );
    },
  );
}

Future<void> saveUserIdToPrefs(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final existingUserId = prefs.getString('userId');

  if (existingUserId == null) {
    prefs.setString('userId', userId);
  }
}

Future<String?> loadUserIdFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(
      'userId'); // Will return null if 'userId' is not in the preferences
}

void showPlatformAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required bool reschedule,
  VoidCallback? onTapReschedule,
  String positiveButtonText = 'OK',
  VoidCallback? onPositive,
  String negativeButtonText = 'Cancel',
  VoidCallback? onNegative,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Platform.isIOS
          ? _buildCupertinoAlertDialog(
              context: context,
              title: title,
              description: description,
              reschedule: reschedule,
              onTapReschedule: onTapReschedule,
              positiveButtonText: positiveButtonText,
              onPositive: onPositive,
              negativeButtonText: negativeButtonText,
              onNegative: onNegative,
            )
          : _buildMaterialAlertDialog(
              context: context,
              title: title,
              description: description,
              positiveButtonText: positiveButtonText,
              onPositive: onPositive,
              negativeButtonText: negativeButtonText,
              onNegative: onNegative,
            );
    },
  );
}

Widget _buildCupertinoAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required bool reschedule,
  VoidCallback? onTapReschedule,
  required String positiveButtonText,
  VoidCallback? onPositive,
  required String negativeButtonText,
  VoidCallback? onNegative,
}) {
  return CupertinoAlertDialog(
    title: Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.red,
        fontSize: 14,
      ),
    ),
    content: Text(description),
    actions: [
      if (reschedule)
        CupertinoDialogAction(
          onPressed: () {
            onTapReschedule?.call();
            Navigator.pop(context);
          },
          child:
              Text('Reschedule', style: GoogleFonts.poppins(color: Colors.red)),
        ),
      CupertinoDialogAction(
        onPressed: () {
          onPositive?.call();
          Navigator.pop(context);
        },
        child: Text(positiveButtonText,
            style: GoogleFonts.poppins(color: const Color(0xFF1988FF))),
      ),
      CupertinoDialogAction(
        onPressed: () {
          onNegative?.call();
          Navigator.pop(context);
        },
        child: Text(negativeButtonText,
            style: GoogleFonts.poppins(color: Colors.red)),
      ),
    ],
  );
}

Widget _buildMaterialAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String positiveButtonText,
  VoidCallback? onPositive,
  required String negativeButtonText,
  VoidCallback? onNegative,
}) {
  return AlertDialog(
    title: Text(
      title,
      style: GoogleFonts.poppins(),
    ),
    content: Text(
      description,
      style: GoogleFonts.poppins(),
    ),
    actions: [
      TextButton(
        onPressed: () {
          onPositive?.call();
          Navigator.pop(context);
        },
        child: Text(
          positiveButtonText,
          style: GoogleFonts.poppins(color: const Color(0xFF1988FF)),
        ),
      ),
      TextButton(
        onPressed: () {
          onNegative?.call();
          Navigator.pop(context);
        },
        child: Text(
          negativeButtonText,
          style: GoogleFonts.poppins(),
        ),
      ),
    ],
  );
}
