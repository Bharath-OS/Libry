import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../models/books_model.dart';
import '../../provider/book_provider.dart';
import '../widgets/dialogs.dart';

spacing({required double height}) {
  return SizedBox(height: height);
}
void showSnackBar({required String text,required BuildContext context}){
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text)));
}

PageTransition transition({required Widget child}){
  return PageTransition(
    type: PageTransitionType.fade,
    curve: Curves.easeIn,
    child: child,
    duration: Duration(milliseconds: 300),
  );
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
            AppDialogs.showSnackBar(
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
