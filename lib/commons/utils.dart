import 'dart:io';
import 'dart:ui';

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

DateTime? parseDate(String dateString) {
  final DateFormat format = DateFormat('EEEE | MMM d, yyyy');
  try {
    return format.parse(dateString);
  } catch (e) {
    print('Invalid date format: $dateString');
    return null;
  }
}
