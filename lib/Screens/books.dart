import 'package:flutter/material.dart';

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
      body: Center(child: Text("Books screen")),
      bottomNavigationBar: bottomNavBar(
        selected: currentIndex,
        method: (int? index) {
          setState(() {
            currentIndex = index!;
          });
        },
      ),
    );
  }
}
