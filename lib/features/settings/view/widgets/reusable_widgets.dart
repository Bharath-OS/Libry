import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/themes/styles.dart';
import '../../../../core/utilities/validation.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/text_field.dart';

Widget buildSettingTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required Widget trailing,
}) {
  final iconColor = AppColors.primary;
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    leading: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha((0.3 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor),
    ),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
    ),
    trailing: trailing,
  );
}

void buildDialogBox({
  required TextEditingController controller,
  required BuildContext context,
  required String title,
  required String label,
  required VoidCallback saveMethod,
  bool isDouble = false
}) {
  // final controller = TextEditingController(text: finePerDay.toString());
  final formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.white,
      title: Text(
        title,
        style: BodyTextStyles.headingSmallStyle(AppColors.darkGrey),
      ),
      content: Form(
        key: formKey,
        child: AppTextField.customTextField(
          isDarkTheme: false,
          validator: (value) =>
              Validator.numberValidator(value: value, isDouble: isDouble),
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          label: label,
        ),
      ),
      actions: [
        MyButton.secondaryButton(
          method: () => Navigator.pop(context),
          text: 'cancel',
        ),
        MyButton.primaryButton(
          method: () {
            if (formKey.currentState!.validate()) {
              saveMethod();
            }
          },
          text: 'Save',
        ),
      ],
    ),
  );
}
