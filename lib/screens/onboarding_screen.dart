import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:motiv8_ai/main.dart';
import 'package:motiv8_ai/screens/general_login_screen.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/screens/signup_screen.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  Widget buildFooter(Color color) {
    return Container(
      color: color,
      height: 60,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Daily Goal Achiever",
          body: "Set and achieve your daily goals with ease.",
          image: SvgPicture.asset("assets/onboarding1.svg"),
          decoration: PageDecoration(
            pageColor: OnboardingPageColors.page1['burntOrange'],
            bodyTextStyle: GoogleFonts.poppins(fontSize: 18),
            titleTextStyle:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            imagePadding: EdgeInsets.all(30),
          ),
        ),
        PageViewModel(
          title: "AI Task Recommendations",
          body: "Receive personalized task recommendations powered by AI.",
          image: SvgPicture.asset("assets/onboarding2.svg"),
          decoration: PageDecoration(
            pageColor: OnboardingPageColors.page2['steelBlue'],
            bodyTextStyle: GoogleFonts.poppins(fontSize: 18),
            titleTextStyle:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            imagePadding: const EdgeInsets.all(24),
          ),
        ),
        PageViewModel(
          title: "Smart Task Suggestions",
          body:
              "Let our AI be your personal task assistant. By understanding your habits and patterns, it recommends tasks that align with your goals, providing valuable insights to optimize your daily workflow.",
          image: SvgPicture.asset("assets/onboarding3.svg"),
          decoration: PageDecoration(
            pageColor: OnboardingPageColors.page3['airForceBlue'],
            bodyTextStyle: GoogleFonts.poppins(fontSize: 18),
            titleTextStyle:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            imagePadding: const EdgeInsets.all(24),
          ),
        ),
      ],
      showNextButton: false,
      showDoneButton: true,
      showSkipButton: true,
      skip: const Text('Skip'),
      onSkip: () {
        ref
            .watch(navigatorKeyProvider)
            .currentState!
            .push(GeneralLoginScreen.route());
      },
      done: const Text(
        "Get Started",
        style: TextStyle(color: Colors.green),
      ),
      onDone: () {
        Navigator.of(context).push(GeneralLoginScreen.route());
      },
      dotsDecorator: DotsDecorator(
        activeColor: Colors.green,
        size: const Size(10, 10),
        spacing: const EdgeInsets.symmetric(horizontal: 8),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   PageController _pageController;
//   int _currentPage = 0;
//   List<Map<String, String?>> _pages = [
//     {
//       'image': 'assets/onboarding1.svg',
//       'detail': 'Page 1 detail description',
//     },
//     {
//       'image': 'assets/onboarding2.svg',
//       'detail': 'Page 2 detail description',
//     },
//     {
//       'image': 'assets/onboarding3.svg',
//       'detail': 'Page 3 detail description',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _currentPage);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _nextPage() {
//     if (_currentPage < _pages.length - 1) {
//       setState(() {
//         _currentPage++;
//       });
//       _pageController.nextPage(
//         duration: Duration(milliseconds: 500),
//         curve: Curves.ease,
//       );
//     }
//   }

//   Widget _buildPage(int index) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           _pages[index]['image'],
//           height: 200,
//         ),
//         SizedBox(height: 16),
//         Text(
//           _pages[index]['detail'],
//           style: TextStyle(fontSize: 18),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildPageIndicator() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         _pages.length,
//         (index) => AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           margin: EdgeInsets.symmetric(horizontal: 8),
//           width: _currentPage == index ? 16 : 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: _currentPage == index ? Colors.blue : Colors.grey,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Onboarding'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: _pages.length,
//               itemBuilder: (context, index) {
//                 return _buildPage(index);
//               },
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentPage = index;
//                 });
//               },
//             ),
//           ),
//           SizedBox(height: 16),
//           _buildPageIndicator(),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _nextPage,
//             child: Text(
//               _currentPage == _pages.length - 1 ? 'Finish' : 'Next',
//             ),
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: OnboardingScreen(),
//   ));
// }
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
