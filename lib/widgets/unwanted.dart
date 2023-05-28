 // CheckboxListTile(
                          //   checkColor: Colors.white,
                          //   controlAffinity: ListTileControlAffinity
                          //       .leading, // this ensures that the checkbox is on the left
                          //   title: Text.rich(
                          //     TextSpan(
                          //       children: <TextSpan>[
                          //         const TextSpan(
                          //             text: 'I agree to the company ',
                          //             style: TextStyle(
                          //               color: Colors.grey,
                          //               fontSize: 14,
                          //             )),
                          //         TextSpan(
                          //           text: 'Terms of Service',
                          //           style: const TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w600,
                          //             fontSize: 14,
                          //           ),
                          //           recognizer: TapGestureRecognizer()
                          //             ..onTap = () {
                          //               _launchURL(
                          //                   'https://ezex55.wixsite.com/my-site-1');
                          //             },
                          //         ),
                          //         const TextSpan(
                          //             text: ' and ',
                          //             style: TextStyle(
                          //               color: Colors.grey,
                          //               fontSize: 14,
                          //             )),
                          //         TextSpan(
                          //           text: 'Privacy Policy',
                          //           style: const TextStyle(
                          //             fontWeight: FontWeight.w600,
                          //             color: Colors.black,
                          //             fontSize: 14,
                          //           ),
                          //           recognizer: TapGestureRecognizer()
                          //             ..onTap = () {
                          //               _launchURL(
                          //                   'https://www.example.com/privacy-policy');
                          //             },
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          //   value: _isTermsAndPolicyAccepted,
                          //   onChanged: (bool? value) {
                          //     setState(() {
                          //       _isTermsAndPolicyAccepted = value!;
                          //     });
                          //   },
                          // ),




//add goals app bar 

// AppBar(
//         title: Text('Add Your Goals!', style: themeData.textTheme.titleLarge),
//         backgroundColor: Colors.transparent,
//         elevation: 0.0, // to remove the shadow under the AppBar
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.close, color: themeData.primaryIconTheme.color),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       )





//add goal card 



// SafeArea(
//         child: ListView(
//           padding:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           children: <Widget>[
//             // Your widgets go here...
//             const SizedBox(
//               height: 20,
//             ),

//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 onChanged: (value) => isTitleFilled = value.isNotEmpty,
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelStyle: themeData.textTheme.bodyLarge,
//                   labelText: 'Goal Title',
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 onChanged: (value) => isDescriptionFilled = value.isNotEmpty,
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                   labelStyle: themeData.textTheme.bodyLarge,
//                   labelText: 'Description',
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             //  date pickers

