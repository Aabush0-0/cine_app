import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cinema_app/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/networks/api_services.dart';
import '../states/movie_cubit.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<Widget> _determineNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("username");

    if (username != null && username.isNotEmpty) {
      // User is logged in, initialize cubit
      final apiServices = ApiServices();
      final movieCubit = MovieCubit(apiServices, username);
      await movieCubit.init();

      return BlocProvider.value(
        value: movieCubit,
        child: FirstScreen(username: username),
      );
    } else {
      // No logged-in user
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineNextScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Show splash animation while deciding next screen
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/cs.gif'),
                  const SizedBox(height: 20),
                  const Text(
                    "IT'S MOVIE TIME",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Navigate to next screen
        return AnimatedSplashScreen(
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/cs.gif'),
              const SizedBox(height: 20),
              const Text(
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
          duration: 2000,
          splashIconSize: 2000,
          splashTransition: SplashTransition.slideTransition,
          curve: Curves.bounceInOut,
          nextScreen: snapshot.data!,
        );
      },
    );
  }
}
