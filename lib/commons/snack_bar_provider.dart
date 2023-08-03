import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SnackbarController extends StateNotifier<bool> {
  SnackbarController() : super(false);

  void show(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

final snackbarProvider = StateNotifierProvider<SnackbarController, bool>(
  (ref) => SnackbarController(),
);
