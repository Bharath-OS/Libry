import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

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
        color: AppColors.background.withAlpha((0.3*255).toInt()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor),
    ),
    title: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
    ),
    trailing: trailing,
  );
}