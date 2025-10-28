import 'package:flutter/material.dart';
import 'package:libry/Models/userdata.dart';

import '../Widgets/bottom_navbar.dart';

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
            }, child: Text("Sign out")),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}
