import 'package:flutter/material.dart';
import 'package:libry/Screens/login.dart';
import 'package:libry/Screens/register.dart';
import 'package:libry/Utilities/constants.dart';
import 'package:libry/Widgets/appbar.dart';
import 'package:libry/Widgets/buttons.dart';

import '../../../Database/userdata.dart';
import '../../../Widgets/scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, String>? userData = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    userData = await UserData.getData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: LibryAppBar.appBar(barTitle: "User Profile", context: context),
      body: userData == null
          ? Center(child: Text("No data"))
          : Padding(
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
                                    text: "${userData?["Username"]}\n",
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
                                        "Librarian ID : ${userData?["LibId"]}\n",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Livvic",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      height: 2,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Email : ${userData?["Email"]}\n",
                                      ),
                                      TextSpan(text: "Book Issued : 123\n"),
                                      TextSpan(text: "Fine collected : 55\$"),
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
            ),
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyButton.secondaryButton(method: () {}, text: "Edit Profile"),
        const SizedBox(height: 10),
        MyButton.primaryButton(
          method: () async {
            await UserData.clearData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => RegisterScreen()),
            );
          },
          text: "Sign out",
        ),
      ],
    );
  }
}
