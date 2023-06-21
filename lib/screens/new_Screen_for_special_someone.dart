import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/widgets/account_textfields.dart';
import 'package:motiv8_ai/widgets/presenting_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final pageProvider = StateProvider<int>((ref) => 0);

class SpecialUserWalkthroughScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => SpecialUserWalkthroughScreen());
  @override
  _SpecialUserWalkthroughScreenState createState() =>
      _SpecialUserWalkthroughScreenState();
}

class _SpecialUserWalkthroughScreenState
    extends ConsumerState<SpecialUserWalkthroughScreen> {
  final controller = PageController(initialPage: 0);
  final nameController = TextEditingController();
  final funFactController = TextEditingController();
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
    nameController.dispose();
    funFactController.dispose();
    super.dispose();
  }

  void _pageChangeListen() {
    setState(() {
      _currentPage = controller.page!.round();
    });
    ref.read(pageProvider.notifier).state = _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) =>
                ref.read(pageProvider.notifier).state = index,
            children: [
              // Screen 1: Welcome
              buildPage(
                color: OnboardingPageColors.page2['saffron']!,
                svg: "assets/onboarding1.svg",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        PresentingAnimatedText(
                          text: 'Hop into Goal-Setting Adventure!',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 1),
                          slideOffset: 200.0,
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   "Welcome to Motiv8-AI!",
                  //   style:
                  //       GoogleFonts.poppins(fontSize: 30, color: Colors.white),
                  // ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "Hey there, friend! Ever heard of a wild pact to marry at 30 if still single? Let's kick off your goal-setting journey with that same thrill. Ready to hop in?",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
              // Screen 2: Personal Introduction
              buildPage(
                color: OnboardingPageColors.page1['skyBlue']!,
                svg: "assets/onboarding2.svg",
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Savor Your Goals!",
                        style: GoogleFonts.poppins(
                            fontSize: 25, color: Colors.white),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            "Ever tried a spinach lasagna? Goal-setting might seem complex but it's just as satisfying. Let's bake your goals to perfection. Bon appétit!",
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              // Screen 3: Informational Goal Introduction
              buildPage(
                color: OnboardingPageColors.page1['darkBlueGray']!,
                svg: "assets/onboarding3.svg",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("No More Hookah, More Goals!",
                        style: GoogleFonts.poppins(
                            fontSize: 26, color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "There was a time when a hookah was someone's significant other. But now, let's make your goals the center of attention. Ready to puff out some successful goal clouds?",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  )
                ],
              ),

              //Screen 4: The Power of Motivation
              buildPage(
                color: OnboardingPageColors.page1['burntOrange']!,
                svg: "assets/onboarding1.svg",
                children: [
                  Text("Goal Tracking Fun-ride!",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Keeping up with goals can be as challenging as understanding feminist philosophies. But don't worry, our goal tracker is more fun than a roller-coaster ride!",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Screen 5: SMART Goal Setting
              buildPage(
                color: OnboardingPageColors.page2['darkBlue']!,
                svg: "assets/onboarding3.svg",
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Time for a Goal-Setting Bond!",
                        style: GoogleFonts.poppins(
                            fontSize: 26, color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Ever heard about someone calling a loved one 'mearey', only to be friendzoned with 'haftey mearey'? Well, goal setting is all about getting to know each other. Let's bond, not as 'mearey', not as 'haftey mearey', but as goal buddies!But who should we call you?",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   child: ,
                  // ),
                ],
              ),

              // Screen 9: The Journey Begins
              buildPage(
                color: OnboardingPageColors.page1['darkBlueGray']!,
                svg: "assets/onboarding2.svg",
                children: [
                  Text("The Goal-Mate Reunion!",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "Here's where the real magic happens, where 'haftey meareys' turn into 'mearey' and goals turn into achievements. Now that we're acquainted and all set, let's go rock those goals and celebrate every milestone, just like a fun reunion!",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
          // Add other screens here...

          Positioned(
            top: 70,
            left: 150,
            right: 100,
            child: SmoothPageIndicator(
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotWidth: 7,
                  dotHeight: 7,
                  dotColor: Colors.grey,
                ),
                controller: controller,
                count: 6),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (_currentPage == 5) {
                    HapticFeedback.heavyImpact();
                    // Update this value to match the number of pages - 1
                    Navigator.of(context)
                        .pushReplacement(HomeViewScreen.route());
                  } else {
                    // Navigate to the next screen
                    HapticFeedback.heavyImpact();
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                child: Container(
                  width: 200, // Set the width of the container here
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        30), // Use borderRadius to make it circular
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == 5 ? "Get Started" : "Next",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
          SizedBox(height: 100),
          SvgPicture.asset(svg),
          SizedBox(height: 15),
          ...children, // Spread the children widgets
        ],
      ),
    );
  }
}

class OnboardingPageColors {
  static final Map<String, Color> page1 = {
    'lightPurple': Color(0xFFDAD9E5),
    'vividPurple': Color(0xFF804DF4),
    'skyBlue': Color(0xFF1A89FB),
    'darkBlueGray': Color(0xFF28363E),
    'burntOrange': Color(0xFFE18A28),
  };

  static final Map<String, Color> page2 = {
    'darkBlue': Color(0xFF1D4873),
    'steelBlue': Color(0xFF7F8A9F),
    'roseTaupe': Color(0xFF675F6B),
    'lightGray': Color(0xFFDDDEDE),
    'saffron': Color(0xFFE6B549),
  };

  static final Map<String, Color> page3 = {
    'periwinkle': Color(0xFFBDBCF2),
    'oxfordBlue': Color(0xFF244893),
    'airForceBlue': Color(0xFF6D8FCA),
    'iris': Color(0xFF6563A9),
    'gray': Color(0xFF7C7C95),
  };
}
