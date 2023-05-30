import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:motiv8_ai/commons/auth_text_field.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();
  final dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    if (Platform.isIOS) {
      return showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3.5,
            width: double.infinity,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                  dateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate);
                  ;
                });
              },
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now(),
              minimumYear: 1900,
              maximumYear: DateTime.now().year,
            ),
          );
        },
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          dateController.text = selectedDate.toIso8601String();
        });
      }
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      leftIcon: const Icon(Icons.calendar_month),
      controller: dateController,
      enabled: false,
      onTap: () => _selectDate(context),
      hintText: 'Date of Birth',
    );
  }
}
