import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          borderRadius: BorderRadius.circular(10),
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
  }) {
    return ElevatedButton(
      onPressed: method,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryButton,
        foregroundColor: AppColors.secondaryButtonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
}