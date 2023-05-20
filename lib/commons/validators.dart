import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailErrorProvider = StateProvider<String>((ref) => '');
final passwordErrorProvider = StateProvider<String>((ref) => '');

class InputValidator {
  static String? validateEmail(String value) {
    final regexEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value.isEmpty) {
      return 'Please enter your email';
    } else if (!regexEmail.hasMatch(value)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    } else {
      return null;
    }
  }
}
