import 'package:flutter/material.dart';

class SplashScreenStyles {
  static final textStyle = const TextStyle(
    fontSize: 82,
    fontFamily: "Lobster",
    color: Colors.white,
  );
  static final subtitleStyle = const TextStyle(
    fontSize: 14,
    fontFamily: "Livvic",
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );
}

class CardStyles {
  static final cardTitleStyle = const TextStyle(
    fontSize: 20,
    fontFamily: "Livvic",
    fontWeight: FontWeight.w700,
  );
  static final cardSubTitleStyle = const TextStyle(
    fontSize: 16,
    fontFamily: "Livvic",
    fontWeight: FontWeight.w600,
    color: Color(0xff606060),
  );
}

class BodyTextStyles {
  static final mainHeadingStyle = const TextStyle(
    fontSize: 32,
    fontFamily: "Livvic",
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );

  static TextStyle headingMediumStyle([Color color = Colors.black]) {
    return TextStyle(
      fontSize: 25,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle headingSmallStyle([Color color = Colors.black]){
    return TextStyle(
      fontSize: 20,
      color: color,
      fontWeight: FontWeight.w700
    );
  }

  static TextStyle bodySmallStyle([Color color = Colors.black]){
    return TextStyle(
      fontSize: 16,
      color: color,
      fontFamily: "Livvic",
      fontWeight: FontWeight.w500
    );
  }
}
