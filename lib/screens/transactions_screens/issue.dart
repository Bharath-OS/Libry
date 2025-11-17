import 'package:flutter/material.dart';
import 'package:libry/widgets/glassmorphism.dart';
import '../../widgets/buttons.dart';
import '../../widgets/scaffold.dart';

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
                spacing: 25,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Verify Member", textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyLarge,),
                  Text(
                    "Enter the member ID to verify the member.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Enter member id to verify")
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
