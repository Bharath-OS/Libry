import 'package:flutter/material.dart';
import 'package:libry/Utilities/constants.dart';

class MyButton {
  static Widget primaryButton({
    required VoidCallback method,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryButtonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget secondaryButton({
    required VoidCallback method,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryButtonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static ElevatedButton backButton({
    required VoidCallback method,
    required String text,
  }) {
    return ElevatedButton.icon(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primaryButtonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.only(top: 9,bottom: 9,left: 20,right: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      label: Text(
        text,
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static IconButton deleteButton({
    required VoidCallback method,
    required String text,
  }) {
    return IconButton(
      icon: Icon(Icons.delete_outline),
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
}
