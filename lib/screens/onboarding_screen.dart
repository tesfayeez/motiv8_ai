import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:motiv8_ai/commons/utils.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/general_login_screen.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/screens/signup_screen.dart';
import 'package:motiv8_ai/screens/themes_screen.dart';
import 'package:motiv8_ai/widgets/presenting_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'homeview_screen.dart';

final onboardingScreenpageProvider = StateProvider<int>((ref) => 0);

class OnBoardingScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => OnBoardingScreen());
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final controller = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(_pageChangeListen);
  }

  @override
  void dispose() {
    controller.removeListener(_pageChangeListen);
    controller.dispose();
    super.dispose();
  }

  void _pageChangeListen() {
    setState(() {
      _currentPage = controller.page!.round();
    });
    ref.read(onboardingScreenpageProvider.notifier).state = _currentPage;
  }

  Widget buildPage({
    required Color color,
    required String svg,
    required List<Widget> children, // Update the parameter type to List<Widget>
  }) {
    return Container(
      color: color,
      child: Column(
        children: [
          const SizedBox(height: 15),
          SvgPicture.asset(
            svg,
            width: MediaQuery.of(context).size.width * 0.43,
            height: MediaQuery.of(context).size.height * 0.45,
          ),
          const SizedBox(height: 15),
          ...children, // Spread the children widgets
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SmoothPageIndicator(
                effect: ExpandingDotsEffect(
                  activeDotColor: theme.colorScheme.primary,
                  dotWidth: 10,
                  dotHeight: 10,
                  dotColor: theme.colorScheme.tertiary,
                ),
                controller: controller,
                count: 3,
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) => ref
                    .read(onboardingScreenpageProvider.notifier)
                    .state = index,
                children: [
                  // Screen 1: Welcome
                  buildPage(
                    color: Colors.white,
                    svg: "assets/onboarding1.svg",
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Welcome to Motive8!",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                            "Discover AI's magic touch in task management. With tailored task suggestions based on your preferences and goals, staying focused has never been easier.",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: theme.colorScheme.onTertiary,
                            )),
                      ),
                    ],
                  ),
                  // Screen 2: Personal Introduction
                  buildPage(
                    color: Colors.white,
                    svg: "assets/onboarding2.svg",
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Your To-Do Lists, Personalized",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 26,
                                color: theme.colorScheme.primary),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Text(
                          "Say goodbye to one-size-fits-all task lists. With our AI's adaptability, you can easily create to-do lists tailored to your goals and style.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  buildPage(
                    color: Colors.white,
                    svg: "assets/onboarding3.svg",
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text("Smart Task Suggestions",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: theme.colorScheme.primary,
                            )),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Get customized task suggestions from our AI! It learns your habits and suggests tasks that fit your goals, making your daily planning easier and more efficient.",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add other screens here...

            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (_currentPage == 2) {
                    HapticFeedback.heavyImpact();
                    // Update this value to match the number of pages - 1
                    Navigator.of(context)
                        .pushReplacement(GeneralLoginScreen.route());
                  } else {
                    // Navigate to the next screen
                    HapticFeedback.heavyImpact();
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutSine,
                    );
                  }
                },
                child: Container(
                  width: 200, // Set the width of the container here
                  padding: const EdgeInsets.all(15),
                  decoration: customButtonDecoration(theme.colorScheme.primary)
                      .copyWith(borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == 2 ? "Get Started" : "Next",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
