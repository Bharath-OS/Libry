import 'package:flutter/material.dart';
import 'package:libry/screens/register.dart';
import 'package:libry/widgets/buttons.dart';
import 'package:libry/widgets/text_field.dart';
import '../constants/app_colors.dart';
import '../utilities/auth_methods.dart';
import '../widgets/layout_widgets.dart';
import '../utilities/helpers.dart';
import '../utilities/validation.dart';
import 'package:flutter/gestures.dart';
import '../widgets/forms.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: FormWidgets.formContainer(title: "Welcome Back", formWidget: _form()),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 25,
        children: [
          customTextField(
            hintText: "Email",
            icon: Icons.email_outlined,
            inputController: emailController,
            validator: (value) {
              return Validator.emailValidator(value);
            },
          ),
          customTextField(
            hintText: "Password",
            icon: Icons.password_outlined,
            inputController: passwordController,
            isObscure: true,
            validator: (value) {
              return Validator.passwordValidator(value);
            },
          ),
          MyButton.primaryButton(
            method: () => validateUser(
              context: context,
              formKey: _formKey,
              emailController: emailController,
              passwordController: passwordController,
            ),
            text: "Login",
          ),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: MyColors.whiteBG),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        transition(child: RegisterScreen()),
                      );
                    },
                  text: "Register",
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


