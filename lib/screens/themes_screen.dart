import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends ConsumerWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ThemeScreen());
  final bool isDirectNavigation;

  const ThemeScreen({Key? key, this.isDirectNavigation = false})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Theme',
        isBackPresent: isDirectNavigation
            ? false
            : ModalRoute.of(context)?.canPop ?? false,
        isBottomLinePresent: true,
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ThemeButton(
                    color: Color(0xFF1988FF),
                    onPressed: () {
                      ref
                          .read(themeProvider.notifier)
                          .changeTheme(AppTheme.light);
                    },
                    text: 'Light',
                  ),
                  const SizedBox(height: 16),
                  ThemeButton(
                    onPressed: () {
                      ref
                          .read(themeProvider.notifier)
                          .changeTheme(AppTheme.dark);
                    },
                    text: 'Dark',
                    color: const Color(0x00000040),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ThemeButton(
                    color: Colors.deepPurple,
                    onPressed: () {
                      ref
                          .read(themeProvider.notifier)
                          .changeTheme(AppTheme.light);
                    },
                    text: 'Purple',
                  ),
                  const SizedBox(height: 16),
                  ThemeButton(
                    onPressed: () {
                      ref
                          .read(themeProvider.notifier)
                          .changeTheme(AppTheme.dark);
                    },
                    text: 'Tan',
                    color: Color(0xFFE8C5A1),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(themeData1) {
    loadThemeFromPrefs();
  } // Default theme can be any of the defined themes

  void loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString('theme');
    if (themeString != null) {
      AppTheme theme =
          AppTheme.values.firstWhere((e) => e.toString() == themeString);
      changeTheme(theme);
    }
  }

  void saveThemeToPrefs(AppTheme theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme.toString());
  }

  void changeTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        state = themeData1;
        break;
      case AppTheme.dark:
        state = themeData1Dark;
        break;
    }
    saveThemeToPrefs(theme);
  }

  static final ThemeData themeData1 = ThemeData(
    colorScheme: ColorScheme(
      primary: const Color(0xFF1988FF),
      tertiary: const Color(0xFF343A40), //any text color
      onTertiary: const Color(0xFF495057), //for bottom navigation unselected
      secondary:
          const Color(0xFFEBF2FF), //For calendar view back ground unselected
      onSecondaryContainer: Colors.white, //for goal card background
      surface: Colors.white, //any white color
      background: Colors.white,
      error: Colors.red[700]!,
      onPrimary: const Color(0xFF1988FF),
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: const Color(0xFFFCFCFC), //main scaffold background
      onError: Colors.white,
      brightness: Brightness.light,
      tertiaryContainer:
          const Color(0xFFE4EDFF), //taskscreen goal header timeline card
    ),
  ).copyWith(
    cupertinoOverrideTheme:
        CupertinoThemeData().copyWith(brightness: Brightness.light),
    snackBarTheme: const SnackBarThemeData(
      showCloseIcon: true,
      backgroundColor: const Color(0xFF1988FF),
      behavior: SnackBarBehavior.floating,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  );

  static final ThemeData themeData1Dark = ThemeData.from(
    colorScheme: ColorScheme.dark(
        primary: const Color(0xFF1988FF), // Dodger Blue
        tertiary: Colors.white,
        onTertiary: const Color(0xD1D1D1D1),
        primaryContainer: const Color(0x00000040),
        secondary:
            const Color.fromRGBO(170, 170, 170, 0.15), // Tangerine for contrast
        surface: Colors.white,
        background: const Color(0xFF202124),
        error: Colors
            .red[700]!, // We assume this exists in the Material Color Reds
        onPrimary: const Color(0xFF1988FF),
        onSecondary: Colors.black,
        onSurface: const Color(0xFF202124),
        onBackground: const Color(0xFF202124),
        onError: Colors.white,
        brightness: Brightness.dark,
        tertiaryContainer: const Color.fromRGBO(170, 170, 170, 0.15),
        onSecondaryContainer: const Color.fromRGBO(170, 170, 170, 0.15)),
  ).copyWith(
    cupertinoOverrideTheme:
        CupertinoThemeData().copyWith(brightness: Brightness.dark),
    snackBarTheme: SnackBarThemeData(
      showCloseIcon: true,
      contentTextStyle: GoogleFonts.poppins(color: Colors.white),
      backgroundColor: const Color(0xFF1988FF),
      behavior: SnackBarBehavior.floating,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  );
}

enum AppTheme { light, dark }

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    required this.onPressed,
    required this.text,
    required this.color,
  });

  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: [
          Container(
            decoration: cardBoxDecoration(color, true).copyWith(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2.5,
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.grey.shade100,
            elevation: 5.0,
            child: Container(
              decoration:
                  cardBoxDecoration(Colors.grey.shade100, true).copyWith(
                      borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
              height: 80,
              width: MediaQuery.of(context).size.width / 2.5,
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      child: Divider(
                        thickness: 4,
                      ),
                    ),
                    SizedBox(
                      child: Divider(
                        thickness: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

// child: Text,
//         style: Theme.of(context).textTheme.button,
