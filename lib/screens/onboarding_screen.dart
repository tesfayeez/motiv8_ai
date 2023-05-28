import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:motiv8_ai/screens/login_screen.dart';
import 'package:motiv8_ai/screens/signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Daily Goal Achiever",
          body: "Set and achieve your daily goals with ease.",
          image: Image.asset('assets/daily_goal.jpg'),
          decoration: PageDecoration(
            bodyTextStyle: TextStyle(fontSize: 18),
            titleTextStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            imagePadding: EdgeInsets.all(24),
          ),
          footer: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Set and achieve your daily goals with ease.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "AI Task Recommendations",
          body: "Receive personalized task recommendations powered by AI.",
          image: Image.asset('assets/daily_goal.jpg'),
          decoration: PageDecoration(
            bodyTextStyle: TextStyle(fontSize: 18),
            titleTextStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            imagePadding: EdgeInsets.all(24),
          ),
          footer: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Receive personalized task recommendations powered by AI.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        PageViewModel(
          title: "Motivational Quotes",
          body: "Get daily motivational quotes tailored to your goals.",
          image: Image.asset('assets/daily_goal.jpg'),
          decoration: PageDecoration(
            bodyTextStyle: TextStyle(fontSize: 18),
            titleTextStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            imagePadding: EdgeInsets.all(24),
          ),
          footer: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Get daily motivational quotes tailored to your goals.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
      showNextButton: false,
      showDoneButton: true,
      done: const Text("Get Started"),
      onDone: () {
        // Perform actions when done button is pressed
        Navigator.of(context).push(SignUpScreen.route());
      },
      dotsDecorator: DotsDecorator(
        activeColor: Colors.blue, // Customize the active dot color
        size: Size(10, 10),
        spacing: EdgeInsets.symmetric(horizontal: 8),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
