import 'package:flutter/material.dart';
import 'package:libry/Screens/books_screen.dart';
import 'package:libry/provider/members_provider.dart';
import 'package:libry/features/books/add_book_screen.dart';
import 'package:libry/core/themes/styles.dart';
import 'package:libry/provider/issue_provider.dart';
import 'package:libry/features/auth/view/login.dart';
import 'package:libry/constants/app_colors.dart';
import 'package:libry/screens/transactions_screens/issue.dart';
import 'package:provider/provider.dart';
import '../../../widgets/layout_widgets.dart';
import '../../../database/userdata.dart';
import '../auth/data/model/user_model.dart';
import '../../../utilities/helpers.dart';
import '../../features/home/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color color = MyColors.primaryColor;
  late User? user;

  @override
  void initState() {
    super.initState();
    // if (mounted) {
    // }
    _loadUserData();
  }

  void _loadUserData() {
    user = UserDatabase.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWidgets.customScaffold(
      appBar: LayoutWidgets.appBar(barTitle: "Account", context: context),
      body: SafeArea(child: SingleChildScrollView(child: _buildProfile())),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),
            _buildKeyStats(color),
            _quickActionButtons(color),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String profileLetters = '';
    user!.name.split(' ').forEach((word)=>profileLetters += word[0]);
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: MyColors.primaryButtonColor,
          child: Text(
             profileLetters,
            style: BodyTextStyles.mainHeadingStyle.copyWith(
              fontSize: 40,
              color: MyColors.whiteBG,
            ),
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${user!.name}\n",
            style: TextStyle(
              color: MyColors.whiteBG,
              fontFamily: "Lobster",
              fontSize: 42,
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(
                text: "Librarian\n",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Livvic",
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade400,
                ),
              ),
              TextSpan(
                text: user!.email,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Livvic",
                  fontWeight: FontWeight.normal,

                )
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyStats(Color color) {
    final activeMembersCount = context.watch<IssueProvider>().activeCount;
    final issuedTodayCount = context.watch<IssueProvider>().issuedTodayCount;
    final fineOwes = context.watch<IssueProvider>().fineOwed;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: MyColors.whiteBG,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            icon: Icons.book_rounded,
            stat: issuedTodayCount,
            label: "Issued Today",
            color: color,
          ),
          verticalDivider(),
          _buildStatCard(
            icon: Icons.people_rounded,
            stat: activeMembersCount,
            label: "Active Members",
            color: color,
          ),
          verticalDivider(),
          _buildStatCard(
            icon: Icons.currency_rupee_rounded,
            stat: fineOwes,
            label: "Fine Owes",
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _quickActionButtons(Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: MyColors.whiteBG,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          actionButton(
            iconColor: color,
            textColor: color,
            icon: Icons.add_rounded,
            text: "Add Book",
            method: ()=>Navigator.push(context, transition(child: AddBookScreen()))
          ),
          Divider(),
          actionButton(
            iconColor: color,
            textColor: color,
            icon: Icons.arrow_upward_rounded,
            text: "Issue Book",
            method: () =>
                Navigator.push(context, transition(child: IssueBookScreen())),
          ),
          Divider(),
          actionButton(
            icon: Icons.create_outlined,
            iconColor: color,
            text: "Edit Profile",
            textColor: color,
            method: () async{
              await Navigator.push(context, transition(child: EditProfileScreen()));
              _loadUserData();
            }
          ),
          Divider(),
          actionButton(icon: Icons.file_copy_outlined, iconColor: color,text: "Download",textColor: color, method: (){}),
          Divider(),
          actionButton(
              icon: Icons.exit_to_app,
              iconColor: MyColors.warningColor,
              text: "Logout",
              textColor: MyColors.warningColor,
              method: () async{
                UserDatabase.setLogValue(false);
                await Navigator.push(context, transition(child: LoginScreen()));
                _loadUserData();
              }
          ),
        ],
      ),
    );
  }
}

Widget _buildStatCard({
  required IconData icon,
  required int stat,
  required String label,
  Color color = Colors.black,
}) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color, fontWeight: FontWeight.bold),
          Text(
            stat.toString(),
            style: BodyTextStyles.headingMediumStyle(color),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: BodyTextStyles.bodySmallStyle(
              color,
            ).copyWith(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget verticalDivider() {
  return Container(height: 100, width: 1.5, color: Colors.black12);
}

Widget actionButton({
  required IconData icon,
  required Color iconColor,
  required String text,
  required Color textColor,
  required VoidCallback method,
}) {
  return GestureDetector(
    onTap: method,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(icon, color: iconColor, size: 40),
            Text(text, style: CardStyles.cardSubTitleStyle.copyWith(color: textColor)),
          ],
        ),
        Icon(Icons.arrow_forward_ios_rounded,color: iconColor,),
      ],
    ),
  );
}
