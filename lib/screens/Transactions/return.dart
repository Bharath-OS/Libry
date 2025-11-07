import 'package:flutter/material.dart';
import 'package:libry/utilities/constants.dart';
import 'package:libry/Widgets/scaffold.dart';

import '../../Widgets/buttons.dart';
import '../../themes/styles.dart';

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
              color: MyColors.whiteBG,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                spacing: 20,
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
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MyColors.textFieldFillColor,
                      hintText: "Enter member id",
                      hintStyle: TextStyle(
                        color: MyColors.primaryButtonColor,
                        fontSize: 18,
                        fontFamily: "Livvic",
                        fontWeight: FontWeight.w600
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: MyColors.primaryButtonColor,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: MyColors.warningColor,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      )
                    ),
                  ),
                  MyButton.primaryButton(method: () {}, text: "Verify"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
