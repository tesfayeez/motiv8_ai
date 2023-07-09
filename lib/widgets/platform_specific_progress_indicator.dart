import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingCircle(
      color: const Color(0xFF1988FF),
      size: 35,
    );

    return Container(
      child: spinkit,
    );
  }
}
