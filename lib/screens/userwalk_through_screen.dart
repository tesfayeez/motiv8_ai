import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motiv8_ai/screens/homeview_screen.dart';
import 'package:motiv8_ai/widgets/presenting_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final pageProvider = StateProvider<int>((ref) => 0);

class UserWalkthroughScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => UserWalkthroughScreen());
  @override
  _UserWalkthroughScreenState createState() => _UserWalkthroughScreenState();
}

class _UserWalkthroughScreenState extends ConsumerState<UserWalkthroughScreen> {
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
                  AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      PresentingAnimatedText(
                        text: 'Welcome to Motiv8-AI!',
                        textStyle: GoogleFonts.poppins(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        duration: const Duration(seconds: 1),
                        slideOffset: 200.0,
                      ),
                    ],
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
                        "Your journey to success starts here. We're here to guide you through setting, refining, and achieving your goals.",
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
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Let's Get to Know Each Other",
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
                          "To make this journey personal to you, we'd like to know a bit about you. What's your name, and what's a fun fact about you?",
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        ),
                        TextField()
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
                  Text("What is a Goal?",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TyperAnimatedText(
                              "A goal is a desired result you commit to achieve. It's more than just a wish or a dream - it's a target you can work towards. Goals guide your focus, giving you direction and sustaining your momentum in life.",
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.white)),
                        ]),
                  )
                ],
              ),

              //Screen 4: The Power of Motivation
              buildPage(
                color: OnboardingPageColors.page1['burntOrange']!,
                svg: "assets/onboarding1.svg",
                children: [
                  Text("Your Motivation",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TyperAnimatedText(
                          "Understanding your motivation helps us tailor our support. Motivation is the driving force behind goal achievement. It's what pushes you to persist and persevere, even when the going gets tough. What drives you to achieve your goals?",
                          textStyle: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // Screen 5: SMART Goal Setting
              buildPage(
                color: OnboardingPageColors.page2['darkBlue']!,
                svg: "assets/onboarding3.svg",
                children: [
                  Text("Setting SMART Goals",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TyperAnimatedText(
                          "Effective goals are SMART: Specific, Measurable, Achievable, Relevant, Time-bound. A specific goal has a much greater chance of being accomplished than a general one. Measurable goals help you track progress and stay motivated. Achievable goals are within your abilities, while relevant goals align with your other life plans. Time-bound goals have a deadline which creates a sense of urgency.",
                          textStyle: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   child: ,
                  // ),
                ],
              ),

              //Screen 6: Preferences and Routines
              buildPage(
                color: OnboardingPageColors.page2['roseTaupe']!,
                svg: "assets/onboarding2.svg",
                children: [
                  Text("Your Preferences Matter",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "Knowing your preferred routines and habits helps us better assist you. Do you have a preferred time of day for goal-related activities? What kind of reminders do you find most helpful? How can we best fit into your daily life?",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
              // Screen 7: The Importance of Consistency
              buildPage(
                color: OnboardingPageColors.page3['periwinkle']!,
                svg: "assets/onboarding2.svg",
                children: [
                  Text("Consistency is Key",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "Regular reminders can keep you on track. Consistency breeds habits, and habits can fuel your success. How often would you like to receive goal reminders?",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
              // Screen 8: The Art of Goal Refinement
              buildPage(
                color: OnboardingPageColors.page1['vividPurple']!,
                svg: "assets/onboarding1.svg",
                children: [
                  Text("Refining Your Goals",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "Goals aren't set in stone. They can and should evolve with you. Regularly reviewing and refining your goals helps you stay on track and allows for adjustments as your life changes. Remember, it's okay to change your goals. It's a sign of growth and adaptation.",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
              // Screen 9: The Journey Begins
              buildPage(
                color: OnboardingPageColors.page1['darkBlueGray']!,
                svg: "assets/onboarding2.svg",
                children: [
                  Text("Let's Get Started!",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        "You're now equipped with the knowledge and tools to effectively set and pursue your goals. Remember, the journey of a thousand miles begins with a single step. Here's to taking that step and many more on your path to success.",
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
                count: 9),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (_currentPage == 8) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _currentPage == 8 ? "Get Started" : "Next",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.grey,
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
