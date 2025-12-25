import 'package:flutter/material.dart';
import 'package:libry/features/auth/view/login.dart';
import 'package:libry/features/home/main_screen.dart';
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
import '../data/model/user_model.dart';

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
          AppTextField.customTextField(
            label: "Full name",
            controller: userNameController,
            validator: (value) {
              return Validator.emptyValidator(value);
            },
          ),
          AppTextField.customTextField(
            label: "Email",
            controller: emailController,
            validator: (value) {
              return Validator.registerEmailValidator(value);
            },
          ),
          AppTextField.customTextField(
            label: "Password",
            isObscure: true,
            controller: passwordController,
            validator: (value) {
              return Validator.passwordValidator(value);
            },
          ),
          Selector<AuthViewModel, bool>(
            selector: (_, auth) => auth.isLoading,
            builder: (_, isLoading, __) {
              return MyButton.primaryButton(
                method: () {
                  userValidation(
                    formKey: _formKey,
                    controllers: [
                      userNameController,
                      emailController,
                      passwordController,
                    ],
                  );
                },
                text: isLoading ? "Validating" : "Register",
              );
            },
          ),
          RichText(
            text: TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: AppColors.white),
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

  void userValidation({
    required GlobalKey<FormState> formKey,
    required List<TextEditingController> controllers,
  }) {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      String? message;
      final UserModel user = UserModel(
        name: controllers[0].text.trim(),
        email: controllers[1].text.trim(),
        password: controllers[2].text.trim(),
      );
      message = context.read<AuthViewModel>().registerUser(
        user: user,
        context: context,
      );
      if (message == null) {
        Navigator.push(context, transition(child: MainScreen()));
        message = "Account created!";
      }
      showSnackBar(text: message, context: context);
    }
  }
}
