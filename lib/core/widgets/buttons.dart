import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../features/books/data/model/books_model.dart';
import '../../features/books/views/book_history.dart';
import '../../features/books/views/edit_book_screen.dart';
import '../../features/members/data/model/members_model.dart';
import '../../features/members/view/edit_member.dart';
import '../../features/members/view/member_history.dart';
import '../constants/app_colors.dart';
import '../utilities/helpers.dart';

class MyButton {
  // 1. FAB (Floating Action Button)
  static FloatingActionButton fab({required VoidCallback onPressed, required String label}) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(Icons.add, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
    );
  }

  // 2. Primary Button (Main Actions)
  static Widget primaryButton({
    required VoidCallback method,
    required String text,
    double fontSize = 15,
    double? width,
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: Colors.white,
        minimumSize: Size(width ?? 0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: Text(text, style: TextStyle(fontFamily: "Livvic", fontSize: fontSize, fontWeight: FontWeight.bold)),
    );
  }

  // 3. Outlined Button (NEW - Perfect for "Cancel")
  static Widget outlinedButton({
    required VoidCallback method,
    required String text,
    Color? color,
  }) {
    final themeColor = color ?? AppColors.primaryButton;
    return OutlinedButton(
      onPressed: method,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: themeColor, width: 1.5),
        foregroundColor: themeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Livvic",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 4. Secondary Button
  static Widget secondaryButton({
    required VoidCallback method,
    required String text,
    double fontSize = 15,
    double? width
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 0, 48),
        backgroundColor: AppColors.secondaryButton,
        foregroundColor: AppColors.secondaryButtonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
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

  // 5. Delete Button (Fixed Logic)
  static Widget deleteButton({required VoidCallback method, bool isTextButton = false,bool isDisabled = false}) {
    if (isTextButton) {
      return ElevatedButton(
        onPressed: isDisabled ? null : method,
        style: ElevatedButton.styleFrom(
          backgroundColor: !isDisabled ? AppColors.dangerButton : AppColors.lightGrey,
          foregroundColor: AppColors.dangerButtonText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: const Text("Delete", style: TextStyle(fontFamily: "Livvic", fontWeight: FontWeight.bold)),
      );
    }
    return IconButton(
      onPressed: method,
      icon: SvgPicture.asset(
        "assets/icons/delete-icon.svg",
        colorFilter: ColorFilter.mode(AppColors.dangerButton, BlendMode.srcIn),
      ),
    );
  }

  // 6. Back Button
  static Widget backButton({required VoidCallback method}) {
    return FilledButton.icon(
      onPressed: method,
      icon: const Icon(Icons.arrow_back_ios, size: 16),
      label: const Text("Back"),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.primaryButtonText,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  static Widget buildDetailsActionButtons<T>(BuildContext context,T item) {
    String editLabel = '';
    String deleteLabel = '';
    String historyLabel = 'View Borrow History';
    if (item is MemberModel) {
      editLabel = 'Edit Member';
      deleteLabel = 'Delete Member';
    } else if (item is BookModel) {
      editLabel = 'Edit Book';
      deleteLabel = 'Delete Book';
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (item is MemberModel) {
                  Navigator.push(
                    context,
                    transition(child: MemberHistoryScreen(memberId: item.id!)),
                  );
                } else if (item is BookModel) {
                  Navigator.push(
                    context,
                    transition(child: BookHistoryScreenView(bookId: item.id!)),
                  );
                }
              },
              icon: Icon(Icons.history),
              label: Text(historyLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryButton,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (item is MemberModel) {
                  Navigator.push(
                    context,
                    transition(child: EditMembersScreen(member: item)),
                  );
                } else if (item is BookModel) {
                  Navigator.push(
                    context,
                    transition(child: EditBookScreenView(book: item)),
                  );
                }
              },
              icon: Icon(Icons.edit),
              label: Text(editLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (item is MemberModel) {
                  deleteMember(
                    context: context,
                    memberDetails: item,
                    inDetailsScreen: true,
                  );
                } else if (item is BookModel) {
                  deleteBook(
                    context: context,
                    bookDetails: item,
                    inDetailsScreen: true,
                  );
                }
              },
              icon: Icon(Icons.delete),
              label: Text(deleteLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}