// lib/screens/issue_history_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../models/books_model.dart';
import '../../../models/issue_records_model.dart';
import '../../../models/members_model.dart';
import '../../../provider/book_provider.dart';
import '../../../provider/issue_provider.dart';
import '../../../provider/members_provider.dart';
import '../../../widgets/layout_widgets.dart';

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
    final bookProvider = context.read<BookProvider>();
    final memberProvider = context.read<MembersProvider>();

    // Get all issues and apply filter
    final allIssues = issueProvider.allIssues;
    final filteredIssues = _applyFilter(allIssues, issueProvider);

    // Calculate stats
    final totalIssues = allIssues.length;
    final activeIssues = allIssues.where((i) => !i.isReturned).length;
    final returnedIssues = allIssues.where((i) => i.isReturned).length;
    final overdueIssues = allIssues.where((i) =>
    !i.isReturned && DateTime.now().isAfter(i.dueDate)
    ).length;

    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(
        barTitle: 'All Transactions',
        context: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stats Cards
            _buildStatsCards(totalIssues, activeIssues, returnedIssues, overdueIssues),

            // Filter Chips
            _buildFilterChips(totalIssues, activeIssues, returnedIssues, overdueIssues),

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
                  return _buildIssueCard(issue, book, member, issueProvider);
                },
              ),
            ),
          ],
        ),
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

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
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
      selectedColor: MyColors.bgColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildIssueCard(IssueRecords issue, Books? book, Members? member, IssueProvider issueProvider) {
    final isOverdue = !issue.isReturned && DateTime.now().isAfter(issue.dueDate);
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
            // Book and Member Info Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: MyColors.bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.book, color: Colors.white),
                ),
                SizedBox(width: 12),
                // Book and Member Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book?.title ?? 'Unknown Book',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'by ${book?.author ?? 'Unknown Author'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              member?.name ?? 'Unknown Member',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
            // Row 1: Issue ID and Borrow Date
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Issue ID',
                    issue.issueId,
                    Icons.tag,
                  ),
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

            // Row 2: Due Date and Status
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

            // Row 3: Book ID and Member ID
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
                            '₹${fine.toStringAsFixed(2)}',
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
                  // Return Button (if not returned)
                  if (!issue.isReturned)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _returnBook(issue),
                        icon: Icon(Icons.assignment_return, size: 18),
                        label: Text('Return Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryButtonColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                  if (!issue.isReturned) SizedBox(width: 8),

                  // View Details Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewDetails(issue, book, member),
                      icon: Icon(Icons.remove_red_eye, size: 18),
                      label: Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MyColors.bgColor,
                        side: BorderSide(color: MyColors.bgColor),
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
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<IssueRecords> _applyFilter(List<IssueRecords> issues, IssueProvider issueProvider) {
    switch (_filter) {
      case 'active':
        return issues.where((i) => !i.isReturned).toList();
      case 'returned':
        return issues.where((i) => i.isReturned).toList();
      case 'overdue':
        return issues.where((i) =>
        !i.isReturned && DateTime.now().isAfter(i.dueDate)
        ).toList();
      default:
        return issues;
    }
  }

  void _setFilter(String filter) {
    setState(() => _filter = filter);
  }

  Future<void> _returnBook(IssueRecords issue) async {
    try {
      final issueProvider = context.read<IssueProvider>();
      final bookProvider = context.read<BookProvider>();
      final memberProvider = context.read<MembersProvider>();

      // 1. Mark as returned in Hive
      await issueProvider.returnBook(issue.issueId);

      // 2. Update book in SQLite
      final book = bookProvider.getBookById(issue.bookId);
      if (book != null) {
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
      }

      // 3. Update member in SQLite
      final member = memberProvider.getMemberById(issue.memberId);
      if (member != null) {
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
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book returned successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Refresh the UI
      setState(() {});

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewDetails(IssueRecords issue, Books? book, Members? member) {
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
                _buildDetailRow('Title', book?.title ?? 'Unknown'),
                _buildDetailRow('Author', book?.author ?? 'Unknown'),
                _buildDetailRow('Book ID', 'B${issue.bookId.toString().padLeft(3, '0')}'),
              ]),

              SizedBox(height: 16),

              // Member Details
              _buildDetailSection('Member Information', [
                _buildDetailRow('Name', member?.name ?? 'Unknown'),
                _buildDetailRow('Member ID', 'M${issue.memberId.toString().padLeft(3, '0')}'),
                _buildDetailRow('Phone', member?.phone ?? 'N/A'),
              ]),

              SizedBox(height: 16),

              // Transaction Details
              _buildDetailSection('Transaction Details', [
                _buildDetailRow('Issue ID', issue.issueId),
                _buildDetailRow('Borrow Date', _formatDate(issue.borrowDate)),
                _buildDetailRow('Due Date', _formatDate(issue.dueDate)),
                _buildDetailRow('Status', issue.isReturned ? 'Returned' : 'Active'),
                if (issue.isReturned)
                  _buildDetailRow('Return Date', _formatDate(issue.returnDate!)),
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
            color: MyColors.bgColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MyColors.darkGrey),
          ),
          child: Column(
            children: children,
          ),
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
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
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