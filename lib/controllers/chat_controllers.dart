import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/chat_api.dart';
import 'package:motiv8_ai/api/local_notifications_api.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';

import 'package:shared_preferences/shared_preferences.dart';

final taskListProvider =
    StateNotifierProvider<TaskList, List<GoalTask>>((ref) => TaskList());

final goalTaskListProvider =
    StateNotifierProvider<GoalTaskList, List<GoalTask>>(
        (ref) => GoalTaskList());

final goalTaskSubtasksListProvider =
    StateNotifierProvider<GoalTaskSubTaskList, List<String>>(
        (ref) => GoalTaskSubTaskList());

class TaskList extends StateNotifier<List<GoalTask>> {
  TaskList() : super([]);

  void addTask(GoalTask task) {
    state = [...state, task];
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void updateTasks(List<GoalTask> tasks) {
    state = tasks;
  }

  void clear() {
    state = [];
  }
}

class GoalTaskList extends StateNotifier<List<GoalTask>> {
  GoalTaskList() : super([]);

  void addTask(GoalTask task) {
    state = [...state, task];
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void updateTasks(List<GoalTask> tasks) {
    state = tasks;
  }

  void clear() {
    state = [];
  }
}

class GoalTaskSubTaskList extends StateNotifier<List<String>> {
  GoalTaskSubTaskList() : super([]);

  void addTask(String task) {
    state = [...state, task];
  }

  void removeTask(String task) {
    state = state.where((taskItem) => taskItem != task).toList();
  }

  void updateTasks(List<String> tasks) {
    state = tasks;
  }

  void clear() {
    state = [];
  }
}

final chatAPIControllerProvider = StateNotifierProvider<ChatAPIController,
    AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return ChatAPIController(ref.watch(chatApiProvider));
});

// final generateGoalTasksControllerProvider =
//     FutureProvider.family<List<GoalTask>, Goal>((ref, goal) async {
//   final chatAPIController = ref.read(chatAPIControllerProvider.notifier);
//   final result = await chatAPIController.generateGoalTasksController(goal);
//   return result.fold(
//     (failure) {
//       // Handle the failure case, e.g., log the error or show an error message
//       print(failure);
//       return []; // Return an empty list on failure
//     },
//     (tasks) => tasks,
//   );
// });
final generateGoalNameControllerProvider =
    FutureProvider.family<String, String>((ref, goalDescriptionText) async {
  final chatAPIController = ref.read(chatAPIControllerProvider.notifier);
  final goalName =
      await chatAPIController.generateGoalName(goalDescriptionText);
  // ref.read(taskListProvider.notifier).updateTasks(goalName);
  return goalName;
});

final generateGoalTasksControllerProvider =
    FutureProvider.family<List<GoalTask>, Goal>((ref, goal) async {
  final chatAPIController = ref.read(chatAPIControllerProvider.notifier);
  final tasks = await chatAPIController.generateGoalTasksController(goal);
  ref.read(taskListProvider.notifier).updateTasks(tasks);
  return tasks;
});

final generateGoalTaskSubtasksControllerProvider =
    FutureProvider.family<List<String>, GoalTask>((ref, task) async {
  final chatAPIController = ref.read(chatAPIControllerProvider.notifier);
  final subtasks =
      await chatAPIController.generateGoalTaskSubtasksController(task);
  ref.read(goalTaskSubtasksListProvider.notifier).updateTasks(subtasks);
  return subtasks;
});

final motivationalQuotesProvider =
    FutureProvider.family<List<String>, String>((ref, goalName) async {
  // final notificationService = ref.read(notificationServiceProvider);
  final quotesAsyncValue = ref.watch(getMotivationalQuotesProvider(goalName));

  final quotes = quotesAsyncValue.maybeWhen(
    data: (quotes) => quotes,
    orElse: () => const <String>[],
  );

  var now = DateTime.now();
  var firstNotificationTime = now.add(Duration(minutes: 1));
  var secondNotificationTime = now.add(Duration(minutes: 2));

  // if (quotes.isNotEmpty) {
  //   notificationService.showNotificationAtTime(
  //     id: 1,
  //     title: 'Motiv8-AI',
  //     body: quotes[0],
  //     scheduledTime: firstNotificationTime,
  //   );
  // }

  // if (quotes.length > 1) {
  //   notificationService.showNotificationAtTime(
  //     id: 2,
  //     title: 'Motiv8-AI',
  //     body: quotes[1],
  //     scheduledTime: secondNotificationTime,
  //   );
  // }

  return quotes; // Return the quotes
});

final getMotivationalQuotesProvider =
    FutureProvider.family<List<String>, String>((ref, goalName) async {
  final chatAPIController = ref.read(chatAPIControllerProvider.notifier);
  return chatAPIController.getMotivationalQuotes(10); // Return the quotes
});

