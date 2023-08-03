import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/commons/global_providers.dart';
import 'package:motiv8_ai/models/quotes_model.dart';

final quotesAPIProvider = Provider((ref) {
  final auth = ref.watch(firebaseAuthProvider);

  return QuotesAPI(db: ref.watch(firebaseFirestoreProvider));
});

abstract class IQuotesAPI {
  Future<List<QuotesModel>> fetchRandomQuotes(int count);
}

class QuotesAPI implements IQuotesAPI {
  final FirebaseFirestore _db;
  QuotesAPI({
    required FirebaseFirestore db,
  }) : _db = db;

  @override
  Future<List<QuotesModel>> fetchRandomQuotes(int count) async {
    try {
      // Fetch random quotes from Cloud Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('quotes')
          .orderBy('timestamp',
              descending:
                  true) // Assuming you have a timestamp field for ordering
          .limit(count)
          .get();

      // Transform the query snapshot into Quote objects
      List<QuotesModel> randomQuotes = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return QuotesModel(
          quote: data['text'],
          author: data['author'],
        );
      }).toList();

      return randomQuotes;
    } catch (e) {
      // Handle any errors that occur during the fetching process
      print('An error occurred while fetching quotes: $e');
      return [];
    }
  }
}
