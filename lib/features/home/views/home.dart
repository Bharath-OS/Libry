import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:libry/features/auth/data/services/userdata.dart';
import 'package:libry/features/books/viewmodel/book_provider.dart';
import 'package:libry/features/home/views/widget/widgets.dart';
import 'package:libry/features/issues/viewmodel/issue_provider.dart';
import 'package:libry/features/members/viewmodel/members_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utilities/helpers/date_formater.dart';
import '../../../core/utilities/helpers/greeting.dart';
import '../../../core/widgets/layout_widgets.dart';
import '../../auth/view/profile.dart';


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
    greeting = getGreeting(time);
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
              // SizedBox(height: 4),
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
              // SizedBox(height: 4),
              Text(
                formattedDate,
                style: TextStyle(
                  color: AppColors.white.withAlpha((0.8 * 255).toInt()),
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
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final issueProvider = context.watch<IssueProvider>();
    final bookProvider = context.watch<BookViewModel>();
    final memberProvider = context.watch<MembersProvider>();

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
            buildStatCard(
              'Total Books',
              bookProvider.totalBooks.toString(),
              Icons.book,
              Colors.blue,
            ),
            SizedBox(width: 12),
            buildStatCard(
              'Available',
              bookProvider.availableBooks.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            buildStatCard(
              'Members',
              memberProvider.totalCount.toString(),
              Icons.people,
              Colors.orange,
            ),
            SizedBox(width: 12),
            buildStatCard(
              'Active Issues',
              issueProvider.activeCount.toString(),
              Icons.bookmark,
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayOverview() {
    final issueProvider = context.watch<IssueProvider>();

    return dashboardContainer([
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
          buildTodayItem(
            'Issued',
            issueProvider.issuedTodayCount.toString(),
            Icons.upload,
            Colors.blue,
          ),
          addVerticalDivider(),
          buildTodayItem(
            'Returned',
            issueProvider.returnTodayCount.toString(),
            Icons.download,
            Colors.green,
          ),
        ],
      ),
      SizedBox(height: 16),
      Divider(),
      SizedBox(height: 16),
      Row(
        children: [
          buildTodayItem(
            'Due Today',
            issueProvider.dueTodayCount.toString(),
            Icons.calendar_today,
            Colors.orange,
          ),
          addVerticalDivider(),
          buildTodayItem(
            'Overdue',
            issueProvider.overDueCount.toString(),
            Icons.warning,
            Colors.red,
          ),
        ],
      ),
    ]);
  }

  Widget _buildRecentActivity() {
    final issueProvider = context.watch<IssueProvider>();
    final bookProvider = context.read<BookViewModel>();
    final memberProvider = context.read<MembersProvider>();

    // Get recent issues (last 5)
    final recentIssues =
        issueProvider.allIssues.where((issue) => !issue.isReturned).toList()
          ..sort((a, b) => b.borrowDate.compareTo(a.borrowDate));

    final limitedIssues = recentIssues.take(5).toList();

    return dashboardContainer([
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
              style: TextStyle(fontSize: 12, color: AppColors.lightGrey),
            ),
        ],
      ),
      SizedBox(height: 16),
      //Empty case.
      if (limitedIssues.isEmpty)
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(Icons.inbox, size: 48, color: AppColors.lightGrey),
                SizedBox(height: 8),
                Text(
                  'No recent issues',
                  style: TextStyle(color: AppColors.darkGrey),
                ),
              ],
            ),
          ),
        )
      //Not empty case
      else
        ...limitedIssues.map((issue) {
          final book = bookProvider.getBookById(issue.bookId);
          final member = memberProvider.getMemberById(issue.memberId);
          final daysLeft = issue.dueDate.difference(DateTime.now()).inDays;
          final isOverdue = daysLeft < 0;

          return recentIssueCard(
            isOverdue: isOverdue,
            daysLeft: daysLeft,
            book: book,
            member: member,
          );
        }),
    ]);
  }
}
