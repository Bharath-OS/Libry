import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/books_model.dart';
import '../../provider/book_provider.dart';

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

void showAlertMessage({
  required String message,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void deleteBook({required BuildContext context, required Books bookDetails, inDetailsScreen=true}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Book"),
      content: const Text("Are you sure you want to delete this book?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // 🔥 Use the actual book ID, not index 0
            context.read<BookProvider>().removeBook(bookDetails.id!);
            Navigator.pop(context); // Close dialog
            inDetailsScreen ? Navigator.pop(context) : null; // Go back to books list
            showAlertMessage(
              message: "${bookDetails.title} deleted successfully",
              context: context,
            );
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}
