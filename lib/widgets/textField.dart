import 'package:flutter/material.dart';
import 'package:libry/Utilities/constants.dart';

TextFormField customTextField({
  required String hintText,
  required IconData icon,
  required TextEditingController inputController,
  required String? Function(String?)? validator,
  bool isObscure = false,
  Color textColor = const Color(0xffC1DCFF),
  Color errorTextColor = const Color(0xffFF1010),
  double cornerRadius = 20,
}) {
  final Color fillColor = Color(0xff3F5A7C);
  return TextFormField(
    style: const TextStyle(
      color: Color(0xffC1DCFF),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    controller: inputController,
    obscureText: isObscure,
    validator: validator,
    decoration: InputDecoration(
      filled: true,
      fillColor: fillColor,
      prefixIcon: Icon(icon, color: textColor),
      hintText: hintText,
      hintStyle: TextStyle(
        color: MyColors.bgColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      errorStyle: TextStyle(
        color: MyColors.warningColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
        borderSide: BorderSide(color: textColor, width: 3),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius))
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 3,color: MyColors.warningColor)
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        borderSide: BorderSide(color: MyColors.warningColor, width: 3),
      ),
    ),
  );
}
