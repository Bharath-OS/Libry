import 'package:flutter/material.dart';
import 'package:libry/Utilities/constants.dart';
import 'package:libry/Widgets/buttons.dart';

import '../../../Database/userdata.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Map<String, String>? userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    userData = (await UserData.getData())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Column(
        children: [
          SizedBox(height: 140, width: double.infinity),
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(color: MyColors.bgColor),
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "${userData?["Username"]??"Guest"}\n",
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
                      MyButton.primaryButton(
                        method: () {},
                        text: "Edit Profile",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Librarian ID : ${userData?["LibId"]}\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Livvic",
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 2
                          ),
                          children: [
                            TextSpan(text: "Email : ${userData?["Email"]}\n"),
                            TextSpan(text: "Book Issued : 123\n"),
                            TextSpan(text: "Fine collected : 55\$")
                          ],
                        ),
                      ),
                      MyButton.secondaryButton(method: (){}, text: "Sign out")
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
