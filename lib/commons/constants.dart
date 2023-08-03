import 'package:flutter/material.dart';
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
    MotivationalQuotesScreen(),
    const SettingsScreen(
      isDirectNavigation: true,
    ),

    // const AccountScreen(
    //   isDirectNavigation: true,
    // ),
  ];
}
