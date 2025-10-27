import 'package:flutter/material.dart';
import 'package:libry/Widgets/buttons.dart';
import 'package:libry/Widgets/glassmorphism.dart';
import 'package:libry/Widgets/textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color formTitleColor = const Color(0xffC1DCFF);

  final Color formBgColor = const Color(0xff0D3868);
  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late Map<String, String> userDataMap;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formTitleColor,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/splashBG.png', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: GlassMorphism(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 30,
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Livvic",
                        fontWeight: FontWeight.bold,
                        color: formTitleColor,
                      ),
                    ),
                    Form(
                      child: Column(
                        spacing: 25,
                        children: [
                          customTextField(
                            hintText: "email",
                            icon: Icons.email_outlined,
                            inputController: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!_emailRegExp.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null; // input is valid
                            },
                          ),
                          customTextField(
                            hintText: "Password",
                            icon: Icons.password_outlined,
                            inputController: passwordController,
                            isObscure: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field cannot be empty";
                              } else if (value.length <= 5) {
                                return "Password should atleast have 6 characters";
                              }
                              return null;
                            },
                          ),
                          MyButton.primaryButton(method: () {}, text: "Login"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
