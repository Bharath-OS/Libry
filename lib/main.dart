import 'package:flutter/material.dart';
import 'Screens/splash.dart';
import 'Themes/styles.dart';

void main(){
  runApp(LibryApp());
}
class LibryApp extends StatelessWidget {
  const LibryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.myTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
