import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
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

final goalcalendarStateProvider =
    StateNotifierProvider<CalendarState, CalendarData>(
        (ref) => CalendarState());

class CalendarView extends ConsumerWidget {
  const CalendarView({Key? key}) : super(key: key);

  Widget buildDefaultDay(BuildContext context, DateTime day,
      CalendarData calendarData, ThemeData themeData) {
    return Container(
      width: 35, // Making it square
      height: 35, // Making it square
      decoration: BoxDecoration(
        color: themeData.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: themeData.colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildSelectedDay(BuildContext context, DateTime day,
      CalendarData calendarData, ThemeData themeData) {
    return Container(
      width: 35, // Making it square and slightly bigger
      height: 35, // Making it square and slightly bigger
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: themeData.colorScheme.surface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildToday(BuildContext context, DateTime day, DateTime focusedDay,
      ThemeData themeData) {
    return Container(
      width: 35, // Making it square
      height: 35, // Making it square
      decoration: BoxDecoration(
        color: themeData.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: themeData.colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData themeData = ref.watch(themeProvider);
    final calendarData = ref.watch(calendarStateProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select Date',
        isCenterTitle: true,
        // isClosePresent: true,
        isBackPresent: false,
        isCloseOnTheRight: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: TableCalendar(
          firstDay: today,
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: calendarData.focusedDay,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          headerVisible: true,
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextStyle: GoogleFonts.poppins(fontSize: 16),
          ),
          daysOfWeekVisible: true,
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: (selectedDay, focusedDay) {
            ref.watch(calendarStateProvider.notifier).selectDay(selectedDay);
            ref.watch(calendarStateProvider.notifier).changeFocus(focusedDay);
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
          },
          onPageChanged: (focusedDay) {
            ref.watch(calendarStateProvider.notifier).changeFocus(focusedDay);
          },
          selectedDayPredicate: (day) {
            return isSameDay(calendarData.selectedDay, day);
          },
          onFormatChanged: (format) {
            ref.watch(calendarStateProvider.notifier).changeFormat(format);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, _) {
              return buildDefaultDay(context, day, calendarData, themeData);
            },
            selectedBuilder: (context, day, _) {
              return buildSelectedDay(context, day, calendarData, themeData);
            },
            todayBuilder: (context, day, focusedDay) =>
                buildToday(context, day, focusedDay, themeData),
          ),
        ),
      ),
    );
  }
}

class GoalCalendarView extends ConsumerWidget {
  const GoalCalendarView({Key? key}) : super(key: key);

  Widget buildDefaultDay(BuildContext context, DateTime day,
      CalendarData calendarData, ThemeData themeData) {
    return Container(
      width: 35, // Making it square
      height: 35, // Making it square
      decoration: BoxDecoration(
        color: themeData.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: themeData.colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildSelectedDay(BuildContext context, DateTime day,
      CalendarData calendarData, ThemeData themeData) {
    return Container(
      width: 35, // Making it square and slightly bigger
      height: 35, // Making it square and slightly bigger
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: themeData.colorScheme.surface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildToday(BuildContext context, DateTime day, DateTime focusedDay,
      ThemeData themeData) {
    return Container(
      width: 35, // Making it square
      height: 35, // Making it square
      decoration: BoxDecoration(
        color: themeData.colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: themeData.colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData themeData = ref.watch(themeProvider);
    final calendarData = ref.watch(goalcalendarStateProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TableCalendar(
        firstDay: today,
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: calendarData.focusedDay,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        headerVisible: true,
        headerStyle: HeaderStyle(
          rightChevronVisible: false,
          titleCentered: false,
          titleTextStyle: GoogleFonts.poppins(fontSize: 16),
        ),
        daysOfWeekVisible: true,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (selectedDay, focusedDay) {
          ref.watch(goalcalendarStateProvider.notifier).selectDay(selectedDay);
          ref.watch(goalcalendarStateProvider.notifier).changeFocus(focusedDay);
          HapticFeedback.selectionClick();
        },
        onPageChanged: (focusedDay) {
          ref.watch(goalcalendarStateProvider.notifier).changeFocus(focusedDay);
        },
        selectedDayPredicate: (day) {
          return isSameDay(calendarData.selectedDay, day);
        },
        onFormatChanged: (format) {
          ref.watch(calendarStateProvider.notifier).changeFormat(format);
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            return buildDefaultDay(context, day, calendarData, themeData);
          },
          selectedBuilder: (context, day, _) {
            return buildSelectedDay(context, day, calendarData, themeData);
          },
          todayBuilder: (context, day, focusedDay) =>
              buildToday(context, day, focusedDay, themeData),
        ),
      ),
    );
  }
}
