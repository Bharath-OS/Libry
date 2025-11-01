import 'package:flutter/material.dart';
import 'package:libry/Utilities/constants.dart';
import 'package:libry/Widgets/scaffold.dart';

import '../../Widgets/buttons.dart';

class ReturnBookScreen extends StatefulWidget {
  const ReturnBookScreen({super.key});

  @override
  State<ReturnBookScreen> createState() => _ReturnBookScreenState();
}

class _ReturnBookScreenState extends State<ReturnBookScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text("Issue Book Page"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: MyColors.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Verify Member",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Livvic",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text("Enter the member ID to verify the member."),
                  MyButton.primaryButton(method: (){}, text: "Verify")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
