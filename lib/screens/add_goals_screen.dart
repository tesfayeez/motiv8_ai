import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:uuid/uuid.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

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

  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  Goal? currentGoal;
  User? currentUser;
  bool isTitleFilled = false;
  bool isDescriptionFilled = false;
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;
  AsyncValue<List<String>>? taskListAsyncValue;

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime initialDate) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      DateTime? pickedDate;
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate,
            minimumDate: initialDate,
            onDateTimeChanged: (DateTime newDate) {
              pickedDate = newDate;
            },
          ),
        ),
      );
      return pickedDate;
    } else {
      return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: initialDate,
        lastDate: DateTime(2101),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }
    if (currentGoal != null) {
      taskListAsyncValue =
          ref.watch(generateGoalTasksControllerProvider(currentGoal!));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Goals!', style: themeData.textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0.0, // to remove the shadow under the AppBar
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: themeData.primaryIconTheme.color),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          children: <Widget>[
            // Your widgets go here...
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => isTitleFilled = value.isNotEmpty,
                controller: titleController,
                decoration: InputDecoration(
                  labelStyle: themeData.textTheme.bodyLarge,
                  labelText: 'Goal Title',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => isDescriptionFilled = value.isNotEmpty,
                controller: descriptionController,
                decoration: InputDecoration(
                  labelStyle: themeData.textTheme.bodyLarge,
                  labelText: 'Description',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            //  date pickers

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate =
                          await _selectDate(context, DateTime.now());
                      if (pickedDate != null) {
                        setState(() {
                          isStartDateSelected = true;
                          startDate = pickedDate;
                        });
                      }
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text(startDate == null
                        ? 'Select Start Date'
                        : '${startDate!.toLocal()}'.split(' ')[0]),
                  ),
                  const Icon(Icons.arrow_forward),
                  Theme(
                    data: themeData,
                    child: InkWell(
                      onTap: () async {
                        DateTime? pickedDate =
                            await _selectDate(context, DateTime.now());
                        if (pickedDate != null) {
                          setState(() {
                            isEndDateSelected = true;
                            endDate = pickedDate;
                          });
                        }
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(
                        endDate == null
                            ? 'Select End Date'
                            : '${endDate!.toLocal()}'.split(' ')[0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(45.0),
              child: TextButton(
                onPressed: isTitleFilled &&
                        isDescriptionFilled &&
                        isStartDateSelected &&
                        isEndDateSelected
                    ? () async {
                        currentGoal = Goal(
                          id: const Uuid().v4(),
                          userID: currentUser!.uid,
                          name: titleController.text,
                          description: descriptionController.text,
                          startDate: startDate,
                          endDate: endDate,
                        );
                        taskListAsyncValue = ref.watch(
                            generateGoalTasksControllerProvider(currentGoal!));
                      }
                    : null,
                child: const Text('Generate AI TASK'),
              ),
            ),
            if (taskListAsyncValue != null)
              taskListAsyncValue!.when(
                data: (tasks) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: tasks
                          .map((task) => Card(
                                color: Colors.white70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    task,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                },
                loading: () => const CupertinoActivityIndicator(
                  radius: 14,
                  color: Colors.amber,
                ),
                error: (_, __) => const Text('An error occurred'),
              ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(45.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return themeData.primaryColorLight;
                      }
                      return themeData.colorScheme
                          .background; // Use the component's default.
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all<Color?>(
                      themeData.buttonTheme.colorScheme?.onPrimary),
                ),
                onPressed: isTitleFilled &&
                        isDescriptionFilled &&
                        isStartDateSelected &&
                        isEndDateSelected
                    // (taskListAsyncValue?.when(
                    //       data: (tasks) => tasks.isNotEmpty,
                    //       loading: () => false,
                    //       error: (_, __) => false,
                    //     ) ??
                    //     false)
                    ? () {
                        taskListAsyncValue?.when(
                          data: (tasks) {
                            ref
                                .read(goalControllerProvider.notifier)
                                .createGoal(
                                  name: titleController.text,
                                  reminderFrequency: '',
                                  description: descriptionController.text,
                                  startDate: startDate,
                                  endDate: endDate,
                                  tasks: tasks,
                                  context: context,
                                  userID: currentUser!.uid,
                                );
                            Navigator.of(context).pop();
                          },
                          loading: () => const Loader(),
                          error: (error, stackTrace) {
                            // handle the error state if necessary
                          },
                        );
                      }
                    : null,
                child: const Text('Submit Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
