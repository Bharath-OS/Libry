import 'package:flutter/material.dart';
import 'package:libry/Screens/login.dart';
import 'package:libry/Widgets/textField.dart';
import 'package:page_transition/page_transition.dart';
import '../Utilities/constants.dart';
import '../Widgets/buttons.dart';
import '../Widgets/scaffold.dart';
import '../database/userdata.dart';
import '../models/user.dart';
import '../utilities/helpers.dart';
import '../utilities/validation.dart';
import 'package:flutter/gestures.dart';

import '../widgets/form.dart';

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
    return CustomScaffold(
      body: FormContainer(title: "Get Started", formWidget: _form()),
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
            hintText: "Librarian ID",
            icon: Icons.perm_identity_outlined,
            inputController: libIdController,
            validator: (value) {
              return Validator.emptyValidator(value);
            },
          ),
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
              return Validator.emailValidator(value);
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
              _userValidation();
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
                        MaterialPageRoute(builder: (context) => LoginScreen()),
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

  void _userValidation() {
    FocusScope.of(context).unfocus();
    String message = "";
    if (_formKey.currentState!.validate()) {
      User user = User(
        name: userNameController.text,
        libId: libIdController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      bool result = UserDatabase.saveData(user: user);
      if (result) {
        UserDatabase.setRegisterValue(true);
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            curve: Curves.easeIn,
            child: LoginScreen(),
            duration: Duration(milliseconds: 300),
          ),
        );
        message = "Account created!";
      } else {
        message = "Something went wrong. Try again";
      }
      showSnackBar(text: message, context: context);
    }
  }
}
