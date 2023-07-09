import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  static route() =>
      MaterialPageRoute(builder: (context) => const NotificationsScreen());

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  DateTime? goalCheckUpReminder;
  DateTime? taskCheckUpReminder;
  DateTime? motivationalQuoteReminder;

  Future<void> _showTimePicker(
      BuildContext context, DateTime? selectedTime) async {
    if (kIsWeb || Theme.of(context).platform == TargetPlatform.android) {
      // Show Material-style time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime now = DateTime.now();
        final DateTime selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          selectedTime = selectedDateTime;
        });
      }
    } else {
      // Show Cupertino-style time picker
      final TimeOfDay? pickedTime = await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                // Provide the desired theme data
                brightness: Theme.of(context).brightness,
                primaryColor: Theme.of(context).primaryColor,
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: Colors.black, // Customize the text color
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  final DateTime now = DateTime.now();
                  final DateTime selectedDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    newDateTime.hour,
                    newDateTime.minute,
                  );
                  setState(() {
                    selectedTime = selectedDateTime;
                  });
                },
              ),
            ),
          );
        },
      );
      ;

      ;

      if (pickedTime != null) {
        final DateTime now = DateTime.now();
        final DateTime selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          selectedTime = selectedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    bool generateTasks = false;
    // final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        isBackPresent: true,
        isCenterTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Goal & Tasks Settings',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: goalCardDarkThemeDecoration(
                    theme.colorScheme.onSecondaryContainer, isDark),
                child: Column(
                  children: [
                    ExpandableSwitchTile(
                      contentBuilder: () => alertTime(theme, 'Reminder Time',
                          goalCheckUpReminder, '4:00 pm'),
                      leading: Text(
                        'Goal Check Up Reminders',
                        style: GoogleFonts.poppins(
                            color: theme.colorScheme.onTertiary),
                      ),
                    ),
                    ExpandableSwitchTile(
                      contentBuilder: () => alertTime(theme, 'Reminder Time',
                          taskCheckUpReminder, '8:00 pm'),
                      leading: Text(
                        'Review Tasks Reminder',
                        style: GoogleFonts.poppins(
                            color: theme.colorScheme.onTertiary),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Goal Alert time',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      trailing: Text(
                        "8:00 am",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Motivational Quote Settings',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: goalCardDarkThemeDecoration(
                    theme.colorScheme.onSecondaryContainer, isDark),
                child: Column(
                  children: [
                    ExpandableSwitchTile(
                      leading: Text(
                        'Generate Motivational Quotes ',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      contentBuilder: () => motivationalQuotesSettings(theme),
                    ),
                    SwitchListTile.adaptive(
                      activeColor: theme.colorScheme.primary,
                      title: Text(
                        'Review Task check-up',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      value: generateTasks,
                      onChanged: (value) {
                        setState(() {
                          generateTasks = value;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Motivational Quotes Reminder Time',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () =>
                            _showTimePicker(context, motivationalQuoteReminder),
                        child: Text(
                            motivationalQuoteReminder != null
                                ? DateFormat('h:mm a')
                                    .format(motivationalQuoteReminder!)
                                : '8:00 am',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: theme.colorScheme.primary,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Padding motivationalQuotesSettings(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Repeat',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: theme.colorScheme.onTertiary,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Chip(
                surfaceTintColor: theme.colorScheme.primary,
                label: Text("Daily"),
              ),
              Chip(
                label: Text("Weekly"),
              ),
              Chip(
                label: Text("None"),
              )
            ],
          ),
          Text(
            'On Theses Days',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: theme.colorScheme.onTertiary,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Chip(
                label: Text("S"),
              ),
              Chip(
                label: Text("M"),
              ),
              Chip(
                label: Text("T"),
              ),
              Chip(
                label: Text("W"),
              ),
              Chip(
                label: Text("T"),
              ),
              Chip(
                label: Text("F"),
              ),
              Chip(
                label: Text("S"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Padding alertTime(
      ThemeData themeData, String title, DateTime? time, String defaultTime) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: themeData.colorScheme.onTertiary,
          ),
        ),
        GestureDetector(
          onTap: () => _showTimePicker(context, time),
          child: Text(
              time != null ? DateFormat('h:mm a').format(time) : defaultTime,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: themeData.colorScheme.primary)),
        )
      ]),
    );
  }
}

// class ExpandableListTile extends StatefulWidget {
//   final Widget leading;

//   final Widget content;

//   ExpandableListTile({required this.leading, required this.content});

//   @override
//   _ExpandableListTileState createState() => _ExpandableListTileState();
// }

// class _ExpandableListTileState extends State<ExpandableListTile> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           leading: widget.leading,
//           trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
//           onTap: () {
//             setState(() {
//               _isExpanded = !_isExpanded;
//             });
//           },
//         ),
//         if (_isExpanded) widget.content,
//       ],
//     );
//   }
// }
class ExpandableTile extends StatefulWidget {
  final Widget leading;

  final Widget Function() contentBuilder;

  ExpandableTile({
    required this.leading,
    required this.contentBuilder,
  });

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: widget.leading,
          trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: SizedBox.shrink(),
          secondChild: widget.contentBuilder(),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ],
    );
  }
}

class ExpandableSwitchTile extends StatefulWidget {
  final Widget leading;

  final Widget Function() contentBuilder;

  ExpandableSwitchTile({
    required this.leading,
    required this.contentBuilder,
  });

  @override
  _ExpandableSwitchTileState createState() => _ExpandableSwitchTileState();
}

class _ExpandableSwitchTileState extends State<ExpandableSwitchTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          activeColor: const Color(0xFF1988FF),
          title: widget.leading,
          value: _isExpanded,
          onChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: SizedBox.shrink(),
          secondChild: widget.contentBuilder(),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ],
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Row(
        children: [
          Icon(Icons.access_time),
          const SizedBox(width: 8),
          Text(
            selectedTime.format(context),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
