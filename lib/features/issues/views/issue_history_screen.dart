// Claude changed: This file has been updated to properly handle fine payment
// Key changes:
// 1. Fine payment now reduces member's fine balance
// 2. Fine is marked as paid using isFinePaid flag
// 3. Returned books can't be returned again
// 4. Fine calculation uses the new calculateFine logic

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:libry/core/widgets/issue_history_reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/helpers.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/layout_widgets.dart';
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
    final issueProvider = context.watch<IssueViewModel>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersViewModel>();

    final allIssues = issueProvider.allIssues.reversed.toList();
    final filteredIssues = _applyFilter(allIssues, issueProvider);

    final totalIssues = allIssues.length;
    final activeIssues = allIssues.where((i) => !i.isReturned).length;
    final returnedIssues = allIssues.where((i) => i.isReturned).length;
    final overdueIssues = allIssues
        .where((i) => calculateOverDue(dueDate: i.dueDate, isReturned: i.isReturned))
        .length;

    return LayoutWidgets.customScaffold(
      appBar: AppBar(
        title: Text(
          'All Transactions',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            IssueHistoryWidgets.buildStatsCards(
              total: totalIssues,
              active: activeIssues,
              returned: returnedIssues,
              overdue: overdueIssues,
            ),

            IssueHistoryWidgets.buildFilterChips(
              total: totalIssues,
              active: activeIssues,
              returned: returnedIssues,
              overdue: overdueIssues,
              currentFilter: _filter,
              onFilterChanged: _setFilter,
            ),

            Expanded(
              child: filteredIssues.isEmpty
                  ? IssueHistoryWidgets.buildEmptyState(
                      message: 'No transactions found',
                      showClearFilter: _filter != 'all',
                      onClearFilter: () => setState(() => _filter = 'all'),
                    )
                  : SizedBox(
                      // decoration: BoxDecoration(color: AppColors.background),
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredIssues.length,
                        itemBuilder: (context, index) {
                          final issue = filteredIssues[index];
                          final book = bookProvider.getBookById(issue.bookId!);
                          final member = memberProvider.getMemberById(
                            issue.memberId!,
                          );
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: _buildIssueCard(
                              issue,
                              book,
                              member,
                              issueProvider,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: MyButton.fab(
        onPressed: () =>
            Navigator.push(context, transition(child: IssueBookScreen())),
        label: 'Issue Book',
      ),
    );
  }

  Widget _buildIssueCard(
    IssueRecords issue,
    BookModel? book,
    MemberModel? member,
    IssueViewModel issueProvider,
  ) {
    final isOverdue = calculateOverDue(dueDate: issue.dueDate, isReturned: issue.isReturned);

    // Claude changed: Use calculateFine from provider for accurate calculation
    final fine = issueProvider.calculateFine(issue);

    final bookTitle = book?.title ?? issue.bookName ?? 'Deleted Book';
    final bookAuthor = book?.author ?? 'Unknown Author';
    final memberName = member?.name ?? issue.memberName ?? 'Deleted Member';
    final isBookDeleted = book == null;
    final isMemberDeleted = member == null;

    Color statusColor;
    String statusText;

    if (issue.isReturned) {
      statusColor = Colors.green;
      statusText = 'Returned';
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
    } else {
      statusColor = Colors.orange;
      statusText = 'Active';
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOverdue ? Colors.red : Colors.grey.shade200,
          width: isOverdue ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBookDeleted || isMemberDeleted)
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 18,
                      color: Colors.orange[800],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isBookDeleted && isMemberDeleted
                            ? 'Book and Member have been deleted'
                            : isBookDeleted
                            ? 'Book has been deleted'
                            : 'Member has been deleted',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isBookDeleted ? Colors.grey : AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).toInt()),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isBookDeleted ? Icons.book_outlined : Icons.book,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              bookTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: isBookDeleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isBookDeleted
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: statusColor.withAlpha(
                                    (0.3 * 255).toInt(),
                                  ),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'by $bookAuthor',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isMemberDeleted
                                  ? Icons.person_off_outlined
                                  : Icons.person_outline,
                              size: 14,
                              color: isMemberDeleted
                                  ? Colors.grey
                                  : Colors.blue[700],
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              memberName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: isMemberDeleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isMemberDeleted
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(color: Colors.grey[300], height: 1),
            SizedBox(height: 12),

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
                    value: _formatDate(issue.borrowDate),
                    icon: Icons.calendar_today,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: IssueHistoryWidgets.buildInfoItem(
                    label: 'Due Date',
                    value: _formatDate(issue.dueDate),
                    icon: Icons.event,
                  ),
                ),
                Expanded(
                  child: issue.isReturned
                      ? IssueHistoryWidgets.buildInfoItem(
                          label: 'Returned',
                          value: _formatDate(issue.returnDate!),
                          icon: Icons.check_circle,
                        )
                      : IssueHistoryWidgets.buildInfoItem(
                          label: 'Days Left',
                          value:
                              '${max(0, issue.dueDate.difference(DateTime.now()).inDays)}',
                          icon: Icons.access_time,
                        ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: IssueHistoryWidgets.buildInfoItem(
                    label: 'Book ID',
                    value: 'B${issue.bookId.toString().padLeft(3, '0')}',
                    icon: Icons.bookmark,
                  ),
                ),
                Expanded(
                  child: IssueHistoryWidgets.buildInfoItem(
                    label: 'Member ID',
                    value: 'M${issue.memberId.toString().padLeft(3, '0')}',
                    icon: Icons.badge,
                  ),
                ),
              ],
            ),

            // Claude changed: Show fine info with payment status
            if (fine > 0)
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: issue.isFinePaid != null && issue.isFinePaid!
                      ? Colors.green[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: issue.isFinePaid != null && issue.isFinePaid!
                        ? Colors.green[300]!
                        : Colors.red[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: issue.isFinePaid != null && issue.isFinePaid!
                            ? Colors.green[100]
                            : Colors.red[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        issue.isFinePaid != null && issue.isFinePaid!
                            ? Icons.check_circle
                            : Icons.money_off,
                        color: issue.isFinePaid != null && issue.isFinePaid!
                            ? Colors.green[700]
                            : Colors.red[700],
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue.isFinePaid != null && issue.isFinePaid!
                                ? 'Fine Paid'
                                : 'Overdue Fine',
                            style: TextStyle(
                              color:
                                  issue.isFinePaid != null && issue.isFinePaid!
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Rs $fine',
                            style: TextStyle(
                              color:
                                  issue.isFinePaid != null && issue.isFinePaid!
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  if (!issue.isReturned && !isBookDeleted)
                    Expanded(
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
                            if(mounted) {
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
                        icon: Icon(Icons.assignment_return, size: 18),
                        label: Text('Return Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                  if (!issue.isReturned && !isBookDeleted) SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewDetails(issue, book, member),
                      icon: Icon(Icons.remove_red_eye, size: 18),
                      label: Text('Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
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
            .where(
              (i) =>
                  !i.isReturned &&
                  DateUtils.dateOnly(
                    DateTime.now(),
                  ).isAfter(DateUtils.dateOnly(i.dueDate)),
            )
            .toList();
      default:
        return issues;
    }
  }

  void _setFilter(String filter) {
    setState(() => _filter = filter);
  }

  void _viewDetails(IssueRecords issue, BookModel? book, MemberModel? member) {
    final bookTitle = book?.title ?? issue.bookName ?? 'Deleted Book';
    final bookAuthor = book?.author ?? 'Unknown';
    final memberName = member?.name ?? issue.memberName ?? 'Deleted Member';
    final memberPhone = member?.phone ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Transaction Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Issue ID: ${issue.issueId}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),

                _buildDetailSection(
                  'Book Information',
                  Icons.book,
                  AppColors.primary,
                  [
                    _buildDetailRow('Title', bookTitle),
                    _buildDetailRow('Author', bookAuthor),
                    _buildDetailRow(
                      'Book ID',
                      'B${issue.bookId.toString().padLeft(3, '0')}',
                    ),
                    if (book == null)
                      _buildDetailRowWithIcon(
                        'Status',
                        '⚠️ Book Deleted',
                        Icons.warning,
                        Colors.orange,
                      ),
                  ],
                ),

                SizedBox(height: 20),

                _buildDetailSection(
                  'Member Information',
                  Icons.person,
                  Colors.blue,
                  [
                    _buildDetailRow('Name', memberName),
                    _buildDetailRow(
                      'Member ID',
                      'M${issue.memberId.toString().padLeft(3, '0')}',
                    ),
                    _buildDetailRow('Phone', memberPhone),
                    if (member == null)
                      _buildDetailRowWithIcon(
                        'Status',
                        '⚠️ Member Deleted',
                        Icons.warning,
                        Colors.orange,
                      ),
                  ],
                ),

                SizedBox(height: 20),

                _buildDetailSection(
                  'Transaction Details',
                  Icons.history,
                  Colors.purple,
                  [
                    _buildDetailRow('Issue ID', issue.issueId),
                    _buildDetailRow(
                      'Borrow Date',
                      _formatDate(issue.borrowDate),
                    ),
                    _buildDetailRow('Due Date', _formatDate(issue.dueDate)),
                    _buildDetailRow(
                      'Status',
                      issue.isReturned ? 'Returned' : 'Active',
                    ),
                    if (issue.isReturned)
                      _buildDetailRow(
                        'Return Date',
                        _formatDate(issue.returnDate!),
                      ),
                    // Claude changed: Show fine with payment status
                    if (issue.fineAmount > 0)
                      _buildDetailRowWithIcon(
                        'Fine Amount',
                        'Rs ${issue.fineAmount} ${issue.isFinePaid != null && issue.isFinePaid! ? "(Paid)" : "(Unpaid)"}',
                        issue.isFinePaid != null && issue.isFinePaid!
                            ? Icons.check_circle
                            : Icons.money_off,
                        issue.isFinePaid != null && issue.isFinePaid!
                            ? Colors.green
                            : Colors.red,
                      ),
                  ],
                ),

                SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    Color iconColor,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha((0.1 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithIcon(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
