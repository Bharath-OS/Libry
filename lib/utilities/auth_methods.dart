import 'package:flutter/material.dart';

import '../Screens/main_screen.dart';
import '../database/userdata.dart';
import '../models/user_model.dart';
import 'helpers.dart';

void validateUser({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) {
  String message = "Something went wrong! Please Try Again or Register!";
  final User? user = UserDatabase.getData();
  if (formKey.currentState!.validate()) {
    if (user != null) {
      if (user.email == emailController.text &&
          user.password == passwordController.text) {
        message = "Logged In Successfully!";
        UserDatabase.setLogValue(true);
        Navigator.pushReplacement(context, transition(child: MainScreen()));
      } else {
        message = "Invalid Credentials!";
      }
    }
  }
  showSnackBar(text: message, context: context);
}

void userValidation({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required List<TextEditingController> controllers,
}) {
  FocusScope.of(context).unfocus();
  String message = "";
  if (formKey.currentState!.validate()) {
    User user = User(
      name: controllers[0].text,
      email: controllers[1].text,
      password: controllers[2].text,
    );
    bool result = UserDatabase.saveData(user: user);
    if (result) {
      UserDatabase.setRegisterValue(true);
      UserDatabase.setLogValue(true);
      Navigator.pushReplacement(
        context,
        transition(child: MainScreen())
      );
      message = "Account created!";
    } else {
      message = "Something went wrong. Try again";
    }
    showSnackBar(text: message, context: context);
  }
}
