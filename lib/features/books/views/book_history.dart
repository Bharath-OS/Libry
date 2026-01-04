import 'package:flutter/material.dart';
import 'package:libry/core/utilities/helpers.dart';
import 'package:libry/core/widgets/issue_history_reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../data/model/books_model.dart';
import '../../issues/data/model/issue_records_model.dart';
import '../../members/data/model/members_model.dart';
import '../viewmodel/book_provider.dart';
import '../../issues/viewmodel/issue_provider.dart';
import '../../members/viewmodel/members_provider.dart';
import '../../../core/widgets/layout_widgets.dart';

class BookHistoryScreenView extends StatefulWidget {
  final int bookId;

  const BookHistoryScreenView({super.key, required this.bookId});

  @override
  State<BookHistoryScreenView> createState() => _BookHistoryScreenState();
}

class _BookHistoryScreenState extends State<BookHistoryScreenView> {
  String _filter = 'all'; // 'all', 'active', 'returned', 'overdue'

  @override
  Widget build(BuildContext context) {
    final issueProvider = context.watch<IssueViewModel>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersViewModel>();

    final book = bookProvider.getBookById(widget.bookId);
    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Book History')),
        body: Center(child: Text('Book not found')),
      );
    }

    // Get all issues for this book
    final allBookIssues = issueProvider.allIssues
        .where((issue) => issue.bookId == widget.bookId)
        .toList();

    // Apply filter
    final filteredIssues = _applyFilter(allBookIssues, issueProvider);

    // Calculate stats
    final totalIssues = allBookIssues.length;
    final activeIssues = allBookIssues.where((i) => !i.isReturned).length;
    final returnedIssues = allBookIssues.where((i) => i.isReturned).length;
    final overdueIssues = allBookIssues.where((i) => !i.isReturned && DateUtils.dateOnly(DateTime.now()).isAfter(DateUtils.dateOnly(i.dueDate))).length;

    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(
        barTitle: 'Book Borrow History',
        context: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Book Info Header
            _buildBookHeader(book),

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
                        final member = memberProvider.getMemberById(
                          issue.memberId,
                        );
                        return _buildIssueCard(issue, member, issueProvider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookHeader(BookModel book) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.book, color: AppColors.primary, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'by ${book.author}',
                  style: TextStyle(color: AppColors.lightGrey, fontSize: 14),
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
    MemberModel? member,
    IssueViewModel issueProvider,
  ) {
    final isOverdue = calculateOverDue(dueDate: issue.dueDate, isReturned: issue.isReturned);
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
            // Member Info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: AppColors.background),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member?.name ?? 'Unknown Member',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${member?.memberId ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
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

            // Fine Info (if applicable)
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
            .where((i) => !i.isReturned && DateUtils.dateOnly(DateTime.now()).isAfter(DateUtils.dateOnly(i.dueDate)))
            .toList();
      default:
        return issues;
    }
  }

  void _setFilter(String filter) {
    setState(() => _filter = filter);
  }
}
