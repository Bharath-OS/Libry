import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';

class MyButton {
  static FloatingActionButton fab({required VoidCallback method}) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: AppColors.primaryButton,
      elevation: 0,
      onPressed: method,
      child: Icon(Icons.add, color: AppColors.primaryButtonText, size: 40),
    );
  }

  static Widget primaryButton({
    required VoidCallback method,
    required String text,
    double? fontSize = 15,
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: Colors.white,
        // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
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
    double fontSize = 15,
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryButton,
        // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryButtonText,
        ),
      ),
    );
  }

  static ElevatedButton backButton({required VoidCallback method}) {
    return ElevatedButton.icon(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.primaryButtonText,
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

  static Widget deleteButton({
    required VoidCallback method,
    bool isTextButton = false,
  }) {
    if (!isTextButton) {
      return IconButton(
        icon: SvgPicture.asset("assets/icons/delete-icon.svg"),
        onPressed: method,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dangerButton,
          foregroundColor: AppColors.dangerButtonText,
          // padding: EdgeInsets.only(top: 9,bottom: 9,left: 20,right: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );
    }
    else{
      return ElevatedButton(
        onPressed: method,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dangerButton,
          // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Text(
          "Delete",
          style: TextStyle(
            fontFamily: "Livvic",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.dangerButtonText,
          ),
        ),
      );;
    }
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
