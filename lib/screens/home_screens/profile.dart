import 'package:flutter/material.dart';
import 'package:libry/Screens/login.dart';
import 'package:libry/Screens/register.dart';
import 'package:libry/constants/app_colors.dart';
import 'package:libry/Widgets/appbar.dart';
import 'package:libry/Widgets/buttons.dart';
import '../../../Widgets/scaffold.dart';
import '../../../database/userdata.dart';
import '../../../models/user_model.dart';
import '../../../utilities/helpers.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    user = UserDatabase.getData()?? User(name: '', email: '', password: '');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: LibryAppBar.appBar(barTitle: "User Profile", context: context),
      body: _buildProfile(),
    );
  }
  Widget _buildProfile(){
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: MyColors.whiteBG,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "${user.name}\n",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Lobster",
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              TextSpan(
                                text: "Librarian",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Livvic",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text:
                            "",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Livvic",
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              height: 2,
                            ),
                            children: [
                              TextSpan(
                                text: "Email : ${user.email}\n",
                              ),
                              TextSpan(text: "Book Issued : ${user.bookIssued}\n"),
                              TextSpan(text: "Fine collected : ${user.fineCollected}\$"),
                            ],
                          ),
                        ),
                        _buildActions(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyButton.secondaryButton(method: () {
          Navigator.push(
            context,
            transition(child: EditProfileScreen())
          );
        }, text: "Edit Profile"),
        const SizedBox(height: 10),
        MyButton.primaryButton(
          method: () {
            // UserDatabase.clearData();
            UserDatabase.setLogValue(false);
            Navigator.pushReplacement(
              context,
              transition(child: LoginScreen())
            );
          },
          text: "Sign out",
        ),
      ],
    );
  }
}
