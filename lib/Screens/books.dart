import 'package:flutter/material.dart';
import 'package:libry/Screens/register.dart';
import '../Database/userdata.dart';

class BooksScreen extends StatefulWidget {
  BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Books screen"),
            ElevatedButton(onPressed: () {
              UserData.clearData();
              UserData.setRegisterValue(false);
              UserData.setLogValue(false);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>RegisterScreen()));
            }, child: Text("Sign out")),
          ],
        ),
      ),
    );
  }
}
