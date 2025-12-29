// lib/screens/issue_history_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utilities/helpers.dart';
import '../../core/widgets/layout_widgets.dart';
import 'data/service/issue_records_db.dart';
import '../books/data/model/books_model.dart';
import 'data/model/issue_records_model.dart';
import '../members/data/model/members_model.dart';
import '../books/viewmodel/book_provider.dart';
import 'viewmodel/issue_provider.dart';
import '../members/viewmodel/members_provider.dart';
import 'issue.dart';

class IssueHistoryScreen extends StatefulWidget {
  const IssueHistoryScreen({super.key});

  @override
  State<IssueHistoryScreen> createState() => _IssueHistoryScreenState();
}

class _IssueHistoryScreenState extends State<IssueHistoryScreen> {
  String _filter = 'all'; // 'all', 'active', 'returned', 'overdue'

  @override
  Widget build(BuildContext context) {
    final issueProvider = context.watch<IssueProvider>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersProvider>();

    // Get all issues and apply filter
    final allIssues = issueProvider.allIssues;
    final filteredIssues = _applyFilter(allIssues, issueProvider);

    // Calculate stats
    final totalIssues = allIssues.length;
    final activeIssues = allIssues.where((i) => !i.isReturned).length;
    final returnedIssues = allIssues.where((i) => i.isReturned).length;
    final overdueIssues = allIssues
        .where((i) => !i.isReturned && DateTime.now().isAfter(i.dueDate))
        .length;

    return LayoutWidgets.customScaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stats Cards
            _buildStatsCards(
              totalIssues,
              activeIssues,
              returnedIssues,
              overdueIssues,
            ),

            // Filter Chips
            _buildFilterChips(
              totalIssues,
              activeIssues,
              returnedIssues,
              overdueIssues,
            ),

            // Issues List
            Expanded(
              child: filteredIssues.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No transactions found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredIssues.length,
                itemBuilder: (context, index) {
                  final issue = filteredIssues[index];
                  final book = bookProvider.getBookById(issue.bookId);
                  final member = memberProvider.getMemberById(issue.memberId);
                  return _buildIssueCard(
                    issue,
                    book,
                    member,
                    issueProvider,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: Text("Issue Book"),
        onPressed: () =>
            Navigator.push(context, transition(child: IssueBookScreen())),
      ),
    );
  }

  Widget _buildStatsCards(int total, int active, int returned, int overdue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              total.toString(),
              Colors.blue,
              Icons.all_inclusive,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Active',
              active.toString(),
              Colors.orange,
              Icons.book_online,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Returned',
              returned.toString(),
              Colors.green,
              Icons.check_circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Overdue',
              overdue.toString(),
              Colors.red,
              Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label,
      String value,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildFilterChips(int total, int active, int returned, int overdue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all', total),
            SizedBox(width: 8),
            _buildFilterChip('Active', 'active', active),
            SizedBox(width: 8),
            _buildFilterChip('Returned', 'returned', returned),
            SizedBox(width: 8),
            _buildFilterChip('Overdue', 'overdue', overdue),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => _setFilter(value),
      backgroundColor: Colors.grey[200],
      selectedColor: AppColors.background,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildIssueCard(
      IssueRecords issue,
      Books? book,
      Members? member,
      IssueProvider issueProvider,
      ) {
    final isOverdue = !issue.isReturned && DateTime.now().isAfter(issue.dueDate);
    final fine = issueProvider.calculateFine(issue);

    // Use stored names if available, otherwise try to get from database
    // If both fail, show as "Deleted"
    final bookTitle = book?.title ?? issue.bookName ?? 'Deleted Book';
    final bookAuthor = book?.author ?? 'Unknown Author';
    final memberName = member?.name ?? issue.memberName ?? 'Deleted Member';
    final isBookDeleted = book == null;
    final isMemberDeleted = member == null;

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
            // Deleted Items Warning (if any)
            if (isBookDeleted || isMemberDeleted)
              Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, size: 16, color: Colors.orange),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Book and Member Info Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isBookDeleted
                        ? Colors.grey
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isBookDeleted ? Icons.book_outlined : Icons.book,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                // Book and Member Details
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
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'by $bookAuthor',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            isMemberDeleted
                                ? Icons.person_off_outlined
                                : Icons.person_outline,
                            size: 14,
                            color: isMemberDeleted
                                ? Colors.grey
                                : AppColors.darkGrey,
                          ),
                          SizedBox(width: 4),
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
                                    : Colors.black,
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
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: issue.isReturned
                        ? Colors.green
                        : isOverdue
                        ? Colors.red
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    issue.isReturned
                        ? 'Returned'
                        : isOverdue
                        ? 'Overdue'
                        : 'Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 8),

            // Transaction Details
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('Issue ID', issue.issueId, Icons.tag),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Borrowed',
                    _formatDate(issue.borrowDate),
                    Icons.calendar_today,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Due Date',
                    _formatDate(issue.dueDate),
                    Icons.event,
                  ),
                ),
                Expanded(
                  child: issue.isReturned
                      ? _buildInfoItem(
                    'Returned',
                    _formatDate(issue.returnDate!),
                    Icons.check_circle,
                  )
                      : _buildInfoItem(
                    'Days Left',
                    '${max(0, issue.dueDate.difference(DateTime.now()).inDays)}',
                    Icons.access_time,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Book ID',
                    'B${issue.bookId.toString().padLeft(3, '0')}',
                    Icons.bookmark,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Member ID',
                    'M${issue.memberId.toString().padLeft(3, '0')}',
                    Icons.badge,
                  ),
                ),
              ],
            ),

            // Fine Info (if applicable)
            if (fine > 0)
              Container(
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overdue Fine',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Rs $fine',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  // Return Button (only if book exists and not returned)
                  if (!issue.isReturned && !isBookDeleted)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _returnBook(issue),
                        icon: Icon(Icons.assignment_return, size: 18),
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

                  if (!issue.isReturned && !isBookDeleted) SizedBox(width: 8),

                  // View Details Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewDetails(issue, book, member),
                      icon: Icon(Icons.remove_red_eye, size: 18),
                      label: Text('Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.background,
                        side: BorderSide(color: AppColors.background),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.darkGrey),
        SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: AppColors.darkGrey),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<IssueRecords> _applyFilter(
      List<IssueRecords> issues,
      IssueProvider issueProvider,
      ) {
    switch (_filter) {
      case 'active':
        return issues.where((i) => !i.isReturned).toList();
      case 'returned':
        return issues.where((i) => i.isReturned).toList();
      case 'overdue':
        return issues
            .where((i) => !i.isReturned && DateTime.now().isAfter(i.dueDate))
            .toList();
      default:
        return issues;
    }
  }

  void _setFilter(String filter) {
    setState(() => _filter = filter);
  }

  Future<void> _returnBook(IssueRecords issue) async {
    final issueProvider = context.read<IssueProvider>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersProvider>();

    final fine = issueProvider.calculateFine(issue);

    // Check if book and member still exist
    final book = bookProvider.getBookById(issue.bookId);
    final member = memberProvider.getMemberById(issue.memberId);

    if (book == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot return: Book has been deleted'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (member == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot return: Member has been deleted'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (fine > 0) {
      final confirmed = await _showFinePaymentDialog(fine);
      if (!confirmed) return;
      await _payFine(issue, fine, member);
    }

    // Process return
    try {
      // 1. Mark as returned in Hive
      await issueProvider.returnBook(issue.issueId);

      // 2. Update book copies
      final updatedBook = Books(
        id: book.id,
        title: book.title,
        author: book.author,
        year: book.year,
        language: book.language,
        publisher: book.publisher,
        genre: book.genre,
        pages: book.pages,
        totalCopies: book.totalCopies,
        copiesAvailable: book.copiesAvailable + 1,
        coverPicture: book.coverPicture,
      );
      await bookProvider.updateBook(updatedBook);

      // 3. Update member borrow count
      final updatedMember = Members(
        id: member.id,
        memberId: member.memberId,
        name: member.name,
        email: member.email,
        phone: member.phone,
        address: member.address,
        fine: member.fine,
        totalBorrow: member.totalBorrow,
        currentlyBorrow: member.currentlyBorrow - 1,
        joined: member.joined,
        expiry: member.expiry,
      );
      await memberProvider.updateMember(updatedMember);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book returned successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error returning book: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _showFinePaymentDialog(int fine) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fine Payment Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Overdue fine: Rs $fine'),
            SizedBox(height: 16),
            Text('Please collect the fine before returning the book.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Fine Paid'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<void> _payFine(IssueRecords issue, int fine, Members member) async {
    final issueProvider = context.read<IssueProvider>();
    final memberProvider = context.read<MembersProvider>();

    // 1. Update issue with fine amount
    final updatedIssue = issue.copyWith(fineAmount: fine);
    await IssueDBHive.box.put(issue.issueId, updatedIssue);

    // 2. Update member's fine total
    final updatedMember = Members(
      id: member.id,
      memberId: member.memberId,
      name: member.name,
      email: member.email,
      phone: member.phone,
      address: member.address,
      totalBorrow: member.totalBorrow,
      currentlyBorrow: member.currentlyBorrow,
      fine: member.fine + fine,
      joined: member.joined,
      expiry: member.expiry,
    );
    await memberProvider.updateMember(updatedMember);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fine of Rs $fine recorded'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewDetails(IssueRecords issue, Books? book, Members? member) {
    final bookTitle = book?.title ?? issue.bookName ?? 'Deleted Book';
    final bookAuthor = book?.author ?? 'Unknown';
    final memberName = member?.name ?? issue.memberName ?? 'Deleted Member';
    final memberPhone = member?.phone ?? 'N/A';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Book Details
              _buildDetailSection('Book Information', [
                _buildDetailRow('Title', bookTitle),
                _buildDetailRow('Author', bookAuthor),
                _buildDetailRow(
                  'Book ID',
                  'B${issue.bookId.toString().padLeft(3, '0')}',
                ),
                if (book == null)
                  _buildDetailRow('Status', '⚠️ Book Deleted'),
              ]),

              SizedBox(height: 16),

              // Member Details
              _buildDetailSection('Member Information', [
                _buildDetailRow('Name', memberName),
                _buildDetailRow(
                  'Member ID',
                  'M${issue.memberId.toString().padLeft(3, '0')}',
                ),
                _buildDetailRow('Phone', memberPhone),
                if (member == null)
                  _buildDetailRow('Status', '⚠️ Member Deleted'),
              ]),

              SizedBox(height: 16),

              // Transaction Details
              _buildDetailSection('Transaction Details', [
                _buildDetailRow('Issue ID', issue.issueId),
                _buildDetailRow('Borrow Date', _formatDate(issue.borrowDate)),
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
                if (issue.fineAmount > 0)
                  _buildDetailRow('Fine', 'Rs ${issue.fineAmount}'),
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.background,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.darkGrey),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}