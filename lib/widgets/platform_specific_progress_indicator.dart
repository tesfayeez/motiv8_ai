import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final progressIndicator = Platform.isIOS
        ? const CupertinoActivityIndicator(
            radius: 15,
            color: Colors.blue,
          )
        : const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          );

    return Container(
      child: progressIndicator,
    );
  }
}
