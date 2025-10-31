import 'package:flutter/material.dart';
import 'package:libry/Widgets/scaffold.dart';

class ReturnBookScreen extends StatefulWidget {
  const ReturnBookScreen({super.key});

  @override
  State<ReturnBookScreen> createState() => _ReturnBookScreenState();
}

class _ReturnBookScreenState extends State<ReturnBookScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text("Issue Book Page"), centerTitle: true,backgroundColor: Colors.transparent,),
      body: Center(
        child: Text("Return Book Screen"),
      ),
    );
  }
}
