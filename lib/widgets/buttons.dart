import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:libry/constants/app_colors.dart';

class MyButton {
  static FloatingActionButton fab({required VoidCallback method}) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: MyColors.primaryButtonColor,
      elevation: 0,
      onPressed: method,
      child: Icon(Icons.add, color: MyColors.whiteBG, size: 40),
    );
  }

  static Widget primaryButton({
    required VoidCallback method,
    required String text,
    double? fontSize = 20
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryButtonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget secondaryButton({
    required VoidCallback method,
    required String text,
    double fontSize = 20
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryButtonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static ElevatedButton backButton({required VoidCallback method}) {
    return ElevatedButton.icon(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryButtonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.only(top: 9, bottom: 9, left: 20, right: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      label: Text(
        "Back",
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static IconButton deleteButton({required VoidCallback method}) {
    return IconButton(
      icon: SvgPicture.asset("assets/icons/delete-icon.svg"),
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.warningColor,
        foregroundColor: Colors.white,
        // padding: EdgeInsets.only(top: 9,bottom: 9,left: 20,right: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  static ElevatedButton filterButton({required VoidCallback method}) {
    return ElevatedButton(
      onPressed: method,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Text(
          "Filter",
          style: TextStyle(
            fontFamily: "Livvic",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
