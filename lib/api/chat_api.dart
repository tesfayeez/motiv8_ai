import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/typedef.dart';
import 'package:motiv8_ai/models/goals_model.dart';
import 'package:motiv8_ai/models/goaltask_models.dart';
import 'package:uuid/uuid.dart';

final chatApiProvider = Provider((ref) {
  return ChatAPI();
});

abstract class IChatAPI {
  FutureEither<String> sendMessage(List<Map<String, dynamic>> messages);
  FutureEither<List<GoalTask>> generateGoalTasks(Goal goal);
  Future<Either<Failure, List<String>>> getMotivationalQuotes(
      String goalName, int quoteCount);
  FutureEither<List<String>> getGoalTaskSubtasks(GoalTask task);
  FutureEither<String> summarizeGoalToGetGoalName(String goalDescriptionText);
}

class ChatAPI implements IChatAPI {
  static const String _apiKey =
      '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';
  static const String _baseUrl = 'https://api.openai.com';
  static const int _maxTokens = 400;
  static const double _temperature = 0.7;
  static const String model = 'gpt-3.5-turbo';

  @override
  Future<Either<Failure, String>> sendMessage(
    List<Map<String, dynamic>> messages,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': model,
          'messages': messages,
          'max_tokens': _maxTokens,
          'temperature': _temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final messages = List<Map<String, dynamic>>.from(data['choices']);
        final lastMessage = messages.last;
        if (lastMessage['message']['role'] == 'assistant') {
          return right(lastMessage['message']['content']);
        } else {
          return left(Failure(
            'Failed to parse message: Assistant message not found',
            StackTrace.current,
          ));
        }
      } else {
        return left(Failure(
          'Failed to send message: ${response.reasonPhrase}',
          StackTrace.current,
        ));
      }
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<GoalTask>> generateGoalTasks(Goal goal) async {
    final List<GoalTask> generatedTasks = [];
    String format = '''
        Task Format:
        Date: [Date in YYYY-MM-DD format]
        Task Name: [Task Name]
        Description: [Description]

        Please provide the tasks in the format shown above. Each task should contribute to the final goal and fit within the given timeline. Here's an example task:

        Date: 2023-06-13
        Task Name: Set Goal and Plan
        Description: Determine a realistic plan to reach the goal of losing 5lbs by the end of the month. This plan should include a specific diet and exercise routine.
    ''';

    try {
      final message = [
        {"role": "user", "content": "Please generate tasks based on my goal."},
        {"role": "user", "content": "Description: ${goal.description}"},
        {
          "role": "user",
          "content":
              "Timeline: Start Date: ${goal.startDate?.toIso8601String()}, End Date: ${goal.endDate?.toIso8601String()}"
        },
        {"role": "user", "content": "Milestones: ${goal.milestones}"},
        // {"role": "user", "content": "Challenges: ${goal.challenges}"},
        // {"role": "user", "content": "Resources: ${goal.resources}"},
        {
          "role": "user",
          "content":
              "Task Breakdown Preference: ${goal.taskBreakdownPreference}"
        },
        {
          "role": "user",
          "content": "Definition of Success: ${goal.definitionOfSuccess}"
        },
        {
          "role": "user",
          "content": "Strategies and Approaches: ${goal.strategiesApproaches}"
        },
        {
          "role": "user",
          "content": "Timeline Flexibility: ${goal.timelineFlexibility}"
        },
        {"role": "user", "content": "Time Commitment: ${goal.timeCommitment}"},

        {"role": "user", "content": format},
        {
          "role": "user",
          "content":
              "Please dont respond in any other format or dont give any thing besides the format"
        }
      ];

      final response = await sendMessage(message);

      response.fold(
        (l) => <GoalTask>[],
        (r) {
          final lines = r.split('\n');
          // final generatedTasks = <GoalTask>[];

          DateTime? date;
          String? taskName;
          String? description;

          for (final line in lines) {
            final taskLine = line.trim();
            print("Processing line: $taskLine");
            final dateMatch = RegExp(r'Date:\s*(.*)', caseSensitive: false)
                .firstMatch(taskLine);
            if (dateMatch != null) {
              DateTime parsedDate =
                  DateFormat('yyyy-MM-dd').parse(dateMatch.group(1)!.trim());

              date =
                  DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
              print("Parsed date: $date");
            }

            final taskNameMatch =
                RegExp(r'Task Name:\s*(.*)', caseSensitive: false)
                    .firstMatch(taskLine);
            if (taskNameMatch != null) {
              taskName = taskNameMatch.group(1)!.trim();
              print("Parsed task name: $taskName");
            }

            final descriptionMatch =
                RegExp(r'Description:\s*(.*)', caseSensitive: false)
                    .firstMatch(taskLine);
            if (descriptionMatch != null) {
              description = descriptionMatch.group(1)!.trim();
              print("Parsed description: $description");
            }

            if (date != null && taskName != null && description != null) {
              final task = GoalTask(
                id: const Uuid().v4(),
                name: taskName,
                description: description,
                date: date,
              );
              generatedTasks.add(task);
              print("Created task: $taskName, $description, $date");
              // Reset fields for next task
              date = null;
              taskName = null;
              description = null;
            }
          }

          return generatedTasks;
        },
      );
    } catch (e, st) {
      print("Error in generateGoalTasks: $e");
      print("Stacktrace: $st");
      return left(Failure(e.toString(), st));
    }

    return right(generatedTasks);
  }

  @override
  Future<Either<Failure, List<String>>> getMotivationalQuotes(
      String goalName, int quoteCount) async {
    print(goalName);
    try {
      List<String> quotes = [];
      for (var i = 0; i < quoteCount; i++) {
        final response = await sendMessage([
          {
            'role': 'user',
            'content':
                'Generate a motivational quote for me to achieve my goal of $goalName.'
          },
        ]);

        // Extract the motivational quote from the response
        quotes.add(response.fold(
            (l) => '', // Return an empty string on failure
            (r) => r));
      }

      return right(quotes);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<Either<Failure, String>> getMotivationalQuote(String goalName) async {
    print(goalName);
    // 'Generate a motivational quote for me to achieve my goal of $goalName.'
    try {
      final response = await sendMessage([
        {
          'role': 'user',
          'content': 'Generate a motivational quote for me to achieve my goal.'
        },
      ]);
      String quote = response.fold(
        (l) => '', // Return an empty string on failure
        (r) => r,
      );
      return right(quote); // Return only one quote
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<String>> getGoalTaskSubtasks(GoalTask task) async {
    try {
      final response = await sendMessage([
        {
          'role': 'user',
          'content':
              'Generate a subtasks to achieve my task of named ${task.name}  with a discription ${task.description} make it user freindly and dont number it just respond with text'
        },
      ]);

      // Split the response string into subtasks
      List<String> subtasks = response.fold(
        (l) => <String>[], // Return an empty list on failure
        (r) =>
            r.split('\n'), // Split the response into multiple lines on success
      );

      return right(subtasks);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<String> summarizeGoalToGetGoalName(
      String goalDescriptionText) async {
    try {
      final response = await sendMessage([
        {
          'role': 'user',
          'content':
              'Summarize this goal description $goalDescriptionText to get goal name and make it short as possible'
        },
      ]);

      // Split the response string into subtasks
      String goalName = response.fold(
        (l) => '', // Return an empty list on failure
        (r) => r, // Split the response into multiple lines on success
      );

      return right(goalName);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
