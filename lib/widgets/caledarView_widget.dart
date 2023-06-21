import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarData {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;

  CalendarData(
      {required this.selectedDay,
      required this.focusedDay,
      required this.calendarFormat});
}

class CalendarState extends StateNotifier<CalendarData> {
  CalendarState()
      : super(CalendarData(
            selectedDay: DateTime.now(),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.week));

  void selectDay(DateTime day) {
    state = CalendarData(
        selectedDay: day,
        focusedDay: state.focusedDay,
        calendarFormat: state.calendarFormat);
  }

  void changeFocus(DateTime day) {
    state = CalendarData(
        selectedDay: state.selectedDay,
        focusedDay: day,
        calendarFormat: state.calendarFormat);
  }

  void changeFormat(CalendarFormat format) {
    state = CalendarData(
        selectedDay: state.selectedDay,
        focusedDay: state.focusedDay,
        calendarFormat: format);
  }
}

final calendarStateProvider =
    StateNotifierProvider<CalendarState, CalendarData>(
        (ref) => CalendarState());

class CalendarView extends ConsumerWidget {
  const CalendarView({Key? key}) : super(key: key);

  Widget buildDefaultDay(BuildContext context, DateTime day,
      CalendarData calendarData, ThemeData themeData) {
    return Container(
      width: 40, // Making it square
      height: 40, // Making it square
      decoration: BoxDecoration(
        color: themeData.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${DateFormat.E().format(day)}',
              style: GoogleFonts.poppins(
                color: themeData.colorScheme.onPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${day.day}',
              style: GoogleFonts.poppins(
                color: themeData.colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedDay(BuildContext context, DateTime day,
      CalendarData calendarData, ThemeData themeData) {
    return Container(
      width: 55, // Making it square and slightly bigger
      height: 57, // Making it square and slightly bigger
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${DateFormat.E().format(day)}',
              style: GoogleFonts.poppins(
                color: themeData.colorScheme.surface,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${day.day}',
              style: GoogleFonts.poppins(
                color: themeData.colorScheme.surface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildToday(BuildContext context, DateTime day, DateTime focusedDay,
      ThemeData themeData) {
    return Container(
      width: 40, // Making it square
      height: 40, // Making it square
      decoration: BoxDecoration(
        color: themeData.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${DateFormat.E().format(day)}',
              style: GoogleFonts.poppins(
                color: themeData.colorScheme.onPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${day.day}',
              style: GoogleFonts.poppins(
                color: themeData.colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData themeData = ref.watch(themeProvider);
    final calendarData = ref.watch(calendarStateProvider);

    return TableCalendar(
      firstDay: DateTime.utc(2023, 04, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: calendarData.focusedDay,
      availableCalendarFormats: const {CalendarFormat.week: 'Week'},
      calendarFormat: calendarData.calendarFormat,
      headerVisible: false,
      daysOfWeekVisible: false,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (selectedDay, focusedDay) {
        ref.read(calendarStateProvider.notifier).selectDay(selectedDay);
        ref.read(calendarStateProvider.notifier).changeFocus(focusedDay);
      },
      onPageChanged: (focusedDay) {
        ref.read(calendarStateProvider.notifier).changeFocus(focusedDay);
      },
      selectedDayPredicate: (day) {
        return isSameDay(calendarData.selectedDay, day);
      },
      onFormatChanged: (format) {
        ref.read(calendarStateProvider.notifier).changeFormat(format);
      },
      calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            return buildDefaultDay(context, day, calendarData, themeData);
          },
          selectedBuilder: (context, day, _) {
            return buildSelectedDay(context, day, calendarData, themeData);
          },
          todayBuilder: (context, day, focusedDay) =>
              buildToday(context, day, focusedDay, themeData)),
    );
  }
}
