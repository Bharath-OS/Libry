// dialogs.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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