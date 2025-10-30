import 'package:flutter/material.dart';

import 'Transactions/issue.dart';
import 'Transactions/return.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IssueBookScreen()),
                  ),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Issue Book",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Livvic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ReturnBookScreen())),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Return Book",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Livvic",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
