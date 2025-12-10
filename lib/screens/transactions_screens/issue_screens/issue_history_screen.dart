// lib/screens/issue_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/books_model.dart';
import '../../../models/issue_records_model.dart';
import '../../../models/members_model.dart';
import '../../../provider/book_provider.dart';
import '../../../provider/issue_provider.dart';
import '../../../provider/members_provider.dart';


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
    final bookProvider = context.read<BookProvider>();
    final memberProvider = context.read<MembersProvider>();
    final issues = issueProvider.issues;

    return Scaffold(
      appBar: AppBar(title: Text('Issue History')),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: Text('All (${issueProvider.totalCount})'),
                  selected: _filter == 'all',
                  onSelected: (_) => _setFilter('all'),
                ),
                FilterChip(
                  label: Text('Active (${issueProvider.activeCount})'),
                  selected: _filter == 'active',
                  onSelected: (_) => _setFilter('active'),
                ),
                FilterChip(
                  label: Text('Returned (${issueProvider.returnedCount})'),
                  selected: _filter == 'returned',
                  onSelected: (_) => _setFilter('returned'),
                ),
              ],
            ),
          ),

          // Issues List
          Expanded(
            child: issues.isEmpty
                ? Center(child: Text('No issues found'))
                : ListView.builder(
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];
                final book = bookProvider.getBookById(issue.bookId);
                final member = memberProvider.getMemberById(issue.memberId);

                return _buildIssueCard(issue, book, member, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(
      IssueRecords issue,
      Books? book,
      Members? member,
      BuildContext context,
      ) {
    final issueProvider = context.read<IssueProvider>();
    final isOverdue = !issue.isReturned &&
        DateTime.now().isAfter(issue.dueDate);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(book?.title ?? 'Unknown Book'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Member: ${member?.name ?? 'Unknown'}'),
            Text('Issue ID: ${issue.issueId}'),
            Text('Borrowed: ${_formatDate(issue.borrowDate)}'),
            Text('Due: ${_formatDate(issue.dueDate)}'),
            if (issue.isReturned)
              Text('Returned: ${_formatDate(issue.returnDate!)}'),
            if (isOverdue)
              Text(
                'Overdue! Fine: ₹${issueProvider.calculateFine(issue)}',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        trailing: issue.isReturned
            ? Chip(
          label: Text('Returned'),
          backgroundColor: Colors.green[100],
        )
            : ElevatedButton(
          onPressed: () => _returnBook(issue, context),
          child: Text('Return'),
        ),
      ),
    );
  }

  void _setFilter(String filter) {
    setState(() => _filter = filter);
    context.read<IssueProvider>().setFilter(filter);
  }

  Future<void> _returnBook(IssueRecords issue, BuildContext context) async {
    try {
      // 1. Mark as returned in Hive
      await context.read<IssueProvider>().returnBook(issue.issueId);

      // 2. Update book in SQLite
      final book = context.read<BookProvider>().getBookById(issue.bookId);
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
          copiesAvailable: book.copiesAvailable + 1, // Increase
          coverPicture: book.coverPicture,
        );
        await context.read<BookProvider>().updateBook(updatedBook);
      }

      // 3. Update member in SQLite
      final member = context.read<MembersProvider>().getMemberById(issue.memberId);
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
          currentlyBorrow: member.currentlyBorrow - 1, // Decrease
          joined: member.joined,
          expiry: member.expiry,
        );
        await context.read<MembersProvider>().updateMember(updatedMember);
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book returned successfully'))
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'))
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}