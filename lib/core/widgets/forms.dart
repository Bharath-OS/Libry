import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../themes/styles.dart';
import 'buttons.dart';
import 'glassmorphism.dart';

class FormWidgets {
  static Widget formContainer({
    required String title,
    required Widget formWidget,
    Color titleColor = const Color(0xffC1DCFF),
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: SingleChildScrollView(
          child: GlassMorphism(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Livvic",
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 30),
                formWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget formField({
    required String title,
    required Widget child,
  }) {
    final style = const TextStyle(
      color: Color(0xffC1DCFF),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: style),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  static Widget dropdown<T>({
    required T? value,
    required List<T> items,
    required void Function(T?)? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      dropdownColor: AppColors.darkGrey,
      initialValue: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      style: TextFieldStyle.inputTextStyle,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkTFBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkTFFocus, width: 2),
        ),
         errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }


  static Widget formActionButtons({
    required BuildContext context,
    required VoidCallback saveMethod,
  }) {
    return Row(
      children: [
        Expanded(
          child: MyButton.secondaryButton(
            method: () => Navigator.pop(context),
            text: 'Cancel',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: MyButton.primaryButton(method: saveMethod, text: 'Save'),
        ),
      ],
    );
  }

}
