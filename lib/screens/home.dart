import 'package:flutter/material.dart';
import 'package:libry/Themes/styles.dart';
import 'package:libry/provider/book_provider.dart';
import 'package:libry/provider/issue_provider.dart';
import 'package:libry/provider/members_provider.dart';
import 'package:libry/screens/home_screens/profile.dart';
import 'package:libry/utilities/helpers/date_formater.dart';
import 'package:libry/widgets/layout_widgets.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../database/userdata.dart';
import '../widgets/cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime time;
  late String greeting;
  final _actionSectionBG = MyColors.bgColor;

  @override
  void initState() {
    super.initState();
    _greeting();
  }

  void _greeting() {
    time = DateTime.now();
    if (time.hour >= 0 && time.hour < 12) {
      greeting = "Good Morning";
    } else if (time.hour >= 12 && time.hour < 17) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 10,
            children: [
              _buildHeaderSection(),
              _buildDetailsSection(),
              _buildActionSection(),
              _buildRecentActionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    String formattedDate = dateFormat(date: time);
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: "$greeting, \n${UserDatabase.getUserName}\n",
              style: TextStyle(
                color: MyColors.whiteBG,
                fontFamily: "Lobster",
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: formattedDate,
                  style: TextStyle(
                    color: MyColors.whiteBG,
                    fontFamily: "Livvic",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
              radius: 45,
              backgroundColor: Colors.blue,
              child: Center(
                child: Text(
                  UserDatabase.getUserName.trim()[0],
                  style: BodyTextStyles.headingMediumStyle(
                    MyColors.whiteBG,
                  ).copyWith(fontSize: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Expanded(
      flex: 2,
      child: SizedBox(
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: Cards.detailsCard(
                        count: context.watch<IssueProvider>().issuedTodayCount,
                        parameter: "Issued Today",
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: Cards.detailsCard(
                        count: context.watch<IssueProvider>().returnedCount,
                        parameter: "Returned Today",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: Cards.detailsCard(
                        count: context.watch<IssueProvider>().dueTodayCount,
                        parameter: "Due Today",
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: Cards.detailsCard(
                        count: context.watch<IssueProvider>().overDueCount,
                        parameter: "Overdue Books",
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

  Widget _buildActionSection() {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _actionSectionBG,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text("Argent Actions"),
      ),
    );
  }

  Widget _buildRecentActionsSection() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: _actionSectionBG,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
