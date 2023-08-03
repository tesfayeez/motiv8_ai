import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum CounterType { upToSeven, dateTime }

final counterProvider = StateNotifierProvider.family<CounterController, dynamic,
    CounterProviderParams>((ref, params) {
  return CounterController(params.type, params.startHour, params.startMinute,
      params.endHour, params.endMinute);
});

class CounterProviderParams {
  final CounterType type;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  CounterProviderParams({
    required this.type,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 23,
    this.endMinute = 30,
  });
}

class CounterController extends StateNotifier<dynamic> {
  final CounterType type;
  final DateTime startTime;
  final DateTime endTime;

  CounterController(
      this.type, int startHour, int startMinute, int endHour, int endMinute)
      : startTime = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, startHour, startMinute),
        endTime = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, endHour, endMinute),
        super(type == CounterType.dateTime
            ? DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, startHour, startMinute)
            : 3) {
    if (type == CounterType.dateTime &&
        (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime))) {
      throw ArgumentError('End time must be later than start time');
    }
  }

  void increment() {
    if (type == CounterType.upToSeven && state < 7) {
      state++;
    } else if (type == CounterType.dateTime &&
        state is DateTime &&
        (state as DateTime).isBefore(endTime)) {
      state = (state as DateTime).add(Duration(minutes: 30));
    }
  }

  void decrement() {
    if (type == CounterType.upToSeven && state > 3) {
      state--;
    } else if (type == CounterType.dateTime &&
        state is DateTime &&
        (state as DateTime).isAfter(startTime)) {
      state = (state as DateTime).subtract(Duration(minutes: 30));
    }
  }
}

class CustomCounterWidget extends ConsumerWidget {
  final CounterProviderParams params;
  final UniqueKey key;
  final void Function(dynamic) onCounterChanged; // Add the callback parameter

  CustomCounterWidget({
    required this.params,
    required this.key,
    required this.onCounterChanged, // Initialize the callback
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final counter = ref.watch(counterProvider(params));

    // Call the callback when the counter changes
    // onCounterChanged(counter);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            ref.watch(counterProvider(params).notifier).decrement();

            onCounterChanged(counter);
          },
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "-",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 60, // specify a fixed width
          child: Text(
            params.type == CounterType.dateTime && counter is DateTime
                ? DateFormat.jm().format(counter)
                : '${counter}x',
            style: GoogleFonts.poppins(fontSize: 14),
            textAlign: TextAlign.center, // center the text
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            ref.watch(counterProvider(params).notifier).increment();
            onCounterChanged(counter); // Call the callback after increment
          },
          child: Container(
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "+",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}



// class CustomCounterWidget extends ConsumerWidget {
//   final CounterProviderParams params;
//   final UniqueKey key;

//   CustomCounterWidget({required this.params, required this.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final counter = ref.watch(counterProvider(params));
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () => ref.watch(counterProvider(params).notifier).decrement(),
//           child: Container(
//             alignment: Alignment.center,
//             height: 30,
//             width: 30,
//             decoration: BoxDecoration(
//               border: Border.all(color: theme.colorScheme.primary, width: 2),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Text(
//               "-",
//               style: GoogleFonts.poppins(fontSize: 16),
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         Container(
//           width: 60, // specify a fixed width
//           child: Text(
//             params.type == CounterType.dateTime && counter is DateTime
//                 ? DateFormat.jm().format(counter)
//                 : '${counter}x',
//             style: GoogleFonts.poppins(fontSize: 14),
//             textAlign: TextAlign.center, // center the text
//           ),
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         GestureDetector(
//           onTap: () => ref.watch(counterProvider(params).notifier).increment(),
//           child: Container(
//             alignment: Alignment.center,
//             height: 30,
//             width: 30,
//             decoration: BoxDecoration(
//               border: Border.all(color: theme.colorScheme.primary, width: 2),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Text(
//               "+",
//               style: GoogleFonts.poppins(fontSize: 16),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }