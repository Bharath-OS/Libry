import 'package:flutter/material.dart';
import 'package:libry/constants/app_colors.dart';
import 'package:libry/screens/transactions_screens/issue_screens/issue_history_screen.dart';import 'package:libry/widgets/layout_widgets.dart';

import 'transactions_screens/issue.dart';
import 'transactions_screens/return.dart';


class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  
  @override
  Widget build(BuildContext context){
    return LayoutWidgets.customScaffold(
      appBar: AppBar(title: Text("Book Transactions")),
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
                      color: MyColors.whiteBG,
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => IssueHistoryScreen()),
                  ),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: MyColors.whiteBG,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "View all Transactions",
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
