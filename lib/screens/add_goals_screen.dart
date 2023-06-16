import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/widgets/add_goals_text_field.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/custom_date_picker.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AddGoalScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  const AddGoalScreen({Key? key}) : super(key: key);

  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController targetDateController = TextEditingController();
  final TextEditingController startingDateController = TextEditingController();
  AsyncValue<List<String>>? taskListAsyncValue;
  late ConfettiController _confettiController;
  DateTime? startDate;
  DateTime? endDate;
  Goal? currentGoal;
  User? currentUser;

  final TextStyle textStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  bool _checkFieldsFilled() {
    bool isFilled = true;

    if (titleController.text.isEmpty) {
      isFilled = false;
      // titleController.clear();
      // titleController.text = 'Please enter Goal name';
    }

    if (descriptionController.text.isEmpty) {
      isFilled = false;
      // descriptionController.clear();
      // descriptionController.text = 'Please enter Description';
    }

    if (timeController.text.isEmpty) {
      isFilled = false;
      // timeController.clear();
      // timeController.text = 'Please select Time';
    }

    if (targetDateController.text.isEmpty) {
      isFilled = false;
    } else {
      endDate = parseDate(targetDateController.text);
    }

    if (startingDateController.text.isEmpty) {
      isFilled = false;
    } else {
      startDate = parseDate(startingDateController.text);
    }
    return isFilled;
  }

  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }
    // if (currentGoal != null) {
    //   taskListAsyncValue =
    //       ref.watch(generateGoalTasksControllerProvider(currentGoal!));
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isClosePresent: true,
        isBackPresent: false,
        title: 'Add Goal',
        isCenterTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            SectionWidget(
              title: 'Name',
              controller: titleController,
              hintText: 'Enter Goal name',
            ),
            SectionWidget(
              title: 'Description',
              controller: descriptionController,
              hintText: 'Enter Description',
              isHeightGrow: true,
            ),
            SectionWidget(
              title: 'Time',
              controller: timeController,
              hintText: 'Time',
              hasSuffixIcon: true,
              isDate: false,
              isDatePicker: true,
            ),
            SectionWidget(
              title: 'Target Date',
              controller: targetDateController,
              hintText: 'No due date',
              hasSuffixIcon: true,
              isDatePicker: true,
            ),
            SectionWidget(
              title: 'Starting Date',
              controller: startingDateController,
              hintText: 'No due date',
              hasSuffixIcon: true,
              isDatePicker: true,
            ),
            CustomButton(
              text: 'Update Goal',
              onPressed: () {
                if (_checkFieldsFilled()) {
                  ref.read(goalControllerProvider.notifier).createGoal(
                        name: titleController.text,
                        reminderFrequency: '',
                        description: descriptionController.text,
                        startDate: startDate,
                        endDate: endDate,
                        tasks: [],
                        context: context,
                        userID: currentUser!.uid,
                      );
                  ref.watch(navigatorKeyProvider).currentState!.pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('Incomplete Fields'),
                        content: const Text(
                            'Please fill in all the required fields.'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String hintText;
  final bool isHeightGrow;
  final bool hasSuffixIcon;
  final bool isDatePicker;
  final bool isDate;

  const SectionWidget({
    required this.title,
    required this.controller,
    required this.hintText,
    this.isHeightGrow = false,
    this.hasSuffixIcon = false,
    this.isDatePicker = false,
    this.isDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        if (isDatePicker)
          SizedBox(
            child: CustomDatePicker(
              controller: controller,
              showDate: isDate,
              title: title,
            ),
          )
        else if (isHeightGrow)
          SizedBox(
            child: GoalsTextField(
              controller: controller,
              hasSuffixIcon: hasSuffixIcon,
              hintText: hintText,
              isHeightGrow: true,
            ),
          )
        else
          SizedBox(
            child: GoalsTextField(
              controller: controller,
              hasSuffixIcon: hasSuffixIcon,
              hintText: hintText,
            ),
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}
