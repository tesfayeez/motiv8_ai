import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

BoxDecoration goalCardDarkThemeDecoration(Color color) {
  return BoxDecoration(
    color: color,
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0, 0),
        blurRadius: 20,
      ),
    ],
    borderRadius: BorderRadius.circular(10),
  );
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
    color: const Color.fromRGBO(170, 170, 170, 0.15),
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
