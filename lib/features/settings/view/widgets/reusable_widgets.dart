import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons.dart';

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
        MyButton.deleteButton(
          method: () {
            onConfirm();
            Navigator.pop(context);
          },
          isTextButton: true
          // style: ElevatedButton.styleFrom(backgroundColor: Colors.red,foregroundColor: AppColors.white),
          // child: const Text('Delete'),
        ),
      ],
    ),
  );
}

// In reusable_widgets.dart

void showSettingsEditDialog({
  required BuildContext context,
  required String title,
  required String label,
  String? initialValue,
  required Function(String) onSave,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ),
      actions: [
        MyButton.outlinedButton(
          method: () => Navigator.pop(context),
          text: 'Cancel',
          color: AppColors.lightGrey
        ),
        MyButton.primaryButton(
          method: () {
            // Only save if the validation passes (or if no validator is provided)
            if (formKey.currentState!.validate()) {
              onSave(controller.text.trim());
              Navigator.pop(context);
            }
          },
          text: 'Save',
        ),
      ],
    ),
  );
}