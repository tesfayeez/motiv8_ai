import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

class CustomDatePicker extends ConsumerStatefulWidget {
  CustomDatePicker({
    Key? key,
    this.showDate = true,
    this.focusNode,
    required this.controller,
    this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final bool showDate;
  final FocusNode? focusNode;
  final String? hintText;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends ConsumerState<CustomDatePicker> {
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

    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;

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
          icon: Icon(Icons.add, color: theme.colorScheme.primary, size: 35),
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext builder) {
                return Container(
                  height: widget.showDate ? 250.0 : 200.0,
                  color: theme.colorScheme.onSecondaryContainer,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: widget.showDate
                            ? CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: _dateTime ?? DateTime.now(),
                                minimumYear: 2023,
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
                              color: theme.colorScheme.primary,
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
        fillColor: theme.colorScheme.onSecondaryContainer,
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
        hintText: widget.hintText ??
            (widget.showDate ? 'Select a date' : 'Select a time'),
        hintStyle: GoogleFonts.poppins(
            color: theme.colorScheme.onTertiary, fontSize: 14),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
