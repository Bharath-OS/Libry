import 'package:flutter/material.dart';

void showPopUpScreen({
  required String title,
  required BuildContext context,
  required Widget child,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(title: Text("Add Book"), content: child);
    },
  );
}

void showAlertMessage({required String message, required BuildContext context}) {
  showDialog(context: context, builder: (_) => Text(message));
}
