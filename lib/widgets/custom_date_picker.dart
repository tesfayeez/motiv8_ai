import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';

final GlobalKey<_CustomDatePickerState> datePickerKey =
    GlobalKey<_CustomDatePickerState>();
final GlobalKey<_CustomDatePickerState> timePickerKey =
    GlobalKey<_CustomDatePickerState>();

class CustomDatePicker extends ConsumerStatefulWidget {
  CustomDatePicker({
    Key? key,
    this.showDate = true,
    this.focusNode,
    required this.controller,
    this.hintText,
    this.date,
    this.time,
  }) : super(key: key);

  final TextEditingController controller;
  final bool showDate;
  final FocusNode? focusNode;
  final String? hintText;
  final DateTime? date;
  final DateTime? time;

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

  // @override
  // void initState() {
  //   super.initState();
  //   _dateFormat = DateFormat('EEEE, MMM d, yyyy');
  //   _timeFormat = DateFormat('hh:mm a');
  //   _dateTime = widget.showDate ? DateTime.now() : null;
  //   _timeOfDay = widget.showDate ? null : TimeOfDay.now();
  // }
  @override
  void initState() {
    super.initState();

    _dateFormat = DateFormat('EEEE, MMM d, yyyy');
    _timeFormat = DateFormat('hh:mm a');
    _dateTime = widget.date ?? (widget.showDate ? DateTime.now() : null);
    _timeOfDay = widget.showDate ? null : TimeOfDay.now();

    if (widget.date != null) {
      widget.controller.text = _dateFormat.format(widget.date!);
    } else if (widget.time != null) {
      final formattedTime = _timeFormat.format(
        DateTime(
          0,
          0,
          0,
          widget.time!.hour,
          widget.time!.minute,
        ),
      );
      widget.controller.text = formattedTime;
    }
  }

  @override
  void didUpdateWidget(CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.text != oldWidget.controller.text) {
      setState(() {
        try {
          if (widget.showDate) {
            _dateTime = _dateFormat.parse(widget.controller.text);
          } else {
            final parsedTime = _timeFormat.parse(widget.controller.text);
            _timeOfDay = TimeOfDay.fromDateTime(parsedTime);
          }
        } catch (e) {
          _dateTime = null;
          _timeOfDay = null;
        }

        if (widget.controller.text.isEmpty) {
          if (widget.showDate && widget.date != null) {
            _dateTime = widget.date;
            widget.controller.text = _dateFormat.format(_dateTime!);
          } else if (!widget.showDate && widget.time != null) {
            _timeOfDay = TimeOfDay.fromDateTime(widget.time!);
            final formattedTime = _timeFormat.format(DateTime(
              0,
              0,
              0,
              _timeOfDay!.hour,
              _timeOfDay!.minute,
            ));
            widget.controller.text = formattedTime;
          }
        }
      });
    }
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
                                    final formattedDate =
                                        _dateFormat.format(_dateTime!);
                                    widget.controller.text = formattedDate;
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
                                    final formattedTime = _timeFormat.format(
                                        DateTime(0, 0, 0, _timeOfDay!.hour,
                                            _timeOfDay!.minute));
                                    widget.controller.text = formattedTime;
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
