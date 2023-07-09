import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:motiv8_ai/screens/task_view_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/add_goals_text_field.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:motiv8_ai/widgets/custom_button.dart';
import 'package:motiv8_ai/widgets/custom_date_picker.dart';
import 'package:uuid/uuid.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AddGoalScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FractionalTranslation(
          translation: Offset(0, 1 - animation.value),
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
  bool isGoalEmpty = false;
  String goalId = '';
  bool allFieldsAreValid = false;
  final TextStyle textStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    if (ref.watch(currentUserProvider) != null) {
      // currentUser = ref.watch(currentUserProvider);
    }
    // if (currentGoal != null) {
    //   taskListAsyncValue =
    //       ref.watch(generateGoalTasksControllerProvider(currentGoal!));
    // }
    bool checkValuesNotEmpty() {
      if (titleController.text.isEmpty ||
          descriptionController.text.isEmpty ||
          targetDateController.text.isEmpty ||
          goalId.isEmpty) {
        setState(() {
          allFieldsAreValid = false;
        });
        return false;
      } else {
        setState(() {
          allFieldsAreValid = true;
        });
        return true;
      }
    }

    GoalTask setAllValues() {
      final goalTask = GoalTask(
          id: Uuid().v4(),
          name: titleController.text,
          description: descriptionController.text,
          date: parseDate(targetDateController.text),
          goalId: goalId,
          taskReminderTime: DateTime.now());
      return goalTask;
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        isClosePresent: false,
        isCloseOnTheRight: true,
        isBackPresent: false,
        title: 'Add Task',
        isCenterTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            ref
                .watch(getAllGoalsStreamProvider(
                    ref.watch(currentUserProvider)!.uid))
                .when(
              data: (goals) {
                // Data is available, return the GoalsDropdown with the data
                if (goals.isNotEmpty)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Goal",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      GoalsDropdown(
                        items: goals,
                        onGoalChanged: (selectedGoal) {
                          if (selectedGoal != null) {
                            goalId = selectedGoal.id;
                          }
                        },
                      ),
                    ],
                  );
                else {
                  setState(() {
                    isGoalEmpty = true;
                  });

                  return Container();
                }
              },
              loading: () {
                // Data is still loading, return a loading indicator
                return Container();
              },
              error: (error, st) {
                // An error occurred, return an error message
                return Container();
              },
            ),
            const SizedBox(height: 10),
            if (!isGoalEmpty) ...[
              SectionWidget(
                title: 'Name',
                controller: titleController,
                hintText: 'Enter Task name',
              ),
              SectionWidget(
                title: 'Description',
                controller: descriptionController,
                hintText: 'Enter Task Description',
                isHeightGrow: true,
              ),
              SectionWidget(
                hintText: 'Select Date',
                title: 'Task Date',
                controller: targetDateController,
                isDatePicker: true,
              ),
              SizedBox(
                height: 10,
              ),
              // SubtaskGenerator(
              //   goalTask: setAllValues(),
              // ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Add Task',
                onPressed: () {
                  print("object");
                },
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      'Please add goals before adding tasks',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: theme.colorScheme.onTertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomButton(
                        text: 'Add Goal',
                        onPressed: () {
                          Navigator.of(context).pop();
                          showAddGoalModal(context);
                        },
                      ),
                    )
                  ],
                ),
              )
            ]
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
  final bool isDropDown;

  const SectionWidget({
    required this.title,
    required this.controller,
    required this.hintText,
    this.isHeightGrow = false,
    this.hasSuffixIcon = false,
    this.isDatePicker = false,
    this.isDate = true,
    this.isDropDown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        if (isDatePicker)
          SizedBox(
            child: CustomDatePicker(
              hintText: hintText,
              controller: controller,
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

// class GoalsDropdown extends ConsumerStatefulWidget {
//   final List<Goal> items;
//   final ValueChanged<Goal?> onGoalChanged;

//   GoalsDropdown({required this.items, required this.onGoalChanged});

//   @override
//   _GoalsDropdownState createState() => _GoalsDropdownState();
// }

// class _GoalsDropdownState extends ConsumerState<GoalsDropdown> {
//   Goal? dropdownValue;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.items.isNotEmpty) {
//       dropdownValue = widget.items[0];
//     }
//   }

//   static const OutlineInputBorder customBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.all(
//       Radius.circular(10.0),
//     ),
//   );

//   @override
//   Widget build(BuildContext context) {
//     final themeData = ref.watch(themeProvider);
//     if (widget.items.isEmpty) {
//       return Container(); // Return an empty container if there are no items
//     }

//     return DropdownButtonFormField<Goal>(
//       value: dropdownValue,
//       icon: Icon(
//         Icons.arrow_downward,
//         color: themeData.colorScheme.primary,
//       ),
//       iconSize: 24,
//       elevation: 0,
//       decoration: InputDecoration(
//           filled: true,
//           fillColor: themeData.colorScheme.onSecondaryContainer,
//           border: customBorder,
//           enabledBorder: customBorder.copyWith(
//             borderSide: BorderSide(
//               color: themeData.colorScheme.brightness == Brightness.dark
//                   ? themeData.colorScheme.onSecondaryContainer
//                   : themeData.colorScheme.secondary,
//             ),
//           )),
//       onChanged: (Goal? newValue) {
//         setState(() {
//           dropdownValue = newValue;
//         });
//         widget.onGoalChanged(newValue);
//       },
//       items: widget.items.map<DropdownMenuItem<Goal>>((Goal value) {
//         return DropdownMenuItem<Goal>(
//           value: value,
//           child: Text(
//             capitalize(value.name),
//             style: GoogleFonts.poppins(fontSize: 16),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
class GoalsDropdown extends StatelessWidget {
  final List<Goal> items;
  final ValueChanged<Goal?> onGoalChanged;

  GoalsDropdown({required this.items, required this.onGoalChanged});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(); // Return an empty container if there are no items
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPicker(
        itemExtent: 100.0,
        onSelectedItemChanged: (int index) {
          onGoalChanged(items[index]);
        },
        children: items.map((Goal goal) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              capitalize(goal.name),
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          );
        }).toList(),
      );
    } else {
      return DropdownButtonFormField<Goal>(
        value: items.isNotEmpty ? items[0] : null,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: onGoalChanged,
        items: items.map<DropdownMenuItem<Goal>>((Goal value) {
          return DropdownMenuItem<Goal>(
            value: value,
            child: Text(
              capitalize(value.name),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }).toList(),
      );
    }
  }
}
