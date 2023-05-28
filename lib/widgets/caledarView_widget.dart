import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

  Widget buildDefaultDay(
      BuildContext context, DateTime day, CalendarData calendarData) {
    return Container(
      width: 40, // Making it square
      height: 40, // Making it square
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${DateFormat.E().format(day)}',
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${day.day}',
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedDay(
      BuildContext context, DateTime day, CalendarData calendarData) {
    return Container(
      width: 50, // Making it square and slightly bigger
      height: 50, // Making it square and slightly bigger
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${DateFormat.E().format(day)}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${day.day}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildToday(BuildContext context, DateTime day, DateTime focusedDay) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        color:
            Colors.blue.shade400, // You can change this to your desired color
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData themeData = Theme.of(context);
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
            return buildDefaultDay(context, day, calendarData);
          },
          selectedBuilder: (context, day, _) {
            return buildSelectedDay(context, day, calendarData);
          },
          todayBuilder: (context, day, focusedDay) =>
              buildToday(context, day, focusedDay)),
    );
  }
}
