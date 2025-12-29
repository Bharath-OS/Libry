// lib/screens/issue_history_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../data/service/issue_records_db.dart';
import '../../books/data/model/books_model.dart';
import '../data/model/issue_records_model.dart';
import '../../members/data/model/members_model.dart';
import '../../books/viewmodel/book_provider.dart';
import '../viewmodel/issue_provider.dart';
import '../../members/viewmodel/members_provider.dart';
import 'issue.dart';

class IssueHistoryScreen extends StatefulWidget {
  const IssueHistoryScreen({super.key});

  @override
  State<IssueHistoryScreen> createState() => _IssueHistoryScreenState();
}

class _IssueHistoryScreenState extends State<IssueHistoryScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final issueProvider = context.watch<IssueProvider>();

    // 1. Get filtered list
    final filteredIssues = issueProvider.allIssues.where((issue) {
      if (_filter == 'active') return issue.returnDate == null;
      if (_filter == 'returned') return issue.returnDate != null;
      if (_filter == 'overdue') return issue.returnDate == null && issue.dueDate.isBefore(DateTime.now());
      return true;
    }).toList();

    // 2. Prepare Stats
    final stats = {
      'Total': issueProvider.allIssues.length,
      'Active': issueProvider.activeCount,
      'Overdue': issueProvider.overDueCount,
    };

    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Issue History", context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 100), // Spacing for transparent AppBar
            HistorySharedWidgets.buildStatsHeader(stats: stats, primaryColor: AppColors.primary),
            const SizedBox(height: 16),
            HistorySharedWidgets.buildFilterBar(
              currentFilter: _filter,
              onFilterChanged: (val) => setState(() => _filter = val),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredIssues.length,
                itemBuilder: (context, index) {
                  return Cards.historyCard(
                    issue: filteredIssues[index],
                    context: context,
                    onReturn: () => _handleReturn(filteredIssues[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleReturn(IssueRecords issue) {
    // Your return logic here...
  }
}