import 'package:flutter/material.dart';
import 'package:libry/Widgets/buttons.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});
  //TODO: Add the back button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          width: 150,
          height: 50,
          child: MyButton.backButton(
            method: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Center(child: Text("Books details")),
    );
  }
}
