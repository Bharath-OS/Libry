import 'package:flutter/material.dart';

import 'glassmorphism.dart';

class FormContainer extends StatelessWidget {
  static final Color formTitleColor = const Color(0xffC1DCFF);
  final String title;
  final Widget formWidget;
  const FormContainer({super.key,required this.title, required this.formWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: GlassMorphism(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 30,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Livvic",
                  fontWeight: FontWeight.bold,
                  color: formTitleColor,
                ),
              ),
              formWidget
            ],
          ),
        ),
      ),
    );
  }
}
