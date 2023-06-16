import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/goal_task_screen.dart';
import 'package:motiv8_ai/widgets/CustomRadioButtons.dart';
import 'package:motiv8_ai/widgets/add_goals_text_field.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_date_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uuid/uuid.dart';

final goalNameProvider = Provider<String>((ref) => throw UnimplementedError());
final funFactProvider = Provider<String>((ref) => throw UnimplementedError());

class GoalCreationScreen extends ConsumerStatefulWidget {
  final bool isDirectNavigation;

  GoalCreationScreen({this.isDirectNavigation = false, super.key});

  static Route route() {
    return MaterialPageRoute(builder: (context) => GoalCreationScreen());
  }

  @override
  _GoalCreationScreenState createState() => _GoalCreationScreenState();
}

class _GoalCreationScreenState extends ConsumerState<GoalCreationScreen> {
  final PageController controller = PageController(initialPage: 0);
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final TextEditingController taskBreakdownPreferenceController =
      TextEditingController();
  final TextEditingController definitionOfSuccessController =
      TextEditingController();
  final TextEditingController timelineFlexibilityController =
      TextEditingController();
  final TextEditingController timeCommitmentController =
      TextEditingController();
  final TextEditingController milestonesController = TextEditingController();

  final FocusNode taskNameFocusNode = FocusNode();
  final FocusNode taskDescriptionFocusNode = FocusNode();
  final FocusNode timeFocusNode = FocusNode();
  final FocusNode startDataFocusNode = FocusNode();
  final FocusNode endEndFocusNode = FocusNode();

  AsyncValue<List<GoalTask>>? taskListAsyncValue;

