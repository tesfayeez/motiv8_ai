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

BoxDecoration cardBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        offset: const Offset(2, 2),
        blurRadius: 5,
      ),
    ],
  );
}
