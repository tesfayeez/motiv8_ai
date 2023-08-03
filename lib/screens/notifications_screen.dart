import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/snack_bar_provider.dart';
import 'package:motiv8_ai/commons/user_settings_provider.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/user_controllers.dart';
import 'package:motiv8_ai/models/user_model.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/counter_widget.dart';
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
  final UniqueKey motivationalFrequencyKey = UniqueKey();
  final UniqueKey motivationalStartKey = UniqueKey();
  final UniqueKey motivationalEndKey = UniqueKey();
  final counterParams = CounterProviderParams(type: CounterType.upToSeven);

  final motivatonalEndDateParams = CounterProviderParams(
      type: CounterType.dateTime,
      startHour: 11,
      startMinute: 30,
      endHour: 23,
      endMinute: 30);
  final motivatonalStartDateParams = CounterProviderParams(
      type: CounterType.dateTime,
      startHour: 6,
      startMinute: 0,
      endHour: 24,
      endMinute: 00);

  void submitData() {
    print("its being clicked");
    final motivationReminderFrequency =
        ref.read(counterProvider(counterParams));
    final motivationReminderStartDate =
        ref.read(counterProvider(motivatonalStartDateParams)) as DateTime;
    final reminderReminderEndDate =
        ref.read(counterProvider(motivatonalEndDateParams)) as DateTime;

    print(motivationReminderFrequency);

    // Create a new UserSettings object with the updated data
    UserSettings updatedSettings = UserSettings(
      motivationalQuoteReminderFrequency: motivationReminderFrequency,
      motivationalQuoteStartTime: motivationReminderStartDate,
      motivationalQuoteEndTime: reminderReminderEndDate,
      // add other fields as necessary
    );

    // Use the provider to update the UserSettings
    ref
        .read(userControllerProvider.notifier)
        .updateUserSettings(updatedSettings);
    ref.read(hasUnsavedChangesProvider.notifier).setUnsavedChanges(false);
    showSnackBar();
  }

  void showSnackBar() {
    final snackbarController = ref.read(snackbarProvider.notifier);
    snackbarController.show(context, 'Updated Motivational Notification');
  }

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
    // bool generateTasks = false;
    final hasUnsavedChanges = ref.watch(hasUnsavedChangesProvider);

    print("has un saved changes $hasUnsavedChanges");
    // final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        isBackPresent: true,
        isCenterTitle: true,
        isTralingPresent: hasUnsavedChanges,
        onSave: () => submitData(),
        onBackTapped: hasUnsavedChanges
            ? () {
                showPlatformAlertDialog(
                  context: context,
                  description:
                      'You have unsaved changes,do you want to save your settings?',
                  title: 'Error',
                  reschedule: false,
                  positiveButtonText: 'Yes',
                  negativeButtonText: 'No',
                  onNegative: () {
                    Navigator.of(context).pop();
                    ref
                        .read(hasUnsavedChangesProvider.notifier)
                        .setUnsavedChanges(false);
                  },
                  onPositive: () {
                    submitData();

                    Navigator.of(context).pop();
                  },
                );
              }
            : null,
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
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: goalCardDarkThemeDecoration(
                    theme.colorScheme.onSecondaryContainer, isDark),
                child: Column(
                  children: [
                    ReminderFrequencyRow(
                        key: motivationalFrequencyKey,
                        params: counterParams,
                        labelText: 'How Many',
                        onCounterChanged: (counter) {
                          if (counter is int) {
                            // final currentCounter =
                            //     ref.read(counterProvider(counterParams));
                            // currentCounter.state = counter;
                            ref
                                .watch(notificationSettingsProvider.notifier)
                                .updateMotivationalQuoteFrequency(counter);
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    ReminderFrequencyRow(
                        key: motivationalStartKey,
                        params: motivatonalStartDateParams,
                        labelText: 'Start at',
                        onCounterChanged: (counter) {
                          if (counter is DateTime) {
                            // final currentCounter = ref.read(
                            //     counterProvider(motivatonalStartDateParams));
                            // currentCounter.state = counter;
                            ref
                                .read(notificationSettingsProvider.notifier)
                                .updateMotivationalQuoteStartTime(counter);
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    ReminderFrequencyRow(
                      key: motivationalEndKey,
                      params: motivatonalEndDateParams,
                      labelText: 'End at',
                      onCounterChanged: (counter) {
                        if (counter is DateTime) {
                          // final currentCounter = ref
                          //     .read(counterProvider(motivatonalEndDateParams));
                          // currentCounter.state = counter;
                          ref
                              .read(notificationSettingsProvider.notifier)
                              .updateMotivationalQuoteStartTime(counter);
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
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

class ReminderFrequencyRow extends ConsumerWidget {
  final UniqueKey key;
  final CounterProviderParams params;
  final String labelText;
  final Function(dynamic) onCounterChanged;

  ReminderFrequencyRow({
    required this.key,
    required this.params,
    required this.labelText,
    required this.onCounterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: theme.colorScheme.onTertiary,
          ),
        ),
        CustomCounterWidget(
          params: params,
          key: key,
          onCounterChanged: onCounterChanged,
        ),
      ],
    );
  }
}

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
 // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Chip(
          //       label: Text("S"),
          //     ),
          //     Chip(
          //       label: Text("M"),
          //     ),
          //     Chip(
          //       label: Text("T"),
          //     ),
          //     Chip(
          //       label: Text("W"),
          //     ),
          //     Chip(
          //       label: Text("T"),
          //     ),
          //     Chip(
          //       label: Text("F"),
          //     ),
          //     Chip(
          //       label: Text("S"),
          //     )
          //   ],
          // ),

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

// Text(
          //   'Repeat',
          //   style: GoogleFonts.poppins(
          //     fontSize: 14,
          //     color: theme.colorScheme.onTertiary,
          //   ),
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Chip(
          //       surfaceTintColor: theme.colorScheme.primary,
          //       label: Text("Daily"),
          //     ),
          //     Chip(
          //       label: Text("Weekly"),
          //     ),
          //     Chip(
          //       label: Text("None"),
          //     )
          //   ],
          // ),

           // ExpandableSwitchTile(
                    //   leading: Text(
                    //     'Generate Motivational Quotes ',
                    //     style: GoogleFonts.poppins(
                    //       fontSize: 16,
                    //       color: theme.colorScheme.onTertiary,
                    //     ),
                    //   ),
                    //   contentBuilder: () => motivationalQuotesSettings(theme),
                    // ),



                      // Padding motivationalQuotesSettings(ThemeData theme) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Row(
  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //   children: [
  //         //     Text(
  //         //       'How Many',
  //         //       style: GoogleFonts.poppins(
  //         //         fontSize: 14,
  //         //         color: theme.colorScheme.onTertiary,
  //         //       ),
  //         //     ),
  //         //     CustomCounterWidget(
  //         //         params: CounterProviderParams(type: CounterType.upToSeven),
  //         //         key: motivationalFrequencyKey)
  //         //   ],
  //         // ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Start At',
  //               style: GoogleFonts.poppins(
  //                 fontSize: 14,
  //                 color: theme.colorScheme.onTertiary,
  //               ),
  //             ),
  //             CustomCounterWidget(
  //               params: CounterProviderParams(
  //                   type: CounterType.dateTime,
  //                   startHour: 6,
  //                   startMinute: 0,
  //                   endHour: 24,
  //                   endMinute: 00),
  //               key: motivationalStartKey,
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'End At',
  //               style: GoogleFonts.poppins(
  //                 fontSize: 14,
  //                 color: theme.colorScheme.onTertiary,
  //               ),
  //             ),
  //             CustomCounterWidget(
  //                 params: CounterProviderParams(
  //                     type: CounterType.dateTime,
  //                     startHour: 11,
  //                     startMinute: 30,
  //                     endHour: 23,
  //                     endMinute: 30),
  //                 key: motivationalEndKey),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }