import 'package:flutter/material.dart';
import 'package:libry/features/members/viewmodel/members_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../features/books/data/model/books_model.dart';
import '../../features/books/viewmodel/book_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/buttons.dart';
import '../widgets/dialogs.dart';

Widget spacing({required double height}) {
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
  final currentlyBorrow = bookDetails.totalCopies - bookDetails.copiesAvailable;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Book"),
      content: currentlyBorrow == 0
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
          isDisabled: currentlyBorrow != 0,
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

void deleteMember({
  required BuildContext context,
  required String memberId,
  inDetailsScreen = true,
}) {
  final memberDetails = context.read<MembersViewModel>().getMemberById(memberId);
  final currentlyBorrow = memberDetails?.currentlyBorrow;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Member"),
      content: currentlyBorrow == 0
          ? const Text("Are you sure you want to delete this member?")
          : const Text(
          "You cannot delete this member while they still have borrowed books. Please return all books before deleting the member."
      ),
      actions: [
        MyButton.outlinedButton(
            method: () => Navigator.pop(context),
            text: "Cancel",
            color: AppColors.lightGrey
        ),
        MyButton.deleteButton(
          isTextButton: true,
          isDisabled: currentlyBorrow != 0,
          method: () {
            // Safely handle missing ID
            if (memberDetails?.id == null) {
              Navigator.pop(context);
              showSnackBar(text: "Cannot delete member: missing ID", context: context);
              return;
            }

            context.read<MembersViewModel>().removeMember(memberDetails!.id!);
            Navigator.pop(context); // Close dialog
            inDetailsScreen
                ? Navigator.pop(context)
                : null; // Go back to books list
            showSnackBar(text: "${memberDetails.name} deleted successfully", context: context);
          },
        ),
      ],
    ),
  );
}

bool calculateOverDue({required DateTime dueDate, required bool isReturned}){
  final today = DateUtils.dateOnly(DateTime.now());
  final dueDateOnly = DateUtils.dateOnly(dueDate);
  return !isReturned &&
      today.isAfter(dueDateOnly);
}
