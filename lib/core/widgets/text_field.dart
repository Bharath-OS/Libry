import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTextField {
  Widget customTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
    bool isDarkTheme = true,
    TextInputType keyboardType = TextInputType.text,
    bool isObscure = false,
  }) {
    // Logic to select colors based on theme
    final textColor = isDarkTheme ? AppColors.darkTFText : AppColors.lightTFText;
    final borderColor = isDarkTheme ? AppColors.darkTFBorder : AppColors.lightTFBorder;
    final focusColor = isDarkTheme ? AppColors.darkTFFocus : AppColors.lightTFFocus;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 14,
          ),
          // Border when the field is NOT selected
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
          // Border when the user is typing
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: focusColor, width: 2),
          ),
          // Error border logic
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
