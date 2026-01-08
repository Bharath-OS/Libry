import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:libry/core/constants/app_colors.dart';
import 'package:libry/core/widgets/issue_history_reusable_widgets.dart';
import 'package:libry/features/books/data/model/books_model.dart';
import 'package:libry/features/books/viewmodel/book_provider.dart';
import 'package:libry/features/issues/data/model/issue_records_model.dart';
import 'package:libry/features/issues/viewmodel/issue_provider.dart';
import 'package:libry/features/members/viewmodel/members_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../data/model/members_model.dart';

class MemberHistoryScreen extends StatefulWidget {
  final String memberId;

  const MemberHistoryScreen({super.key, required this.memberId});

  @override
  State<MemberHistoryScreen> createState() => _MemberHistoryScreenState();
}

class _MemberHistoryScreenState extends State<MemberHistoryScreen> {
  String _filter = 'all'; // 'all', 'active', 'returned', 'overdue'

  void _setFilter(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final issueProvider = context.watch<IssueViewModel>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersViewModel>();

    final member = memberProvider.getMemberById(widget.memberId);
    if (member == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Member History')),
        body: Center(child: Text('Member not found')),
      );
    }

    // Get all issues for this member
    final allMemberIssues = issueProvider.allIssues
        .where((issue) => issue.memberId == widget.memberId)
        .toList();

    // Apply filter
    final filteredIssues = _applyFilter(allMemberIssues, issueProvider);

    // Calculate stats
    final totalIssues = allMemberIssues.length;
    final activeIssues = allMemberIssues.where((i) => !i.isReturned).length;
    final returnedIssues = allMemberIssues.where((i) => i.isReturned).length;
    final overdueIssues = allMemberIssues
        .where((i) =>
            !i.isReturned &&
            DateUtils.dateOnly(DateTime.now())
                .isAfter(DateUtils.dateOnly(i.dueDate)))
        .length;

    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(
        barTitle: 'Member Borrow History',
        context: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Member Info Header
            _buildMemberHeader(member, activeIssues),

            // Stats Cards - Using Reusable Widget
            IssueHistoryWidgets.buildStatsCards(
              total: totalIssues,
              active: activeIssues,
              returned: returnedIssues,
              overdue: overdueIssues,
            ),

            // Filter Chips - Using Reusable Widget
            IssueHistoryWidgets.buildFilterChips(
              total: totalIssues,
              active: activeIssues,
              returned: returnedIssues,
              overdue: overdueIssues,
              currentFilter: _filter,
              onFilterChanged: _setFilter,
            ),

            // Issues List
            Expanded(
              child: filteredIssues.isEmpty
                  ? IssueHistoryWidgets.buildEmptyState(
                      message: 'No transactions found',
                      showClearFilter: _filter != 'all',
                      onClearFilter: () => setState(() => _filter = 'all'),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredIssues.length,
                      itemBuilder: (context, index) {
                        final issue = filteredIssues[index];
                        final book = bookProvider.getBookById(issue.bookId!);
                        return _buildIssueCard(issue, book, issueProvider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberHeader(MemberModel member, int activeIssues) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: AppColors.background, size: 35),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Member ID: ${member.memberId}',
                  style: TextStyle(color: AppColors.darkGrey, fontSize: 14),
                ),
                Text(
                  'Currently Borrowed: $activeIssues/5',
                  style: TextStyle(color: AppColors.darkGrey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(
    IssueRecords issue,
    BookModel? book,
    IssueViewModel issueProvider,
  ) {
    final isOverdue =
        !issue.isReturned && DateUtils.dateOnly(DateTime.now()).isAfter(DateUtils.dateOnly(issue.dueDate));
    final fine = issueProvider.calculateFine(issue);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOverdue ? Colors.red : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Info
            Row(
              children: [
                Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.background.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: () {
                    final coverData = book?.coverPictureData;
                    if (coverData != null && coverData.isNotEmpty) {
                      return Image.memory(coverData, fit: BoxFit.cover);
                    }
                    return Icon(Icons.book, color: AppColors.primary);
                  }(),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book?.title ?? issue.bookName!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'by ${book?.author ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge - Using Reusable Widget
                IssueHistoryWidgets.buildStatusBadge(
                  isReturned: issue.isReturned,
                  isOverdue: isOverdue,
                ),
              ],
            ),

            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 8),

            // Issue Details - Using Reusable Widget
            Row(
              children: [
                Expanded(
                  child: IssueHistoryWidgets.buildInfoItem(
                    label: 'Issue ID',
                    value: issue.issueId,
                    icon: Icons.tag,
                  ),
                ),
                Expanded(
                  child: IssueHistoryWidgets.buildInfoItem(
                    label: 'Borrowed',
                    value: IssueHistoryWidgets.formatDate(issue.borrowDate),
                    icon: Icons.calendar_today,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: IssueHistoryWidgets.buildInfoItem(
                    label: 'Due Date',
                    value: IssueHistoryWidgets.formatDate(issue.dueDate),
                    icon: Icons.event,
                  ),
                ),
                Expanded(
                  child: issue.isReturned
                      ? IssueHistoryWidgets.buildInfoItem(
                          label: 'Returned',
                          value: IssueHistoryWidgets.formatDate(
                            issue.returnDate!,
                          ),
                          icon: Icons.check_circle,
                        )
                      : IssueHistoryWidgets.buildInfoItem(
                          label: 'Days Left',
                          value:
                              '${issue.dueDate.difference(DateTime.now()).inDays}',
                          icon: Icons.access_time,
                        ),
                ),
              ],
            ),

            // Fine Info - Using Reusable Widget
            if (fine > 0) IssueHistoryWidgets.buildFineWarning(fine: fine),

            // Return Button (if not returned)
            if (!issue.isReturned)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      bool isSuccess = await IssueHistoryWidgets.returnBook(
                        issue: issue,
                        context: context,
                      );
                      if (mounted && isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Book returned successfully'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error returning book'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.assignment_return),
                    label: Text('Return Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<IssueRecords> _applyFilter(
    List<IssueRecords> issues,
    IssueViewModel issueProvider,
  ) {
    switch (_filter) {
      case 'active':
        return issues.where((i) => !i.isReturned).toList();
      case 'returned':
        return issues.where((i) => i.isReturned).toList();
      case 'overdue':
        return issues
            .where((i) =>
                !i.isReturned &&
                DateUtils.dateOnly(DateTime.now())
                    .isAfter(DateUtils.dateOnly(i.dueDate)))
            .toList();
      default: // 'all'
        return issues;
    }
  }
}
