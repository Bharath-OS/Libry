import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libry/Screens/books.dart';
import 'package:libry/Screens/login.dart';
import 'package:libry/Screens/register.dart';
import 'package:libry/Themes/styles.dart';
import 'package:libry/Utilities/constants.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    userVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/images/splashBG.png", fit: BoxFit.cover),
          ),
          AnimatedOpacity(
            opacity: !_isVisible ? 0.0 : 1.0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
            child: _splashScreenContent(),
          ),
        ],
      ),
    );
  }

  Future<void> userVerification() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isVisible = true;
    });
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        curve: Curves.easeIn,
        child: BooksScreen(),
        duration: Duration(milliseconds: 300)
      ),
    );
  }

  Widget _splashScreenContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Libry", style: SplashScreenStyles.textStyle),
          Text(
            "Effortless Library Management,\nSimplified",
            textAlign: TextAlign.center,
            style: SplashScreenStyles.subtitleStyle,
          ),
        ],
      ),
    );
  }
}
