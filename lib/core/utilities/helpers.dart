import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../features/books/data/model/books_model.dart';
import '../../features/books/viewmodel/book_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/buttons.dart';
import '../widgets/dialogs.dart';

spacing({required double height}) {
  return SizedBox(height: height);
}

void showSnackBar({required String text, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

PageTransition transition({required Widget child}) {
  return PageTransition(
    type: PageTransitionType.fade,
    curve: Curves.easeIn,
    child: child,
    duration: Duration(milliseconds: 300),
  );
}

void deleteBook({
  required BuildContext context,
  required BookModel bookDetails,
  inDetailsScreen = true,
}) {
  final borrowCount = bookDetails.totalCopies - bookDetails.copiesAvailable;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Book"),
      content: borrowCount == 0
          ? const Text("Are you sure you want to delete this book?")
          : const Text(
              "You cannot delete this book while it is being borrowed. Return all books first before deletion.",
            ),
      actions: [
        MyButton.outlinedButton(
          method: () => Navigator.pop(context),
          text: "Cancel",
          color: AppColors.lightGrey
        ),
        MyButton.deleteButton(
          isTextButton: true,
          isDisabled: borrowCount != 0,
          method: () {
            // 🔥 Use the actual book ID, not index 0
            context.read<BookViewModel>().removeBook(bookDetails.id!);
            Navigator.pop(context); // Close dialog
            inDetailsScreen
                ? Navigator.pop(context)
                : null; // Go back to books list
            AppDialogs.showSnackBar(
              message: "${bookDetails.title} deleted successfully",
              context: context,
            );
          },
        ),
      ],
    ),
  );
}
