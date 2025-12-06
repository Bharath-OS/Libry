import 'package:flutter/material.dart';
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
}