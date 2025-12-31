import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

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
  static const Color fillColor = Color(0xff3F5A7C);

  static final ThemeData myTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        fontFamily: "Livvic",
        color: Colors.white,
      ),
      // centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //   filled: true,
    //   fillColor: fillColor,
    //   labelStyle: TextFieldStyle.inputTextStyle,
    //   hintStyle: TextStyle(
    //     color: AppColors.background,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   errorStyle: TextStyle(
    //     color: AppColors.error,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(cornerRadius),
    //     borderSide: BorderSide(color: AppColors.background, width: 3),
    //   ),
    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(cornerRadius),
    //     borderSide: BorderSide.none,
    //   ),
    //   errorBorder: UnderlineInputBorder(
    //     borderSide: BorderSide(width: 3, color: AppColors.error),
    //   ),
    //   focusedErrorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(cornerRadius),
    //     borderSide: BorderSide(color: AppColors.error, width: 3),
    //   ),
    // ),
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
    return TextStyle(fontSize: 25, color: color, fontWeight: FontWeight.w700);
  }

  static TextStyle headingSmallStyle([Color color = Colors.black]) {
    return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.w700);
  }

  static TextStyle bodySmallStyle([Color color = Colors.black]) {
    return TextStyle(
      fontSize: 16,
      color: color,
      fontFamily: "Livvic",
      fontWeight: FontWeight.w500,
    );
  }
}

class TextFieldStyle {
  static InputDecoration textFieldStyle({required String hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.lightGrey,
      hintText: hintText,
      enabledBorder: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 3, color: AppColors.primaryButton),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  static TextStyle inputTextStyle = TextStyle(
    color: AppColors.background,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
