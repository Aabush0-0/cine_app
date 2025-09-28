import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cinema_app/screens/first_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/cs.gif'),
          Text(
            "IT'S MOVIE TIME",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      duration: 5000,
      splashIconSize: 2000,
      splashTransition: SplashTransition.slideTransition,
      curve: Curves.bounceInOut,
      nextScreen: FirstScreen(),
    );
  }
}
