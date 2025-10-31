import 'package:flutter/material.dart';

import '../Utilities/constants.dart';

class SplashScreenStyles {
  static final textStyle = TextStyle(
    fontSize: 82,
    fontFamily: "Lobster",
    color: Colors.white,
  );
  static final subtitleStyle = TextStyle(
    fontSize: 14,
    fontFamily: "Livvic",
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );
}
class CustomTheme {
  static const double cornerRadius = 20;

  static final ThemeData myTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 36,
        fontFamily: "Livvic",
        color: Colors.white,
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: MyColors.whiteColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      hintStyle: TextStyle(
        color: MyColors.bgColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      errorStyle: TextStyle(
        color: MyColors.warningColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
        borderSide: BorderSide(color: Colors.black, width: 3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
        borderSide: BorderSide.none,
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 3, color: MyColors.warningColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
        borderSide: BorderSide(color: MyColors.warningColor, width: 3),
      ),
    ),
  );
}