import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/custom_appbar.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  static route() =>
      MaterialPageRoute(builder: (context) => const NotificationsScreen());

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final isDark = theme.colorScheme.brightness == Brightness.dark;
    bool generateTasks = false;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        isBackPresent: true,
        isCenterTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Motivational Quotes',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: goalCardDarkThemeDecoration(
                    theme.colorScheme.onSecondaryContainer, isDark),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      activeColor: theme.colorScheme.primary,
                      title: Text(
                        'Generate Motivational Quotes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      value: generateTasks,
                      onChanged: (value) {
                        setState(() {
                          generateTasks = value;
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      activeColor: theme.colorScheme.primary,
                      title: Text(
                        'Review Task check-up',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      value: generateTasks,
                      onChanged: (value) {
                        setState(() {
                          generateTasks = value;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Goal Alert time',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      trailing: Text("8:00 am",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: theme.colorScheme.primary,
                          )),
                    ),
                    ListTile(
                      title: Text(
                        'Goal Alert time',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      trailing: Text("8:00 am",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: theme.colorScheme.primary,
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Goal Settings',
                style: GoogleFonts.poppins(
                  color: theme.colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: goalCardDarkThemeDecoration(
                    theme.colorScheme.onSecondaryContainer, isDark),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      activeColor: theme.colorScheme.primary,
                      title: Text(
                        'Motivational Quotes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      value: generateTasks,
                      onChanged: (value) {
                        setState(() {
                          generateTasks = value;
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      activeColor: theme.colorScheme.primary,
                      title: Text(
                        'Review Task check-up',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      value: generateTasks,
                      onChanged: (value) {
                        setState(() {
                          generateTasks = value;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Goal Alert time',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      trailing: Text("8:00 am",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: theme.colorScheme.primary,
                          )),
                    ),
                    ListTile(
                      title: Text(
                        'Goal Alert time',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      trailing: GestureDetector(
                        child: Text(
                          "8:00 am",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        onTap: () {},
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
