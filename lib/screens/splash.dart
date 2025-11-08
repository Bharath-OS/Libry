import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libry/database/userdata.dart';
import 'package:libry/Screens/main_screen.dart';
import 'package:libry/Screens/login.dart';
import 'package:libry/Screens/register.dart';
import 'package:libry/Themes/styles.dart';
import '../Widgets/scaffold.dart';
import '../utilities/helpers.dart';

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
    return CustomScaffold(
      body: AnimatedOpacity(
        opacity: !_isVisible ? 0.0 : 1.0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
        child: _splashScreenContent(),
      ),
    );
  }

  Future<void> userVerification() async {
    print("At userverification");
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isVisible = true;
    });
    print("before Navigator");
    late Widget childWidget;
    late final bool isLogged;
    late final bool isRegistered;
    try
    {
      isLogged = UserDatabase.isLogged;
      isRegistered = UserDatabase.isRegistered;
      print("isLogged: $isLogged");
      print("isRegistered: $isRegistered");
    }
    catch(e)
    {
      print("Exception: $e");
    }


    if (isLogged) {
      childWidget = MainScreen();
    } else if (!isLogged && isRegistered) {
      childWidget = LoginScreen();
    } else {
      childWidget = RegisterScreen();
    }
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(context, transition(child: childWidget));
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
