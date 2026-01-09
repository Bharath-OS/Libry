import 'package:flutter/material.dart';
import 'package:libry/core/themes/styles.dart';
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
    isReadOnly = false,
    int? maxLength,
    Widget? suffixIcon,
    Widget? prefixIcon,
    VoidCallback? method,
  }) {
    // Logic to select colors based on theme
    final textColor = isDarkTheme ? AppColors.darkTFText : AppColors.lightTFText;
    final borderColor = isDarkTheme ? AppColors.darkTFBorder : AppColors.lightTFBorder;
    final focusColor = isDarkTheme ? AppColors.darkTFFocus : AppColors.lightTFFocus;
    final textStyle = TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        onTap: method,
        cursorColor: AppColors.background,
        style: TextFieldStyle.inputTextStyle,
        controller: controller,
        obscureText: isObscure,
        maxLength: maxLength,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: label,
          prefixIcon: prefixIcon,
          counterText: '',
          counterStyle: textStyle,
          labelStyle: textStyle,
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
    required Function(String) onFieldSubmitted,
    bool isDisabled = false
  }) {
    return TextFormField(
      cursorColor: AppColors.background,
      style: TextFieldStyle.inputTextStyle,
      controller: inputController,
      readOnly: isDisabled,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: AppColors.background),
        prefixIcon: Icon(prefixIcon, color: AppColors.background),
        suffixIcon: flagVariable
            ? Icon(Icons.check, color: AppColors.success)
            : IconButton(
          icon: Icon(Icons.search, color: AppColors.background),
          onPressed: onPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.background.withAlpha((0.3 * 255).toInt())),
        ),
        filled: true,
        fillColor: Colors.white.withAlpha((0.1 * 255).toInt()),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) => Validator.emptyValidator(value),
    );
  }
}