final getMotivationalQuoteProvider =
    FutureProvider.family<String, String>((ref, goalName) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final chatAPIController = ref.read(chatAPIControllerProvider.notifier);
  final lastCalledDate = sharedPreferences.getString('lastCalledDate');
  final currentDate = DateTime.now()
      .toString()
      .substring(0, 10); // Get the current date in the format 'yyyy-MM-dd'
  final result = await chatAPIController.getMotivationalQuote(goalName);
  return result;

  // if (lastCalledDate != currentDate) {
  //   // Call the getMotivationalQuote function
  //   final result = await chatAPIController.getMotivationalQuote(goalName);
  //   print("coming hre $result");
  //   // Update the last called date in shared preferences
  //   await sharedPreferences.setString('lastCalledDate', currentDate);
  //   await sharedPreferences.setString('cachedQuote', result);
  //   return result;
  // } else {
  //   // Return the previously cached quote
  //   String quotew = sharedPreferences.getString('cachedQuote') ?? '';
  //   // print("cached quote $quotew");
  //   return sharedPreferences.getString('cachedQuote') ?? '';
  // }
});

class ChatAPIController
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final ChatAPI _chatAPI;

  ChatAPIController(this._chatAPI) : super(const AsyncValue.loading()) {
    String motiv8Description = """
Your name is 'MOTIV8-AI'. I want you to act as a motivational coach. I will provide you with some information about someone's goals and challenges, and it will be your job to come up with strategies that can help this person achieve their goals. This could involve providing positive affirmations, giving helpful advice or suggesting activities they can do to reach their end goal. if you don't understand the question, don't think too much, tell the user to be more specific with more details
Motiv8-AI is a mobile app that is designed to help users set and achieve goals by providing daily reminders and motivational messages. The app has several features, including the ability to create and manage multiple goals, track progress, connect with others who have similar goals, and receive personalized motivational messages generated by an AI language model called ChatGPT.

Motiv8-AI also has a goal breakdown screen that allows users to break down their goals into smaller, more manageable tasks. The screen uses ChatGPT to generate a list of suggested tasks based on the user's goal and progress, spread out in the timeline for the user-entered start and end dates. This feature provides users with a personalized and realistic plan to achieve their goals.

In terms of what Motiv8-AI cannot do, it is important to note that the app is not a substitute for professional guidance or medical advice. While the app can provide users with motivation and support, it cannot diagnose or treat any medical conditions or mental health issues. Additionally, the app is not capable of physical activity tracking, such as steps or distance traveled.

Overall, Motiv8-AI is a powerful tool for young adults and professionals who are interested in self-improvement and goal-setting. By understanding the capabilities and limitations of the app, users can get the most out of its features and achieve their goals with greater ease and motivation.
""";

    sendMessage([
      {
        "role": "system",
        "content": motiv8Description

        // "content":
        //     "You are a highly efficient assistant. Your purpose is to aid in the creation of clear, achievable goals and assist in breaking these goals down into manageable, actionable tasks."
      },
    ]);
  }

  Future<void> sendMessage(List<Map<String, dynamic>> messages) async {
    state = const AsyncValue.loading();
    final result = await _chatAPI.sendMessage(messages);
    state = result.fold(
      (error) => AsyncValue.error(error.message, error.stackTrace),
      (response) {
        return AsyncValue.data([
          {"role": "assistant", "content": response}
        ]);
      },
    );
  }

  Future<List<GoalTask>> generateGoalTasksController(Goal goal) async {
    final result = await _chatAPI.generateGoalTasks(goal);
    return result.fold(
      (failure) {
        return <GoalTask>[];
      },
      (tasks) {
        return tasks;
      },
    );
  }

  Future<String> generateGoalName(String goalDescriptionText) async {
    final result =
        await _chatAPI.summarizeGoalToGetGoalName(goalDescriptionText);
    return result.fold(
      (failure) {
        return '';
      },
      (goalName) {
        return goalName;
      },
    );
  }

  Future<List<String>> generateGoalTaskSubtasksController(GoalTask task) async {
    final result = await _chatAPI.getGoalTaskSubtasks(task);
    return result.fold(
      (failure) {
        return <String>[];
      },
      (tasks) {
        return tasks;
      },
    );
  }

  Future<List<String>> getMotivationalQuotes(int quoteCount) async {
    state = const AsyncValue.loading();
    final result = await _chatAPI.getMotivationalQuotes(quoteCount);
    return result.fold(
      (error) {
        state = AsyncValue.error(error.message, error.stackTrace);
        throw error; // If you want to propagate the error
      },
      (quotes) {
        state = AsyncValue.data([
          for (var quote in quotes) {'role': 'assistant', 'content': quote}
        ]);
        return quotes; // You should return the quotes here
      },
    );
  }

  Future<String> getMotivationalQuote(String goalName) async {
    state = const AsyncValue.loading();
    final result = await _chatAPI.getMotivationalQuote(goalName);
    return result.fold(
      (error) {
        state = AsyncValue.error(error.message, error.stackTrace);
        throw error; // If you want to propagate the error
      },
      (quotes) {
        return quotes; // You should return the quotes here
      },
    );
  }
}
