import 'package:flutter/material.dart';
import 'package:libry/features/auth/view/login.dart';
import 'package:libry/features/auth/view/main_screen.dart';
import 'package:libry/features/auth/view_models/user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/auth_methods.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/utilities/validation.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/forms.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../../core/widgets/text_field.dart';
import 'package:flutter/gestures.dart';

import '../data/model/user_model.dart';
import '../data/services/userdata.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      body: FormWidgets.formContainer(
        title: "Get Started",
        formWidget: _form(),
      ),
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
                        transition(child: LoginView()),
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

  void userValidation({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required List<TextEditingController> controllers,
  }) {
    FocusScope.of(context).unfocus();
    String message = "";
    if (formKey.currentState!.validate()) {
      final UserModel user = UserModel(
        name: controllers[0].text.trim(),
        email: controllers[1].text.trim(),
        password: controllers[2].text.trim(),
      );
      bool isSuccess = context.read<AuthViewModel>().registerUser(
        user: user,
        context: context,
      );
      if (isSuccess) {
        Navigator.push(context, transition(child: MainScreen()));
        message = "Account created!";
      } else {
        message = "Something went wrong. Try again";
      }
      showSnackBar(text: message, context: context);
    }
  }
}
