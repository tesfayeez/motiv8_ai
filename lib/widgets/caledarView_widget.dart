import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// final selectedDayProvider = StateProvider<DateTime?>((ref) => DateTime.now());

// class CalendarView extends ConsumerWidget {
//   const CalendarView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ThemeData themeData = Theme.of(context);
//     final selectedDateController =
//         ref.watch(selectedDayProvider.notifier).state;
//     return StatefulBuilder(builder: (context, setState) {
//       CalendarFormat calendarFormat = CalendarFormat.week;
//       DateTime focusedDay = DateTime.now();
//       DateTime? selectedDay = selectedDateController;
//       return TableCalendar(
//         firstDay: DateTime.utc(2020, 10, 16),
//         lastDay: DateTime.utc(2030, 3, 14),
//         focusedDay: focusedDay,
//         availableCalendarFormats: const {
//           CalendarFormat.week: 'Week',
//         },
//         calendarFormat: calendarFormat,
//         calendarStyle: CalendarStyle(
//           defaultTextStyle: themeData.textTheme.bodyLarge!,
//           isTodayHighlighted: true,
//           todayDecoration: BoxDecoration(
//             color: themeData.primaryColorLight,
//             shape: BoxShape.circle,
//           ),
//           selectedTextStyle:
//               themeData.textTheme.bodyLarge!.copyWith(color: Colors.white),
//           selectedDecoration: BoxDecoration(
//             color: themeData.primaryColor,
//             shape: BoxShape.circle,
//           ),
//         ),
//         onFormatChanged: (format) {
//           setState(() {
//             calendarFormat = format;
//           });
//         },
//         onPageChanged: (focusedDay) {
//           focusedDay = focusedDay;
//         },
//         onDaySelected: (selectedDay, focusedDay) {
//           setState(() {
//             selectedDay = selectedDay;
//             focusedDay = focusedDay;
//           });

//           // Perform your action here
//           print('Selected Day: $selectedDay');

//           // Update the selected day
//           ref.read(selectedDayProvider.notifier).state = selectedDay;
//         },
//         selectedDayPredicate: (day) {
//           return isSameDay(selectedDay, day);
//         },
//       );
//     });
//   }
// }
// final selectedDayProvider = StateProvider<DateTime?>((ref) => DateTime.now());

// class CalendarView extends ConsumerWidget {
//   const CalendarView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ThemeData themeData = Theme.of(context);
//     final selectedDateController =
//         ref.watch(selectedDayProvider.notifier).state;

//     return StatefulBuilder(builder: (context, setState) {
//       CalendarFormat calendarFormat = CalendarFormat.week;
//       DateTime focusedDay = DateTime.now();
//       DateTime? selectedDay = selectedDateController;

//       return TableCalendar(
//         firstDay: DateTime.utc(2020, 10, 16),
//         lastDay: DateTime.utc(2030, 3, 14),
//         focusedDay: focusedDay,
//         availableCalendarFormats: const {CalendarFormat.week: 'Week'},
//         calendarFormat: calendarFormat,
//         headerVisible:
//             false, // to hide the header with the arrows and the month
//         calendarStyle: CalendarStyle(
//           defaultTextStyle: GoogleFonts.poppins(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey,
//             fontStyle: FontStyle.normal,
//           ),
//           isTodayHighlighted: true,
//           todayDecoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.lightBlueAccent.shade100,
//                 Colors.grey.shade300,
//               ],
//             ),
//             shape: BoxShape.rectangle,
//           ),
//           selectedTextStyle: GoogleFonts.poppins(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//           selectedDecoration: BoxDecoration(
//             color: Colors.blue,
//             shape: BoxShape.rectangle,
//           ),
//         ),
//         onFormatChanged: (format) {
//           setState(() {
//             calendarFormat = format;
//           });
//         },
//         onPageChanged: (focusedDay) {
//           focusedDay = focusedDay;
//         },
//         onDaySelected: (selectedDay, focusedDay) {
//           setState(() {
//             selectedDay = selectedDay;
//             focusedDay = focusedDay;
//           });

//           print('Selected Day: $selectedDay');
//           ref.read(selectedDayProvider.notifier).state = selectedDay;
//         },
//         selectedDayPredicate: (day) {
//           return isSameDay(selectedDay, day);
//         },
//       );
//     });
//   }
// }

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
        firstDay: DateTime.utc(2023, 04, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
        availableCalendarFormats: const {CalendarFormat.week: 'Week'},
        calendarFormat: calendarFormat,
        headerVisible: false,
        daysOfWeekVisible: false,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
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
          },
          selectedBuilder: (context, day, focusedDay) {
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
          },
        ),
        onFormatChanged: (format) {
          setState(() {
            calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            focusedDay = focusedDay;
          });
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDay = selectedDay;
            focusedDay = focusedDay;
          });

          print('Selected Day: $selectedDay');

          ref.read(selectedDayProvider.notifier).state = selectedDay;
        },
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
      );
    });
  }
}
