import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker({
    Key? key,
    this.title,
    this.showDate = true,
    this.focusNode,
    required this.controller,
  }) : super(key: key);

  final String? title;
  final TextEditingController controller;
  final bool showDate;
  final FocusNode? focusNode;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateFormat _dateFormat;
  late DateFormat _timeFormat;
  DateTime? _dateTime;
  TimeOfDay? _timeOfDay;
  static const customBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Color.fromARGB(255, 175, 228, 254)),
  );

  @override
  void initState() {
    super.initState();
    _dateFormat = DateFormat('EEEE, MMM d, yyyy');
    _timeFormat = DateFormat('hh:mm a');
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = widget.focusNode ?? FocusNode();
    final shouldRequestFocus =
        focusNode.hasFocus && widget.controller.text.isEmpty;

    if (shouldRequestFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNode);
      });
    }
    return TextFormField(
      readOnly: true,
      controller: widget.controller,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(Icons.add, color: Colors.blue, size: 35),
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext builder) {
                return Container(
                  height: widget.showDate ? 250.0 : 200.0,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: widget.showDate
                            ? CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: _dateTime ?? DateTime.now(),
                                minimumYear: 2021,
                                maximumYear: 2101,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() {
                                    _dateTime = newDate;
                                    widget.controller.text =
                                        _dateFormat.format(_dateTime!);
                                  });
                                },
                              )
                            : CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: _timeOfDay != null
                                    ? DateTime.now().subtract(Duration(
                                        hours: DateTime.now().hour -
                                            _timeOfDay!.hour,
                                        minutes: DateTime.now().minute -
                                            _timeOfDay!.minute))
                                    : DateTime.now(),
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    _timeOfDay =
                                        TimeOfDay.fromDateTime(newDateTime);
                                    widget.controller.text = _timeFormat.format(
                                        DateTime(0, 0, 0, _timeOfDay!.hour,
                                            _timeOfDay!.minute));
                                  });
                                },
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
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: customBorder.copyWith(
          borderSide: BorderSide(
            color: widget.controller.text.isNotEmpty
                ? Colors.blue
                : const Color.fromARGB(255, 175, 228, 254),
          ),
        ),
        focusedBorder: customBorder.copyWith(
          borderSide: BorderSide(
            color: widget.controller.text.isNotEmpty
                ? Colors.blue
                : const Color.fromARGB(255, 175, 228, 254),
          ),
        ),
        hintText: widget.showDate ? 'Select a date' : 'Select a time',
        hintStyle: GoogleFonts.poppins(color: Colors.black45, fontSize: 14),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