//             Padding(
//               padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       DateTime? pickedDate =
//                           await _selectDate(context, DateTime.now());
//                       if (pickedDate != null) {
//                         setState(() {
//                           isStartDateSelected = true;
//                           startDate = pickedDate;
//                         });
//                       }
//                     },
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     child: Text(startDate == null
//                         ? 'Select Start Date'
//                         : '${startDate!.toLocal()}'.split(' ')[0]),
//                   ),
//                   const Icon(Icons.arrow_forward),
//                   Theme(
//                     data: themeData,
//                     child: InkWell(
//                       onTap: () async {
//                         DateTime? pickedDate =
//                             await _selectDate(context, DateTime.now());
//                         if (pickedDate != null) {
//                           setState(() {
//                             isEndDateSelected = true;
//                             endDate = pickedDate;
//                           });
//                         }
//                       },
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       child: Text(
//                         endDate == null
//                             ? 'Select End Date'
//                             : '${endDate!.toLocal()}'.split(' ')[0],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(45.0),
//               child: TextButton(
//                 onPressed: isTitleFilled &&
//                         isDescriptionFilled &&
//                         isStartDateSelected &&
//                         isEndDateSelected
//                     ? () async {
//                         currentGoal = Goal(
//                           id: const Uuid().v4(),
//                           userID: currentUser!.uid,
//                           name: titleController.text,
//                           description: descriptionController.text,
//                           startDate: startDate,
//                           endDate: endDate,
//                         );
//                         taskListAsyncValue = ref.watch(
//                             generateGoalTasksControllerProvider(currentGoal!));
//                       }
//                     : null,
//                 child: const Text('Generate AI TASK'),
//               ),
//             ),
//             CustomDatePicker(),
//             if (taskListAsyncValue != null)
//               taskListAsyncValue!.when(
//                 data: (tasks) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: tasks
//                           .map((task) => Card(
//                                 color: Colors.white70,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     task,
//                                     style: const TextStyle(color: Colors.black),
//                                   ),
//                                 ),
//                               ))
//                           .toList(),
//                     ),
//                   );
//                 },
//                 loading: () => const CupertinoActivityIndicator(
//                   radius: 14,
//                   color: Colors.amber,
//                 ),
//                 error: (_, __) => const Text('An error occurred'),
//               ),
//             const SizedBox(
//               height: 5,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(45.0),
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.resolveWith<Color?>(
//                     (Set<MaterialState> states) {
//                       if (states.contains(MaterialState.pressed)) {
//                         return themeData.primaryColorLight;
//                       }
//                       return themeData.colorScheme
//                           .background; // Use the component's default.
//                     },
//                   ),
//                   foregroundColor: MaterialStateProperty.all<Color?>(
//                       themeData.buttonTheme.colorScheme?.onPrimary),
//                 ),
//                 onPressed: isTitleFilled &&
//                         isDescriptionFilled &&
//                         isStartDateSelected &&
//                         isEndDateSelected
//                     // (taskListAsyncValue?.when(
//                     //       data: (tasks) => tasks.isNotEmpty,
//                     //       loading: () => false,
//                     //       error: (_, __) => false,
//                     //     ) ??
//                     //     false)
//                     ? () {
//                         taskListAsyncValue?.when(
//                           data: (tasks) {
//                             ref
//                                 .read(goalControllerProvider.notifier)
//                                 .createGoal(
//                                   name: titleController.text,
//                                   reminderFrequency: '',
//                                   description: descriptionController.text,
//                                   startDate: startDate,
//                                   endDate: endDate,
//                                   tasks: tasks,
//                                   context: context,
//                                   userID: currentUser!.uid,
//                                 );
//                             Navigator.of(context).pop();
//                           },
//                           loading: () => const Loader(),
//                           error: (error, stackTrace) {
//                             // handle the error state if necessary
//                           },
//                         );
//                       }
//                     : null,
//                 child: const Text('Submit Goal'),
//               ),
//             ),
//           ],
//         ),
//       ),



//add goal screen route

//  static Route route() {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) =>
//           const AddGoalScreen(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var begin = const Offset(0.0, 1.0);
//         var end = Offset.zero;
//         var curve = Curves.ease;

//         var tween =
//             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     );
//   }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:motiv8_ai/models/goals_model.dart';
// import 'package:motiv8_ai/widgets/add_goals_text_field.dart';
// import 'package:motiv8_ai/widgets/custom_appbar.dart';
// import 'package:motiv8_ai/widgets/custom_button.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class AddGoalScreen extends ConsumerStatefulWidget {
//   const AddGoalScreen({super.key});

//   @override
//   _AddGoalScreenState createState() => _AddGoalScreenState();
// }

// class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   DateTime? startDate;
//   DateTime? endDate;
//   Goal? currentGoal;
//   User? currentUser;
//   bool isTitleFilled = false;
//   bool isDescriptionFilled = false;
//   bool isStartDateSelected = false;
//   bool isEndDateSelected = false;
//   AsyncValue<List<String>>? taskListAsyncValue;

//   Future<DateTime?> _selectDate(
//       BuildContext context, DateTime initialDate) async {
//     // ...
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData themeData = Theme.of(context);

//     // Accessing screen width and height
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     // Create a Text style to be reused
//     final TextStyle textStyle = GoogleFonts.poppins(
//       fontSize: 18,
//       fontWeight: FontWeight.w500,
//     );

//     return Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: CustomAppBar(
//           backgroundColor: Colors.grey.shade100,
//           title: 'Add Goal',
//           isCenterTitle: true,
//           isBottomLinePresent: true,
//         ),
//         body: SafeArea(
//           child: ListView(
//             padding: EdgeInsets.only(
//                 left: screenWidth * 0.05, // 5% of screen width
//                 right: screenWidth * 0.05, // 5% of screen width
//                 bottom: MediaQuery.of(context).viewInsets.bottom),
//             children: [
//               SizedBox(
//                 height: screenHeight * 0.02, // 2% of screen height
//               ),
//               Text(
//                 'Name',
//                 style: textStyle,
//               ),
//               SizedBox(
//                 height: screenHeight * 0.01,
//               ),
//               GoalsTextField(
//                 controller: titleController,
//                 hasSuffixIcon: false,
//                 hintText: 'Enter Goal name',
//               ),
//               SizedBox(
//                 height: screenHeight * 0.015,
//               ),
//               Text(
//                 'Description',
//                 style: textStyle,
//               ),
//               SizedBox(
//                 height: screenHeight * 0.01,
//               ),
//               Expanded(
//                 child: GoalsTextField(
//                   isHeightGrow: true,
//                   controller: descriptionController,
//                   hasSuffixIcon: false,
//                   hintText: 'Enter Description',
//                 ),
//               ),
//               SizedBox(
//                 height: screenHeight * 0.015,
//               ),
//               Text(
//                 'Time',
//                 style: textStyle,
//               ),
//               SizedBox(
//                 height: screenHeight * 0.01,
//               ),
//               GoalsTextField(
//                 controller: titleController,
//                 hasSuffixIcon: true,
//                 suffixIcon: Icon(
//                   Icons.add,
//                   color: Colors.blue,
//                   size: 35,
//                 ),
//                 hintText: 'Time',
//               ),
//               SizedBox(
//                 height: screenHeight * 0.015,
//               ),
//               Text(
//                 'Target Date',
//                 style: textStyle,
//               ),
//               SizedBox(
//                 height: screenHeight * 0.01,
//               ),
//               GoalsTextField(
//                 controller: titleController,
//                 hasSuffixIcon: true,
//                 suffixIcon: Icon(
//                   Icons.add,
//                   color: Colors.blue,
//                   size: 35,
//                 ),
//                 hintText: 'No due date',
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 'Starting Date',
//                 style: textStyle,
//               ),
//               SizedBox(
//                 height: screenHeight * 0.01,
//               ),
//               GoalsTextField(
//                   controller: titleController,
//                   hasSuffixIcon: true,
//                   suffixIcon: Icon(
//                     Icons.add,
//                     color: Colors.blue,
//                     size: 35,
//                   ),
//                   hintText: 'No due date'),
//               SizedBox(
//                 height: screenHeight * 0.05, // 5% of screen height
//               ),
//               CustomButton(
//                 text: 'Create',
//                 onPressed: () {},
//               )
//             ],
//           ),
//         ));
//   }
// }

// class OnboardingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IntroductionScreen(
//       pages: [
//         PageViewModel(
//           title: "Daily Goal Achiever",
//           body: "Set and achieve your daily goals with ease.",
//           image: Image.asset('assets/daily_goal.jpg'),
//         ),
//         PageViewModel(
//           title: "AI Task Recommendations",
//           body: "Receive personalized task recommendations powered by AI.",
//           image: Image.asset('assets/daily_goal.jpg'),
//         ),
//         PageViewModel(
//           title: "Motivational Quotes",
//           body: "Get daily motivational quotes tailored to your goals.",
//           image: Image.asset('assets/daily_goal.jpg'),
//         ),
//       ],
//       done: Text("Get Started"),
//       onDone: () {
//         // Perform actions when done button is pressed
//         Navigator.of(context).push(LoginScreen.route());
//       },
//       next: Text("Next"),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class GoalsTextField extends StatelessWidget {
//   final String hintText;
//   final bool hasSuffixIcon;
//   final bool hasMoreLines;
//   final Icon suffixIcon;
//   final TextEditingController controller;

//   GoalsTextField({
//     required this.hintText,
//     this.hasMoreLines = false,
//     this.hasSuffixIcon = false,
//     this.suffixIcon = const Icon(Icons.access_time),
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       expands: true,
//       maxLines: hasMoreLines ? 1 : null,
//       style: GoogleFonts.poppins(fontSize: 12),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4.0),
//           borderSide: BorderSide(color: Colors.white),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4.0),
//           borderSide: BorderSide(color: Colors.white),
//         ),
//         hintText: hintText,
//         hintStyle: GoogleFonts.poppins(
//           color: Colors.grey,
//           fontSize: 12,
//         ),
//         suffixIcon: hasSuffixIcon ? suffixIcon : null,
//       ),
//     );
//   }
// }


//calendar

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
//         firstDay: DateTime.utc(2023, 04, 16),
//         lastDay: DateTime.utc(2030, 3, 14),
//         focusedDay: focusedDay,
//         availableCalendarFormats: const {CalendarFormat.week: 'Week'},
//         calendarFormat: calendarFormat,
//         headerVisible: false,
//         daysOfWeekVisible: false,
//         calendarBuilders: CalendarBuilders(
//           defaultBuilder: (context, day, focusedDay) {
//             return Container(
//               width: 40, // Making it square
//               height: 40, // Making it square
//               decoration: BoxDecoration(
//                 color: Colors.blueGrey.shade50,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${DateFormat.E().format(day)}',
//                       style: GoogleFonts.poppins(
//                         color: Colors.blue,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       '${day.day}',
//                       style: GoogleFonts.poppins(
//                         color: Colors.blue,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//           selectedBuilder: (context, day, focusedDay) {
//             return Container(
//               width: 50, // Making it square and slightly bigger
//               height: 50, // Making it square and slightly bigger
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${DateFormat.E().format(day)}',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       '${day.day}',
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//         onFormatChanged: (format) {
//           setState(() {
//             calendarFormat = format;
//           });
//         },
//         onPageChanged: (focusedDay) {
//           setState(() {
//             focusedDay = focusedDay;
//           });
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