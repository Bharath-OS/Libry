import 'package:flutter/material.dart';
import 'Screens/splash.dart';

void main(){
  runApp(LibryApp());
}
class LibryApp extends StatelessWidget {
  const LibryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
