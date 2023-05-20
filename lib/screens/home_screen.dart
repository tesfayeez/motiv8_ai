import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/commons/loader.dart';
import 'package:motiv8_ai/controllers/auth_controllers.dart';
import 'package:motiv8_ai/controllers/chat_controllers.dart';
import 'package:motiv8_ai/controllers/goal_controllers.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/add_goals_screen.dart';
import 'package:motiv8_ai/widgets/caledarView_widget.dart';
import 'package:motiv8_ai/widgets/goal_card_widget.dart';

final notificationButtonProvider = Provider<Function>((ref) {
  final notificationService = ref.read(notificationServiceProvider);

  void showNotificationOnClick() {
    notificationService.showNotification(
      id: 1,
      title: 'Motiv8-AI',
      body: 'This is a motivational notification',
      payload: 'notification_payload',
    );
  }

  return showNotificationOnClick;
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  User? currentUser;
  @override
  Widget build(BuildContext context) {
    final showNotificationOnClick = ref.read(notificationButtonProvider);
    if (ref.watch(currentUserProvider) != null) {
      currentUser = ref.watch(currentUserProvider);
    }
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50.0, // Specify the height of the button
        width: 50.0, // Specify the width of the button
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(AddGoalScreen.route()),
            // Set the shape of the button to be square
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CalendarView(key: widget.key),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  print('get movie');
                  NotificationServices().showNotification(
                      title: 'Motiv8-AI',
                      body:
                          'Embrace the challenge, ignite your dedication. Every step and choice counts. Stay focused, shed 5lbs.');
                },
                child: const Text('Get Motivational Quotes'),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     final quotesAsyncValue =
              //         ref.watch(getMotivationalQuotesProvider('Lose 5lbs'));

              //     quotesAsyncValue.when(
              //       data: (quotes) {
              //         // Quotes are retrieved successfully
              //         // Use the retrieved quotes as needed
              //         // Example: print the quotes to the console
              //         print(quotes);
              //       },
              //       loading: () {
              //         // Loading state
              //         // You can show a loading indicator if desired
              //       },
              //       error: (error, stackTrace) {
              //         // Error occurred while fetching quotes
              //         // Handle the error or display an appropriate error message
              //         print('Error fetching motivational quotes: $error');
              //       },
              //     );
              //   },
              //   child: const Text('Get Motivational Quotes'),
              // ),

              const SizedBox(height: 16.0),
              Card(
                elevation: 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tasks for the day',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // List your goals for the day here
                      ref.watch(getGoalsStreamProvider(currentUser!.uid)).when(
                            data: (goals) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: goals.length,
                                itemBuilder: (context, index) {
                                  final goal = goals[index];

                                  return GoalCard(goal: goal);
                                },
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, _) => Text('Error: $error'),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
