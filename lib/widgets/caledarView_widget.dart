import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final selectedDayProvider = StateProvider<DateTime?>((ref) => DateTime.now());

class CalendarView extends ConsumerWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData themeData = Theme.of(context);
    final selectedDateController =
        ref.watch(selectedDayProvider.notifier).state;
    return StatefulBuilder(builder: (context, setState) {
      CalendarFormat calendarFormat = CalendarFormat.week;
      DateTime focusedDay = DateTime.now();
      DateTime? selectedDay = selectedDateController;
      return TableCalendar(
        firstDay: DateTime.utc(2020, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
        availableCalendarFormats: const {
          CalendarFormat.week: 'Week',
        },
        calendarFormat: calendarFormat,
        calendarStyle: CalendarStyle(
          defaultTextStyle: themeData.textTheme.bodyLarge!,
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            color: themeData.primaryColorLight,
            shape: BoxShape.circle,
          ),
          selectedTextStyle:
              themeData.textTheme.bodyLarge!.copyWith(color: Colors.white),
          selectedDecoration: BoxDecoration(
            color: themeData.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        onFormatChanged: (format) {
          setState(() {
            calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          focusedDay = focusedDay;
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDay = selectedDay;
            focusedDay = focusedDay;
          });

          // Perform your action here
          print('Selected Day: $selectedDay');

          // Update the selected day
          ref.read(selectedDayProvider.notifier).state = selectedDay;
        },
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
      );
    });
  }
}
