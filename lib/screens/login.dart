import 'package:flutter/material.dart';
import 'package:libry/Screens/books.dart';
import 'package:libry/Screens/main_screen.dart';
import 'package:libry/Screens/register.dart';
import 'package:libry/Widgets/buttons.dart';
import 'package:libry/Widgets/glassmorphism.dart';
import 'package:libry/Widgets/textField.dart';
import 'package:libry/main.dart';
import 'package:page_transition/page_transition.dart';

import '../Database/userdata.dart';
import 'home.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                      key: _formKey,
                      child: Column(
                        spacing: 25,
                        children: [
                          customTextField(
                            hintText: "Email",
                            icon: Icons.email_outlined,
                            inputController: emailController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == " ") {
                                return 'Please enter your email';
                              } else if (!_emailRegExp.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          customTextField(
                            hintText: "Password",
                            icon: Icons.password_outlined,
                            inputController: passwordController,
                            isObscure: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == " ") {
                                return "Field cannot be empty";
                              } else if (value.length <= 5) {
                                return "Password should atleast have 6 characters";
                              }
                              return null;
                            },
                          ),
                          MyButton.primaryButton(
                            method: () async {
                              if (_formKey.currentState!.validate()) {
                                bool? isLogged =
                                    await UserData.isLogged ?? false;
                                //TODO: Verify this line later
                                // if (isLogged) {
                                //   Navigator.pushReplacement(
                                //     context,
                                //     PageTransition(
                                //       type: PageTransitionType.fade,
                                //       curve: Curves.easeIn,
                                //       child: BooksScreen(),
                                //       duration: Duration(milliseconds: 300),
                                //     ),
                                //   );
                                // }
                                final Map<String, String>? userData =
                                    await UserData.getData();
                                bool? result = await validateUser(userData);
                                if (result == true) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Logged In Successfully!"),
                                    ),
                                  );
                                } else if (result == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Incorrect credentials!"),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Something went wrong. Please Try Again!",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            text: "Login",
                          ),
                          MyButton.secondaryButton(
                            method: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            ),
                            text: "Go to register",
                          ),
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

  Future<bool?> validateUser(Map<String, String>? userData) async {
    if (userData == null || userData.isEmpty) {
      return null;
    } else {
      String? userEmail = userData?["email"] ?? "";
      String? password = userData?["password"] ?? "";
      if (userEmail == emailController.text &&
          password == passwordController.text) {
        await UserData.setLogValue(true);
        return true;
      }
    }
    return false;
  }
}
