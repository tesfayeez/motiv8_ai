import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motiv8_ai/widgets/platform_specific_progress_indicator.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomProgressIndicator(),
    );
  }
}
