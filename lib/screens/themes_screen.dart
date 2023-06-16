import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final theme = ref.watch(themeProvider);
                  return Text(
                    'Current theme: ${theme.primaryColor}',
                    style: Theme.of(context).textTheme.headline6,
                  );
                },
              ),
              const SizedBox(height: 16),
              ThemeButton(
                color: Color(0xFF1988FF),
                onPressed: () {
                  ref.read(themeProvider.notifier).changeTheme(AppTheme.theme1);
                },
                text: 'Dodger Blue​',
              ),
              const SizedBox(height: 16),
              ThemeButton(
                onPressed: () {
                  ref.read(themeProvider.notifier).changeTheme(AppTheme.theme2);
                },
                text: 'Tangerine',
                color: Color(0xFFE68000),
              ),
              const SizedBox(height: 16),
              ThemeButton(
                onPressed: () {
                  ref.read(themeProvider.notifier).changeTheme(AppTheme.theme3);
                },
                text: 'Mobster',
                color: Color(0xFF59515E),
              ),
              const SizedBox(height: 16),
              ThemeButton(
                onPressed: () {
                  ref.read(themeProvider.notifier).changeTheme(AppTheme.theme4);
                },
                text: 'KSU Purple',
                color: Color(0xFF512888),
              ),
              const SizedBox(height: 16),
              ThemeButton(
                onPressed: () {
                  ref.read(themeProvider.notifier).changeTheme(AppTheme.theme5);
                },
                text: 'Cornflower Blue',
                color: Color(0xFF6495ED),
              )
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
  ThemeNotifier()
      : super(themeData1); // Default theme can be any of the defined themes

  static final ThemeData themeData1 = ThemeData.from(
    colorScheme: ColorScheme(
        primary: const Color(0xFF1988FF), // Dodger Blue
        primaryContainer: const Color(0xFFEBF2FF)
            .withOpacity(0.4), // A bit darker than Dodger Blue
        secondary: const Color(0xFFE68000), // Tangerine for contrast
        secondaryContainer: const Color(0xFFD66E00), // A bit darker Tangerine
        surface: Colors.white,
        background: Colors.white,
        error: Colors
            .red[700]!, // We assume this exists in the Material Color Reds
        onPrimary: const Color(0xFF1988FF),
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
        onSecondaryContainer: const Color(0xFFEBF2FF)),
  );

  static final ThemeData themeData2 = ThemeData.from(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE68000),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  static final ThemeData themeData3 = ThemeData.from(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF59515E),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  static final ThemeData themeData4 = ThemeData.from(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF512888),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  static final ThemeData themeData5 = ThemeData.from(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6495ED),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  void changeTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.theme1:
        state = themeData1;
        break;
      case AppTheme.theme2:
        state = themeData2;
        break;
      case AppTheme.theme3:
        state = themeData3;
        break;
      case AppTheme.theme4:
        state = themeData4;
        break;
      case AppTheme.theme5:
        state = themeData5;
        break;
    }
  }
}

enum AppTheme {
  theme1,
  theme2,
  theme3,
  theme4,
  theme5,
}

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
          Material(
            color: color,
            elevation: 5.0,
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
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
              height: 80,
              width: double.infinity,
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