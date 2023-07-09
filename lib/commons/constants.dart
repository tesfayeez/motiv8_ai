import 'package:flutter/material.dart';
import 'package:motiv8_ai/screens/account_screen.dart';
import 'package:motiv8_ai/screens/home_screen.dart';
import 'package:motiv8_ai/screens/motivaitional_quotes_screen.dart';
import 'package:motiv8_ai/screens/mygoals_screen.dart';
import 'package:motiv8_ai/screens/settings_screen.dart';

class UIConstants {
  static List<Widget> bottomTabBarPages = [
    const HomeScreen(),
    const MyGoalsScreen(
      isDirectNavigation: true,
    ),
    const SettingsScreen(
      isDirectNavigation: true,
    ),
    MotivationalQuotesScreen(),
    const AccountScreen(
      isDirectNavigation: true,
    ),
  ];
}
