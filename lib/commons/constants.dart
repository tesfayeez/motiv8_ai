import 'package:flutter/material.dart';
import 'package:motiv8_ai/screens/generate_ai_goals.dart';
import 'package:motiv8_ai/screens/goals_screen.dart';
import 'package:motiv8_ai/screens/home_screen.dart';
import 'package:motiv8_ai/screens/settings_screen.dart';

class UIConstants {
  static List<Widget> bottomTabBarPages = [
    const HomeScreen(),
    const GoalsScreen(),
    GenerateAI(),
    const SettingsScreen()
  ];
}
