import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingCircle(
      color: Colors.blue,
      size: 40,
    );

    return Container(
      child: spinkit,
    );
  }
}
