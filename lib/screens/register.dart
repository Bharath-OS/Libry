import 'package:flutter/material.dart' hide Key;
import 'package:libry/Database/userdata.dart';
import 'package:libry/Screens/login.dart';
import 'package:libry/Widgets/glassmorphism.dart';
import 'package:libry/Widgets/textField.dart';
import 'package:page_transition/page_transition.dart';

import '../Widgets/buttons.dart';
import '../models/user.dart';
import '../models/Keys/keys.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final libIdController;
  late final userNameController;
  late final emailController;
  late final passwordController;
  final _formKey = GlobalKey<FormState>();
  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  final RegExp _passwordExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
  late Map<String, String> userDataMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    libIdController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    libIdController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/splashBG.png', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: GlassMorphism(
                borderRadius: 50,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 25,
                      children: [
                        Text(
                          "Get Started",
                          style: TextStyle(
                            color: Color(0xffC1DCFF),
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        customTextField(
                          hintText: "Librarian ID",
                          icon: Icons.perm_identity_outlined,
                          inputController: libIdController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == " ") {
                              return "Field cannot be empty";
                            } else if (value.length > 6) {
                              return "Id should be less than 6 characters";
                            }
                            return null;
                          },
                        ),
                        customTextField(
                          hintText: "Full name",
                          icon: Icons.person_outlined,
                          inputController: userNameController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == " ") {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                        ),
                        customTextField(
                          hintText: "Email",
                          icon: Icons.email_outlined,
                          inputController: emailController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value == " ") {
                              return "Field cannot be empty";
                            } else if (!_emailRegExp.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        customTextField(
                          hintText: "Password",
                          icon: Icons.password_outlined,
                          isObscure: true,
                          inputController: passwordController,
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

                              bool result = await UserData.saveData(
                                userdata: userDataMap,
                              );
                              String message;
                              FocusScope.of(context).unfocus();
                              if (result) {
                                message = "Account created!";
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    curve: Curves.easeIn,
                                    child: LoginScreen(),
                                    duration: Duration(milliseconds: 300),
                                  ),
                                );
                              } else {
                                message = "Something went wrong. Try again";
                              }
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(message)));
                              print(userDataMap);
                              await UserData.setLogValue(result);
                            } else {}
                          },
                          text: "Register",
                        ),
                        MyButton.secondaryButton(
                          method: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          ),
                          text: "Go to Login",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: bottomNavBar(selected: null, method: (int? index) {  }),
    );
  }
}
