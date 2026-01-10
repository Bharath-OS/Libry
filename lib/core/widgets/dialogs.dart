import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'buttons.dart';

class AppDialogs {
  static void showAlert({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          MyButton.outlinedButton(
            method: () => Navigator.pop(context),
            text:"Cancel",
          ),
          MyButton.primaryButton(
            method: onConfirm,
            text: "Confirm",
          ),
        ],
      ),
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String message, bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message,style: TextStyle(color: isError?AppColors.white:Colors.black),),backgroundColor: isError?AppColors.error:AppColors.white,),
    );
  }

  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required Widget content,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
      ),
    );
  }
}