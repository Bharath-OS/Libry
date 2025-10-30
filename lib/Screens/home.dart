import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Good Morning, Bharath OS\nThursday 16, Oct 2025"),
                    CircleAvatar()
                  ],
                ),
              ),
              Expanded(flex: 2, child: Container(color: Colors.blue)),
              Expanded(flex: 2, child: Container(color: Colors.yellow)),
              Expanded(flex: 2, child: Container(color: Colors.orange)),
            ],
          ),
        ),
      ),
    );
  }
}
