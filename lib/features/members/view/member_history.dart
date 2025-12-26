import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../books/data/model/books_model.dart';
import '../../../models/issue_records_model.dart';
import '../../books/viewmodel/book_provider.dart';
import '../data/model/members_model.dart';
import '../../../provider/issue_provider.dart';
import '../../../provider/members_provider.dart';

class MemberHistoryScreen extends StatefulWidget {
  final int memberId;

  const MemberHistoryScreen({super.key, required this.memberId});

  @override
  State<MemberHistoryScreen> createState() => _MemberHistoryScreenState();
}

class _MemberHistoryScreenState extends State<MemberHistoryScreen> {
  String _filter = 'all'; // 'all', 'active', 'returned', 'overdue'

  @override
  Widget build(BuildContext context) {
    final issueProvider = context.watch<IssueProvider>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersProvider>();

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
        .where((i) => !i.isReturned && DateTime.now().isAfter(i.dueDate))
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
            _buildMemberHeader(member,activeIssues),

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
                            'Borrow a book to see the history',
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
                        return _buildIssueCard(issue, book, issueProvider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberHeader(Members member, int activeIssues) {
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
                  'Currently Borrowed: ${activeIssues}/5',
                  style: TextStyle(color: AppColors.darkGrey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int total, int active, int returned, int overdue) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
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
    final textColor = AppColors.white;
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
          Text(label, style: TextStyle(fontSize: 12, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildFilterChips(int total, int active, int returned, int overdue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    IssueProvider issueProvider,
  ) {
    final isOverdue =
        !issue.isReturned && DateTime.now().isAfter(issue.dueDate);
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
                    color: AppColors.background.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // child: Icon(Icons.book, color: AppColors.background, size: 30),
                  child: book?.coverPicture == null || book!.coverPicture.isEmpty
                      ? Icon(Icons.book, color: AppColors.primary)
                      : Image.file(File(book.coverPicture), fit: BoxFit.cover),
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
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

            // Issue Details
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
                          '${issue.dueDate.difference(DateTime.now()).inDays}',
                          Icons.access_time,
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
                    Text(
                      'Fine: ₹${fine.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

            // Return Button (if not returned)
            if (!issue.isReturned)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _returnBook(issue, book),
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

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
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

  Future<void> _returnBook(IssueRecords issue, Books? book) async {
    try {
      final issueProvider = context.read<IssueProvider>();
      final bookProvider = context.read<BookViewModel>();
      final memberProvider = context.read<MembersProvider>();

      // 1. Mark as returned in Hive
      await issueProvider.returnBook(issue.issueId);

      // 2. Update book in SQLite
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
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
