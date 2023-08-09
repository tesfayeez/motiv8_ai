import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class FirebaseCallableFunctions {
  Future<void> sendTestNotification({
    required String message,
  }) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendTestNotification');
      final results = await callable.call(<String, String?>{
        'message': message,
      });
      print('Results: ${results.data.toString()}');
      return results.data;
    } catch (e) {
      log(e.toString());

      return;
    }
  }
}
