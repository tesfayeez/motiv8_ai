import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/api/quotes_api.dart';
import 'package:motiv8_ai/models/quotes_model.dart';

final quotesControllerProvider =
    StateNotifierProvider<QuotesController, List<QuotesModel>>((ref) {
  return QuotesController(
    quotesAPI: ref.watch(quotesAPIProvider),
  );
});

class QuotesController extends StateNotifier<List<QuotesModel>> {
  final QuotesAPI _quotesAPI;

  QuotesController({
    required QuotesAPI quotesAPI,
  })  : _quotesAPI = quotesAPI,
        super([]);

  Future<List<QuotesModel>> getQuotes() async {
    try {
      state = []; // Clear the previous quotes
      final quotes = await _quotesAPI.fetchRandomQuotes(10);
      state = quotes; // Update the state with the fetched quotes
      return quotes;
    } catch (error) {
      throw error;
    }
  }
}
