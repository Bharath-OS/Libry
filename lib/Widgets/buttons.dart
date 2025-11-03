import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:libry/Utilities/constants.dart';

class MyButton {
  //Primary Button
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
  //Secondary action button
  static Widget secondaryButton({
    required VoidCallback method,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.secondaryButtonColor,
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
  //Back Button
  static ElevatedButton backButton({
    required VoidCallback method,
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
        "Back",
        style: TextStyle(
          fontFamily: "Livvic",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //Delete Button
  static IconButton deleteButton({
    required VoidCallback method,
  }) {
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

  //Filter button.
  static ElevatedButton filterButton({required VoidCallback method}){
    return ElevatedButton(onPressed: method,child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23,vertical: 8),
      child: Text("Filter",style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "Livvic",
        backgroundColor: MyColors.whiteBG,
      ),),
    ));
  }
}
