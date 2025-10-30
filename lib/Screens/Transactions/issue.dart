import 'package:flutter/material.dart';

class IssueBookScreen extends StatefulWidget {
  const IssueBookScreen({super.key});

  @override
  State<IssueBookScreen> createState() => _IssueBookScreenState();
}

class _IssueBookScreenState extends State<IssueBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Issue Book Page"), centerTitle: true),
      body: Center(child: Text("Issue Book Screen")),
    );
  }
}
