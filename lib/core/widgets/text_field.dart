import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utilities/validation.dart';

class AppTextField {
  static Widget customTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
    bool isDarkTheme = true,
    TextInputType keyboardType = TextInputType.text,
    bool isObscure = false,
    int maxLines = 1,
    isReadOnly = false
  }) {
    // Logic to select colors based on theme
    final textColor = isDarkTheme ? AppColors.darkTFText : AppColors.lightTFText;
    final borderColor = isDarkTheme ? AppColors.darkTFBorder : AppColors.lightTFBorder;
    final focusColor = isDarkTheme ? AppColors.darkTFFocus : AppColors.lightTFFocus;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: isReadOnly,
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

  static Widget customIssueTextField({
    required TextEditingController inputController,
    required String label,
    required IconData prefixIcon,
    required bool flagVariable,
    required VoidCallback onPressed,
    required Function(String) onChanged,
    required Function(String) onFieldSubmitted
  }) {
    return TextFormField(
      controller: inputController,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(prefixIcon, color: AppColors.background),
        suffixIcon: flagVariable
            ? Icon(Icons.check, color: AppColors.success)
            : IconButton(
          icon: Icon(Icons.search, color: AppColors.background),
          onPressed: onPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.background.withOpacity(0.3)),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      style: TextStyle(color: AppColors.background),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => Validator.emptyValidator(value),
    );
  }
}
