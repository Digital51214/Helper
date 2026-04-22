import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    print('===== SPLASH SESSION CHECK STARTED =====');

    await Future.delayed(const Duration(seconds: 3));

    final bool isLoggedIn = await SessionManager.isLoggedIn();
    final int userId = await SessionManager.getUserId();
    final String email = await SessionManager.getUserEmail();
    final String username = await SessionManager.getUserName();
    final String profilePic = await SessionManager.getProfilePic();

    print('===== SPLASH SESSION DATA =====');
    print('IS LOGGED IN: $isLoggedIn');
    print('USER ID     : $userId');
    print('EMAIL       : $email');
    print('USERNAME    : $username');
    print('PROFILE PIC : $profilePic');

    if (!mounted) return;

    if (isLoggedIn && userId != 0) {
      print('===== SPLASH NAVIGATION =====');
      print('GO TO: BottomNavigationScreen');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigationScreen(),
        ),
      );
    } else {
      print('===== SPLASH NAVIGATION =====');
      print('GO TO: WelcomeScreen');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
          // Agar direct login screen chahiye to isay use karo:
          // builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/signup1.png'),
                height: 200,
                width: 200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}