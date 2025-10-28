import 'package:flutter/material.dart';
import 'package:libry/Screens/settings.dart';
import 'package:libry/Widgets/bottom_navbar.dart';

import 'books.dart';
import 'home.dart';
import 'members.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    BooksScreen(),
    MembersScreen(),
    TransactionsScreen(),
    SettingsScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Transactions Page")),
    );
  }
}
