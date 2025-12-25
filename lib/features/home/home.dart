import 'package:flutter/material.dart';
import 'package:libry/features/auth/data/services/userdata.dart';
import 'package:libry/features/books/viewmodel/book_provider.dart';
import 'package:libry/provider/issue_provider.dart';
import 'package:libry/provider/members_provider.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utilities/helpers/date_formater.dart';
import '../../core/widgets/layout_widgets.dart';
import '../auth/view/profile.dart';

void main(){
  runApp(
    MaterialApp(
      home: HomeScreen(),
    )
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime time;
  late String greeting;

  @override
  void initState() {
    super.initState();
    time = DateTime.now();
    greeting = _getGreeting();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24),
              _buildQuickStats(),
              SizedBox(height: 24),
              _buildTodayOverview(),
              SizedBox(height: 24),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String formattedDate = dateFormat(date: time);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: "Livvic",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                UserModelService.getUserModelName,
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: "Lobster",
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                formattedDate,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontFamily: "Livvic",
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.white,
            child: Text(
              UserModelService.getUserModelName.trim()[0].toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.background,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final bookProvider = context.watch<BookViewModel>();
    final memberProvider = context.watch<MembersProvider>();
    final issueProvider = context.watch<IssueProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Library Overview',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Books',
                bookProvider.totalBooks.toString(),
                Icons.book,
                Colors.blue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Available',
                bookProvider.availableBooks.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Members',
                memberProvider.totalCount.toString(),
                Icons.people,
                Colors.orange,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active Issues',
                issueProvider.activeCount.toString(),
                Icons.bookmark,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayOverview() {
    final issueProvider = context.watch<IssueProvider>();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Activity",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTodayItem(
                  'Issued',
                  issueProvider.issuedTodayCount.toString(),
                  Icons.upload,
                  Colors.blue,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
                margin: EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _buildTodayItem(
                  'Returned',
                  issueProvider.returnTodayCount.toString(),
                  Icons.download,
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTodayItem(
                  'Due Today',
                  issueProvider.dueTodayCount.toString(),
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
                margin: EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: _buildTodayItem(
                  'Overdue',
                  issueProvider.overDueCount.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayItem(String label, String count, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final issueProvider = context.watch<IssueProvider>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersProvider>();

    // Get recent issues (last 5)
    final recentIssues = issueProvider.allIssues
        .where((issue) => !issue.isReturned)
        .toList()
      ..sort((a, b) => b.borrowDate.compareTo(a.borrowDate));

    final limitedIssues = recentIssues.take(5).toList();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Issues',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (limitedIssues.isNotEmpty)
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          if (limitedIssues.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                    SizedBox(height: 8),
                    Text(
                      'No active issues',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...limitedIssues.map((issue) {
              final book = bookProvider.getBookById(issue.bookId);
              final member = memberProvider.getMemberById(issue.memberId);
              final daysLeft = issue.dueDate.difference(DateTime.now()).inDays;
              final isOverdue = daysLeft < 0;

              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? Colors.red.withOpacity(0.1)
                            : daysLeft <= 2
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.book,
                        color: isOverdue
                            ? Colors.red
                            : daysLeft <= 2
                            ? Colors.orange
                            : Colors.blue,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book?.title ?? 'Unknown Book',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            member?.name ?? 'Unknown Member',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? Colors.red
                            : daysLeft <= 2
                            ? Colors.orange
                            : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isOverdue
                            ? '${-daysLeft}d late'
                            : '$daysLeft days',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = time.hour;
    if (hour >= 0 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }
}