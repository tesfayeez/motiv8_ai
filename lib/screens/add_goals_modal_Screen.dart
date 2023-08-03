import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/screens/goal_task_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/CustomRadioButtons.dart';
import 'package:motiv8_ai/widgets/add_goals_text_field.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/goal_header_widget.dart';
import 'package:uuid/uuid.dart';

class AddGoalsModalScreen extends ConsumerStatefulWidget {
  const AddGoalsModalScreen({Key? key}) : super(key: key);

  @override
  _AddGoalsModalScreenState createState() => _AddGoalsModalScreenState();
}

class _AddGoalsModalScreenState extends ConsumerState<AddGoalsModalScreen> {
  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController goalDescriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reminderController = TextEditingController();

  final TextEditingController taskBreakdownPreferenceController =
      TextEditingController();
  final TextEditingController definitionOfSuccessController =
      TextEditingController();
  final TextEditingController timelineFlexibilityController =
      TextEditingController();
  final TextEditingController timeCommitmentController =
      TextEditingController();
  final TextEditingController milestonesController = TextEditingController();
  final PageController controller = PageController(initialPage: 0);
  DateTime? startDate;
  DateTime? endDate;

  User? currentUser;
  bool _userWantAITasks = false;
  bool _isSwitched = false;
  int currentPage = 0;
  Goal? currentGoal;

  Goal? setAllValues() {
    String goalName = goalNameController.text;
    String goalDescriptionText = goalDescriptionController.text;

    String timeCommitment = timeCommitmentController.text;
    String timelineFlexibility = timelineFlexibilityController.text;
    String taskBreakdownPreference = taskBreakdownPreferenceController.text;
    String milestones = milestonesController.text;
    String definitionOfSuccess = definitionOfSuccessController.text;

    DateTime endDate = parseDate(endDateController.text, regularDate: true);
    DateTime startDate = parseDate(startDateController.text, regularDate: true);
    print(reminderController.text);
    TimeOfDay reminderTime = convertTo24HourFormat(reminderController.text);
    print("the dates");
    print(startDateController.text);
    print(endDateController.text);
    print(endDate);
    print(startDate);

    currentGoal = Goal(
      id: const Uuid().v4(),
      name: goalName,
      userID: currentUser!.uid,
      description: goalDescriptionText,
      startDate: startDate,
      endDate: endDate,
      milestones: milestones,
      definitionOfSuccess: definitionOfSuccess,
      taskBreakdownPreference: taskBreakdownPreference,
      timeCommitment: timeCommitment,
      timelineFlexibility: timelineFlexibility,
      reminderTime: reminderTime,
    );
    return currentGoal;
  }

  void nextPage() {
    setAllValues();
    setState(() {
      currentPage++;
    });
    controller.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  bool _isValid() {
    return true;
    // return goalDescriptionController.text.isNotEmpty ||
    //     startDateController.text.isNotEmpty ||
    //     endDateController.text.isNotEmpty ||
    //     taskBreakdownPreferenceController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }

    final theme = ref.watch(themeProvider);
    final textColor = theme.colorScheme.onTertiary;

    return Scaffold(
      appBar: CustomAppBar(
        title: currentPage == 0 ? 'Add Your goal' : 'Goal Builder 🧠',
        isCenterTitle: true,
        isClosePresent: false,
        isBackPresent: false,
        isCloseOnTheRight: true,
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What do you want to call your goal 🎯',
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GoalsTextField(
                        controller: goalNameController,
                        hasSuffixIcon: false,
                        hintText: 'Name...',
                        isHeightGrow: true,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Enter your Goal Description 📝',
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GoalsTextField(
                        controller: goalDescriptionController,
                        hasSuffixIcon: false,
                        hintText: 'Description...',
                        isHeightGrow: true,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Set Your Timeline 📅',
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DateCard(
                            isDatePicker: true,
                            hintText: 'Start Date',
                            controller: startDateController,
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.grey,
                            size: 40,
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          DateCard(
                            isDatePicker: true,
                            hintText: 'End Date',
                            controller: endDateController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Time Your Task Reminders ⏰',
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: Row(
                        children: [
                          TimeCard(
                            controller: reminderController,
                            hintText: 'Reminder',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Task Breakdown Preference ⚙️',
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: TaskBreakdownWidget(
                        color: theme.colorScheme.primary,
                        controller: taskBreakdownPreferenceController,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Define Success ✅',
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: textColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GoalsTextField(
                        controller: definitionOfSuccessController,
                        hasSuffixIcon: false,
                        hintText: 'Success...',
                        isHeightGrow: true,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SwitchListTile.adaptive(
                      activeColor: theme.colorScheme.primary,
                      title: Text(
                        'Generate AI Tasks for goal? 🤖',
                        style:
                            GoogleFonts.poppins(fontSize: 16, color: textColor),
                      ),
                      value:
                          _isSwitched, // boolean variable to manage the switch's state
                      onChanged: (bool value) {
                        setState(() {
                          _userWantAITasks = value;
                          _isSwitched = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      onPressed: () {
                        setAllValues();
                        if (_userWantAITasks) {
                          nextPage();
                        } else {
                          ref
                              .watch(goalControllerProvider.notifier)
                              .createGoal(context: context, goal: currentGoal!);
                          Navigator.of(context).pop();
                        }
                      },
                      text: _userWantAITasks ? 'Generate Tasks' : 'Create Goal',
                    )
                  ],
                ),
              ),
            ),
            if (currentGoal != null) GoalTasksScreen(goal: currentGoal!)
          ],
        ),
      ),
    );
  }
}
