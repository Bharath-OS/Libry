import 'package:flutter/material.dart';
import 'package:libry/features/auth/view/register.dart';
import 'package:libry/features/auth/view_models/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import '../../home/main_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    bool isLoading = context.watch<AuthViewModel>().isLoading;
    return LayoutWidgets.customScaffold(
      body: FormWidgets.formContainer(
        title: "Welcome Back",
        formWidget: _form(isLoading),
      ),
    );
  }

  Widget _form(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 25,
        children: [
          AppTextField.customTextField(
            label: "Email",
            controller: emailController,
            validator: (value) {
              return Validator.emailValidator(value);
            },
          ),
          AppTextField.customTextField(
            label: "Password",
            controller: passwordController,
            isObscure: true,
            validator: (value) {
              return Validator.passwordValidator(value);
            },
          ),
          Selector<AuthViewModel, bool>(
            selector: (_, auth) => auth.isLoading,
            builder: (_, isLoading, __) {
              return MyButton.primaryButton(
                method: () => validateLogin(),
                text: isLoading ? "Processing..." : "Login",
              );
            },
          ),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: AppColors.white),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        transition(child: RegisterView()),
                      );
                    },
                  text: "Register",
                  style: TextStyle(
                    color: AppColors.primaryButton,
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

  void validateLogin() {
    String? message;
    if (_formKey.currentState!.validate()) {
      message = context.read<AuthViewModel>().loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (message == null) {
        message = "Welcome back!";
        Navigator.pushReplacement(context, transition(child: MainScreen()));
      } else {
        message = "Invalid Credentials!";
      }
      showSnackBar(text: message, context: context);
    }
  }
}
