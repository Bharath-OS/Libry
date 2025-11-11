import 'package:flutter/material.dart';
import 'package:libry/screens/main_screen.dart';
import 'package:libry/screens/register.dart';
import 'package:libry/widgets/buttons.dart';
import 'package:libry/widgets/textField.dart';
import 'package:page_transition/page_transition.dart';
import '../constants/app_colors.dart';
import '../widgets/scaffold.dart';
import '../database/userdata.dart';
import '../models/user_model.dart';
import '../utilities/helpers.dart';
import '../utilities/validation.dart';
import 'package:flutter/gestures.dart';
import '../widgets/form.dart';

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
    return CustomScaffold(
      body: FormContainer(title: "Welcome Back", formWidget: _form()),
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
          MyButton.primaryButton(method: () => _validateUser(), text: "Login"),
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
                        PageTransition(
                          type: PageTransitionType.fade,
                          curve: Curves.easeIn,
                          child: RegisterScreen(),
                          duration: Duration(milliseconds: 300),
                        ),
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

  void _validateUser() {
    String message = "Something went wrong! Please Try Again or Register!";
    final User? user = UserDatabase.getData();
    if (_formKey.currentState!.validate()) {
      if (user != null) {
        if (user.email == emailController.text &&
            user.password == passwordController.text) {
          message = "Logged In Successfully!";
          UserDatabase.setLogValue(true);
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              curve: Curves.easeIn,
              child: MainScreen(),
              duration: Duration(milliseconds: 300),
            ),
          );
        } else {
          message = "Invalid Credentials!";
        }
      }
    }
    showSnackBar(text: message, context: context);
  }
}