  DateTime? startDate;
  DateTime? endDate;
  Goal? currentGoal;
  User? currentUser;
  int currentPage = 0;
  int totalPages = 6;
  bool isCloseVisible = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(taskNameFocusNode);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    taskNameController.dispose();
    taskDescriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    timelineFlexibilityController.dispose();
    taskBreakdownPreferenceController.dispose();
    definitionOfSuccessController.dispose();
    timeCommitmentController.dispose();
    milestonesController.dispose();
    taskNameFocusNode.dispose();
    taskDescriptionFocusNode.dispose();
    timeFocusNode.dispose();
    startDataFocusNode.dispose();
    endEndFocusNode.dispose();
    super.dispose();
  }

  void setAllValues() {
    String goalName = taskNameController.text;
    String goalDescriptionText = taskDescriptionController.text;
    String time = timeController.text;
    String timeCommitment = timeCommitmentController.text;
    String timelineFlexibility = timelineFlexibilityController.text;
    String taskBreakdownPreference = taskBreakdownPreferenceController.text;
    String milestones = milestonesController.text;
    String definitionOfSuccess = definitionOfSuccessController.text;

    endDate = parseDate(endDateController.text);
    startDate = parseDate(startDateController.text);

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
    );
  }

  bool _isAnyFieldFocused() {
    return taskNameController.text.isNotEmpty ||
        taskDescriptionController.text.isNotEmpty ||
        startDateController.text.isNotEmpty ||
        endDateController.text.isNotEmpty ||
        timeController.text.isNotEmpty;
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      if (currentPage == 0) {
        FocusScope.of(context).requestFocus(taskNameFocusNode);
      } else if (currentPage == 1) {
        FocusScope.of(context).requestFocus(taskDescriptionFocusNode);
      } else if (currentPage == 2) {
        FocusScope.of(context).requestFocus(timeFocusNode);
      } else if (currentPage == 3) {
        FocusScope.of(context).requestFocus(startDataFocusNode);
      } else if (currentPage == 4) {
        FocusScope.of(context).requestFocus(endEndFocusNode);
      }
      setState(() {
        currentPage++;
      });
      controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // Handle form submission
      Goal sampleGoal = Goal(
        id: '1',
        name: 'Fitness Journey',
        userID: '123',
        description: 'Achieve a healthy and fit lifestyle',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 12, 31),
        reminderFrequency: 'Daily',
        tasks: [],
        milestones: 'Lose 10 pounds',
        taskBreakdownPreference: 'Weekly',
        definitionOfSuccess: 'Improved stamina and strength',
        strategiesApproaches: 'Work with a personal trainer',
        timelineFlexibility: 'Moderate',
        timeCommitment: '1 hour per day',
      );
      // Do something with the collected data
      // if (_checkFieldsFilled()) {
      //   ref.read(goalControllerProvider.notifier).createGoal(
      //         name: taskName,
      //         reminderFrequency: '',
      //         description: taskDescriptionText,
      //         startDate: startDate,
      //         endDate: endDate,
      //         tasks: [],
      //         context: context,
      //         userID: currentUser!.uid,
      //       );
      //   Navigator.of(context).pushReplacement(HomeViewScreen.route());
      // }
      //HEEEERREEEE
      // ref.read(goalControllerProvider.notifier).createGoal(
      //       name: taskName,
      //       reminderFrequency: '',
      //       description: taskDescriptionText,
      //       startDate: startDate,
      //       endDate: endDate,
      //       tasks: [],
      //       context: context,
      //       userID: currentUser!.uid,
      //     );
      // Navigator.of(context).pushReplacement(HomeViewScreen.route());
      // Navigate to the next screen
      setAllValues();
      Navigator.of(context).push(GoalTasksScreen.route(sampleGoal));
    }
  }

  bool _checkFieldsFilled() {
    bool isFilled = true;

    if (taskNameController.text.isEmpty && currentPage == 0) {
      isFilled = false;
      // titleController.clear();
      // titleController.text = 'Please enter Goal name';
    }

    if (taskDescriptionController.text.isEmpty && currentPage == 1) {
      isFilled = false;
      // descriptionController.clear();
      // descriptionController.text = 'Please enter Description';
    }

    if (timeController.text.isEmpty && currentPage == 2) {
      isFilled = false;
      // timeController.clear();
      // timeController.text = 'Please select Time';
    }
    if (startDateController.text.isEmpty && currentPage == 3) {
      isFilled = false;
    } else {
      startDate = parseDate(startDateController.text);
    }
    if (endDateController.text.isEmpty && currentPage == 4) {
      isFilled = false;
    } else {
      endDate = parseDate(endDateController.text);
    }

    return isFilled;
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: 'Add your Goal',
        isClosePresent: isCloseVisible,
        isBackPresent: widget.isDirectNavigation,
        isCenterTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              // physics: _checkFieldsFilled()
              //     ? const AlwaysScrollableScrollPhysics()
              //     : const NeverScrollableScrollPhysics(),
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  isCloseVisible = index == 0;
                });
              },
              children: [
                // Screen 1: Welcome
                buildPage(
                  height: MediaQuery.of(context).size.height * 0.07,
                  color: Colors.white,
                  title: 'Enter your Goal Description 📝',
                  descriptionOfTitle:
                      'Please provide more detail about your goal. What specific outcomes are you seeking to achieve?',
                  exampleOfTitle:
                      '"I want to start running regularly to improve my overall physical health and stamina. I would like to be able to run 5 kilometers without stopping.',
                  children: [
                    SectionWidget(
                      isHeightGrow: true,
                      focusNode: taskDescriptionFocusNode,
                      controller: taskDescriptionController,
                      hintText: 'Describe your goal',
                    )
                  ],
                ),
                // Screen 2: Personal Introduction

                buildPage(
                  height: MediaQuery.of(context).size.height * 0.07,
                  title: 'Set Your Timeline 📅',
                  exampleOfTitle:
                      'Start Date: June 15, 2023, End Date: September 15, 2023.',
                  descriptionOfTitle:
                      'Please enter the start date and end date for your goal.',
                  color: Colors.white,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        SectionWidget(
                          focusNode: startDataFocusNode,
                          isDate: false,
                          isDatePicker: true,
                          controller: startDateController,
                          hintText: 'Reminder',
                          hasSuffixIcon: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Icon(
                          Icons.arrow_downward_sharp,
                          color: Colors.grey,
                          size: 35,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SectionWidget(
                          focusNode: endEndFocusNode,
                          isDate: true,
                          isDatePicker: true,
                          controller: endDateController,
                          hintText: 'Reminder',
                          hasSuffixIcon: true,
                        )
                      ],
                    ),
                  ],
                ),
                buildPage(
                  height: MediaQuery.of(context).size.height * 0.07,
                  title: 'Identify Milestones 🎖️🏅',
                  descriptionOfTitle:
                      'Are there any milestones or key events related to your goal that occur between your start and end dates?',
                  exampleOfTitle:
                      'I would like to be able to run 1 mile without stopping by July 1, 2 miles by July 15, 3 miles by August 1, 4 miles by August 15, and 5 miles by September 1',
                  color: Colors.white,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        SectionWidget(
                          isHeightGrow: true,
                          focusNode: taskNameFocusNode,
                          controller: milestonesController,
                          hintText: 'Milestones',
                        ),
                      ],
                    ),
                  ],
                ),
                buildPage(
                  height: MediaQuery.of(context).size.height * 0.07,
                  title: 'Task Breakdown Preference ⚙️',
                  exampleOfTitle: 'I prefer daily tasks.',
                  descriptionOfTitle:
                      'How would you like to break down the tasks?',
                  color: Colors.white,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        SectionWidget(
                          controller: taskBreakdownPreferenceController,
                          isRadioButton: true,
                          hintText: '',
                        ),
                      ],
                    ),
                  ],
                ),
                buildPage(
                  height: MediaQuery.of(context).size.height * 0.07,
                  title: 'Define Success ✅',
                  exampleOfTitle:
                      'Success for me is being able to run 5 miles without stopping. I will know I have achieved it when I can do this consistently.',
                  descriptionOfTitle:
                      'What does success look like for your goal? How will you know when you\'ve achieved it?',
                  color: Colors.white,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        SectionWidget(
                          isHeightGrow: true,
                          controller: definitionOfSuccessController,
                          isRadioButton: false,
                          hintText: 'Define Success',
                        ),
                      ],
                    ),
                  ],
                ),
                buildPage(
                  height: MediaQuery.of(context).size.height * 0.07,
                  title: 'Generating your Task...✨',
                  exampleOfTitle: '',
                  descriptionOfTitle:
                      'Congratulations! Your goal information has been captured. We are now using AI to generate personalized tasks specifically designed to help you achieve your goal. In the next screen, you will see the tasks generated for you.',
                  color: Colors.white,
                  children: [],
                ),

                // ...
              ],
            ),
            // Add other screens here...
            Align(
              alignment: Alignment.topCenter,
              child: SmoothPageIndicator(
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.orange,
                  dotWidth: 15,
                  dotHeight: 7,
                  dotColor: Colors.blue,
                ),
                controller: controller,
                count: totalPages,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: _isAnyFieldFocused(),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    nextPage();
                  },
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          currentPage == totalPages - 1
                              ? "Generate Tasks"
                              : "Continue",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        currentPage == totalPages - 1
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )

                        // Icon(
                        //   currentPage == totalPages - 1
                        //       ? Icons.check
                        //       : Icons.arrow_forward,
                        //   color: Colors.white,
                        //   size: 35,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    Color? color,
    List<Widget>? children,
    String? title,
    String? exampleOfTitle,
    String? descriptionOfTitle,
    double? height,
    Widget? otherWidget,
  }) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: color,
        child: SingleChildScrollView(
          child: otherWidget ??
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      title ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      descriptionOfTitle ?? '',
                      style:
                          GoogleFonts.poppins(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'For example: $exampleOfTitle',
                      style:
                          GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: children ?? [],
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  final bool isHeightGrow;
  final bool hasSuffixIcon;
  final bool isDatePicker;
  final bool isDate;
  final bool isRadioButton;
  final FocusNode? focusNode;

  const SectionWidget({
    required this.controller,
    required this.hintText,
    this.isHeightGrow = false,
    this.hasSuffixIcon = false,
    this.isDatePicker = false,
    this.isRadioButton = false,
    this.isDate = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (isDatePicker)
          SizedBox(
            child: CustomDatePicker(
              title: hintText,
              controller: controller,
            ),
          )
        else if (isHeightGrow)
          SizedBox(
            child: GoalsTextField(
              focusNode: focusNode,
              controller: controller,
              hasSuffixIcon: hasSuffixIcon,
              hintText: hintText,
              isHeightGrow: true,
            ),
          )
        else if (isRadioButton)
          SizedBox(
            child: TaskBreakdownWidget(
              controller: controller,
            ),
          )
        else
          SizedBox(
            child: GoalsTextField(
              focusNode: focusNode,
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

class OnboardingPageColors {
  static final Map<String, Color> page1 = {
    'lightPurple': Color(0xFFDAD9E5),
    'vividPurple': Color(0xFF804DF4),
    'skyBlue': Color(0xFF1A89FB),
    'darkBlueGray': Color(0xFF28363E),
    'burntOrange': Color(0xFFE18A28),
  };

  static final Map<String, Color> page2 = {
    'darkBlue': Color(0xFF1D4873),
    'steelBlue': Color(0xFF7F8A9F),
    'roseTaupe': Color(0xFF675F6B),
    'lightGray': Color(0xFFDDDEDE),
    'saffron': Color(0xFFE6B549),
  };

  static final Map<String, Color> page3 = {
    'periwinkle': Color(0xFFBDBCF2),
    'oxfordBlue': Color(0xFF244893),
    'airForceBlue': Color(0xFF6D8FCA),
    'iris': Color(0xFF6563A9),
    'gray': Color(0xFF7C7C95),
  };
}