import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/themes/styles.dart';
import '../../core/utilities/helpers.dart';
import '../../core/widgets/layout_widgets.dart';
import '../auth/data/services/userdata.dart';
import '../auth/view/login.dart';
import '../auth/view/register.dart';
import '../home/views/main_screen.dart';

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
    return LayoutWidgets.customScaffold(
      body: AnimatedOpacity(
        opacity: !_isVisible ? 0.0 : 1.0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
        child: _splashScreenContent(),
      ),
    );
  }

  Future<void> userVerification() async {
    debugPrint("At userverification");
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _isVisible = true;
    });
    debugPrint("before Navigator");
    late Widget childWidget;
    late final bool isLogged;
    late final bool isRegistered;
    try
    {
      isLogged = UserModelService.isLogged;
      isRegistered = UserModelService.isRegistered;
      debugPrint("isLogged: $isLogged");
      debugPrint("isRegistered: $isRegistered");
    }
    catch(e)
    {
      debugPrint("Exception: $e");
    }


    if (isLogged) {
      childWidget = MainScreen();
    } else if (!isLogged && isRegistered) {
      childWidget = LoginView();
    } else {
      childWidget = RegisterView();
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
