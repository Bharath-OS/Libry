//reusable widgets from settingsview

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

Widget buildManagementCard({
  required String title,
  required IconData icon,
  required List<String> items,
  required String emptyMessage,
  required VoidCallback onAdd,
  required Function(String) onEdit,
  required Function(String) onDelete,
}) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background.withAlpha((0.3*255).toInt()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${items.length}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        if (items.isEmpty)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                emptyMessage,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  title: Text(items[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 20),
                        color: AppColors.primary,
                        onPressed: () => onEdit(items[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20),
                        color: Colors.red,
                        onPressed: () => onDelete(items[index]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onAdd,
            icon: Icon(Icons.add),
            label: Text('Add $title'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Generic Dialog for Adding/Editing a single String value
void showManagerDialog({
  required BuildContext context,
  required String title,
  String? initialValue,
  required String label,
  required List<String> existingItems,
  required Function(String) onSave, // This is the Callback
}) {
  final controller = TextEditingController(text: initialValue);
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          // Reusing your existing validator logic
          validator: (value) => Validator.genreValidator(value, existingItems),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              onSave(controller.text.trim()); // Execute the callback
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

// Generic Dialog for Deleting
void showDeleteConfirmDialog({
  required BuildContext context,
  required String itemName,
  required String category,
  required VoidCallback onConfirm, // Another Callback
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete $category'),
      content: Text('Are you sure you want to delete "$itemName"?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
