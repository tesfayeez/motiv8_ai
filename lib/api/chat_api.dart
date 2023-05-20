import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/auth_api.dart';
import 'package:motiv8_ai/commons/typedef.dart';
import 'package:motiv8_ai/models/goals_model.dart';

final chatApiProvider = Provider((ref) {
  return ChatAPI();
});

abstract class IChatAPI {
  FutureEither<String> sendMessage(List<Map<String, dynamic>> messages);
  FutureEither<List<String>> generateGoalTasks(Goal goal);
  Future<Either<Failure, List<String>>> getMotivationalQuotes(
      String goalName, int quoteCount);
}

class ChatAPI implements IChatAPI {
  static const String _apiKey =
      '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';
  static const String _baseUrl = 'https://api.openai.com';
  static const int _maxTokens = 300;
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
  FutureEither<List<String>> generateGoalTasks(Goal goal) async {
    try {
      // Construct the prompt string using the goal data
      // final prompt =
      //     'Generate tasks for goal ${goal.name} that ${goal.description} starting on ${goal.startDate?.toIso8601String() ?? 'any date'} and ending on ${goal.endDate?.toIso8601String() ?? 'any date'}.';
      final prompt =
          'Please generate a timeline of actionable tasks for achieving the goal "${goal.name}", which involves "${goal.description}". The goal is set to start on ${goal.startDate?.toIso8601String() ?? 'any date'} and expected to be accomplished by ${goal.endDate?.toIso8601String() ?? 'any date'}. Kindly break down the tasks in a sequential manner, ensuring each task contributes toward the final goal and fits within the given timeline.';

      // Send the prompt to the ChatGPT API
      final response = await sendMessage([
        {'role': 'user', 'content': prompt},
      ]);

      // Extract the generated tasks from the response
      final tasks = response.fold((l) => null, (r) {
        return r.split('\n').map((task) => task.trim()).toList();
      });

      return right(tasks!);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
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
}
