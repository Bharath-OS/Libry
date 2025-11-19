import 'package:flutter/material.dart';
import 'package:libry/screens/login.dart';
import 'package:libry/widgets/text_field.dart';
import '../constants/app_colors.dart';
import '../utilities/auth_methods.dart';
import '../widgets/buttons.dart';
import '../widgets/layout_widgets.dart';
import '../utilities/helpers.dart';
import '../utilities/validation.dart';
import 'package:flutter/gestures.dart';

import '../widgets/forms.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController libIdController;
  late final TextEditingController userNameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    libIdController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    libIdController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: FormWidgets.formContainer(title: "Get Started", formWidget: _form()),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 25,
        children: [
          customTextField(
            hintText: "Full name",
            icon: Icons.person_outlined,
            inputController: userNameController,
            validator: (value) {
              return Validator.emptyValidator(value);
            },
          ),
          customTextField(
            hintText: "Email",
            icon: Icons.email_outlined,
            inputController: emailController,
            validator: (value) {
              return Validator.registerEmailValidator(value);
            },
          ),
          customTextField(
            hintText: "Password",
            icon: Icons.password_outlined,
            isObscure: true,
            inputController: passwordController,
            validator: (value) {
              return Validator.passwordValidator(value);
            },
          ),
          MyButton.primaryButton(
            method: () {
              userValidation(
                context: context,
                formKey: _formKey,
                controllers: [
                  userNameController,
                  emailController,
                  passwordController,
                ],
              );
            },
            text: "Register",
          ),
          RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: MyColors.whiteBG),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        transition(child: LoginScreen()),
                      );
                    },
                  text: "Login",
                  style: TextStyle(
                    color: MyColors.primaryButtonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

