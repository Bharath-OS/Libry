import 'package:flutter/material.dart';
import 'package:libry/Utilities/constants.dart';
import 'package:libry/Widgets/glassmorphism.dart';

import '../../Widgets/buttons.dart';
import '../../Widgets/scaffold.dart';

class IssueBookScreen extends StatefulWidget {
  const IssueBookScreen({super.key});

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text("Issue Book"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: GlassMorphism(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Verify Member", textAlign: TextAlign.center),
                  Text("Enter the member ID to verify the member."),
                  TextFormField(),
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
